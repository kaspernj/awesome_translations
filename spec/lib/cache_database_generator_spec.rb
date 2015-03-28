require "spec_helper"

describe AwesomeTranslations::CacheDatabaseGenerator do
  let(:cache_database_generator) { AwesomeTranslations::CacheDatabaseGenerator.new(debug: false) }
  let(:table) { db.tables["cached_translations"] }
  let(:db) { cache_database_generator.db }

  before do
    require "fileutils"

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
    table.name.should eq :cached_translations
  end

  describe "#cache_translations" do
    it "can cache translations" do
      cache_database_generator.cache_translations
      row = db.select(:cached_translations, key: "activerecord.attributes.user.id").fetch
      row.should_not eq false

      cached_translation = AwesomeTranslations::CacheDatabaseGenerator::CachedTranslation.find(row[:id])
    end
  end
end
