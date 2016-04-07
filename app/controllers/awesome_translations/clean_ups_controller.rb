class AwesomeTranslations::CleanUpsController < AwesomeTranslations::ApplicationController
  def new
  end

  def create
    translation_values = AwesomeTranslations::CacheDatabaseGenerator::TranslationValue
      .where(id: params[:c].keys)

    translation_values.destroy_all

    redirect_to [:new, :clean_up]
  end

private

  helper_method :translations_to_clean_up
  def translations_to_clean_up
    @translations_to_migrate ||= AwesomeTranslations::CacheDatabaseGenerator::TranslationValue
      .joins(:translation_key)
      .includes(:translation_key)
      .joins("LEFT JOIN handler_translations ON handler_translations.translation_key_id = translation_keys.id")
      .where("handler_translations.id IS NULL")
      .where("translation_values.file_path LIKE '%/config/locales/awesome_translations/%'")
  end
end
