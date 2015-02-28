require "spec_helper"

describe AwesomeTranslations::Handlers::ValidationsHandler do
  let(:validations_handler) { AwesomeTranslations::Handlers::ValidationsHandler.new }
  let(:user_group) { validations_handler.groups.select { |group| group.name == "User" }.first }
  let(:blank_email_translation) { user_group.translations.select { |translation| translation.key.include? "email.blank" }.first }

  it "#groups" do
    validations_handler.groups.to_a.length.should eq 2
  end

  describe "#translations_for_group" do
    it "finds the right number of validation translations" do
      user_group.translations.to_a.length.should eq 5
    end

    it "finds the right key" do
      blank_email_translation.key.should eq "activerecord.errors.models.user.attributes.email.blank"
    end

    it "finds the right directory" do
      blank_email_translation.dir.should eq "#{Rails.root}/config/locales/awesome_translations/models/user"
    end
  end
end
