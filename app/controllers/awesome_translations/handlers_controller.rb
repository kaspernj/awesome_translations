class AwesomeTranslations::HandlersController < AwesomeTranslations::ApplicationController
  before_filter :set_handler

  def index
    @handlers = AwesomeTranslations::Handler.all
  end

  def show
    @translations = @handler.translations
  end

  def update
    @handler.translations.each do |translation|
      next unless params[:t].key?(translation.key)

      values = params[:t][translation.key]
      values.each do |locale, value|
        translated_value = translation.translated_value_for_locale(locale)
        translated_value.value = value
        translated_value.save!
      end
    end

    render nothing: true
  end

private

  def set_handler
    @handler = AwesomeTranslations::Handler.find(params[:id]) if params[:id]
  end
end
