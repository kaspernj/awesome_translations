class AwesomeTranslations::GroupsController < AwesomeTranslations::ApplicationController
  before_filter :set_handler
  before_filter :set_group

  def index
  end

  def show
    @translations = @group.translations
  end

  def update
    puts "Params: #{params}"
    puts "Keys: #{params[:t].keys}"

    @group.translations.each do |translation|
      if translation.array_translation?
        unless params[:t].key?(translation.array_key)
          puts "Ignore: #{translation.key}"
          next
        end

        puts "Array: #{params[:t][translation.array_key][translation.array_no.to_s]}"
        puts "Translation: #{translation}"

        values = params[:t][translation.array_key][translation.array_no.to_s]
        next unless values
      else
        unless params[:t].key?(translation.key)
          puts "Ignore: #{translation.key}"
          next
        end

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

private

  def set_handler
    @handler = AwesomeTranslations::Handler.find(params[:handler_id])
  end

  def set_group
    @group = AwesomeTranslations::Group.find_by_handler_and_id(@handler, params[:id])
  end
end
