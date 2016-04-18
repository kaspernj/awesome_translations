class AwesomeTranslations::CachesController < AwesomeTranslations::ApplicationController
  def index
  end

  def create
    cache_db_generator = AwesomeTranslations::CacheDatabaseGenerator.new(debug: true)
    cache_db_generator.cache_translations

    flash[:notice] = "The cache was updated"
    redirect_to caches_path
  end
end
