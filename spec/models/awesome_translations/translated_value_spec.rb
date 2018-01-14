require "spec_helper"

describe AwesomeTranslations::TranslatedValue do
  let(:test_file_path) { "#{Dir.tmpdir}/da.yml" }

  let(:translated_value) do
    described_class.new(
      file: test_file_path,
      key: "activerecord.attributes.test_model.test",
      locale: :da,
      value: "test"
    )
  end

  before do
    test_translations = {
      "da" => {
        "activerecord" => {
          "attributes" => {
            "test_model" => {
              "test" => "test",
              "other_translation" => "En anden"
            }
          }
        }
      }
    }

    File.open(test_file_path, "w") do |fp|
      fp.write(YAML.dump(test_translations))
    end
  end

  it "#save!" do
    translated_value.value = "new test"
    translated_value.save!

    translations = YAML.safe_load(File.read(test_file_path))

    expect(translations["da"]["activerecord"]["attributes"]["test_model"]["test"]).to eq "new test"
    expect(translations["da"]["activerecord"]["attributes"]["test_model"]["other_translation"]).to eq "En anden"
  end
end
