class TestTranslateService < ApplicationService
  def self.static_method
    t(".hello_static_method")
  end

  def perform
    t(".hello_world")
  end
end
