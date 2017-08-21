class AwesomeTranslations::DuplicatesController < AwesomeTranslations::ApplicationController
  def index
    @duplicates = AwesomeTranslations::CacheDatabaseGenerator::TranslationValue
      .select("translation_values.*, duplicate_translation_values.id AS duplicate_id")
      .joins("
        INNER JOIN translation_values AS duplicate_translation_values ON
          duplicate_translation_values.translation_key_id = translation_values.translation_key_id
      ")
      .where("translation_values.id < duplicate_translation_values.id")
      .where("translation_values.locale = duplicate_translation_values.locale")
  end

  def create
    ids = []
    params[:d].each do |translation_value_id, check_value|
      ids << translation_value_id.to_i if check_value == "1"
    end

    translation_values = AwesomeTranslations::CacheDatabaseGenerator::TranslationValue
      .where(id: ids)

    translation_values.each do |translation_value|
      AwesomeTranslations::TranslationMigrator.new(translation_value: translation_value).execute
      translation_value.destroy!
    end

    redirect_back(fallback_location: :root)
  end
end
