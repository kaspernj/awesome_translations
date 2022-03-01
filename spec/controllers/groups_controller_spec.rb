require "spec_helper"

describe AwesomeTranslations::GroupsController do
  routes { AwesomeTranslations::Engine.routes }

  let(:model_locales_path) { Rails.root.join("config/locales/awesome_translations/models").to_s }
  let(:user_yml_path) { "#{model_locales_path}/user/da.yml" }
  let(:role_yml_path) { "#{model_locales_path}/role/da.yml" }
  let(:date_time_path) { Rails.root.join("config/locales/awesome_translations/date_time/da.yml").to_s }

  before do
    AwesomeTranslations::CacheDatabaseGenerator.current.cache_translations

    FileUtils.rm_f(model_locales_path) if File.exist?(model_locales_path)
    FileUtils.rm_f(date_time_path) if File.exist?(date_time_path)

    I18n.load_path.delete(date_time_path)
    I18n.load_path.delete(model_locales_path)
  end

  render_views

  describe "#update" do
    it "updates translations" do
      expect(I18n.load_path).not_to include model_locales_path

      put :update, params: {handler_id: "model_handler", id: "User", t: {
        "activerecord.attributes.user.password" => {"da" => "Adgangskode", "de" => "Kenwort", "en" => "Password"}
      }}

      danish_user_translations = YAML.load_file(user_yml_path)
      expect(danish_user_translations["da"]["activerecord"]["attributes"]["user"]["password"]).to eq "Adgangskode"
    end

    it "updates paths" do
      key_to_update = "activerecord.attributes.role.role"

      put :update, params: {handler_id: "model_handler", id: "Role", t: {
        key_to_update => {"da" => "Rolle", "de" => "Die type", "en" => "Role"}
      }}

      da_translation_value = AwesomeTranslations::CacheDatabaseGenerator::TranslationValue
        .joins(:translation_key)
        .find_by(translation_keys: {key: key_to_update}, locale: "da")

      de_translation_value = AwesomeTranslations::CacheDatabaseGenerator::TranslationValue
        .joins(:translation_key)
        .find_by(translation_keys: {key: key_to_update}, locale: "de")

      expect(da_translation_value).not_to be_nil
      expect(da_translation_value.value).to eq "Rolle"

      expect(de_translation_value).not_to be_nil
      expect(de_translation_value.value).to eq "Die type"

      expect(I18n.load_path).to include role_yml_path
    end

    it "handles array translations" do
      put :update, params: {handler_id: "rails_handler", id: "date_time", t: {
        "date.day_names" => {
          "1" => {
            "da" => "Mandag"
          },
          "4" => {
            "da" => "Torsdag"
          }
        }
      }}

      translations = YAML.load_file(date_time_path)

      expect(translations["da"]["date"]["day_names"][1]).to eq "Mandag"
      expect(translations["da"]["date"]["day_names"][4]).to eq "Torsdag"
    end
  end

  it "#update_translations_cache" do
    request.env["HTTP_REFERER"] = handler_group_path("rails_handler", "date_time")
    post :update_translations_cache, params: {handler_id: "rails_handler", id: "date_time"}
    expect(response).to redirect_to handler_group_path("rails_handler", "date_time")
  end
end
