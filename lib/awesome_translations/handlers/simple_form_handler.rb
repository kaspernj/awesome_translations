class AwesomeTranslations::Handlers::SimpleFormHandler < AwesomeTranslations::Handlers::BaseHandler
  def enabled?
    true
  end

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

      simple_form_translations(model_inspector).each { |translation| yielder << translation }
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

  def simple_form_translations(model_inspector)
    result = []

    model_inspector.attributes.each do |attribute|
      translations = {}

      I18n.available_locales.each do |locale|
        translations[locale] = I18n.t(attribute.i18n_key, locale: locale)
      end

      result << AwesomeTranslations::Translation.new(
        key: attribute.simple_form_label_key,
        key_show: "#{attribute.name}.label",
        dir: dir_path(model_inspector)
      )
      result << AwesomeTranslations::Translation.new(
        key: attribute.simple_form_hint_key,
        key_show: "#{attribute.name}.hint",
        dir: dir_path(model_inspector)
      )
      result << AwesomeTranslations::Translation.new(
        key: attribute.simple_form_placeholder_key,
        key_show: "#{attribute.name}.placeholder",
        dir: dir_path(model_inspector)
      )
      result << AwesomeTranslations::Translation.new(
        key: attribute.simple_form_include_blank_key,
        key_show: "#{attribute.name}.include_blank",
        dir: dir_path(model_inspector)
      )
      result << AwesomeTranslations::Translation.new(
        key: attribute.simple_form_prompt_key,
        key_show: "#{attribute.name}.prompt",
        dir: dir_path(model_inspector)
      )
    end

    result
  end
end
