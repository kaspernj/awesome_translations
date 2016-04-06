FactoryGirl.define do
  factory :handler, class: "AwesomeTranslations::CacheDatabaseGenerator::Handler" do
    identifier "rails_handler"
    name "RailsHandler"

    factory :model_handler do
      identifier "model_handler"
      name "ModelHandler"
    end
  end
end
