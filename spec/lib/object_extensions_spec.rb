require "spec_helper"

describe AwesomeTranslations::ObjectExtensions do
  it "detects the correct key" do
    expect(t(".test")).to eq "translation missing: en.spec.lib.object_extensions_spec.test"
  end
end
