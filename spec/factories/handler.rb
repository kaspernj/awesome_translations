FactoryGirl.define do
  factory :handler, class: "AwesomeTranslations::CacheDatabaseGenerator::Handler" do
    identifier "rails_handler"
    name "Rails Handler"
  end
end
