class AwesomeTranslations::CacheDatabaseGenerator
  autoload :CachedTranslation, "#{File.dirname(__FILE__)}/cache_database_generator/cached_translation"

  attr_reader :db

  def initialize(args = {})
    require "baza"

    @args = args
    @debug = @args[:debug] || false
    @args[:path] = Tempfile.new("awesome_translations_cache_database_generator").path
  end

  def init_database
    @db = Baza::Db.new(type: :sqlite3, path: @args[:path], debug: @debug)
    CachedTranslation.db = @db
    CachedTranslation.table_name = "cached_translations"

    @cached_translations_table = @db.tables.create(:cached_translations,
      columns: [
        {
          name: :id,
          type: :int,
          autoincr: true,
          primarykey: true
        },{
          name: :locale,
          type: :varchar
        },{
          name: :file_path,
          type: :text
        },{
          name: :key,
          type: :varchar
        },{
          name: :value,
          type: :text
        }
      ],
      indexes: [
        :id,
        :file_path,
        :key
      ]
    )

    @initialized = true
  end

  def cache_translations
    init_database unless initialized?
    cache_translations_in_dir(Rails.root.join("config", "locales"))
  end

  def initialized?
    @initialized ||= false
  end

private

  def debug(message)
    print "#{message}\n" if @debug
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
        @db.upsert(:cached_translations, {}, {
          locale: locale,
          file_path: file_path,
          key: current_key.join("."),
          value: value
        })
      end
    end
  end
end
