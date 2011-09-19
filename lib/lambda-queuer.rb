require 'rubygems'
require 'amqp'
require 'sourcify'

class LambdaQueuer
	attr_accessor :queue
	def initialize(options = {})
		@host = options[:host] || '127.0.0.1'
		@port = options[:port] || 5672
		@exchange = options[:exchange] || 'default_exchange'
		@request_routing_key = options[:request_routing_key] || 'default_routing_key'
		@response_routing_key = options[:response_routing_key]
	end

	def post(&block)
		EventMachine.run do
			begin
				connection = AMQP.connect(:host => @host, :port => @port)
			  	channel = AMQP::Channel.new(connection)
			  	exchange = channel.direct(@exchange, :auto_delete => true)
			  	@queue = channel.queue(@request_routing_key, :auto_delete => true)
			  	@queue.bind(exchange, :routing_key => @request_routing_key)
				v = block.to_source
			  	exchange.publish(v, :routing_key => @request_routing_key)
				if (@response_routing_key)
				  	@answer_queue = channel.queue(@response_routing_key, :auto_delete => true)
				  	@answer_queue.bind(exchange, :routing_key => @response_routing_key)
					@answer_queue.subscribe do |message|
						puts "Received: #{message}"
						connection.close { EventMachine.stop }
					end
				else
					EventMachine.add_timer(2) do
						connection.close { EventMachine.stop }
					end
				end
			rescue => e
				puts e
			end
		end
	end
end

#LambdaQueuer.new(:exchange => 'lambda_exchange', :request_routing_key => 'lambda', :response_routing_key => 'lambda_response').post {|data| true}

