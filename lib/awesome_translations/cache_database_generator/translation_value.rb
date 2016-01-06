class AwesomeTranslations::CacheDatabaseGenerator::TranslationValue < BazaModels::Model
  belongs_to :translation_key, foreign_key: "translation_key_id", class_name: "AwesomeTranslations::CacheDatabaseGenerator::TranslationKey"

  validates_presence_of :translation_key

  delegate :key, to: :translation_key

  def handler_translation
    AwesomeTranslations::CacheDatabaseGenerator::HandlerTranslation
      .where(translation_key_id: translation_key_id)
      .first
  end

  def calculated_translation_file_path
    "#{handler_translation.dir}/#{locale}.yml"
  end

  def migrate_to_awesome_translations_namespace!
    raise "stub!"
  end
end
