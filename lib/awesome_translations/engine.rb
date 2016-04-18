require "bootstrap_builders"
require "haml-rails"
require "sass-rails"
require "jquery-rails"
require "simple_form"
require "simple_form_ransack"
require "twitter-bootstrap-rails"

module AwesomeTranslations; end

class AwesomeTranslations::Engine < ::Rails::Engine
  isolate_namespace AwesomeTranslations
end
