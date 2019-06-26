# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV["RAILS_ENV"] ||= "test"
require_relative "dummy/config/environment"

require "rspec/rails"
require "baza_models"
require "database_cleaner"
require "capybara"
require "capybara-webkit"
require "factory_bot"
require "forgery"
require "globalize"
require "sass-rails"
require "simple_form"

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[Rails.root.join("spec/support/**/*.rb")].each { |f| require f }

# Checks for pending migrations before tests are run.
# If you are not using ActiveRecord, you can remove this line.
ActiveRecord::Migration.check_pending! if defined?(ActiveRecord::Migration)

FactoryBot.definition_file_paths << File.join(File.dirname(__FILE__), "factories")
FactoryBot.find_definitions

AwesomeTranslations.load_object_extensions

Capybara.app = AwesomeTranslations::Engine
Capybara.javascript_driver = :webkit

RSpec.configure do |config|
  config.include AwesomeTranslations::Engine.routes.url_helpers
  config.include FactoryBot::Syntax::Methods

  config.infer_spec_type_from_file_location!

  config.before(:suite) do
    DatabaseCleaner.clean_with(:truncation)

    generator = AwesomeTranslations::CacheDatabaseGenerator.current
    generator.cache_translations
  end

  config.before(:each) do
    Capybara.reset_sessions!

    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.start

    AwesomeTranslations::CacheDatabaseGenerator.current.init_database

    BazaModels::TestDatabaseCleaner.clean
  end

  config.before(:each, js: true) do
    DatabaseCleaner.strategy = :truncation
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end

  config.before do
    I18n.load_path.delete_if { |path| !File.exist?(path) }
  end

  config.after do
    generator = AwesomeTranslations::CacheDatabaseGenerator.current
    generator.close

    translation_file = Rails.root.join("config", "locales", "translations.yml").to_s
    File.unlink(translation_file) if File.exist?(translation_file)

    at_dir = Rails.root.join("config", "locales", "awesome_translations").to_s
    FileUtils.rm_rf(at_dir) if File.exist?(at_dir)
    FileUtils.touch(Rails.root.join("config", "locales", ".keep").to_s)
  end
end
