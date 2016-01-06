require "spec_helper"

describe AwesomeTranslations::ModelInspector::Attribute do
  let(:user_inspector) { AwesomeTranslations::ModelInspector.model_classes.find { |model_inspector| model_inspector.clazz == User } }
  let(:email_attr) { user_inspector.attributes.find { |attribute| attribute.name == "email" } }

  it "#i18n_key" do
    expect(email_attr.i18n_key).to eq "activerecord.attributes.user.email"
  end

  it "#name" do
    expect(email_attr.name).to eq "email"
  end

  it "#model_inspector" do
    expect(email_attr.model_inspector.clazz).to eq User
  end
end
