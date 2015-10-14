require "spec_helper"

describe AwesomeTranslations::Handlers::ValidationsHandler do
  let(:validations_handler) { AwesomeTranslations::Handlers::ValidationsHandler.new }
  let(:user_group) { validations_handler.groups.select { |group| group.name == "User" }.first }
  let(:blank_email_translation) { user_group.translations.select { |translation| translation.key.include? "email.blank" }.first }

  it "#groups" do
    expect(validations_handler.groups.to_a.length).to eq 4
  end

  describe "#translations_for_group" do
    it "finds the right number of validation translations" do
      user_group.translations.to_a.length.should eq 6
    end

    it "finds the right key" do
      blank_email_translation.key.should eq "activerecord.errors.models.user.attributes.email.blank"
    end

    it "finds the right directory" do
      blank_email_translation.dir.should eq "#{Rails.root}/config/locales/awesome_translations/models/user"
    end

    it 'finds confirmation translations' do
      confirmation_translation = user_group.translations.select { |translation| translation.key.include? 'email_confirmation' }.first
      expect(confirmation_translation).to_not be_blank
      expect(confirmation_translation.key).to eq 'activerecord.attributes.user.email_confirmation'
    end
  end
end
