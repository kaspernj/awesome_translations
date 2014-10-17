require "spec_helper"

describe AwesomeTranslations::Handler do
  it "should list available handlers" do
    handlers = AwesomeTranslations::Handler.all
    handlers.length.should > 0
  end
end
