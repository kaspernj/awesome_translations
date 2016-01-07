class AwesomeTranslations::GroupsController < AwesomeTranslations::ApplicationController
  before_action :set_handler
  before_action :set_group

  def index
  end

  def show
    @translations = @group.handler_translations
  end

  def update
    @group.handler_translations.each do |translation|
      values = values_from_translation(translation)
      next unless values
      save_values(translation, values)
    end

    I18n.backend.reload!
    redirect_to handler_group_path(@handler, @group)
  end

  def update_translations_cache
    handler = AwesomeTranslations::Handler.find(@handler)
    group = AwesomeTranslations::Group.find_by_handler_and_id(handler, @group)

    generator = AwesomeTranslations::CacheDatabaseGenerator.current
    generator.update_translations_for_group(@handler, group, @group)

    redirect_to handler_group_path(@handler, @group)
  end

private

  def set_handler
    @handler = AwesomeTranslations::CacheDatabaseGenerator::Handler.find_by(identifier: params[:handler_id])
  end

  def set_group
    @group = @handler.groups.find_by(identifier: params[:id])
  end

  def values_from_translation(translation)
    if translation.array_translation?
      params[:t][translation.array_key][translation.array_no.to_s] if params[:t].key?(translation.array_key)
    else
      params[:t][translation.key] if params[:t].key?(translation.key)
    end
  end

  def save_values(translation, values)
    values.each do |locale, value|
      translated_value = translation.translated_value_for_locale(locale)
      translated_value.value = value
      translated_value.save!
    end
  end
end
