$:.push File.expand_path('../lib', __FILE__)

# Maintain your gem's version:
require 'economy/version'

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = 'economy'
  s.version     = Economy::VERSION
  s.authors     = ['mmontossi']
  s.email       = ['mmontossi@gmail.com']
  s.homepage    = 'https://github.com/mmontossi/economy'
  s.summary     = 'Economy for Rails'
  s.description = 'High performance multicurrency money for rails.'
  s.license     = 'MIT'

  s.files = Dir['{app,config,db,lib}/**/*', 'MIT-LICENSE', 'Rakefile', 'README.md']
  s.test_files = Dir['test/**/*']

  s.required_ruby_version = '>= 2.0.0'

  s.add_dependency 'rails', ['>= 4.2.0', '< 4.3.0']
  s.add_dependency 'redis', '~> 3.2'

  s.add_development_dependency 'pg', '~> 0.18'
  s.add_development_dependency 'mocha', '~> 1.1'
end
