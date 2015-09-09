class AwesomeTranslations::MongoidInspector
  def self.model_classes
    # Make sure all models are loaded.
    load_models

    @scanned = {}
    @yielded = {}

    ArrayEnumerator.new do |yielder|
      if Object.const_defined?(:Mongoid)
        mongoid_models do |model_inspector|
          next if @skip.include? model_inspector.clazz.name
          yielder << model_inspector
        end
      end
    end
  end

  def initialize(clazz)
    @clazz = clazz
  end

private

  def self.mongoid_models
    Object.constants.each do |constant|
      clazz = Object.const_get(constant)

      if clazz.class == Class && clazz.include?(Mongoid::Document)
        yield ::AwesomeTranslations::MongoidInspector.new(clazz)
      end
    end
  end
end
