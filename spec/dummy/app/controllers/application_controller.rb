class ApplicationController < ActionController::Base
  include AwesomeTranslations::ControllerTranslateFunctionality

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_filter :set_locale

private

  def set_locale
    if session[:locale]
      I18n.locale = session[:locale]
    else
      I18n.locale = :en
    end
  end
end
