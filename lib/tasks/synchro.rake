namespace :synchro do
  desc "synchro météo"
  task weather: :environment do
    Station.all.each do |station|
      MeteoApiService.new(station).call
    end
  end

  desc "synchro snow"
  task snow: :environment do
    ap "je dois synchro la snow"
    Station.all.each do |station|
      ScrapperSnowService.new(station).call
    end
  end
end
