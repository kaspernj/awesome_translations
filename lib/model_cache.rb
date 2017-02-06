class ModelCache
  def initialize(args)
    @attributes = args.fetch(:attributes)
    @by_keys = args.fetch(:by_keys)
    @model = args.fetch(:model)
  end

  def generate
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
        return current.fetch(key_name).fetch(:models)[key_value]
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

  def register(model)
    attributes = {}
    @attributes.each do |attribute|
      attributes[attribute] = model.__send__(attribute)
    end

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

    nil
  end
end
