class GettextSimpleRails::ModelInspector
  def self.model_classes
    clazzes = []
    ::Rails.application.eager_load!

    ::Object.constants.each do |clazz|
      clazz = clazz.to_s.constantize
      next unless clazz.class == Class
      next unless clazz < ActiveRecord::Base
      yield ::GettextSimpleRails::ModelInspector.new(clazz)
    end
  end

  attr_reader :clazz

  def initialize(clazz)
    @clazz = clazz
  end

  def attributes
    @clazz.attribute_names.each do |attribute_name|
      yield ::GettextSimpleRails::ModelInspector::Attribute.new(self, attribute_name)
    end
  end

  def paperclip_attachments
    return [] unless ::Kernel.const_defined?("Paperclip")
    Paperclip::AttachmentRegistry.names_for(@clazz).each do |name|
      yield(name)
    end
  end

  def snake_name
    return ::StringCases.camel_to_snake(clazz.name)
  end

  def gettext_key
    return "models.name.#{snake_name}"
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
    return "models.attributes.#{snake_name}.#{name}"
  end

  class Attribute
    attr_reader :name

    def initialize(clazz_inspector, name)
      @clazz_inspector = clazz_inspector
      @name = name
    end

    def i18n_key
      return "models.attributes.#{@clazz_inspector.snake_name}.#{@name}"
    end
  end
end
