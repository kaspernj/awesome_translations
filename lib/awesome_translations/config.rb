class AwesomeTranslations::Config
  attr_accessor :paths_to_translate

  def initialize
    @paths_to_translate = [Rails.root.to_s]
  end
end
