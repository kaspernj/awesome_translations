require "spec_helper"

describe AwesomeTranslations::MovalsController do # rubocop:disable RSpec/MultipleMemoizedHelpers
  let!(:handler_translation) do
    create :handler_translation,
      translation_key: translation_key,
      dir: Rails.root.join("config/locales/some/right/path")
  end
  let!(:translation_key) { create :translation_key, key: "some.key" }
  let!(:translation_value) do
    create :translation_value,
      translation_key: translation_key,
      file_path: Rails.root.join("config/locales/some/wrong/path/en.yml")
  end

  let!(:handler_translation_right_path) { create :handler_translation, translation_key: translation_key_right_path, dir: "/some/path" }
  let!(:translation_key_right_path) { create :translation_key, key: "some.right.key" }
  let!(:translation_value_right_path) { create :translation_value, translation_key: translation_key_right_path, file_path: "/some/path/en.yml" }

  before do
    dir_path = File.dirname(translation_value.file_path)
    FileUtils.mkdir_p(dir_path) unless File.exist?(dir_path)

    translation_yaml = {
      "en" => {
        "some" => {
          "key" => "translation"
        }
      }
    }

    File.open(translation_value.file_path, "w") do |fp|
      fp.write(YAML.dump(translation_yaml))
    end
  end

  describe "#index" do # rubocop:disable RSpec/MultipleMemoizedHelpers
    it "renders the page and shows the correct results" do
      visit movals_path

      expect(page).to have_http_status(:success)
      expect(page).to have_current_path movals_path, ignore_query: true

      find("input[type=checkbox][value='#{handler_translation.id}']") # Expect to find

      expect do
        find("input[type=checkbox][value='#{handler_translation_right_path.id}']")
      end.to raise_error(Capybara::ElementNotFound)
    end
  end

  describe "#create" do # rubocop:disable RSpec/MultipleMemoizedHelpers
    it "moves the checked translations to the right path" do
      visit movals_path

      find("input[type=submit]").click
      translation_value.reload

      expect(translation_value.file_path).to eq Rails.root.join("config/locales/some/right/path/en.yml").to_s
    end
  end
end
