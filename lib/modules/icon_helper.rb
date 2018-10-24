module IconHelper
  def icon_path(icon)
    return "#{Dir.pwd}\\lib\\icons\\#{icon}.ico" if OS.windows?
    "#{Dir.pwd}/lib/icons/#{icon}.ico"
  end
end
