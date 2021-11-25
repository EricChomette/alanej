require 'open-uri'
require 'nokogiri'

submitsSnow = []
submitSnow = ""
snowfalls = []
station = 'chamonix'
midsnow = ""
botsnow = ""
url = "https://wepowder.com/fr/#{station}"

html_file = URI.open(url).read
html_doc = Nokogiri::HTML(html_file)

html_doc.search('.snow-big').each do |element|
  element = element.text.strip
  snowfalls.push(element)

end
html_doc.search('.snow-big').each do |element|
    element = element.text.strip
    submitsSnow.push(element)
    submitSnow = submitsSnow[0]
  end
  html_doc.search('.snow-medium').each do |element|
    element = element.text.strip
    snowfalls.push(element)
    midsnow = snowfalls[0]
    botsnow = snowfalls[1]
  end
puts "Sommet:#{submitSnow}, Millieu:#{midsnow}, Vallée:#{botsnow}"
