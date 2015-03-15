require "spec_helper"

describe AwesomeTranslations::TranslateMigration do
  before do
    require "fileutils"

    locales_path = Rails.root.join("config/locales")
    FileUtils.rm_rf(locales_path)
    Dir.mkdir(locales_path)

    fake_path = "#{locales_path}/translations.yml"
    translations = {
      da: {
        activerecord: {
          attributes: {
            user: {
              id: "ID",
              email: "Email",
              created_at: "Oprettet d."
            }
          }
        }
      }
    }

    File.open(fake_path, "w") { |fp| fp.write(YAML.dump(translations)) }
  end

  it "#all" do
    AwesomeTranslations::TranslateMigration.all.should eq []
  end
end
