require "auto_autoloader"
require "baza_models"
require "string-cases"
require "array_enumerator"

module AwesomeTranslations
  AutoAutoloader.autoload_sub_classes(self, __FILE__)

  def self.config
    @config ||= AwesomeTranslations::Config.new
  end

  def self.load_object_extensions
    ::Object.__send__(:include, AwesomeTranslations::ObjectExtensions)
  end
end

require_relative "awesome_translations/engine"
