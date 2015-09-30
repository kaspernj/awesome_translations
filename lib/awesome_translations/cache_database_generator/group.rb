class AwesomeTranslations::CacheDatabaseGenerator::Group < BazaModels::Model
  belongs_to :handler

  has_many :handler_translations, dependent: :destroy, foreign_key: "group_id", class_name: "AwesomeTranslations::CacheDatabaseGenerator::HandlerTranslation"
  has_many :translation_keys, dependent: :destroy, foreign_key: "group_id", class_name: "AwesomeTranslations::CacheDatabaseGenerator::TranslationKey"

  validates_presence_of :name, :handler
end
