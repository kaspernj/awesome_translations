require "spec_helper"

describe AwesomeTranslations::Handlers::FileHandler do
  let(:handler) { AwesomeTranslations::Handlers::FileHandler.new }

  describe "erb stuff" do
    let(:users_index_group) { handler.groups.find { |group| group.name == "app/views/users/index.html.haml" } }
    let(:users_index_translations) { users_index_group.translations }
    let(:users_partial_test_translations) { handler.groups.find { |group| group.name == "app/views/users/_partial_test.html.erb" }.translations }
    let(:layout_group) { handler.groups.find { |group| group.name == "app/views/layouts/application.html.erb" } }
    let(:layout_translations) { layout_group.translations }

    it "finds translations made with the t method" do
      hello_world_translations = users_index_translations.select { |t| t.key == "users.index.hello_world" }.to_a
      expect(hello_world_translations.length).to eq 1
    end

    it "finds translations in the layout" do
      danish_translations = layout_translations.select { |t| t.key == "layouts.application.danish" }.to_a
      expect(danish_translations.length).to eq 1
    end

    it "doesnt include _ in partial keys" do
      partial_test = users_partial_test_translations.select { |t| t.key == "users.partial_test.partial_test" }.to_a
      expect(partial_test.length).to eq 1
    end

    it "removes special characters when using the custom method" do
      current_language_translation = layout_translations.select { |t| t.key == "layouts.application.the_current_language_is" }.to_a
      expect(current_language_translation.length).to eq 1
    end

    it "has unique translations" do
      expect(layout_translations.select { |t| t.key == "layouts.application.hello_world" }.to_a.length).to eq 1
    end

    it "sets the correct translation path" do
      danish_translation = layout_translations.find { |t| t.key == "layouts.application.danish" }
      expect(danish_translation.dir).to eq "#{Rails.root}/config/locales/awesome_translations/layouts/application"
    end
  end

  describe "library stuff" do
    let(:group) { handler.groups.find { |group| group.name == "app/models/role.rb" } }
    let(:mailer_group) { handler.groups.find { |group| group.name == "app/mailers/my_mailer.rb" } }
    let(:subject_translation) { mailer_group.translations.find { |translation| translation.key == "my_mailer.mailer_action.custom_subject" } }
    let(:admin_translation) { group.translations.find { |translation| translation.key == "models.role.administrator" } }
    let(:application_helper_group) { handler.groups.find { |group| group.name == "app/helpers/application_helper.rb" } }
    let(:hello_world_translation) { application_helper_group.translations.find { |translation| translation.key == "helpers.application_helper.hello_world" } }
    let(:users_controller_handler) { handler.groups.find { |group| group.name == "app/controllers/users_controller.rb" } }
    let(:update_saved_translation) { users_controller_handler.translations.find { |translation| translation.key == "users.user_was_updated" } }

    it "finds translations made with the t method" do
      expect(admin_translation).to_not eq nil
      expect(admin_translation.key).to eq "models.role.administrator"
      expect(admin_translation.dir).to end_with "spec/dummy/config/locales/awesome_translations/models/role"
    end

    it "generates keys with method-name for mailers" do
      expect(subject_translation.key).to eq "my_mailer.mailer_action.custom_subject"
    end

    it "finds translations in arrays" do
      moderator_translation = group.translations.find { |translation| translation.key == "models.role.moderator" }
      user_translation = group.translations.find { |translation| translation.key == "models.role.user" }

      expect(moderator_translation).to_not eq nil
      expect(user_translation).to_not eq nil
    end

    it "finds helpers translations using helper_t" do
      expect(hello_world_translation.key).to eq "helpers.application_helper.hello_world"
    end

    it "finds translations with the controller_t-method" do
      expect(update_saved_translation).to_not eq nil
      expect(update_saved_translation.key).to eq "users.user_was_updated"
      expect(update_saved_translation.dir).to end_with "spec/dummy/config/locales/awesome_translations/users"
    end
  end

  describe "global stuff" do
    let(:group) { handler.groups.find { |group| group.name == "app/views/users/show.html.erb" } }
    let(:translations) { group.translations.to_a }
    let(:yes_translation) { translations.find { |translation| translation.key == "yes" } }

    it "finds the right translations" do
      expect(translations.length).to eq 4
    end

    it "reads the keys right" do
      expect(yes_translation.key).to eq "yes"
    end

    it "sets the correct translation path" do
      expect(yes_translation.dir).to eq "#{Rails.root}/config/locales/awesome_translations"
    end

    it "detects absolute existing direct translations" do
      expect(translations.map(&:key)).to include "activerecord.attributes.users.email"
    end
  end
end
