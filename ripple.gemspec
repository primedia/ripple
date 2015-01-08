$:.push File.expand_path('../lib', __FILE__)
require 'ripple/version'

Gem::Specification.new do |gem|
  # Meta
  gem.name = "ripple"
  gem.version = Ripple::VERSION
  gem.summary = %Q{ripple is an object-mapper library for Riak, the distributed database by Basho.}
  gem.description = %Q{ripple is an object-mapper library for Riak, the distributed database by Basho.  It uses ActiveModel to provide an experience that integrates well with Rails 3 applications.}
  gem.email = ["sean@basho.com"]
  gem.homepage = "http://seancribbs.github.com/ripple"
  gem.authors = ["Sean Cribbs"]

  # Deps
  gem.add_development_dependency "rspec", [">= 2.9.0", "< 3.0.0"]
  gem.add_development_dependency 'rake', '~> 0'
  gem.add_development_dependency 'ammeter', '~>0.2.9'
  gem.add_dependency "riak-client", "~> 1.4", ">= 1.4.6"
  gem.add_dependency "activesupport", [">= 4.2.0", "< 5.0.0"]
  gem.add_dependency "activemodel", [">= 4.2.0", "< 5.0.0"]
  gem.add_dependency "protected_attributes", '~>1.0'
  gem.add_dependency "rails-observers", '~>0.1'
  gem.add_dependency "tzinfo", '~>1.1'

  # Files
  gem.files         = `git ls-files`.split($/)
  gem.require_paths = ['lib']
end

