class AwesomeTranslations::ModelInspector::Attribute
  attr_reader :name

  def initialize(clazz_inspector, name)
    @clazz_inspector = clazz_inspector
    @name = name
  end

  def i18n_key
    return "activerecord.attributes.#{@clazz_inspector.snake_name}.#{@name}"
  end
end
