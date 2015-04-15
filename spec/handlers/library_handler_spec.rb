require "spec_helper"

describe AwesomeTranslations::Handlers::LibraryHandler do
  let(:handler) { AwesomeTranslations::Handlers::LibraryHandler.new }
  let(:group) { handler.groups.select { |group| group.name == "app/models/role.rb" }.first }
  let(:admin_translation) { group.translations.select { |translation| translation.key == "models.role.administrator" }.first }

  it "finds translations made with the t method" do
    admin_translation.should_not eq nil
    admin_translation.key.should eq "models.role.administrator"
    admin_translation.dir.should end_with "spec/dummy/config/locales/awesome_translations/app/models"
  end
end
