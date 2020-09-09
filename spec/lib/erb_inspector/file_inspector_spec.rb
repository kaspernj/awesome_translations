require "spec_helper"

describe AwesomeTranslations::ErbInspector::FileInspector do # rubocop:disable RSpec/MultipleMemoizedHelpers
  let(:erb_inspector) do
    AwesomeTranslations::ErbInspector.new(
      dirs: [Rails.root.to_s]
    )
  end

  let(:files) { erb_inspector.files.to_a }
  let(:file_paths) { files.map(&:file_path) }
  let(:js_translations_inspector) { files.find { |file_inspector| file_inspector.file_path == "app/assets/javascripts/translations.js" } }
  let(:user_index_inspector) { files.find { |file_inspector| file_inspector.file_path == "app/views/users/index.html.haml" } }
  let(:user_edit_inspector) { files.find { |file_inspector| file_inspector.file_path == "app/views/users/edit.html.liquid" } }
  let(:user_index_translations) { user_index_inspector.translations.to_a }
  let(:hello_world_translation) { user_index_translations.find { |translation| translation.key == ".hello_world" } }

  describe "#translations" do # rubocop:disable RSpec/MultipleMemoizedHelpers
    it "finds the right number of translations" do
      expect(user_index_translations.length).to eq 3
    end

    it "finds javascript translations" do
      translation_keys = js_translations_inspector.translations.map(&:key)
      translation_full_keys = js_translations_inspector.translations.map(&:full_key)

      expect(translation_keys).to include ".hello_world"
      expect(translation_keys).to include "javascripts.absolute.key"

      expect(translation_full_keys).to include "assets.javascripts.translations.hello_world"
      expect(translation_full_keys).to include "javascripts.absolute.key"
      expect(translation_full_keys).to include "javascripts.absolute.key_with_args"
    end

    it "finds liquid translations" do
      translation_keys = user_edit_inspector.translations.map(&:key)

      expect(translation_keys).to include ".edit_user"
      expect(translation_keys).to include ".test_for_liquid_templates"
      expect(translation_keys).to include ".test_for_liquid_templates_with_var_double_quotes"
      expect(translation_keys).to include ".test_for_liquid_templates_with_var_single_quotes"
      expect(translation_keys).to include ".test_for_liquid_templates_with_escape"
      expect(translation_keys).to include ".test_for_liquid_templates_with_var_escape"
    end
  end
end
