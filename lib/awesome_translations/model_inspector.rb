class AwesomeTranslations::ModelInspector
  autoload :Attribute, "#{File.dirname(__FILE__)}/model_inspector/attribute"

  attr_reader :clazz

  # Yields a model-inspector for each model found in the application.
  def self.model_classes(&blk)
    # Make sure all models are loaded.
    load_models

    @scanned = {}
    constants = Module.constants + Object.constants + Kernel.constants
    constants.sort.each do |constant_name|
      scan_for_models(::Object, constant_name, &blk)
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
    clazz.name.gsub("::", "/").split("/").map { |part| ::StringCases.camel_to_snake(part) }.join("/")
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

  def to_s
    "<AwesomeTranslations::ModelInspector class-name: \"#{@clazz.name}\">"
  end

  def inspect
    to_s
  end

private

  # Loads all models for Rails app and all engines.
  def self.load_models
    load_models_for(Rails.root)
    Rails.application.railties.engines.each do |r|
      load_models_for(r.root)
    end
  end

  # Loads models for the given app-directory (Rails-root or engine).
  def self.load_models_for(root)
    Dir.glob("#{root}/app/models/**/*.rb") do |model_path|
      require model_path
    end
  end

  def self.scan_for_models(parent_clazz, constant_name, &blk)
    return unless parent_clazz.const_defined?(constant_name)

    begin
      clazz = parent_clazz.const_get(constant_name)
    rescue
      return
    end

    return if !clazz.respond_to?(:name) || !clazz.name || !clazz.respond_to?(:constants)
    return if clazz.name == "ActiveRecord::SchemaMigration"
    return if clazz.name.end_with?("::Translation")

    clazz.constants.sort.each do |clazz_sym|
      begin
        class_current = clazz.const_get(clazz_sym)
      rescue
        next
      rescue RuntimeError, LoadError
        next
      end

      if @scanned[class_current]
        next
      else
        @scanned[class_current] = true
      end

      next if !class_current.is_a?(Class) && !class_current.is_a?(Module)

      scan_for_models(clazz, clazz_sym, &blk)
    end

    begin
      return unless clazz < ActiveRecord::Base
    rescue
      return
    end

    blk.call ::AwesomeTranslations::ModelInspector.new(clazz)
  end
end
