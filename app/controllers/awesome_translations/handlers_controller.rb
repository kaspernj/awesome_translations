class AwesomeTranslations::HandlersController < AwesomeTranslations::ApplicationController
  before_action :set_handler, only: [:show, :update_groups_cache]

  def index
    @handlers = AwesomeTranslations::CacheDatabaseGenerator::Handler.order(:name)
  end

  def update_cache
    generator = AwesomeTranslations::CacheDatabaseGenerator.current
    generator.update_handlers

    redirect_to :handlers
  end

  def update_groups_cache
    generator = AwesomeTranslations::CacheDatabaseGenerator.current
    generator.update_handlers do |handler_model|
      next unless handler_model.identifier == @handler.identifier
      generator.update_groups_for_handler(handler_model)
    end

    redirect_to @handler
  end

  def show
    @groups = @handler.groups.order(:name)
  end

private

  def set_handler
    @handler = AwesomeTranslations::CacheDatabaseGenerator::Handler.find_by(identifier: params[:id])
    raise "No such handler: #{params[:id]}" unless @handler
  end
end
