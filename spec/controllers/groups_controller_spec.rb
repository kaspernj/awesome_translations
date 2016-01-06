require "spec_helper"

describe AwesomeTranslations::GroupsController do
  routes { AwesomeTranslations::Engine.routes }

  let(:model_locales_path) { "#{Rails.root}/config/locales/awesome_translations/models" }
  let(:user_yml_path) { "#{model_locales_path}/user/da.yml" }
  let(:role_yml_path) { "#{model_locales_path}/role/da.yml" }
  let(:date_time_path) { Rails.root.join('config', 'locales', 'awesome_translations', 'date_time', 'da.yml') }

  before do
    FileUtils.rm_f(model_locales_path) if File.exist?(model_locales_path)
    FileUtils.rm_f(date_time_path) if File.exist?(date_time_path)

    I18n.load_path.delete(date_time_path.to_s)
    I18n.load_path.delete(model_locales_path)
  end

  render_views

  describe "#update" do
    it "updates translations" do
      expect(I18n.load_path).to_not include model_locales_path

      put :update, handler_id: "model_handler", id: "User", t: {
        "activerecord.attributes.user.password" => {"da" => "Adgangskode", "de" => "Kenwort", "en" => "Password"}
      }

      danish_user_translations = YAML.load_file(user_yml_path)
      expect(danish_user_translations["da"]["activerecord"]["attributes"]["user"]["password"]).to eq "Adgangskode"
    end

    it "updates paths" do
      put :update, handler_id: "model_handler", id: "Role", t: {
        "activerecord.attributes.role.role" => {"da" => "Rolle", "de" => "Die type", "en" => "Role"}
      }

      expect(I18n.load_path).to include role_yml_path
    end

    it 'handles array translations' do
      put :update, handler_id: 'rails_handler', id: 'date_time', t: {
        'date.day_names' => {
          '1' => {
            'da' => 'Mandag'
          },
          '4' => {
            'da' => 'Torsdag'
          }
        }
      }

      translations = YAML.load_file(date_time_path)

      expect(translations['da']['date']['day_names'][1]).to eq 'Mandag'
      expect(translations['da']['date']['day_names'][4]).to eq 'Torsdag'
    end
  end
end
