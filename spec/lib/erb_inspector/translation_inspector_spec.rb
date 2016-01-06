require "spec_helper"

describe AwesomeTranslations::ErbInspector::TranslationInspector do
  let(:erb_inspector) do
    AwesomeTranslations::ErbInspector.new(
      dirs: [Rails.root.to_s]
    )
  end

  let(:files) { erb_inspector.files.to_a }
  let(:file_paths) { files.map { |file| file.file_path } }
  let(:user_index_inspector) { files.select { |file_inspector| file_inspector.file_path == "app/views/users/index.html.haml" }.first }
  let(:user_index_translations) { user_index_inspector.translations.to_a }
  let(:hello_world_translation) { user_index_translations.select { |translation| translation.key == ".hello_world" }.first }
  let(:user_was_created_translation) do
    files
      .select { |file_inspector| file_inspector.file_path == "app/controllers/users_controller.rb" }
      .first
      .translations
      .select { |translation| translation.key == ".user_was_created" }
      .first
  end

  it "#full_key" do
    expect(hello_world_translation.full_key).to eq "users.index.hello_world"
  end

  it "#full_path" do
    expect(hello_world_translation.full_path).to eq Rails.root.join('app', 'views', 'users', 'index.html.haml').to_s
  end

  it '#dir' do
    expect(user_was_created_translation.dir).to end_with 'spec/dummy/config/locales/awesome_translations/app/controllers/users_controller'
  end
end
