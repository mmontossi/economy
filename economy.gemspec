$:.push File.expand_path('../lib', __FILE__)

# Maintain your gem's version:
require 'economy/version'

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = 'economy'
  s.version     = Economy::VERSION
  s.authors     = ['mmontossi']
  s.email       = ['mmontossi@museways.com']
  s.homepage    = 'https://github.com/mmontossi/economy'
  s.summary     = 'Economy for Rails'
  s.description = 'High performance multicurrency money for rails.'
  s.license     = 'MIT'

  s.files = Dir['{app,config,db,lib}/**/*', 'MIT-LICENSE', 'Rakefile', 'README.md']

  s.add_dependency 'rails', '~> 5.1'
  s.add_dependency 'redis', '~> 3.3'

  s.add_development_dependency 'pg', '~> 0.21'
  s.add_development_dependency 'mocha', '~> 1.2'
end
