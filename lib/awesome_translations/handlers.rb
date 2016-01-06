class AwesomeTranslations::Handlers
  AutoAutoloader.autoload_sub_classes(self, __FILE__)

  def self.list
    unless @handlers
      @handlers = []

      Dir.foreach("#{File.dirname(__FILE__)}/handlers") do |file|
        match = file.match(/\A(.+)_handler\.rb\Z/)
        next unless match

        const_name_snake = "#{match[1]}_handler"
        next if const_name_snake == "base_handler"
        const_name_camel = StringCases.snake_to_camel(const_name_snake)

        handler = AwesomeTranslations::Handler.new(
          id: const_name_snake,
          const_name: const_name_camel,
          name: const_name_camel
        )

        @handlers << handler if handler.instance.enabled?
      end
    end

    @handlers
  end
end
