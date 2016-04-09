class AwesomeTranslations::HandlerTranslationsController < AwesomeTranslations::ApplicationController
  def index
    @ransack_values = params[:q] || {}

    @handler_translations = AwesomeTranslations::CacheDatabaseGenerator::HandlerTranslation
      .ransack(@ransack_values)
      .result
      .page(params[:page])
  end
end
