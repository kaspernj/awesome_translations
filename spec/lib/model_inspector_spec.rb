require "spec_helper"

describe AwesomeTranslations::ModelInspector do
  let(:user_inspector) { AwesomeTranslations::ModelInspector.model_classes.select { |model_inspector| model_inspector.clazz == User }.first }
  let(:model_classes) { AwesomeTranslations::ModelInspector.model_classes.map(&:clazz).select { |clazz| !clazz.name.end_with?("::Translation") } }

  it "#model_classes" do
    require "jquery-rails"

    model_classes.to_a.sort { |class1, class2| class1.name <=> class2.name }.should eq [Role, User]
  end

  it "#engines" do
    AwesomeTranslations::ModelInspector.engines.map(&:class).sort { |class1, class2| class1.name <=> class2.name }.should eq [AwesomeTranslations::Engine, Haml::Rails::Engine, Jquery::Rails::Engine, MoneyRails::Engine]
  end

  it "#class_key" do
    user_inspector.class_key.should eq "activerecord.models.user"
  end

  it "#class_key_one" do
    user_inspector.class_key_one.should eq "activerecord.models.user.one"
  end

  it "#class_key_other" do
    user_inspector.class_key_other.should eq "activerecord.models.user.other"
  end

  it "#attribute_key" do
    user_inspector.attribute_key("first_name").should eq "activerecord.attributes.user.first_name"
  end

  it "#snake_name" do
    user_inspector.snake_name.should eq "user"
  end

  it "#attributes" do
    user_inspector.attributes.map(&:name).to_a.should eq ["id", "email", "password", "age"]
  end
end
