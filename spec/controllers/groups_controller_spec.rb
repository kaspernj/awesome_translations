require "spec_helper"

describe AwesomeTranslations::GroupsController do
  let(:model_locales_path) { "#{Rails.root}/config/locales/awesome_translations/models" }
  let(:user_yml_path) { "#{model_locales_path}/user/da.yml" }
  let(:role_yml_path) { "#{model_locales_path}/role/da.yml" }

  before do
    FileUtils.rm_f(model_locales_path) if File.exist?(model_locales_path)
  end

  render_views

  describe "#update" do
    it "updates translations" do
      I18n.load_path.should_not include model_locales_path

      put :update, handler_id: "model_handler", id: "User", use_route: "awesome_translations", t: {
        "activerecord.attributes.user.password" => {"da" => "Adgangskode", "de" => "Kenwort", "en" => "Password"}
      }

      danish_user_translations = YAML.load_file(user_yml_path)
      danish_user_translations["da"]["activerecord"]["attributes"]["user"]["password"].should eq "Adgangskode"
    end

    it "updates paths" do
      put :update, handler_id: "model_handler", id: "Role", use_route: "awesome_translations", t: {
        "activerecord.attributes.role.role" => {"da" => "Rolle", "de" => "Die type", "en" => "Role"}
      }

      I18n.load_path.should include role_yml_path
    end
  end
end
