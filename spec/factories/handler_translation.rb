FactoryBot.define do
  factory :handler_translation, class: "AwesomeTranslations::CacheDatabaseGenerator::HandlerTranslation" do
    handler
    translation_key
    group

    key_show "some.key"
    file_path nil
    line_no nil
    full_path nil
    dir "#{Rails.root}/config/locales/awesome_translations/some/key"
  end
end
