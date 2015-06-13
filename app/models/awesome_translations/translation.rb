class AwesomeTranslations::Translation
  attr_reader :default, :dir, :key, :file_path, :line_no

  def initialize(data)
    @data = data
    @dir, @file_path, @full_path, @line_no = data[:dir], data[:file_path], data[:full_path], data[:line_no]
    @key, @key_show = data[:key], data[:key_show]
    @default = data[:default]

    raise "Dir wasn't valid: '#{@dir}'." unless @dir.present?
  end

  def last_key
    key.to_s.split('.').last
  end

  def key_show_with_fallback
    @key_show.presence || last_key
  end

  def array_translation?
    if @key.match(/\[(\d+)\]\Z/)
      return true
    else
      return false
    end
  end

  def array_key
    if match = @key.match(/\A(.+)\[(\d+)\]\Z/)
      return match[1]
    end

    return nil
  end

  def array_no
    if match = @key.match(/\A(.+)\[(\d+)\]\Z/)
      return match[2].to_i
    end

    return nil
  end

  def id
    raise "stub!"
  end

  def to_param
    id
  end

  def name
    key
  end

  def translated_values
    result = []

    I18n.available_locales.each do |locale|
      next unless value_for?(locale)

      result << AwesomeTranslations::TranslatedValue.new(
        file: "#{dir}/#{locale}.yml",
        key: @key,
        locale: locale,
        value: value(locale: locale)
      )
    end

    return result
  end

  def finished?
    I18n.available_locales.each do |locale|
      next if value_for?(locale)
      return false
    end

    return true
  end

  def unfinished?
    !finished?
  end

  def translated_value_for_locale(locale)
    AwesomeTranslations::TranslatedValue.new(
      file: "#{dir}/#{locale}.yml",
      key: @key,
      locale: locale,
      value: value_for?(locale) ? value(locale: locale) : ""
    )
  end

  def value_for?(locale)
    I18n.with_locale(locale) { return I18n.exists?(@key) }
  end

  def value(args = {})
    locale = (args[:locale] || I18n.locale || I18n.default_locale).to_sym

    return nil unless value_for?(locale)
    I18n.with_locale(locale) { return I18n.t(@key) }
  end

  def file_line_content?
    if @full_path && @line_no && File.exists?(@full_path)
      return true
    else
      return false
    end
  end

  def file_line_content
    count = 0

    File.open(@full_path, "r") do |fp|
      fp.each_line do |line|
        count += 1
        return line if count == @line_no
      end
    end

    raise "Could not find line #{@line_no}. Read #{count}"
  end

  def to_s
    "<AwesomeTranslations::Translation key=\"#{@key}\" dir=\"#{@dir}\" array_translation?=\"#{array_translation?}\" array_key=\"#{array_key}\" array_no=\"#{array_no}\">"
  end

  def inspect
    to_s
  end
end
