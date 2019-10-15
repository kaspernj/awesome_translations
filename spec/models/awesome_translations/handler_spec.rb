require "spec_helper"

describe AwesomeTranslations::Handler do
  it "lists available handlers" do
    handlers = AwesomeTranslations::Handler.all
    expect(handlers.length).to be > 0
  end
end
