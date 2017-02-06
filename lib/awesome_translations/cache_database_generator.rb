require "baza_models"

class AwesomeTranslations::CacheDatabaseGenerator
  AutoAutoloader.autoload_sub_classes(self, __FILE__)

  attr_reader :db

  def self.current
    @current ||= AwesomeTranslations::CacheDatabaseGenerator.new
  end

  def initialize(args = {})
    require "baza"

    @args = args
    @debug = @args[:debug] || false

    init_database
    execute_migrations
  end

  def init_database
    @initialized = true
    @db = Baza::Db.new(type: :sqlite3, path: database_path, debug: false, type_translation: true)

    BazaModels.primary_db = @db

    AwesomeTranslations::CacheDatabaseGenerator::Group.db = @db
    AwesomeTranslations::CacheDatabaseGenerator::Group.table_name = "groups"

    AwesomeTranslations::CacheDatabaseGenerator::Handler.db = @db
    AwesomeTranslations::CacheDatabaseGenerator::Handler.table_name = "handlers"

    AwesomeTranslations::CacheDatabaseGenerator::ScannedFile.db = @db
    AwesomeTranslations::CacheDatabaseGenerator::ScannedFile.table_name = "scanned_files"

    AwesomeTranslations::CacheDatabaseGenerator::TranslationKey.db = @db
    AwesomeTranslations::CacheDatabaseGenerator::TranslationKey.table_name = "translation_keys"

    AwesomeTranslations::CacheDatabaseGenerator::HandlerTranslation.db = @db
    AwesomeTranslations::CacheDatabaseGenerator::HandlerTranslation.table_name = "handler_translations"

    AwesomeTranslations::CacheDatabaseGenerator::TranslationValue.db = @db
    AwesomeTranslations::CacheDatabaseGenerator::TranslationValue.table_name = "translation_values"
  end

  def init_key_cache
    require "model_cache"

    @key_cache = ModelCache.new(
      attributes: [:id],
      by_keys: [
        [:key]
      ],
      model: AwesomeTranslations::CacheDatabaseGenerator::TranslationKey
    )
    @key_cache.generate
  end

  def close
    @initialized = false

    @db.close if @db
    @db = nil

    AwesomeTranslations::CacheDatabaseGenerator::Group.db = nil
    AwesomeTranslations::CacheDatabaseGenerator::Handler.db = nil
    AwesomeTranslations::CacheDatabaseGenerator::TranslationKey.db = nil
    AwesomeTranslations::CacheDatabaseGenerator::HandlerTranslation.db = nil
    AwesomeTranslations::CacheDatabaseGenerator::TranslationValue.db = nil
  end

  def cache_translations
    init_key_cache

    cache_yml_translations
    cache_handler_translations

    clean_up_not_found
  end

  def with_transactioner
    require "active-record-transactioner"

    ActiveRecordTransactioner.new do |transactioner|
      @transactioner = transactioner
      yield
    end
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

  def update_handlers
    @handlers_found ||= {}

    AwesomeTranslations::Handler.all.each do |handler|
      debug "Updating handler: #{handler.name}"
      handler_model = AwesomeTranslations::CacheDatabaseGenerator::Handler.find_or_initialize_by(identifier: handler.id)
      handler_model.assign_attributes(name: handler.name)
      handler_model.save!

      @handlers_found[handler_model.id] = true

      yield handler_model if block_given?
    end
  end

  def update_groups_for_handler(handler_model)
    @groups_found ||= {}
    handler = handler_model.at_handler

    handler.groups.each do |group|
      debug "Updating group: #{group.name}" if @debug
      group_model = AwesomeTranslations::CacheDatabaseGenerator::Group.find_or_initialize_by(
        handler_id: handler_model.id,
        identifier: group.id
      )
      group_model.assign_attributes(name: group.name)
      group_model.save!

      @groups_found[group_model.id] = true

      group_model.at_group = group
      yield group_model if block_given?
    end
  end

  def update_translations_for_group(handler_model, group_model)
    group = group_model.at_group
    @translation_keys_found ||= {}
    @handler_translations_found ||= {}

    group.translations.each do |translation|
      debug "Updating translation: #{translation.key}" if @debug

      key_id = key_id_for_key(translation.key)
      @translation_keys_found[key_id] = true

      handler_translation ||= AwesomeTranslations::CacheDatabaseGenerator::HandlerTranslation.find_or_initialize_by(
        translation_key_id: key_id,
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

      if handler_translation.changed?
        if @transactioner && handler_translation.persisted?
          @transactioner.save!(handler_translation)
        else
          handler_translation.save!
        end
      end

      @handler_translations_found[handler_translation.id] = true
    end
  end

private

  def debug(message)
    puts message.to_s if @debug # rubocop:disable Rails/Output
  end

  def execute_migrations
    require "baza_migrations"

    executor = BazaMigrations::MigrationsExecutor.new(db: @db)
    executor.add_dir "#{File.dirname(__FILE__)}/../../db/baza_translations_migrations"
    executor.execute_migrations
  end

  def cache_translations_in_handlers
    with_transactioner do
      update_handlers do |handler_model|
        update_groups_for_handler(handler_model) do |group_model|
          update_translations_for_group(handler_model, group_model)
        end
      end
    end
  end

  def cache_translations_in_dir(dir_path)
    debug "Looking for translations in #{dir_path}"
    @translation_values_found ||= {}

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
    @translation_keys_found ||= {}

    debug "Cache translations in #{file_path}"

    i18n_hash = YAML.load_file(file_path)
    debug "Hash: #{i18n_hash}"

    i18n_hash.each do |locale, translations|
      cache_translations_in_hash(file_path, locale, translations)
    end

    debug "Done caching translations in #{file_path}"
  end

  def cache_translations_in_hash(file_path, locale, i18n_hash, keys = [])
    i18n_hash.each do |key, value|
      current_key = keys.clone
      current_key << key

      if value.is_a?(Hash)
        debug "Found new hash: #{current_key.join(".")}" if @debug
        cache_translations_in_hash(file_path, locale, value, current_key)
      else
        debug "Found new key: #{current_key.join(".")} translated to #{value}" if @debug

        key = current_key.join(".")
        key_id = key_id_for_key(key)

        translation_value = AwesomeTranslations::CacheDatabaseGenerator::TranslationValue.find_or_initialize_by(
          translation_key_id: key_id,
          locale: locale,
          file_path: file_path
        )
        translation_value.assign_attributes(value: value)
        translation_value.save!

        @translation_values_found[translation_value.id] = true
      end
    end
  end

  def clean_up_not_found
    debug "Cleaning up not found"

    @db.transaction do
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

  def key_id_for_key(key)
    if (data = @key_cache.data_by_key([:key], [key]))
      data.fetch(:id)
    else
      translation_key = AwesomeTranslations::CacheDatabaseGenerator::TranslationKey.find_or_create_by!(key: key)
      @key_cache.register(translation_key)
      translation_key.id
    end
  end
end
