class AwesomeTranslations::Handlers
  @handlers = []

  Dir.foreach("#{File.dirname(__FILE__)}/handlers") do |file|
    match = file.match(/\A(.+)_handler\.rb\Z/)
    next unless match

    const_name_snake = "#{match[1]}_handler"
    const_name_camel = StringCases.snake_to_camel(const_name_snake)

    autoload const_name_camel.to_sym, "#{File.dirname(__FILE__)}/handlers/#{const_name_snake}"

    unless const_name_snake == "base"
      @handlers << AwesomeTranslations::Handler.new(
        id: const_name_snake,
        const_name: const_name_camel,
        name: const_name_camel
      )
    end
  end

  def self.list
    @handlers
  end
end
