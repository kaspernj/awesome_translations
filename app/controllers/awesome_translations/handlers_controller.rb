class AwesomeTranslations::HandlersController < AwesomeTranslations::ApplicationController
  def index
    @handlers = Handler.all
  end

  def show
  end
end
