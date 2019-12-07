FactoryBot.define do
  factory :translation_value, class: "AwesomeTranslations::CacheDatabaseGenerator::TranslationValue" do
    translation_key

    file_path { Rails.root.join("config/locales/some_file.yml") }
    locale { "en" }
    value { "English" }
  end
end
