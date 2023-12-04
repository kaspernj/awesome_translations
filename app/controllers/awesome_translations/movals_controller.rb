class AwesomeTranslations::MovalsController < AwesomeTranslations::ApplicationController
  def index
    @movals = AwesomeTranslations::CacheDatabaseGenerator::TranslationValue
      .select("translation_values.*, handler_translations.id AS handler_translation_id")
      .joins("
        INNER JOIN handler_translations ON
          handler_translations.translation_key_id = translation_values.translation_key_id
      ")
      .where("translation_values.file_path NOT LIKE handler_translations.dir || '%'")
      .group("translation_values.id")
  end

  def create
    params[:m].each_key do |translation_value_id|
      translation_value = AwesomeTranslations::CacheDatabaseGenerator::TranslationValue.find(translation_value_id)
      translation_value.migrate_to_awesome_translations_namespace!
    end

    redirect_back(fallback_location: :root)
  end
end
