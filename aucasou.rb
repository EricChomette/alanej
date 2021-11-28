 <% @dates.each do |date|%>
          <div class="card-meteo">
            <p><%= date + Time.now.day %> <%= @mois %></p>
            <p><%= @weathers[date] %></p>
            <p>probabilité de gel <%= @proba_frosts[date] %> %</p>
            <p>probabilité de pluie <%= @proba_rains[date] %> %</p>
            <p>probabilité de brouillard <%= @proba_fogs[date] %> %</p>
          </div>
        <% end %>
      </div>



@stations.each do |station|
  (0..7).each do |date|
    @condition = Condition.new
    @date = date + Time.now.day
    URI.open("https://api.meteo-concept.com/api/forecast/daily/#{date}/period/2?token=25b726a85bb8874026726594e8131564066e1794ef1e71a60a86f019e5e1968d&insee=#{station.insee}") do |stream|
      forecast = JSON.parse(stream.read)['forecast']
      @weather = WEATHER[forecast['weather']]
    end
    @condition.weather = @weather
    @condtion.station = station.id
    @condtion.date_on = @date
    @condition.save
  end
end
