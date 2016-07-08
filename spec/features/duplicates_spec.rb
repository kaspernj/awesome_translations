require "spec_helper"

describe AwesomeTranslations::DuplicatesController do
  let!(:handler_translation) { create :handler_translation, translation_key: translation_key, dir: Rails.root.join("config", "locales", "some", "right", "path") }
  let!(:translation_key) { create :translation_key, key: "some.key" }
  let!(:translation_value) { create :translation_value, translation_key: translation_key, file_path: Rails.root.join("config", "locales", "some", "right", "path", "en.yml") }
  let!(:translation_value_duplicate) { create :translation_value, translation_key: translation_key, file_path: Rails.root.join("config", "locales", "some", "wrong", "path", "en.yml") }

  before do
    dir_path = File.dirname(translation_value_duplicate.file_path)
    FileUtils.mkdir_p(dir_path) unless File.exist?(dir_path)

    translation_yaml = {
      "en" => {
        "some" => {
          "key" => "translation"
        }
      }
    }

    File.open(translation_value_duplicate.file_path, "w") do |fp|
      fp.write(YAML.dump(translation_yaml))
    end
  end

  describe "#index" do
    it "renders the page and shows the correct duplicates" do
      visit duplicates_path

      expect(page).to have_http_status(:success)
      expect(current_path).to eq duplicates_path

      find("input[type=checkbox][name='d[#{translation_value_duplicate.id}]']")

      expect do
        find("input[type=checkbox][name='d[#{translation_value.id}]']")
      end.to raise_error(Capybara::ElementNotFound)
    end
  end

  describe "#create" do
    it "removes the checked translations" do
      visit duplicates_path

      find("input[type=submit]").click

      expect(File.exist?(translation_value_duplicate.file_path)).to eq false
      expect { translation_value_duplicate.reload }.to raise_error(BazaModels::Errors::RecordNotFound)
    end
  end
end
