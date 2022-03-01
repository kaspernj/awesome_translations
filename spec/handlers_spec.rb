require "spec_helper"

describe AwesomeTranslations::Handlers do
  it "does not include base in list" do
    AwesomeTranslations::Handlers.list.each do |handler|
      expect(handler.id.to_s.downcase.include?("base")).to be false
    end
  end
end
