class AwesomeTranslations::CleanUpsController < AwesomeTranslations::ApplicationController
  def new; end

  def create
    ids = []
    params[:c].each do |translation_value_id, check_value|
      ids << translation_value_id.to_i if check_value == "1"
    end

    translation_values = AwesomeTranslations::CacheDatabaseGenerator::TranslationValue
      .where(id: ids)

    translation_values.each do |translation_value|
      AwesomeTranslations::TranslationMigrator.new(translation_value: translation_value).execute
      translation_value.destroy!
    end

    redirect_to [:new, :clean_up]
  end

private

  helper_method :translations_to_clean_up
  def translations_to_clean_up
    @translations_to_clean_up ||= AwesomeTranslations::CacheDatabaseGenerator::TranslationValue
      .joins(:translation_key)
      .includes(:translation_key)
      .joins("LEFT JOIN handler_translations ON handler_translations.translation_key_id = translation_keys.id")
      .where(handler_translations: {id: nil})
      .where("translation_values.file_path LIKE '%/config/locales/awesome_translations/%'")
  end
end
