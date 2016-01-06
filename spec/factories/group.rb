FactoryGirl.define do
  factory :group, class: "AwesomeTranslations::CacheDatabaseGenerator::Group" do
    handler

    identifier "tests"
    name "Tests"
  end
end
