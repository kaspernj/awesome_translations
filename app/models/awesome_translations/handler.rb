class AwesomeTranslations::Handler
  def self.all
    AwesomeTranslations::Handlers.list
  end

  def self.find id
    AwesomeTranslations::Handlers.list.each do |handler|
      return handler if handler.id == id.to_s
    end

    raise ActiveRecord::RecordNotFound, "Handlers not found: '#{handler}'."
  end

  def initialize data
    @data = data
  end

  def id
    @data[:id]
  end

  def name
    @data[:name]
  end

  def translations
    raise "stub!"
  end
end
