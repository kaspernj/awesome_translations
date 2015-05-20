class AwesomeTranslations::ModelInspector
  autoload :Attribute, "#{File.dirname(__FILE__)}/model_inspector/attribute"

  attr_reader :clazz
  cattr_accessor :models_loaded

  # Yields a model-inspector for each model found in the application.
  def self.model_classes
    # Make sure all models are loaded.
    load_models

    @scanned = {}
    @yielded = {}
    @skip = ["ActiveRecord::SchemaMigration"]

    ArrayEnumerator.new do |yielder|
      find_subclasses(ActiveRecord::Base) do |model_inspector|
        next if @skip.include? model_inspector.clazz.name
        yielder << model_inspector
      end
    end
  end

  def initialize(clazz)
    @clazz = clazz
  end

  def attributes
    ArrayEnumerator.new do |yielder|
      @clazz.attribute_names.each do |attribute_name|
        yielder << ::AwesomeTranslations::ModelInspector::Attribute.new(self, attribute_name)
      end
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

  def class_key
    return "activerecord.models.#{snake_name}"
  end

  def class_key_one
    return "#{class_key}.one"
  end

  def class_key_other
    return "#{class_key}.other"
  end

  # TODO: Maybe this should yield a ModelInspector::Relationship instead?
  def relationships
    @clazz.reflections.each do |key, reflection|
      yield key, reflection
    end
  end

  def attribute_key(attribute_name)
    return "activerecord.attributes.#{snake_name}.#{attribute_name}"
  end

  def to_s
    "<AwesomeTranslations::ModelInspector class-name: \"#{@clazz.name}\">"
  end

  def inspect
    to_s
  end

private

  def self.find_subclasses(clazz, &blk)
    return if @scanned[clazz]
    @scanned[clazz] = true

    clazz.subclasses.each do |subclass|
      blk.call ::AwesomeTranslations::ModelInspector.new(subclass)
      find_subclasses(subclass, &blk)
    end
  end

  # Preloads all models for Rails app and all engines (if they aren't loaded, then they cant be inspected).
  def self.load_models
    return false if AwesomeTranslations::ModelInspector.models_loaded

    AwesomeTranslations::ModelInspector.models_loaded = true

    load_models_for(Rails.root)
    engines.each do |engine|
      load_models_for(engine.root)
    end

    return true
  end

  def self.engines
    ::Rails::Engine.subclasses.map(&:instance)
  end

  # Loads models for the given app-directory (Rails-root or engine).
  def self.load_models_for(root)
    Dir.glob("#{root}/app/models/**/*.rb") do |model_path|
      begin
        require model_path
      rescue => e
        $stderr.puts "Could not load model in #{model_path}"
        $stderr.puts e.inspect
        $stderr.puts e.backtrace
      end
    end
  end
end
