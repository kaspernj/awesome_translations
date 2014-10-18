class AwesomeTranslations::HandlersController < AwesomeTranslations::ApplicationController
  def index
    @handlers = AwesomeTranslations::Handler.all
  end

  def show
    @handler = AwesomeTranslations::Handler.find(params[:id])
    @translations = @handler.translations
  end
end
