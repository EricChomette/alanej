require "uri"
require "net/http"
require "json"
require 'open-uri'
require 'nokogiri'

class ScrapperNeigeService
  def initialize(station)
    @station = station
  end

  def call
    snow(@station)
  end

  private

  def bot_snow(html_doc)
    bot_array = []
    html_doc.search('.snow-medium').each do |element|
      bot_array << element.text.strip
    end
    return bot_array
  end

  def submit_snow(html_doc)
    submit_array = []
    html_doc.search('.snow-big').each do |element|
      submit_array << element.text.strip
    end
    return submit_array
  end

  def snow(station)
    bot_submit_array = []
    html_file = URI.open("https://wepowder.com/fr/#{station.snowurl}").read
    html_doc = Nokogiri::HTML(html_file)

    bot_array = bot_snow(html_doc)
    submit_array = submit_snow(html_doc)

    bot_submit_array << submit_array.first
    bot_submit_array << bot_array[1]
  end
end
