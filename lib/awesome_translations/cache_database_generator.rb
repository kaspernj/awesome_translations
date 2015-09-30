class AwesomeTranslations::CacheDatabaseGenerator
  autoload :Group, "#{File.dirname(__FILE__)}/cache_database_generator/group"
  autoload :Handler, "#{File.dirname(__FILE__)}/cache_database_generator/handler"
  autoload :HandlerTranslation, "#{File.dirname(__FILE__)}/cache_database_generator/handler_translation"
  autoload :TranslationKey, "#{File.dirname(__FILE__)}/cache_database_generator/translation_key"
  autoload :TranslationValue, "#{File.dirname(__FILE__)}/cache_database_generator/translation_value"

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

    AwesomeTranslations::CacheDatabaseGenerator::Group.db ||= @db
    AwesomeTranslations::CacheDatabaseGenerator::Group.table_name = "groups"

    AwesomeTranslations::CacheDatabaseGenerator::Handler.db ||= @db
    AwesomeTranslations::CacheDatabaseGenerator::Handler.table_name = "handlers"

    AwesomeTranslations::CacheDatabaseGenerator::TranslationKey.db ||= @db
    AwesomeTranslations::CacheDatabaseGenerator::TranslationKey.table_name = "translation_keys"

    AwesomeTranslations::CacheDatabaseGenerator::HandlerTranslation.db ||= @db
    AwesomeTranslations::CacheDatabaseGenerator::HandlerTranslation.table_name = "handler_translations"

    AwesomeTranslations::CacheDatabaseGenerator::TranslationValue.db ||= @db
    AwesomeTranslations::CacheDatabaseGenerator::TranslationValue.table_name = "translation_values"
  end

  def cache_translations
    @handlers_found = {}
    @groups_found = {}
    @translation_keys_found = {}
    @handler_translations_found = {}
    @translation_values_found = {}

    cache_yml_translations
    cache_handler_translations

    clean_up_not_found
  end

  def cache_yml_translations
    cache_translations_in_dir(Rails.root.join("config", "locales"))
  end

  def cache_handler_translations
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
      handler_model = AwesomeTranslations::CacheDatabaseGenerator::Handler.find_or_initialize_by(
        identifier: handler.id
      )
      handler_model.assign_attributes(
        name: handler.name
      )
      handler_model.save!

      @handlers_found[handler_model.id] = true

      handler.groups.each do |group|
        group_model = AwesomeTranslations::CacheDatabaseGenerator::Group.find_or_initialize_by(
          handler_id: handler_model.id,
          identifier: group.id
        )
        group_model.assign_attributes(
          name: group.name
        )
        group_model.save!

        @groups_found[group_model.id] = true

        group.translations.each do |translation|
          translation_key = AwesomeTranslations::CacheDatabaseGenerator::TranslationKey.find_or_initialize_by(
            key: translation.key
          )
          translation_key.assign_attributes(
            group_id: group_model.id,
            handler_id: handler_model.id
          )
          translation_key.save!

          @translation_keys_found[translation_key.id] = true

          handler_translation = AwesomeTranslations::CacheDatabaseGenerator::HandlerTranslation.find_or_initialize_by(
            translation_key_id: translation_key.id,
            handler_id: handler_model.id,
            group_id: group_model.id
          )
          handler_translation.assign_attributes(
            default: translation.default,
            file_path: translation.file_path,
            line_no: translation.line_no,
            key_show: translation.key_show,
            full_path: translation.full_path,
            dir: translation.dir
          )
          handler_translation.save!

          @handler_translations_found[handler_translation.id] = true
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

        translation_key = AwesomeTranslations::CacheDatabaseGenerator::TranslationKey.find_or_create_by!(key: key)

        translation_value = AwesomeTranslations::CacheDatabaseGenerator::TranslationValue.find_or_initialize_by(
          translation_key_id: translation_key.id,
          locale: locale
        )
        translation_value.assign_attributes(
          file_path: file_path,
          value: value
        )
        translation_value.save!

        @translation_values_found[translation_value.id] = true
      end
    end
  end

  def clean_up_not_found
    AwesomeTranslations::CacheDatabaseGenerator::Handler
      .where.not(id: @handlers_found.keys)
      .destroy_all

    AwesomeTranslations::CacheDatabaseGenerator::HandlerTranslation
      .where.not(id: @handler_translations_found.keys)
      .destroy_all

    AwesomeTranslations::CacheDatabaseGenerator::Group
      .where.not(id: @groups_found.keys)
      .destroy_all

    AwesomeTranslations::CacheDatabaseGenerator::TranslationKey
      .where.not(id: @translation_keys_found.keys)
      .destroy_all

    AwesomeTranslations::CacheDatabaseGenerator::TranslationValue
      .where.not(id: @translation_values_found.keys)
      .destroy_all
  end
end
