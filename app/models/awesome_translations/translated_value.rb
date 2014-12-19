require "fileutils"

class AwesomeTranslations::TranslatedValue
  attr_accessor :file, :locale, :key, :value

  def initialize data
    @data = data
    @file, @locale, @key, @value = @data[:file], @data[:locale], @data[:key], @data[:value]
  end

  def save!
    dir = File.dirname(@file)
    unless File.exists?(dir)
      FileUtils.mkdir_p(dir)
    end

    unless File.exists?(@file)
      File.open(@data[:file], "w") do |fp|
        fp.write("#{@locale}:\n")
      end
    end

    translations = YAML.load(File.read(@file))
    translations ||= {}

    translations[@locale.to_s] ||= {}
    current = translations[@locale.to_s]

    key_parts = key.split(".")
    last_index = key_parts.length - 1
    key_parts.each_with_index do |key_part, index|
      key_part = key_part.to_s

      if index == last_index
        current[key_part] = value
      else
        current[key_part] ||= {}
        current = current[key_part]
      end
    end

    File.open(file, "w") do |fp|
      fp.write(YAML.dump(translations))
    end
  end
end
