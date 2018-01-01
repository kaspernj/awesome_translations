class AwesomeTranslations::ApplicationController < ActionController::Base
  before_action :init_cache
  skip_before_action :handle_two_factor_authentication

private

  def init_cache
    AwesomeTranslations::CacheDatabaseGenerator.current
  end
end
