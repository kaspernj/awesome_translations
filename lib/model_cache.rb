class ModelCache
  def initialize(args)
    @attributes = args.fetch(:attributes)
    @cache_keys = args[:cache_keys]
    @by_keys = args[:by_keys]
    @model = args.fetch(:model)
  end

  def cache_key_name_for(key_names)
    key_names.join("____")
  end

  def generate
    @key_caches = {}
    @by_caches = {}

    @model.each do |model|
      register(model)
    end

    nil
  end

  def data_by_key(key_names, key_values)
    current = @by_caches
    last_index = key_names.length - 1

    key_names.each_with_index do |key_name, index|
      key_value = key_values[index]

      if index == last_index
        current_key = current[key_name]
        return nil unless current_key
        return current_key.fetch(:models)[key_value]
      else
        current = current.fetch(key_name).fetch(:subs)[key_value]
        return nil unless current
      end
    end
  end

  def model_by_key(key_names, key_values)
    data = data_by_key(key_names, key_values)
    return nil unless data
    @model.new(data, init: true)
  end

  def data_by_cache_key(key_name, key_values)
    key_name = cache_key_name_for(key_name) if key_name.is_a?(Array)
    key_value = Digest::MD5.hexdigest(key_values.join("____"))

    @key_caches[key_name][key_value] if @key_caches[key_name]
  end

  def model_by_cache_key(key_names, key_values)
    data = data_by_cache_key(key_names, key_values)
    return nil unless data
    @model.new(data, init: true)
  end

  def register(model)
    attributes = {}
    @attributes.each do |attribute|
      attributes[attribute] = model.__send__(attribute)
    end

    register_cache_keys(model, attributes) if @cache_keys
    register_cache_by(model, attributes) if @by_keys

    nil
  end

private

  def register_cache_by(model, attributes)
    @by_caches ||= {}

    @by_keys.each do |by_keys|
      current = @by_caches
      last_index = by_keys.length - 1

      by_keys.each_with_index do |by_key, index|
        key_value = model.__send__(by_key)

        if index == last_index
          current[by_key] ||= {}
          current[by_key][:models] ||= {}
          current[by_key].fetch(:models)[key_value] = attributes
        else
          current[by_key] ||= {subs: {}}
          current[by_key][:subs][key_value] ||= {}

          current = current.fetch(by_key).fetch(:subs).fetch(key_value)
        end
      end
    end
  end

  def register_cache_keys(model, attributes)
    @key_caches ||= {}

    @cache_keys.each do |cache_keys|
      key_parts = []

      cache_keys.each do |cache_key|
        key_parts << model.__send__(cache_key).to_s
      end

      key_name = cache_key_name_for(cache_keys)
      key_value = Digest::MD5.hexdigest(key_parts.join("____"))

      @key_caches[key_name] ||= {}
      @key_caches[key_name][key_value] = attributes
    end
  end
end
