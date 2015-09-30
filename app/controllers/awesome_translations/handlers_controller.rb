class AwesomeTranslations::HandlersController < AwesomeTranslations::ApplicationController
  before_filter :set_handler, only: :show

  def index
    @handlers = AwesomeTranslations::CacheDatabaseGenerator::Handler.order(:name)
  end

  def show
    @groups = @handler.groups.order(:name)
  end

private

  def set_handler
    @handler = AwesomeTranslations::CacheDatabaseGenerator::Handler.find(params[:id])
  end
end
