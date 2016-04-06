class AwesomeTranslations::ModelInspector::Attribute
  attr_reader :name, :model_inspector

  def initialize(model_inspector, name)
    @model_inspector = model_inspector
    @name = name
  end

  def i18n_key
    "activerecord.attributes.#{@model_inspector.snake_name}.#{@name}"
  end
end
