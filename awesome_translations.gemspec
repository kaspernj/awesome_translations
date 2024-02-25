$LOAD_PATH.push File.expand_path("lib", __dir__)

# Maintain your gem's version:
require "awesome_translations/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name = "awesome_translations"
  s.version = AwesomeTranslations::VERSION
  s.authors = ["Kasper Stöckel"]
  s.email = ["k@spernj.org"]
  s.homepage = "https://www.github.com/kaspernj/awesome_translations"
  s.summary = "Semi-automatic maintenance of most translations in a Rails app."
  s.description = "Semi-automatic maintenance of most translations in a Rails app."
  s.required_ruby_version = ">= 2.7"
  s.metadata = {"rubygems_mfa_required" => "true"}

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  s.add_dependency "active-record-transactioner", ">= 0.0.7"
  s.add_dependency "array_enumerator", ">= 0.0.10"
  s.add_dependency "auto_autoloader", ">= 0.0.4"
  s.add_dependency "baza", ">= 0.0.37"
  s.add_dependency "baza_migrations", ">= 0.0.1"
  s.add_dependency "baza_models", ">= 0.0.14"
  s.add_dependency "rails", ">= 6.0.0"
  s.add_dependency "string-cases", ">= 0.0.3"
end
