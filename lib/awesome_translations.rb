require "array_enumerator"
require "auto_autoloader"
require "string-cases"
require_relative "awesome_translations/engine"

module AwesomeTranslations
  AutoAutoloader.autoload_sub_classes(self, __FILE__)

  def self.config
    @config ||= AwesomeTranslations::Config.new
  end

  def self.load_object_extensions
    ::Object.include AwesomeTranslations::ObjectExtensions
  end
end
