require "awesome_translations/engine"
require "haml"
require "string-cases"
require "array_enumerator"

module AwesomeTranslations
  autoload :Handlers, "#{File.dirname(__FILE__)}/awesome_translations/handlers"
  autoload :ObjectExtensions, "awesome_translations/object_extensions"
  autoload :ModelInspector, "awesome_translations/model_inspector"
end

Object.__send__(:include, AwesomeTranslations::ObjectExtensions)
