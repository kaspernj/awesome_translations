require "baza_models"

module ::AwesomeTranslations::ApplicationHelper
  include BazaModels::Helpers::RansackerHelper
  include SimpleFormRansackHelper

  def flash_message_class(type)
    type = type.to_s
    type = "success" if type == "notice"
    type = "danger" if type == "alert"
    type = "danger" if type == "error"
    type
  end

  def path_without_root(path)
    path.gsub(/\A#{Regexp.escape(Rails.root.to_s)}(\/|)/, "")
  end

  def path_without_root_or_locales(path)
    path_without_root(path).gsub(/\Aconfig\/locales(\/|)/, "")
  end
end
