class AwesomeTranslations::CacheDatabaseGenerator::Handler < BazaModels::Model
  has_many :groups, dependent: :destroy, foreign_key: "handler_id", class_name: "AwesomeTranslations::CacheDatabaseGenerator::Group"

  validates_presence_of :name
end
