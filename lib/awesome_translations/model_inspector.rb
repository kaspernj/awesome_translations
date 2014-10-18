class AwesomeTranslations::ModelInspector
  autoload :Attribute, "#{File.dirname(__FILE__)}/model_inspector/attribute"

  attr_reader :clazz

  # Yields a model-inspector for each model found in the application.
  def self.model_classes
    clazzes = []
    ::Rails.application.eager_load!

    ::Object.constants.each do |clazz|
      clazz = clazz.to_s.constantize
      next unless clazz.class == Class
      next unless clazz < ActiveRecord::Base
      yield ::AwesomeTranslations::ModelInspector.new(clazz)
    end
  end

  def initialize(clazz)
    @clazz = clazz
  end

  def attributes
    @clazz.attribute_names.each do |attribute_name|
      yield ::AwesomeTranslations::ModelInspector::Attribute.new(self, attribute_name)
    end
  end

  def paperclip_attachments
    return [] unless ::Kernel.const_defined?("Paperclip")
    Paperclip::AttachmentRegistry.names_for(@clazz).each do |name|
      yield name
    end
  end

  def snake_name
    return ::StringCases.camel_to_snake(clazz.name)
  end

  def gettext_key
    return "activerecord.models.#{snake_name}"
  end

  def gettext_key_one
    return "#{gettext_key}.one"
  end

  def gettext_key_other
    return "#{gettext_key}.other"
  end

  # TODO: Maybe this should yield a ModelInspector::Relationship instead?
  def relationships
    @clazz.reflections.each do |key, reflection|
      yield key, reflection
    end
  end

  def i18n_key name
    return "activerecord.attributes.#{snake_name}.#{name}"
  end
end
