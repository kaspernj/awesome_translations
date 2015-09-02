class AwesomeTranslations::CacheDatabaseGenerator
  autoload :Translation, "#{File.dirname(__FILE__)}/cache_database_generator/translation"

  attr_reader :db

  def initialize(args = {})
    require "baza"

    @args = args
    @debug = @args[:debug] || false

    init_database
    execute_migrations
  end

  def init_database
    @initialized = true
    @@db ||= Baza::Db.new(type: :sqlite3, path: database_path, debug: @debug)
    @db = @@db

    AwesomeTranslations::CacheDatabaseGenerator::Translation.db ||= @db
    AwesomeTranslations::CacheDatabaseGenerator::Translation.table_name = "translations"
  end

  def cache_translations
    cache_yml_translations
    cache_handler_translations
  end

  def cache_yml_translations
    init_database unless initialized?
    cache_translations_in_dir(Rails.root.join("config", "locales"))
  end

  def cache_handler_translations
    init_database unless initialized?
    cache_translations_in_handlers
  end

  def initialized?
    @initialized ||= false
  end

  def self.database_path
    @database_path ||= Rails.root.join("db", "awesome_translations.sqlite3").to_s
  end

  def database_path
    @database_path ||= self.class.database_path
  end

private

  def debug(message)
    print "#{message}\n" if @debug
  end

  def execute_migrations
    executor = BazaMigrations::MigrationsExecutor.new(db: @db)
    executor.add_dir "#{File.dirname(__FILE__)}/../../db/baza_translations_migrations"
    executor.execute_migrations
  end

  def cache_translations_in_handlers
    AwesomeTranslations::Handler.all.each do |handler|
      handler.groups.each do |group|
        group.translations.each do |translation|
          translation = AwesomeTranslations::CacheDatabaseGenerator::Translation.find_or_initialize_by(key: translation.key)
          translation.assign_attributes(
            file_path_translation: @current_file,
            line_no: translation.line_no
          )
          translation.save!
        end
      end
    end
  end

  def cache_translations_in_dir(dir_path)
    debug "Looking for translations in #{dir_path}"

    Dir.foreach(dir_path) do |file|
      next if file == "." || file == ".."

      full_path = "#{dir_path}/#{file}"

      if File.directory?(full_path)
        cache_translations_in_dir(full_path)
      elsif File.extname(full_path) == ".yml"
        cache_translations_in_file(full_path)
      end
    end
  end

  def cache_translations_in_file(file_path)
    debug "Cache translations in #{file_path}"

    i18n_hash = YAML.load_file(file_path)
    debug "Hash: #{i18n_hash}"

    i18n_hash.each do |locale, translations|
      cache_translations_in_hash(file_path, locale, translations)
    end
  end

  def cache_translations_in_hash(file_path, locale, i18n_hash, keys = [])
    i18n_hash.each do |key, value|
      current_key = keys.clone
      current_key << key

      if value.is_a?(Hash)
        debug "Found new hash: #{current_key.join(".")}"
        cache_translations_in_hash(file_path, locale, value, current_key)
      else
        debug "Found new key: #{current_key.join(".")} translated to #{value}"

        key = current_key.join(".")

        translation = AwesomeTranslations::CacheDatabaseGenerator::Translation.find_or_initialize_by(key: key)
        translation.assign_attributes(
          file_path: @current_file,
          locale: locale,
          value: value
        )
        translation.save!
      end
    end
  end
end
