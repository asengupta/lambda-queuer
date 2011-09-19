Gem::Specification.new do |s|
	s.name        = 'lambda-queuer'
	s.add_dependency('sourcify', '>= 0.5.0')
	s.version     = '0.0.3'
	s.date        = '2011-09-17'
	s.summary     = "A simple class atop sourcify and amqp which can queue stringified lambdas over RabbitMQ"
	s.description = "A class atop sourcify and amqp which can queue stringified lambdas over RabbitMQ. It is untested on free variables."
	s.authors     = ["Avishek Sen Gupta"]
	s.email       = 'avishek.sen.gupta@gmail.com'
	s.files       = ["lib/lambda-queuer.rb"]
	s.homepage    = 'http://rubygems.org/gems/lambda-queuer'
end
