class AwesomeTranslations::ApplicationController < ActionController::Base
  before_action :init_cache

private

  def init_cache
    AwesomeTranslations::CacheDatabaseGenerator.current
  end
end
