require "spec_helper"

describe AwesomeTranslations::ErbInspector do
  let(:erb_inspector) do
    AwesomeTranslations::ErbInspector.new(
      dirs: [Rails.root.to_s]
    )
  end

  let(:files) { erb_inspector.files.to_a }
  let(:file_paths) { files.map(&:file_path) }

  describe "#files" do
    it "should find haml-files" do
      expect(files.length).to eq 30
    end

    it "should find haml-files" do
      expect(file_paths).to include "app/views/users/index.html.haml"
    end

    it "should find erb-files" do
      expect(file_paths).to include "app/views/users/show.html.erb"
    end
  end
end
