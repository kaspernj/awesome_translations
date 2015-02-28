require "spec_helper"

describe AwesomeTranslations::Handlers::ErbHandler do
  let(:handler) { AwesomeTranslations::Handlers::ErbHandler.new }
  let(:users_index_group) { handler.groups.select { |group| group.name == "app/views/users/index.html.haml" }.first }
  let(:users_index_translations) { users_index_group.translations }
  let(:users_partial_test_translations) { handler.groups.select { |group| group.name == "app/views/users/_partial_test.html.haml" }.first.translations }
  let(:layout_group) { handler.groups.select { |group| group.name == "app/views/layouts/application.html.haml" }.first }
  let(:layout_translations) { layout_group.translations }

  it "finds translations made with the t method" do
    hello_world_translations = users_index_translations.select { |t| t.key == "users.index.hello_world" }
    hello_world_translations.length.should eq 1
  end

  it "finds translations in the layout" do
    danish_translations = layout_translations.select { |t| t.key == "layouts.application.danish" }
    danish_translations.length.should eq 1
  end

  it "doesnt include _ in partial keys" do
    partial_test = users_partial_test_translations.select { |t| t.key == "users.partial_test.partial_test" }
    partial_test.length.should eq 1
  end

  it "removes special characters when using the custom method" do
    current_language_translation = layout_translations.select { |t| t.key == "layouts.application.the_current_language_is" }
    current_language_translation.length.should eq 1
  end

  it "sets the correct translation path" do
    danish_translation = layout_translations.select { |t| t.key == "layouts.application.danish" }.first
    danish_translation.dir.should eq "#{Rails.root}/config/locales/awesome_translations/app/views/layouts"
  end
end
