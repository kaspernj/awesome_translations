require "spec_helper"

describe AwesomeTranslations::Handler do
  it "should list available handlers" do
    handlers = AwesomeTranslations::Handler.all
    expect(handlers.length).to be > 0
  end
end
