require "haml"
require "string-cases"
require "array_enumerator"
require "jquery-rails"

module AwesomeTranslations
  autoload :Config, "#{File.dirname(__FILE__)}/awesome_translations/config"
  autoload :ErbInspector, "#{File.dirname(__FILE__)}/awesome_translations/erb_inspector"
  autoload :Handlers, "#{File.dirname(__FILE__)}/awesome_translations/handlers"
  autoload :ObjectExtensions, "awesome_translations/object_extensions"
  autoload :ModelInspector, "awesome_translations/model_inspector"

  def self.config
    @config ||= AwesomeTranslations::Config.new
  end

  def self.load_object_extensions
    ::Object.__send__(:include, AwesomeTranslations::ObjectExtensions)
  end
end

require_relative "awesome_translations/engine"
