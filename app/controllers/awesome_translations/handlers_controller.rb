class AwesomeTranslations::HandlersController < AwesomeTranslations::ApplicationController
  before_action :set_handler, only: [:show, :update_groups_cache]

  def index
    @handlers = AwesomeTranslations::CacheDatabaseGenerator::Handler.order(:name)
  end

  def update_cache
    generator = AwesomeTranslations::CacheDatabaseGenerator.current
    generator.update_handlers

    redirect_back(fallback_location: :root)
  end

  def update_groups_cache
    generator = AwesomeTranslations::CacheDatabaseGenerator.current
    generator.update_handlers do |handler_model|
      next unless handler_model.identifier == @handler.identifier

      generator.update_groups_for_handler(handler_model)
    end

    redirect_back(fallback_location: :root)
  end

  def show
    @ransack_values = params[:q] || {
      with_translations: "only_with"
    }

    @ransack = @handler
      .groups
      .ransack(@ransack_values)

    @groups = @ransack
      .result
      .includes(handler_translations: :translation_key)
      .order(:name)

    filter_with_translations
    filter_with_missing_translations
  end

private

  def set_handler
    @handler = AwesomeTranslations::CacheDatabaseGenerator::Handler.find_by(identifier: params[:id])
    raise "No such handler: #{params[:id]}" unless @handler
  end

  helper_method :with_translations_collection
  def with_translations_collection
    {"Only with translations" => "only_with", "Only without translations" => "only_without"}
  end

  def filter_with_translations
    case @ransack_values[:with_translations]
    when "only_with"
      @groups = @groups.select { |group| group.handler_translations.any? }
    when "only_without"
      @groups = @groups.select { |group| group.handler_translations.empty? }
    end
  end

  def filter_with_missing_translations
    case @ransack_values[:with_missing_translations]
    when "only_with"
      @groups = @groups.select { |group| group.handler_translations.to_a.any?(&:unfinished?) }
    when "only_without"
      @groups = @groups.select { |group| group.handler_translations.to_a.all?(&:finished?) }
    end
  end

  helper_method :with_missing_translations_collection
  def with_missing_translations_collection
    {
      "Only with missing translations" => "only_with",
      "Only where everything is translated" => "only_without"
    }
  end
end
