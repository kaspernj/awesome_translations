class AwesomeTranslations::Config
  attr_accessor :ignored_paths, :paths_to_translate

  def initialize
    @ignored_paths = [
      Rails.root.join(".git").to_s,
      Rails.root.join("config", "locales").to_s,
      Rails.root.join("log").to_s,
      Rails.root.join("public", "packs-test").to_s,
      Rails.root.join("public", "packs").to_s,
      Rails.root.join("node_modules").to_s,
      Rails.root.join("tmp").to_s,
      Rails.root.join("storage").to_s,
      Rails.root.join("spec").to_s
    ]
    @paths_to_translate = [Rails.root.to_s]
  end
end
