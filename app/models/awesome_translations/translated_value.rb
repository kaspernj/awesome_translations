require "fileutils"

class AwesomeTranslations::TranslatedValue
  attr_accessor :file, :locale, :key, :value

  def initialize(data)
    @file = data.fetch(:file)
    @locale = data.fetch(:locale)
    @key = data.fetch(:key)
    @value = data.fetch(:value)
  end

  def to_s
    "<AwesomeTranslations::TranslatedValue file=\"#{@file}\" locale=\"#{@locale}\" key=\"#{@key}\" value=\"#{@value}\">"
  end

  alias inspect to_s

  def array_translation?
    return true if @key =~ /\[(\d+)\]\Z/
    false
  end

  def array_key
    return unless (match = @key.match(/\A(.+)\[(\d+)\]\Z/))
    match[1]
  end

  def array_no
    return unless (match = @key.match(/\A(.+)\[(\d+)\]\Z/))
    match[2].to_i
  end

  def save!
    dir = File.dirname(@file)
    FileUtils.mkdir_p(dir) unless File.exist?(dir)
    File.open(@file, "w") { |fp| fp.write("#{@locale}:\n") } unless File.exist?(@file)

    translations = YAML.load(File.read(@file))
    translations ||= {}
    translations[@locale.to_s] ||= {}

    insert_translation_into_hash(translations)

    update_models

    I18n.load_path << file unless I18n.load_path.include?(file)
    File.open(file, "w") { |fp| fp.write(YAML.dump(translations)) }
  end

private

  def insert_translation_into_hash(translations)
    current = translations[@locale.to_s]

    key_parts = key.split(".")
    last_index = key_parts.length - 1
    key_parts.each_with_index do |key_part, index|
      key_part = key_part.to_s

      if index == last_index
        if @value.empty?
          current.delete(key_part)
        elsif array_translation?
          match = key_part.match(/\A(.+)\[(\d+)\]\Z/)
          current_array = current[match[1]] || []
          current_array[array_no] = value
          current[match[1]] = current_array
        else
          current[key_part] = value
        end
      else
        current[key_part] ||= {}
        current = current[key_part]
      end
    end
  end

  def update_models
    translation_key = AwesomeTranslations::CacheDatabaseGenerator::TranslationKey
      .find_or_create_by!(key: key)

    translation_value = AwesomeTranslations::CacheDatabaseGenerator::TranslationValue
      .find_or_initialize_by(locale: locale, translation_key: translation_key)

    translation_value.value = value
    translation_value.save!
  end
end
