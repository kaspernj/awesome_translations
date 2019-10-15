require "spec_helper"

describe AwesomeTranslations::Handlers::ValidationsHandler do
  let(:validations_handler) { AwesomeTranslations::Handlers::ValidationsHandler.new }
  let(:user_group) { validations_handler.groups.find { |group| group.name == "User" } }
  let(:blank_email_translation) { user_group.translations.find { |translation| translation.key.include? "email.blank" } }

  it "#groups" do
    expect(validations_handler.groups.to_a.length).to eq 4
  end

  describe "#translations_for_group" do
    it "finds the right number of validation translations" do
      expect(user_group.translations.to_a.length).to eq 6
    end

    it "finds the right key" do
      expect(blank_email_translation.key).to eq "activerecord.errors.models.user.attributes.email.blank"
    end

    it "finds the right directory" do
      expect(blank_email_translation.dir).to eq "#{Rails.root}/config/locales/awesome_translations/models/user"
    end

    it "finds confirmation translations" do
      confirmation_translation = user_group.translations.find { |translation| translation.key.include? "email_confirmation" }
      expect(confirmation_translation).not_to be_blank
      expect(confirmation_translation.key).to eq "activerecord.errors.models.user.attributes.email_confirmation.confirmation"
    end
  end
end
