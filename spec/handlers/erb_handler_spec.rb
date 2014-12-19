require "spec_helper"

describe AwesomeTranslations::Handlers::ErbHandler do
  let(:handler) { AwesomeTranslations::Handlers::ErbHandler.new }
  let(:translations) { handler.translations }

  it "finds translations made with the _ method" do
    hello_world_translations = translations.select { |t| t.key == "views.users.index.hello_world_from_custom" }
    hello_world_translations.length.should eq 1
  end

  it "finds translations made with the t method" do
    hello_world_translations = translations.select { |t| t.key == "views.users.index.hello_world_from_i18n" }
    hello_world_translations.length.should eq 1
  end

  it "finds translations in the layout" do
    danish_translations = translations.select { |t| t.key == "views.layouts.application.danish" }
    danish_translations.length.should eq 1
  end

  it "removes special characters when using the custom method" do
    current_language_translation = translations.select { |t| t.key == "views.layouts.application.the_current_language_is" }
    current_language_translation.length.should eq 1
  end
end
