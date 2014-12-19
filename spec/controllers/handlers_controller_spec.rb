require "spec_helper"
require "fileutils"

describe AwesomeTranslations::HandlersController do
  render_views

  it "#index" do
    get :index, use_route: "awesome_translations"
    response.should be_success
  end

  it "#show" do
    get :show, id: "model_handler", use_route: "awesome_translations"
    response.should be_success
  end

  it "#update" do
    model_locales_path = "#{Rails.root}/config/locales/awesome_translations/models"
    FileUtils.rm_f(model_locales_path) if File.exist?(model_locales_path)

    put :update, id: "model_handler", use_route: "awesome_translations", t: {
      "activerecord.attributes.user.password" => {"da" => "Adgangskode", "de" => "Kenwort", "en" => "Password"},
      "activerecord.attributes.role.role" => {"da" => "Rolle", "de" => "Die type", "en" => "Role"}
    }

    danish_user_translations = YAML.load(File.read("#{model_locales_path}/user/da.yml"))
    danish_role_translations = YAML.load(File.read("#{model_locales_path}/role/da.yml"))

    danish_role_translations["da"]["activerecord"]["attributes"]["role"]["role"].should eq "Rolle"
    danish_user_translations["da"]["activerecord"]["attributes"]["user"]["password"].should eq "Adgangskode"
  end
end
