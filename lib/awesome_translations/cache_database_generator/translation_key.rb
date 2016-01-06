class AwesomeTranslations::CacheDatabaseGenerator::TranslationKey < BazaModels::Model
  belongs_to :group, foreign_key: "group_id"
  belongs_to :handler, foreign_key: "handler_id"

  has_many :handler_translations, dependent: :restrict_with_error, foreign_key: "translation_key_id", class_name: "AwesomeTranslations::CacheDatabaseGenerator::HandlerTranslation"
  has_many :translation_values, dependent: :restrict_with_error, foreign_key: "translation_key_id", class_name: "AwesomeTranslations::CacheDatabaseGenerator::TranslationValue"

  validates_presence_of :group, :handler

  def last_key
    key.to_s.split('.').last
  end
end
