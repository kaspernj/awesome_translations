# desc "Explaining what the task does"
# task :awesome_translations do
#   # Task goes here
# end

namespace :awesome_translations do
  task "install" => :environment do
    yml_root = "#{Rails.root}/config/locales/awesome_translations"

    dirs = [
      yml_root,
      "#{yml_root}/helpers",
      "#{yml_root}/models",
      "#{yml_root}/views",
      "#{yml_root}/controllers"
    ]

    dirs.each do |dir|
      unless File.exist?(dir)
        puts "[AwesomeTranslations] Creating dir: #{dir}"
        Dir.mkdir(dir)
      end
    end
  end

  task "update" => :environment do
  end
end
