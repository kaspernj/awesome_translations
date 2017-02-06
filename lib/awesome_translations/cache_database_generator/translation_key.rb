class AwesomeTranslations::CacheDatabaseGenerator::TranslationKey < BazaModels::Model
  has_many :handler_translations, dependent: :destroy, foreign_key: "translation_key_id", class_name: "AwesomeTranslations::CacheDatabaseGenerator::HandlerTranslation"
  has_many :translation_values, dependent: :destroy, foreign_key: "translation_key_id", class_name: "AwesomeTranslations::CacheDatabaseGenerator::TranslationValue"

  validates_presence_of :group, :handler

  def last_key
    key.to_s.split(".").last
  end
end
