require "spec_helper"

describe AwesomeTranslations::Handlers::ModelHandler do
  let(:model_handler) { AwesomeTranslations::Handlers::ModelHandler.new }
  let(:groups) { model_handler.groups.to_a }
  let(:user_group) { model_handler.groups.select { |group| group.name == "User" }.first }
  let(:translation_keys) { user_group.translations.map { |translation| translation.key }.to_a }

  it "#groups" do
    groups.length.should eq 2
  end

  describe "#translations_for_group" do
    it "should find the right number of translations" do
      user_group.translations.to_a.length.should eq 7
    end

    it "finds the model translations" do
      translation_keys.should include "activerecord.models.user.other"
    end

    it "finds the attribute translations" do
      translation_keys.should include "activerecord.attributes.user.age"
    end

    it "finds the has_many association translations" do
      translation_keys.should include "activerecord.attributes.user.roles"
    end
  end
end
