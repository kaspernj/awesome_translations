$LOAD_PATH.push File.expand_path("../lib", __FILE__)

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

  s.add_dependency "rails", ">= 3.0.0", "< 5.0.0"
  s.add_dependency "string-cases", ">= 0.0.3"
  s.add_dependency "baza", ">= 0.0.20"
  s.add_dependency "baza_models", ">= 0.0.6"
  s.add_dependency "baza_migrations", ">= 0.0.1"
  s.add_dependency "bootstrap_builders", "0.0.5"
  s.add_dependency "array_enumerator", "~> 0.0.10"
  s.add_dependency "haml-rails", ">= 0"
  s.add_dependency "coffee-rails", ">= 0"
  s.add_dependency "sass-rails", "~> 4.0.5"
  s.add_dependency "simple_form", ">= 0"
  s.add_dependency "simple_form_ransack", ">= 0.0.16"
  s.add_dependency "jquery-rails", ">= 0"
  s.add_dependency "auto_autoloader", ">= 0"
  s.add_dependency "active-record-transactioner", ">= 0"
  s.add_dependency "twitter-bootstrap-rails", ">= 3.2.2"

  if RUBY_ENGINE == "jruby"
    s.add_dependency "activerecord-jdbcsqlite3-adapter"
  else
    s.add_dependency "sqlite3"
  end

  s.add_development_dependency "rspec-rails", "3.4.2"
  s.add_development_dependency "capybara", "2.6.2"
  s.add_development_dependency "capybara-webkit", "1.8.0"
  s.add_development_dependency "database_cleaner", "1.5.1"
  s.add_development_dependency "forgery", "0.6.0"
  s.add_development_dependency "factory_girl_rails", "4.6.0"
  s.add_development_dependency "codeclimate-test-reporter", "0.5.0"
  s.add_development_dependency "money-rails", "1.6.0"
  s.add_development_dependency "globalize", "5.0.1"
  s.add_development_dependency "best_practice_project"
  s.add_development_dependency "rubocop", "0.39.0"
  # s.add_development_dependency "scss_lint", "0.47.1"
  s.add_development_dependency "haml_lint", "0.17.0"
  s.add_development_dependency "coffeelint", "1.14.0"
  s.add_development_dependency "rails_best_practices", ">= 0.0.8"
  s.add_development_dependency "will_paginate", "~> 3.1.0"
end
