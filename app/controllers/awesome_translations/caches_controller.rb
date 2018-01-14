class AwesomeTranslations::CachesController < AwesomeTranslations::ApplicationController
  def index; end

  def create
    cache_db_generator = AwesomeTranslations::CacheDatabaseGenerator.new(debug: true)

    if params[:cache] && params[:cache][:type] == "yml"
      cache_db_generator.cache_yml_translations
    else
      cache_db_generator.cache_translations
    end

    flash[:notice] = "The cache was updated"
    redirect_to caches_path
  end
end
