class AwesomeTranslations::Group
  attr_reader :handler, :id, :data

  def self.find_by_handler_and_id(handler, id)
    handler.groups.each do |group|
      return group if group.id == id.to_s
    end

    raise ActiveRecord::RecordNotFound, "Group not found by handler and ID: '#{handler.name}', '#{id}'."
  end

  def initialize(args)
    @handler, @id, @data = args[:handler], args[:id], args[:data]
  end

  def translations(args = {})
    translations_list = @handler.translations_for_group(self)

    args.each do |key, value|
      if key == :finished
        translations_list = translations_list.select { |translation| translation.finished? } if value
      elsif key == :unfinished
        translations_list = translations_list.select { |translation| translation.unfinished? } if value
      else
        raise "Unknown key: #{key}"
      end
    end

    return translations_list
  end

  def translations_count(args = {})
    count = 0
    translations(args).each { count += 1 }
    return count
  end

  def to_param
    id
  end

  def param_key
    id
  end

  def name
    if @data && @data[:name].present?
      return @data[:name].presence
    end

    return id
  end

  def to_s
    "<AwesomeTranslations::Group id=\"#{@id}\" name=\"#{name}\">"
  end

  def inspect
    to_s
  end
end
