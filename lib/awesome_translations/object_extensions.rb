module AwesomeTranslations::ObjectExtensions
  def _(str, replaces = nil)
    str = str.to_s

    if replaces
      replaces.each do |key, val|
        str = str.gsub("%{#{key}}", val.to_s)
      end
    end

    return str
  end
end
