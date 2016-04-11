require "array_enumerator"
require "auto_autoloader"
require "bootstrap_builders"
require "baza_models"
require "sass-rails"
require "simple_form"
require "simple_form_ransack"
require "string-cases"
require "twitter-bootstrap-rails"
require "will_paginate"

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
