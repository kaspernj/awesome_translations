class AwesomeTranslations::Translation
  attr_reader :dir, :key

  def initialize(data)
    @data = data
    @dir, @key = data[:dir], data[:key]
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

      translated_value = AwesomeTranslations::TranslatedValue.new(
        file: "#{dir}/#{locale}.yml",
        key: key,
        locale: locale,
        value: value(locale: locale)
      )
    end

    return result
  end

  def translated_value_for_locale(locale)
    AwesomeTranslations::TranslatedValue.new(
      file: "#{dir}/#{locale}.yml",
      key: key,
      locale: locale,
      value: value_for?(locale) ? value(locale: locale) : ""
    )
  end

  def value_for?(locale)
    I18n.exists?(key, locale: locale)
  end

  def value(args = {})
    locale = args[:locale] || I18n.locale || I18n.default_locale

    return nil unless value_for?(locale)
    I18n.t(key, locale: locale)
  end
end
