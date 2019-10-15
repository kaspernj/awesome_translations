require "spec_helper"

describe AwesomeTranslations::CacheDatabaseGenerator do
  let(:cache_database_generator) { AwesomeTranslations::CacheDatabaseGenerator.current }
  let(:table) { db.tables["handler_translations"] }
  let(:db) { cache_database_generator.db }

  before do
    locales_path = Rails.root.join("config", "locales")
    FileUtils.rm_rf(locales_path)
    Dir.mkdir(locales_path)

    fake_path = "#{locales_path}/translations.yml"
    translations = {
      "da" => {
        "activerecord" => {
          "attributes" => {
            "user" => {
              "id" => "ID",
              "email" => "Email",
              "created_at" => "Oprettet d."
            }
          }
        }
      }
    }

    File.open(fake_path, "w") { |fp| fp.write(YAML.dump(translations)) }
  end

  it "#init_database" do
    expect(table.name).to eq "handler_translations"
  end

  describe "#cache_translations" do
    it "#cache_yml_translations" do
      cache_database_generator.cache_translations

      translation = AwesomeTranslations::CacheDatabaseGenerator::HandlerTranslation
        .joins(:translation_key)
        .where(translation_keys: {key: "activerecord.attributes.user.id"})
        .first

      expect(translation).not_to eq nil
    end

    it "#cache_handler_translations" do
      # AwesomeTranslations::CacheDatabaseGenerator::ScannedFile.all.destroy_all
      cache_database_generator.cache_handler_translations

      translation = AwesomeTranslations::CacheDatabaseGenerator::HandlerTranslation
        .joins(:translation_key)
        .where(translation_keys: {key: "activerecord.attributes.user.id"})
        .first

      expect(translation).not_to eq nil
    end
  end
end
