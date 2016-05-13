require "baza_models"

module ::AwesomeTranslations::ApplicationHelper
  include BazaModels::Helpers::RansackerHelper
  include BootstrapBuilders::ApplicationHelper
  include SimpleFormRansackHelper

  def path_without_root(path)
    path.gsub(/\A#{Regexp.escape(Rails.root.to_s)}(\/|)/, "")
  end

  def path_without_root_or_locales(path)
    path_without_root(path).gsub(/\Aconfig\/locales(\/|)/, "")
  end
end
