require "awesome_translations/engine"
require "haml"
require "string-cases"

module AwesomeTranslations
  autoload :Handlers, "#{File.dirname(__FILE__)}/awesome_translations/handlers"
  autoload :ModelInspector, "awesome_translations/model_inspector"
end
