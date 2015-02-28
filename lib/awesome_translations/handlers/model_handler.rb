class AwesomeTranslations::Handlers::ModelHandler < AwesomeTranslations::Handlers::BaseHandler
  def translations
    result = []

    AwesomeTranslations::ModelInspector.model_classes.each do |model_inspector|
      result += model_names(model_inspector)
      result += active_record_attributes(model_inspector)
      result += paperclip_attachments(model_inspector)
      result += relationships(model_inspector)
    end

    return result
  end

  def groups
    ArrayEnumerator.new do |yielder|
      classes_found = {}

      AwesomeTranslations::ModelInspector.model_classes.each do |model_inspector|
        next if classes_found.key?(model_inspector.clazz)

        classes_found[model_inspector.clazz] = true

        yielder << AwesomeTranslations::Group.new(
          id: model_inspector.clazz.name,
          handler: self
        )
      end
    end
  end

  def translations_for_group(group)
    ArrayEnumerator.new do |yielder|
      model_inspector = AwesomeTranslations::ModelInspector.model_classes.select { |model_inspector| model_inspector.clazz.name == group.name }.first
      raise "No group by that name: #{group.name}" unless group

      model_names(model_inspector).each { |translation| yielder << translation }
      active_record_attributes(model_inspector).each { |translation| yielder << translation }
      paperclip_attachments(model_inspector).each { |translation| yielder << translation }
      relationships(model_inspector).each { |translation| yielder << translation }
    end
  end

private

  def dir_path(model_inspector)
    class_name = model_inspector.clazz.name
    class_name = class_name.gsub("::", "_")
    class_name = StringCases.camel_to_snake(class_name)

    dir_path = "#{Rails.root}/config/locales/awesome_translations/models/#{class_name}"

    return dir_path
  end

  def active_record_attributes(model_inspector)
    result = []

    model_inspector.attributes do |attribute|
      translations = {}

      I18n.available_locales.each do |locale|
        translations[locale] = I18n.t(attribute.i18n_key, locale: locale)
      end

      result << AwesomeTranslations::Translation.new(
        key: attribute.i18n_key,
        dir: dir_path(model_inspector)
      )
    end

    return result
  end

  def paperclip_attachments(model_inspector)
    result = []

    model_inspector.paperclip_attachments do |name|
      result << AwesomeTranslations::Translation.new(
        key: model_inspector.i18n_key(name),
        dir: dir_path(model_inspector)
      )
    end

    return result
  end

  def model_names(model_inspector)
    result = []
    result << AwesomeTranslations::Translation.new(
      key: model_inspector.gettext_key_one,
      dir: dir_path(model_inspector)
    )
    result << AwesomeTranslations::Translation.new(
      key: model_inspector.gettext_key_other,
      dir: dir_path(model_inspector)
    )

    return result
  end

  def relationships(model_inspector)
    result = []

    model_inspector.relationships do |key, reflection|
      result << AwesomeTranslations::Translation.new(
        key: model_inspector.i18n_key(reflection.name),
        dir: dir_path(model_inspector)
      )
    end

    return result
  end
end
