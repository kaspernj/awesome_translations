class AwesomeTranslations::HandlersController < AwesomeTranslations::ApplicationController
  before_filter :set_handler, only: [:show, :update_groups_cache]

  def index
    @handlers = AwesomeTranslations::CacheDatabaseGenerator::Handler.order(:name)
  end

  def update_cache
    generator = AwesomeTranslations::CacheDatabaseGenerator.current
    generator.update_handlers

    redirect_to handlers_path
  end

  def update_groups_cache
    generator = AwesomeTranslations::CacheDatabaseGenerator.current
    generator.update_handlers do |handler, handler_model|
      next unless handler_model.identifier == @handler.identifier
      generator.update_groups_for_handler(handler, handler_model)
    end

    redirect_to handler_path(@handler.identifier)
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
