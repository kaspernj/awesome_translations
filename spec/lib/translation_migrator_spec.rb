require "spec_helper"

describe AwesomeTranslations::TranslationMigrator do
  let!(:handler) { create :handler }
  let!(:translation_key) { create :translation_key, handler: handler }
  let!(:translation_value) { create :translation_value, translation_key: translation_key }
  let!(:handler_translation) { create :handler_translation, translation_key: translation_key, handler: handler }
  let(:content) do
    {
      "en" => {
        "some" => {
          "key" => "something"
        }
      }
    }
  end

  before do
    File.unlink(translation_value.file_path) if File.exists?(translation_value.file_path)
    File.open(translation_value.file_path, "w") { |fp| fp.write(YAML.dump(content)) }
  end

  after do
    File.unlink(translation_value.file_path) if File.exists?(translation_value.file_path)
  end

  it "works" do
    expect(translation_value.file_path).to_not eq handler_translation.file_path
    expect(translation_value.key).to eq handler_translation.key

    migrator = AwesomeTranslations::TranslationMigrator.new(
      translation_value: translation_value,
      handler_translation: handler_translation
    )
    migrator.execute

    expected_path = "#{handler_translation.dir}/en.yml"

    expect(translation_value.file_path).to eq expected_path

    expect(YAML.load_file(expected_path)).to eq content
  end
end
