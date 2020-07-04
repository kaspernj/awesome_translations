class AwesomeTranslations::CacheDatabaseGenerator::Group < BazaModels::Model
  attr_writer :at_group

  belongs_to :handler, class_name: "AwesomeTranslations::CacheDatabaseGenerator::Handler"

  has_many :handler_translations,
    dependent: :destroy,
    foreign_key: "group_id", # rubocop:disable Rails/RedundantForeignKey
    class_name: "AwesomeTranslations::CacheDatabaseGenerator::HandlerTranslation"

  has_many :translation_keys,
    dependent: :destroy,
    foreign_key: "group_id", # rubocop:disable Rails/RedundantForeignKey
    class_name: "AwesomeTranslations::CacheDatabaseGenerator::TranslationKey"

  validates_presence_of :name, :handler

  def at_handler
    @at_handler ||= handler.at_handler
  end

  def at_group
    @at_group ||= AwesomeTranslations::Group.find_by(handler: at_handler, id: identifier)
  end

  def to_param
    identifier
  end
end
