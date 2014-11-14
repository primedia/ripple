source 'https://rubygems.org'

gemspec

group :guard do
  gem 'guard-rspec'
  gem 'rb-fsevent'
  gem 'growl'
end

group :development, :test do
  gem 'ammeter', :path => '/Users/mmaiza/Dev/ammeter'
  gem 'pry'
  gem 'pry-nav'
end

if File.directory?(File.expand_path("../../riak-client", __FILE__))
  gem 'riak-client', :path => "../riak-client"
end

platforms :jruby do
  gem 'jruby-openssl'
end
