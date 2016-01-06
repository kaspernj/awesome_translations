class AwesomeTranslations::GroupsController < AwesomeTranslations::ApplicationController
  before_filter :set_handler
  before_filter :set_group

  def index
  end

  def show
    @translations = @group.handler_translations
  end

  def update
    @group.handler_translations.each do |translation|
      if translation.array_translation?
        next unless params[:t].key?(translation.array_key)
        values = params[:t][translation.array_key][translation.array_no.to_s]
        next unless values
      else
        next unless params[:t].key?(translation.key)
        values = params[:t][translation.key]
      end

      values.each do |locale, value|
        translated_value = translation.translated_value_for_locale(locale)
        translated_value.value = value
        translated_value.save!
      end
    end

    I18n.backend.reload!
    redirect_to handler_group_path(@handler, @group)
  end

  def update_translations_cache
    handler = AwesomeTranslations::Handler.find(@handler.identifier)
    group = AwesomeTranslations::Group.find_by_handler_and_id(handler, @group.identifier)

    generator = AwesomeTranslations::CacheDatabaseGenerator.current
    generator.update_translations_for_group(@handler, group, @group)

    redirect_to handler_group_path(@handler.identifier, @group.identifier)
  end

private

  def set_handler
    @handler = AwesomeTranslations::CacheDatabaseGenerator::Handler.find_by(identifier: params[:handler_id])
  end

  def set_group
    @group = @handler.groups.find_by(identifier: params[:id])
  end
end
