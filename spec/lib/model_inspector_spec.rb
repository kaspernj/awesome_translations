require "spec_helper"

describe AwesomeTranslations::ModelInspector do
  let(:user_inspector) { AwesomeTranslations::ModelInspector.model_classes.find { |model_inspector| model_inspector.clazz == User } }
  let(:model_classes) { AwesomeTranslations::ModelInspector.model_classes.map(&:clazz).reject { |clazz| clazz.name.end_with?("::Translation") } }

  it "#model_classes" do
    expect(model_classes.to_a.sort_by(&:name)).to eq [Role, User]
  end

  it "#engines" do
    expected = [ActionView::Railtie, AwesomeTranslations::Engine, MoneyRails::Engine]
    expect(AwesomeTranslations::ModelInspector.engines.map(&:class).sort_by(&:name)).to eq expected
  end

  it "#class_key" do
    expect(user_inspector.class_key).to eq "activerecord.models.user"
  end

  it "#class_key_one" do
    expect(user_inspector.class_key_one).to eq "activerecord.models.user.one"
  end

  it "#class_key_other" do
    expect(user_inspector.class_key_other).to eq "activerecord.models.user.other"
  end

  it "#attribute_key" do
    expect(user_inspector.attribute_key("first_name")).to eq "activerecord.attributes.user.first_name"
  end

  it "#snake_name" do
    expect(user_inspector.snake_name).to eq "user"
  end

  it "#attributes" do
    expect(user_inspector.attributes.map(&:name).to_a).to eq %w[id email password age]
  end
end
