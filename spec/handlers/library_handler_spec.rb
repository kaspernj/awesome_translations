require "spec_helper"

describe AwesomeTranslations::Handlers::LibraryHandler do
  let(:handler) { AwesomeTranslations::Handlers::LibraryHandler.new }
  let(:group) { handler.groups.select { |group| group.name == "stub!" }.first }

  it "finds translations made with the t method" do
    raise "stub!"
  end
end
