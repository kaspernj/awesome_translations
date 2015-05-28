require "spec_helper"

describe AwesomeTranslations::Handlers::LibraryHandler do
  let(:handler) { AwesomeTranslations::Handlers::LibraryHandler.new }
  let(:group) { handler.groups.select { |group| group.name == "app/models/role.rb" }.first }
  let(:mailer_group) { handler.groups.select { |group| group.name == "app/mailers/my_mailer.rb" }.first }
  let(:subject_translation) { mailer_group.translations.select { |translation| translation.key == "my_mailer.mailer_action.custom_subject" }.first }
  let(:admin_translation) { group.translations.select { |translation| translation.key == "models.role.administrator" }.first }

  it "finds translations made with the t method" do
    admin_translation.should_not eq nil
    admin_translation.key.should eq "models.role.administrator"
    admin_translation.dir.should end_with "spec/dummy/config/locales/awesome_translations/app/models"
  end

  it "generates keys with method-name for mailers" do
    expect(subject_translation.key).to eq "my_mailer.mailer_action.custom_subject"
  end

  it 'finds translations in arrays' do
    moderator_translation = group.translations.select { |translation| translation.key == "models.role.moderator" }.first
    user_translation = group.translations.select { |translation| translation.key == "models.role.user" }.first

    expect(moderator_translation).to_not eq nil
    expect(user_translation).to_not eq nil
  end
end
