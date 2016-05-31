class AwesomeTranslations::Translation
  attr_reader :default, :dir, :key, :key_show, :file_path, :line_no, :full_path

  def initialize(data)
    @data = data
    @dir = data[:dir]
    @file_path = data[:file_path]
    @full_path = data[:full_path]
    @line_no = data[:line_no]
    @key = data[:key]
    @key_show = data[:key_show]
    @default = data[:default]

    raise "Dir wasn't valid: '#{@dir}'." unless @dir.present?
  end

  def last_key
    key.to_s.split(".").last
  end

  def key_show_with_fallback
    @key_show.presence || last_key
  end

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

    result
  end

  def finished?
    I18n.available_locales.each do |locale|
      next if value_for?(locale)
      return false
    end

    true
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
    if array_translation?
      I18n.with_locale(locale) { I18n.exists?(array_key) && I18n.t(array_key)[array_no].present? }
    else
      I18n.with_locale(locale) { I18n.exists?(@key) }
    end
  end

  def value(args = {})
    locale = (args[:locale] || I18n.locale || I18n.default_locale).to_sym

    return nil unless value_for?(locale)

    if array_translation?
      I18n.with_locale(locale) { I18n.t(array_key)[array_no] }
    else
      I18n.with_locale(locale) { I18n.t(@key) }
    end
  end

  def file_line_content?
    return true if @full_path && @line_no && File.exist?(@full_path)
    false
  end

  def file_line_content
    count = 0

    File.open(@full_path, "r") do |fp|
      fp.each_line do |line|
        count += 1
        return line if count == @line_no
      end
    end

    nil
  end

  def to_s
    "<AwesomeTranslations::Translation key=\"#{@key}\" dir=\"#{@dir}\" array_translation?=\"#{array_translation?}\" array_key=\"#{array_key}\" array_no=\"#{array_no}\">"
  end

  def inspect
    to_s
  end
end
