require "spec_helper"

describe AwesomeTranslations::Handlers::GlobalHandler do
  let(:global_handler) { AwesomeTranslations::Handlers::GlobalHandler.new }
  let(:translations) { global_handler.groups.first.translations.to_a }
  let(:yes_translation) { translations.select { |translation| translation.key == "yes" }.first }

  it "finds the right translations" do
    expect(translations.length).to eq 2
  end

  it "reads the keys right" do
    expect(yes_translation.key).to eq "yes"
  end

  it "sets the correct translation path" do
    expect(yes_translation.dir).to eq "#{Rails.root}/config/locales/awesome_translations"
  end
end
