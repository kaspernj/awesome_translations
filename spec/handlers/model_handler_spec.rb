require "spec_helper"

describe AwesomeTranslations::Handlers::ModelHandler do
  let(:model_handler) { AwesomeTranslations::Handlers::ModelHandler.new }
  let(:groups) { model_handler.groups.to_a }
  let(:user_group) { model_handler.groups.detect { |group| group.name == "User" } }
  let(:role_group) { model_handler.groups.detect { |group| group.name == "Role" } }
  let(:translation_keys) { user_group.translations.map(&:key).to_a }
  let(:role_translation_keys) { role_group.translations.map(&:key).to_a }

  it "#groups" do
    expect(groups.length).to eq 4
  end

  describe "#translations_for_group" do
    it "should find the right number of translations" do
      expect(user_group.translations.to_a.length).to eq 7
    end

    it "finds the model translations" do
      expect(translation_keys).to include "activerecord.models.user.other"
    end

    it "finds the attribute translations" do
      expect(translation_keys).to include "activerecord.attributes.user.age"
    end

    it "finds the has_many association translations" do
      expect(translation_keys).to include "activerecord.attributes.user.roles"
    end

    it "finds money-rails translations" do
      expect(role_translation_keys).to include "activerecord.attributes.role.price"
    end
  end

  it "finds globalize translations" do
    expect(role_translation_keys).to include "activerecord.attributes.role.name"
  end
end
