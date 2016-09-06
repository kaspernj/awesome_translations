class AwesomeTranslations::ModelInspector::Attribute
  attr_reader :name, :model_inspector

  def initialize(model_inspector, name)
    @model_inspector = model_inspector
    @name = name
  end

  def i18n_key
    "activerecord.attributes.#{@model_inspector.snake_name}.#{@name}"
  end

  def simple_form_include_blank_key
    "simple_form.include_blanks.#{@model_inspector.snake_name}.#{@name}"
  end

  def simple_form_label_key
    "simple_form.labels.#{@model_inspector.snake_name}.#{@name}"
  end

  def simple_form_hint_key
    "simple_form.hints.#{@model_inspector.snake_name}.#{@name}"
  end

  def simple_form_placeholder_key
    "simple_form.placeholders.#{@model_inspector.snake_name}.#{@name}"
  end

  def simple_form_prompt_key
    "simple_form.prompts.#{@model_inspector.snake_name}.#{@name}"
  end
end
