class ApplicationController < ActionController::Base
  include AwesomeTranslations::ControllerTranslateFunctionality

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  around_action :with_locale

private

  def with_locale(&blk)
    I18n.with_locale(session[:locale] || :en, &blk)
  end
end
