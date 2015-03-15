require "spec_helper"

describe AwesomeTranslations::ModelInspector::Attribute do
  let(:user_inspector) { AwesomeTranslations::ModelInspector.model_classes.select { |model_inspector| model_inspector.clazz == User }.first }
  let(:email_attr) { user_inspector.attributes.select { |attribute| attribute.name == "email" }.first }

  it "#i18n_key" do
    email_attr.i18n_key.should eq "activerecord.attributes.user.email"
  end

  it "#name" do
    email_attr.name.should eq "email"
  end

  it "#model_inspector" do
    email_attr.model_inspector.clazz.should eq User
  end
end
