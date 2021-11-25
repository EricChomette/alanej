# require 'open-uri'
# require 'nokogiri'

# # @stations.each do |station|
# # url = "https://www.france-montagnes.com/station/#{station}"
# # end

# urltest = "https://www.france-montagnes.com/station/val-thorens"
# html_file = URI.open(urltest).read
# html_doc = Nokogiri::HTML(html_file)
# array = []
# html_doc.search('h4').each do |element|
#   array << element.text
#   puts array
# end
