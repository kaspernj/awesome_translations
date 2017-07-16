require "bootstrap_builders"
require "sass-rails"
require "simple_form"
require "simple_form_ransack"

module AwesomeTranslations; end

class AwesomeTranslations::Engine < ::Rails::Engine
  isolate_namespace AwesomeTranslations
end
