require "array_enumerator"
require "auto_autoloader"
require "bootstrap-sass"
require "font-awesome-rails"
require "jquery-rails"
require "string-cases"
require_relative "awesome_translations/engine"

module AwesomeTranslations
  AutoAutoloader.autoload_sub_classes(self, __FILE__)

  def self.config
    @config ||= AwesomeTranslations::Config.new
  end

  def self.load_object_extensions
    ::Object.__send__(:include, AwesomeTranslations::ObjectExtensions)
  end
end
