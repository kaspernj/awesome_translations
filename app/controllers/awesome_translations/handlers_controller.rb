class AwesomeTranslations::HandlersController < AwesomeTranslations::ApplicationController
  before_filter :set_handler

  def index
    @handlers = AwesomeTranslations::Handler.all
  end

  def show
    @groups = @handler.groups
  end

private

  def set_handler
    @handler = AwesomeTranslations::Handler.find(params[:id]) if params[:id]
  end
end
