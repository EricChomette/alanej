
require "uri"
require "net/http"
require "awesome_print"
require "json"
require 'open-uri'
require 'json'

URI.open("https://api.mapbox.com/directions/v5/mapbox/driving/4.831672,45.738998;5.560912,45.199696?geometries=geojson&access_token=pk.eyJ1IjoibWFlbHByIiwiYSI6ImNrd2RrM2U5bzBsc2Eyb24xYXB0cnJscW8ifQ.iFKMjM3OFf6oUgyejjfq8Q") do |stream|
ap  trajet = JSON.parse(stream.read)["routes"]
trajet_Duration = trajet[0]["duration"]
trajet_Longueur = trajet[0]["distance"]

trajet_Duration = trajet_Duration / 60
trajet_Duration = trajet_Duration.to_i
trajet_Longueur = trajet_Longueur / 1000
trajet_Longueur = trajet_Longueur.to_i
budget_car =  trajet_Longueur * 0.246559
budget_car =  budget_car.to_i
puts "durée #{ trajet_Duration} minutes, longueur: #{trajet_Longueur} Km, prix_moyen: #{budget_car} €"
end
