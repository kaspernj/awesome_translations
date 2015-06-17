module ApplicationHelper
  include AwesomeTranslations::ApplicationHelper

  def hello_world
    helper_t('.hello_world')
  end
end
