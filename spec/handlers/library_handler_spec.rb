require "spec_helper"

describe AwesomeTranslations::Handlers::LibraryHandler do
  let(:handler) { AwesomeTranslations::Handlers::LibraryHandler.new }
  let(:group) { handler.groups.select { |group| group.name == "app/models/role.rb" }.first }
  let(:mailer_group) { handler.groups.select { |group| group.name == "app/mailers/my_mailer.rb" }.first }
  let(:subject_translation) { mailer_group.translations.select { |translation| translation.key == "my_mailer.mailer_action.custom_subject" }.first }
  let(:admin_translation) { group.translations.select { |translation| translation.key == "models.role.administrator" }.first }
  let(:application_helper_group) { handler.groups.select { |group| group.name == 'app/helpers/application_helper.rb' }.first }
  let(:hello_world_translation) { application_helper_group.translations.select { |translation| puts "Translation: #{translation}"; translation.key == 'helpers.application_helper.hello_world' }.first }

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

  it 'finds helpers translations using helper_t' do
    expect(hello_world_translation.key).to eq 'helpers.application_helper.hello_world'
  end
end
