require "uri"
require "net/http"
require "json"
require 'open-uri'
require 'nokogiri'

class ScrapperSnowService

  def initialize(station)
    @station = station
    @base_url = "https://wepowder.com/fr/#{@station.snowurl}"
    puts "Synchro snow #{@station.name}"
  end

  def call
    udpate_conditions
  end

  private

  def udpate_conditions
    14.times do |i|
      date_on = Date.today + i.days
      puts "  - #{date_on}"
      condition = Condition.find_or_create_by(station: @station, date_on: date_on)
      condition.update!(snow: snow)
    end
  end

  def snow
    bot_submit_array = []
    html_file = URI.open(@base_url).read
    html_doc = Nokogiri::HTML(html_file)
    bot_array = bot_snow(html_doc)
    submit_array = submit_snow(html_doc)
    bot_submit_array << submit_array.first
    bot_submit_array << bot_array[1]
  end

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

end
