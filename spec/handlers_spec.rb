require "spec_helper"

describe AwesomeTranslations::Handlers do
  it "should not include base in list" do
    AwesomeTranslations::Handlers.list.each do |handler|
      expect(handler.id.to_s.downcase.include?("base")).to eq false
    end
  end
end
