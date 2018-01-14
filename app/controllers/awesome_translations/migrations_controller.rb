class AwesomeTranslations::MigrationsController < AwesomeTranslations::ApplicationController
  def new; end

  def create
    params[:m].each do |translation_value_id, check_value|
      next unless check_value == "1"

      translation_value = AwesomeTranslations::CacheDatabaseGenerator::TranslationValue.find(translation_value_id)
      translation_value.migrate_to_awesome_translations_namespace!
    end

    redirect_to new_migration_path
  end

private

  helper_method :translations_to_migrate
  def translations_to_migrate
    @translations_to_migrate ||= AwesomeTranslations::CacheDatabaseGenerator::TranslationValue
      .joins(:translation_key)
      .includes(:translation_key)
      .joins("INNER JOIN handler_translations ON handler_translations.translation_key_id = translation_keys.id")
      .where("translation_values.file_path NOT LIKE '%/config/locales/awesome_translations/%'")
  end
end
