class AwesomeTranslations::HandlerTranslationsController < AwesomeTranslations::ApplicationController
  def index
    @ransack_values = params[:q] || {}

    @ransack = AwesomeTranslations::CacheDatabaseGenerator::HandlerTranslation
      .ransack(@ransack_values)

    @handler_translations = @ransack
      .result
      .includes(:group, :handler)
  end
end
