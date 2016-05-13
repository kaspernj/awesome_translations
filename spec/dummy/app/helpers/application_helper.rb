module ApplicationHelper
  include AwesomeTranslations::ViewsHelper

  def hello_world
    helper_t(".hello_world")
  end
end
