require "spec_helper"

describe AwesomeTranslations::Handlers::GlobalHandler do
  let(:global_handler) { AwesomeTranslations::Handlers::GlobalHandler.new }
  let(:translations) { global_handler.groups.first.translations.to_a }
  let(:yes_translation) { translations.select { |translation| translation.key == "yes" }.first }

  it "finds the right translations" do
    translations.length.should eq 2
  end

  it "reads the keys right" do
    yes_translation.key.should eq "yes"
  end

  it "sets the correct translation path" do
    yes_translation.dir.should eq "#{Rails.root}/config/locales/awesome_translations"
  end
end
