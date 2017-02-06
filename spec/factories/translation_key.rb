FactoryGirl.define do
  factory :translation_key, class: "AwesomeTranslations::CacheDatabaseGenerator::TranslationKey" do
    key "some.key"
  end
end
