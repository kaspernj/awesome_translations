require "spec_helper"

describe AwesomeTranslations::Handlers::LibraryHandler do
  let(:handler) { AwesomeTranslations::Handlers::LibraryHandler.new }
  let(:group) { handler.groups.select { |group| group.name == "app/models/role.rb" }.first }
  let(:mailer_group) { handler.groups.select { |group| group.name == "app/mailers/my_mailer.rb" }.first }
  let(:subject_translation) { mailer_group.translations.select { |translation| translation.key == "my_mailer.mailer_action.custom_subject" }.first }
  let(:admin_translation) { group.translations.select { |translation| translation.key == "models.role.administrator" }.first }
  let(:application_helper_group) { handler.groups.select { |group| group.name == 'app/helpers/application_helper.rb' }.first }
  let(:hello_world_translation) { application_helper_group.translations.select { |translation| translation.key == 'helpers.application_helper.hello_world' }.first }
  let(:users_controller_handler) { handler.groups.select { |group| group.name == 'app/controllers/users_controller.rb' }.first }
  let(:update_saved_translation) { users_controller_handler.translations.select { |translation| translation.key == 'users.user_was_updated' }.first }

  it "finds translations made with the t method" do
    expect(admin_translation).to_not eq nil
    expect(admin_translation.key).to eq "models.role.administrator"
    expect(admin_translation.dir).to end_with "spec/dummy/config/locales/awesome_translations/app/models/role"
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

  it 'finds translations with the controller_t-method' do
    expect(update_saved_translation).to_not eq nil
    expect(update_saved_translation.key).to eq 'users.user_was_updated'
    expect(update_saved_translation.dir).to end_with 'spec/dummy/config/locales/awesome_translations/app/controllers/users_controller'
  end
end
