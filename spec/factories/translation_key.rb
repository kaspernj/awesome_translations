FactoryGirl.define do
  factory :translation_key, class: "AwesomeTranslations::CacheDatabaseGenerator::TranslationKey" do
    handler
    group

    key "some.key"
  end
end
