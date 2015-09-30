require "spec_helper"

describe AwesomeTranslations::CacheDatabaseGenerator do
  let(:cache_database_generator) { AwesomeTranslations::CacheDatabaseGenerator.new(debug: true) }
  let(:table) { db.tables["translations"] }
  let(:db) { cache_database_generator.db }

  before do
    require "fileutils"

    File.unlink(cache_database_generator.database_path) if File.exist?(cache_database_generator.database_path)

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
    cache_database_generator.init_database
    table.name.should eq :translations
  end

  describe "#cache_translations" do
    it "#cache_yml_translations" do
      cache_database_generator.cache_yml_translations
      row = db.single(:translations, key: "activerecord.attributes.user.id")
      expect(row).to_not eq false

      cached_translation = AwesomeTranslations::CacheDatabaseGenerator::Translation.find(row.fetch(:id))
    end

    it "#cache_handler_translations" do
      cache_database_generator.cache_handler_translations
      row = db.single(:translations, key: "activerecord.attributes.user.id")
      expect(row).to_not eq false

      cached_translation = AwesomeTranslations::CacheDatabaseGenerator::Translation.find(row.fetch(:id))
    end
  end
end
