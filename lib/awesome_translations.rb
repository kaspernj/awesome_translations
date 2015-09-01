require "string-cases"
require "array_enumerator"

module AwesomeTranslations
  path = "#{File.dirname(__FILE__)}/awesome_translations"

  autoload :CacheDatabaseGenerator, "#{path}/cache_database_generator"
  autoload :Config, "#{path}/config"
  autoload :ErbInspector, "#{path}/erb_inspector"
  autoload :GlobalTranslator, "#{path}/global_translator"
  autoload :Handlers, "#{path}/handlers"
  autoload :ModelInspector, "#{path}/model_inspector"
  autoload :ObjectExtensions, "#{path}/object_extensions"
  autoload :TranslateFunctionality, "#{path}/translate_functionality"

  def self.config
    @config ||= AwesomeTranslations::Config.new
  end

  def self.load_object_extensions
    ::Object.__send__(:include, AwesomeTranslations::ObjectExtensions)
  end
end

require_relative "awesome_translations/engine"
