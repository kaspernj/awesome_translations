class AwesomeTranslations::CacheDatabaseGenerator::TranslationKey < BazaModels::Model
  belongs_to :group, foreign_key: "group_id" # rubocop:disable Rails/RedundantForeignKey
  belongs_to :handler, foreign_key: "handler_id" # rubocop:disable Rails/RedundantForeignKey

  has_many :handler_translations,
    dependent: :destroy,
    foreign_key: "translation_key_id", # rubocop:disable Rails/RedundantForeignKey
    class_name: "AwesomeTranslations::CacheDatabaseGenerator::HandlerTranslation"

  has_many :translation_values,
    dependent: :destroy,
    foreign_key: "translation_key_id", # rubocop:disable Rails/RedundantForeignKey
    class_name: "AwesomeTranslations::CacheDatabaseGenerator::TranslationValue"

  validates_presence_of :group, :handler

  def last_key
    key.to_s.split(".").last
  end
end
