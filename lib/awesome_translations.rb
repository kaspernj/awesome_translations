require "awesome_translations/engine"
require "haml"
require "string-cases"
require "array_enumerator"

module AwesomeTranslations
  autoload :Config, "#{File.dirname(__FILE__)}/awesome_translations/config"
  autoload :Handlers, "#{File.dirname(__FILE__)}/awesome_translations/handlers"
  autoload :ObjectExtensions, "awesome_translations/object_extensions"
  autoload :ModelInspector, "awesome_translations/model_inspector"

  def self.config
    @config ||= AwesomeTranslations::Config.new
  end
end

Object.__send__(:include, AwesomeTranslations::ObjectExtensions)
