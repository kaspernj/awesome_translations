$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "awesome_translations/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "awesome_translations"
  s.version     = AwesomeTranslations::VERSION
  s.authors     = ["Kasper Johansen"]
  s.email       = ["k@spernj.org"]
  s.homepage    = "https://www.github.com/kaspernj/awesome_translations"
  s.summary     = "Semi-automatic maintenance of most translations in a Rails app."
  s.description = "Semi-automatic maintenance of most translations in a Rails app."

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]
  s.test_files = Dir["spec/**/*"]

  s.add_dependency "rails", ">= 3.1.2"
  s.add_dependency "string-cases"
  s.add_dependency "jquery-rails"
  s.add_dependency "sass-rails"
  s.add_dependency "haml"
  s.add_dependency "array_enumerator", "~> 0.0.6"

  s.add_development_dependency "haml-rails"
  s.add_development_dependency "sqlite3"
  s.add_development_dependency "rspec-rails"
  s.add_development_dependency "forgery"
  s.add_development_dependency "factory_girl_rails"
  s.add_development_dependency "codeclimate-test-reporter"
end
