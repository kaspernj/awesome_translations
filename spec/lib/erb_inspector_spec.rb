require "spec_helper"

describe AwesomeTranslations::ErbInspector do
  let(:erb_inspector) do
    AwesomeTranslations::ErbInspector.new(
      dirs: [Rails.root.to_s]
    )
  end

  let(:files) { erb_inspector.files.to_a }
  let(:file_paths) { files.map { |file| file.file_path } }

  describe "#files" do
    it "should find haml-files" do
      files.length.should eq 27
    end

    it "should find haml-files" do
      file_paths.should include "app/views/users/index.html.haml"
    end

    it "should find erb-files" do
      file_paths.should include "app/views/users/show.html.erb"
    end
  end
end
