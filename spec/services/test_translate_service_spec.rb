require "spec_helper"

describe TestTranslateService do
  it "uses translations" do
    expect(TestTranslateService.new.perform).to eq "translation missing: en.services.test_translate_service.hello_world"
  end

  it "uses translations in instance methods" do
    expect(TestTranslateService.static_method).to eq "translation missing: en.services.test_translate_service.hello_static_method"
  end
end
