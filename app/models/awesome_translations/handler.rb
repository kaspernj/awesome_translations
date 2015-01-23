class AwesomeTranslations::Handler
  def self.all
    AwesomeTranslations::Handlers.list
  end

  def self.find(id)
    AwesomeTranslations::Handlers.list.each do |handler|
      return handler if handler.id == id.to_s
    end

    raise ActiveRecord::RecordNotFound, "Handlers not found: '#{id}'."
  end

  def initialize(data)
    @data = data
  end

  def id
    @data[:id]
  end

  def to_param
    id
  end

  def param_key
    id
  end

  def name
    @data[:name]
  end

  def const
    AwesomeTranslations::Handlers.const_get(@data[:const_name])
  end

  def translations
    const.new.translations
  end

  def groups
    const.new.groups
  end
end
