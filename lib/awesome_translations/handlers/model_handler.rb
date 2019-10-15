class AwesomeTranslations::Handlers::ModelHandler < AwesomeTranslations::Handlers::BaseHandler
  def groups
    ArrayEnumerator.new do |yielder|
      AwesomeTranslations::ModelInspector.model_classes.each do |model_inspector|
        yielder << AwesomeTranslations::Group.new(
          id: model_inspector.clazz.name,
          handler: self
        )
      end
    end
  end

  def translations_for_group(group)
    ArrayEnumerator.new do |yielder|
      model_inspector = AwesomeTranslations::ModelInspector.model_classes.find { |model_inspector_i| model_inspector_i.clazz.name == group.name }
      raise "No inspector by that name: #{group.name}" unless model_inspector

      model_names(model_inspector).each { |translation| yielder << translation }
      active_record_attributes(model_inspector).each { |translation| yielder << translation }
      paperclip_attachments(model_inspector).each { |translation| yielder << translation }
      relationships(model_inspector).each { |translation| yielder << translation }
      monetized_attributes(model_inspector).each { |translation| yielder << translation }
      globalize_attributes(model_inspector).each { |translation| yielder << translation }
    end
  end

private

  def dir_path(model_inspector)
    class_name = model_inspector.clazz.name
    class_name = class_name.gsub("::", "_")
    class_name = StringCases.camel_to_snake(class_name)

    dir_path = Rails.root.join("config", "locales", "awesome_translations", "models", class_name)

    dir_path.to_s
  end

  def active_record_attributes(model_inspector)
    result = []

    model_inspector.attributes.each do |attribute|
      translations = {}

      I18n.available_locales.each do |locale|
        translations[locale] = I18n.t(attribute.i18n_key, locale: locale)
      end

      result << AwesomeTranslations::Translation.new(
        key: attribute.i18n_key,
        dir: dir_path(model_inspector)
      )
    end

    result
  end

  def paperclip_attachments(model_inspector)
    result = []

    model_inspector.paperclip_attachments do |name|
      result << AwesomeTranslations::Translation.new(
        key: model_inspector.attribute_key(name),
        dir: dir_path(model_inspector)
      )
    end

    result
  end

  def model_names(model_inspector)
    result = []
    result << AwesomeTranslations::Translation.new(
      key: model_inspector.class_key_one,
      dir: dir_path(model_inspector)
    )
    result << AwesomeTranslations::Translation.new(
      key: model_inspector.class_key_other,
      dir: dir_path(model_inspector)
    )

    result
  end

  def relationships(model_inspector)
    result = []

    model_inspector.relationships do |_key, reflection|
      result << AwesomeTranslations::Translation.new(
        key: model_inspector.attribute_key(reflection.name),
        dir: dir_path(model_inspector)
      )
    end

    result
  end

  def monetized_attributes(model_inspector)
    result = []

    model_inspector.money_attributes do |name|
      result << AwesomeTranslations::Translation.new(
        key: model_inspector.attribute_key(name),
        dir: dir_path(model_inspector)
      )
    end

    result
  end

  def globalize_attributes(model_inspector)
    result = []

    model_inspector.globalize_attributes do |name|
      result << AwesomeTranslations::Translation.new(
        key: model_inspector.attribute_key(name),
        dir: dir_path(model_inspector)
      )
    end

    result
  end
end
