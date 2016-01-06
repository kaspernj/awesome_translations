require "codeclimate-test-reporter"
CodeClimate::TestReporter.start

# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV["RAILS_ENV"] ||= 'test'
require_relative "dummy/config/environment"
require 'rspec/rails'
require 'factory_girl'
require 'forgery'
require 'globalize'

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[Rails.root.join("spec/support/**/*.rb")].each { |f| require f }

# Checks for pending migrations before tests are run.
# If you are not using ActiveRecord, you can remove this line.
ActiveRecord::Migration.check_pending! if defined?(ActiveRecord::Migration)

FactoryGirl.definition_file_paths << File.join(File.dirname(__FILE__), 'factories')
FactoryGirl.find_definitions

AwesomeTranslations.load_object_extensions

RSpec.configure do |config|
  include ActionDispatch::TestProcess

  # ## Mock Framework
  #
  # If you prefer to use mocha, flexmock or RR, uncomment the appropriate line:
  #
  # config.mock_with :mocha
  # config.mock_with :flexmock
  # config.mock_with :rr

  config.include FactoryGirl::Syntax::Methods

  config.infer_spec_type_from_file_location!

  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.
  config.use_transactional_fixtures = true

  # If true, the base class of anonymous controllers will be inferred
  # automatically. This will be the default behavior in future versions of
  # rspec-rails.
  config.infer_base_class_for_anonymous_controllers = false

  config.before :suite do
    generator = AwesomeTranslations::CacheDatabaseGenerator.current
    generator.cache_translations
  end

  config.before do
    I18n.load_path.delete_if { |path| !File.exist?(path) }

    generator = AwesomeTranslations::CacheDatabaseGenerator.current
    generator.init_database
  end

  config.after do
    generator = AwesomeTranslations::CacheDatabaseGenerator.current
    generator.close

    translation_file = Rails.root.join("config", "locales", "translations.yml").to_s
    File.unlink(translation_file) if File.exist?(translation_file)

    at_dir = Rails.root.join("config", "locales", "awesome_translations").to_s
    FileUtils.rm_rf(at_dir) if File.exist?(at_dir)
  end

  # Run specs in random order to surface order dependencies. If you find an
  # order dependency and want to debug it, you can fix the order by providing
  # the seed, which is printed after each run.
  #     --seed 1234
  config.order = "random"
end
