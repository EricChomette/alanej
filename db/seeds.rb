require "uri"
require "net/http"
require "json"
require 'open-uri'
require 'nokogiri'

WEATHER = {
      0 => "Soleil",
      1 => "Peu nuageux",
      2 => "Ciel voilé",
      3 => "Nuageux",
      4 => "Très nuageux",
      5 => "Couvert",
      6 => "Brouillard",
      7 => "Brouillard givrant",
      10 => "Pluie faible",
      11 => "Pluie modérée",
      12 => "Pluie forte",
      13 => "Pluie faible verglaçante",
      14 => "Pluie modérée verglaçante",
      15 => "Pluie forte verglaçante",
      16 => "Bruine",
      20 => "Neige faible",
      21 => "Neige modérée",
      22 => "Neige forte",
      30 => "Pluie et neige mêlées faibles",
      31 => "Pluie et neige mêlées modérées",
      32 => "Pluie et neige mêlées fortes",
      40 => "Averses de pluie locales et faibles",
      41 => "Averses de pluie locales",
      42 => "Averses locales et fortes",
      43 => "Averses de pluie faibles",
      44 => "Averses de pluie",
      45 => "Averses de pluie fortes",
      46 => "Averses de pluie faibles et fréquentes",
      47 => "Averses de pluie fréquentes",
      48 => "Averses de pluie fortes et fréquentes",
      60 => "Averses de neige localisées et faibles",
      61 => "Averses de neige localisées",
      62 => "Averses de neige localisées et fortes",
      63 => "Averses de neige faibles",
      64 => "Averses de neige",
      65 => "Averses de neige fortes",
      66 => "Averses de neige faibles et fréquentes",
      67 => "Averses de neige fréquentes",
      68 => "Averses de neige fortes et fréquentes",
      70 => "Averses de pluie et neige mêlées localisées et faibles",
      71 => "Averses de pluie et neige mêlées localisées",
      72 => "Averses de pluie et neige mêlées localisées et fortes",
      73 => "Averses de pluie et neige mêlées faibles",
      74 => "Averses de pluie et neige mêlées",
      75 => "Averses de pluie et neige mêlées fortes",
      76 => "Averses de pluie et neige mêlées faibles et nombreuses",
      77 => "Averses de pluie et neige mêlées fréquentes",
      78 => "Averses de pluie et neige mêlées fortes et fréquentes",
      100 => "Orages faibles et locaux",
      101 => "Orages locaux",
      102 => "Orages fort et locaux",
      103 => "Orages faibles",
      104 => "Orages",
      105 => "Orages forts",
      106 => "Orages faibles et fréquents",
      107 => "Orages fréquents",
      108 => "Orages forts et fréquents",
      120 => "Orages faibles et locaux de neige ou grésil",
      121 => "Orages locaux de neige ou grésil",
      122 => "Orages locaux de neige ou grésil",
      123 => "Orages faibles de neige ou grésil",
      124 => "Orages de neige ou grésil",
      125 => "Orages de neige ou grésil",
      126 => "Orages faibles et fréquents de neige ou grésil",
      127 => "Orages fréquents de neige ou grésil",
      128 => "Orages fréquents de neige ou grésil",
      130 => "Orages faibles et locaux de pluie et neige mêlées ou grésil",
      131 => "Orages locaux de pluie et neige mêlées ou grésil",
      132 => "Orages fort et locaux de pluie et neige mêlées ou grésil",
      133 => "Orages faibles de pluie et neige mêlées ou grésil",
      134 => "Orages de pluie et neige mêlées ou grésil",
      135 => "Orages forts de pluie et neige mêlées ou grésil",
      136 => "Orages faibles et fréquents de pluie et neige mêlées ou grésil",
      137 => "Orages fréquents de pluie et neige mêlées ou grésil",
      138 => "Orages forts et fréquents de pluie et neige mêlées ou grésil",
      140 => "Pluies orageuses",
      141 => "Pluie et neige mêlées à caractère orageux",
      142 => "Neige à caractère orageux",
      210 => "Pluie faible intermittente",
      211 => "Pluie modérée intermittente",
      212 => "Pluie forte intermittente",
      220 => "Neige faible intermittente",
      221 => "Neige modérée intermittente",
      222 => "Neige forte intermittente",
      230 => "Pluie et neige mêlées",
      231 => "Pluie et neige mêlées",
      232 => "Pluie et neige mêlées",
      235 => "Averses de grêle"
}

Station.destroy_all

def find_forecast(date, station)
  URI.open("https://api.meteo-concept.com/api/forecast/daily/#{date}/period/2?token=2795e22b8eab493448975973cfc123f39c329acb1adbc901e2c0b257059bc02f&insee=#{station.insee}") do |stream|
    return JSON.parse(stream.read)['forecast']
  end
end

def weather(date, station)
  forecast = find_forecast(date, station)
  return WEATHER[forecast['weather']]
end

def frost(date, station)
  forecast = find_forecast(date, station)
  return forecast['probafrost']
end

def fog(date, station)
  forecast = find_forecast(date, station)
  return forecast['probafog']
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

def snow(station)
  bot_submit_array = []
  html_file = URI.open("https://wepowder.com/fr/#{station.snowurl}").read
  html_doc = Nokogiri::HTML(html_file)

  bot_array = bot_snow(html_doc)
  submit_array = submit_snow(html_doc)

  bot_submit_array << submit_array.first
  bot_submit_array << bot_array[1]
end

villard_de_lans = Station.create!(
  name: 'Villard de Lans',
  address: '62 Pl. Pierre Chabert, 38250 Villard-de-Lans',
  description: "Située à moins de 30 minutes de route de Grenoble, sur le plateau du Vercors, la station de ski de Villard de Lans s’articule autour de son bourg (4000 habitants) animé en toute saison, de nombreux petits hameaux environnants (les Clots, l'Essarton, les Chaberts...) et de deux pôles d’hébergements implantés en pied de pistes : Le Balcon de Villard et Les Glovettes. C’est de là que skieurs et snowboardeurs empruntent les télécabines de Côte 2000 et du Pré des Preys pour rejoindre les pistes de ski de l’Espace Villard-Corrençon (domaine commun entre les deux stations voisines que sont Villard de Lans et Corrençon en Vercors). Avec 125 kilomètres de pistes de ski alpin tracés entre les forêts de sapins (côté Villard de Lans) et de pins (côté Corrençon) sur près de 1000 mètres de dénivelé, il s’agit ni plus ni moins que du plus vaste domaine skiable du Vercors (le 3ème à l’échelle de l’ensemble du département de l’Isère).Et que dire du tout aussi vaste domaine de ski nordique du Haut Vercors, totalisant 110 kilomètres de pistes accessibles depuis Bois Barbu ou bien encore depuis la Porte des Hauts Plateaux ? De vastes étendues ouvertes avec vue sur la Moucherolle succèdent aux nombreux passages en forêt offrant ainsi un cadre et une ambiance « grand-nord Canadien ».",
  budget: "€€",
  alt_min: 1650,
  alt_max: 2500,
  green_slopes: 15,
  green_open_slopes: 15,
  blue_slopes: 12,
  blue_open_slopes: 12,
  red_slopes: 16,
  red_open_slopes: 16,
  black_slopes: 10,
  black_open_slopes: 10,
  insee: "38548",
  cardphoto: "https://www.isere-tourisme.com/sites/default/files/sitra/445089_625778.jpg",
  bannerphoto: "https://docs.ski-planet.com/stations/source/20831.jpg",
  lat: "45.046258",
  long: "5.557192",
  logo: "https://cdn-s-www.ledauphine.com/images/3B8C29C7-F38B-4A54-B500-7A6C21977D93/NW_raw/le-nouveau-logo-des-deux-stations-photo-le-dl-noel-coolen-1633098536.jpg",
  snowurl: "les-glovettes#belvedere"
)

les_arcs = Station.create!(
  name: "Les Arcs",
  address: "73700 Bourg-Saint-Maurice",
  description: "Les Arcs est une station de sports d'hiver et un nom de domaine skiable de la vallée de la Tarentaise, situés sur le territoire communal des communes de Bourg-Saint-Maurice, Landry, Peisey-Nancroix, et de Villaroger, dans le département de la Savoie en région Auvergne-Rhône-Alpes. Les stations-villages des Arcs — Arc 1600, Arc 1800, Arc 2000 — sont des stations intégrées, dites de « troisième génération », voire de « quatrième génération » pour Arc 1950, installées sur la commune de Bourg-Saint-Maurice et édifiée à partir de la fin des années 1960. La dernière a été construite en 2003. Le domaine skiable associe également les stations de Peisey-Vallandry, situées sur les communes de Landry et Peisey-Nancroix, et de Villaroger. Les domaines des Arcs et de Peisey-Vallandry sont reliés, depuis 2003, par le téléphérique du « Vanoise Express » à celui de Grande Plagne, formant ainsi l'un des plus grands domaines de ski français, Paradiski, avec plus de 425 km de pistes revendiquées.",
  budget: "€€",
  alt_min: 1200,
  alt_max: 3226,
  green_slopes: 1,
  green_open_slopes: 1,
  blue_slopes: 54,
  blue_open_slopes: 45,
  red_slopes: 34,
  red_open_slopes: 29,
  black_slopes: 18,
  black_open_slopes: 16,
  insee: "73054",
  cardphoto: "https://resize-elle.ladmedia.fr/rcrop/638,,forcex/img/var/plain_site/storage/images/loisirs/evasion/que-faire-aux-arcs/76922096-2-fre-FR/Que-faire-aux-Arcs.jpg",
  bannerphoto: "https://www.skieur.com/media/guide_station/img/arc_2000%C2%A9andyparant_1.jpg",
  lat: "45.616770",
  long: "6.769290",
  logo: "https://upload.wikimedia.org/wikipedia/commons/c/c6/Logo_officiel_de_la_station_de_ski_des_Arcs.jpg",
  snowurl: "arc-1950"
)

def new_condition(station)
  (0..7).each do |date|
    real_date = date + Time.now.day
    Condition.create!(
      station: station,
      date: real_date,
      weather: weather(date, station),
      frost_prob: frost(date, station),
      fog_prob: fog(date, station),
      snow: snow(station)
    )
  end
end

Station.all.each do |station|
  new_condition(station)
end
# serre_che = Station.create!(
#   name: "Serre Chevalier",
#   address: "Le, Rte de Pré-Long, 05240 La Salle-les-Alpes",
#   description: "Située à proximité du Parc national des Ecrins, Serre Chevalier Vallée est le regroupement de la ville de Briançon (ville inscrite au patrimoine mondial de l'UNESCO) et de 3 villages : Saint-Chaffrey/Chantemerle, Villeneuve/La Salle les Alpes et le Monêtier les Bains.
#   Avec 250 km de pistes, Serre Chevalier Vallée est le 1er domaine non relié français. Des pistes adaptées pour toutes les glisses, du ski en vallon ou en forêt de mélèzes, des ambiances haute montagne avec des hors pistes de renom, confèrent à cette station un caractère sportif et ludique.
#   Labellisée «Famille plus», Serre Chevalier propose plus de confort pour l'accueil des familles. Au-delà d'un accueil personnalisé, des activités à vivre ensemble ou séparément sont proposées, des animations et des événements adaptés pour tous les âges sont organisés toute la saison et des tarifs réduits permettent à la famille de profiter de son séjour.",
#   budget: "€€",
#   alt_min: 1200,
#   alt_max: 2830,
#   green_slopes: 13,
#   green_open_slopes: 11,
#   blue_slopes: 26,
#   blue_open_slopes: 23,
#   red_slopes: 29,
#   red_open_slopes: 28,
#   black_slopes: 13,
#   black_open_slopes: 7,
#   insee: "05161",
#   cardphoto: "https://www.yonder.fr/sites/default/files/destinations/serre%20chevalier%20figure%20snow%20Serre%20Chevalier%20Vall%C3%A9e%20Brian%C3%A7on%20-%20%40laurapeythieu.jpg",
#   bannerphoto: "https://www.terresens.com/wp-content/uploads/2018/03/Thibaut_Blais2.jpg",
#   lat: "44.946249",
#   long: "6.558491",
#   logo: "https://www.e-briancon.com/wp-content/uploads/2017/08/logo-serre-chevalier.jpg"
# )

# autrans = Station.create!(
#   name: "Domaine alpin Autrans",
#   address: "D218, 38880 Autrans",
#   description: "Située en Isère (région Auvergne-Rhône-Alpes), dans le secteur septentrional du massif du Vercors, localement appelé « Les Quatre-Montagnes » ou encore « Le Val d’Autrans - Méaudre», à proximité de Grenoble (40 km), de Valence et de Lyon, la station-village d’Autrans - Méaudre en Vercors attire les familles et les débutants de par son domaine skiable au relief doux et son architecture montagnarde.
#   Au sein du Parc Naturel Régional du Vercors et entouré des sommets de moyenne altitude de La Sure, du Bec d'Orient, du sommet de Plénouze et de La Molière, le domaine skiable propose 35 pistes sur 2 domaines distincts accessibles avec le même forfait (Autrans - La Sure et Méaudre - Village).
#   L'Espace nordique d’Autrans - Méaudre en Vercors propose quant à lui 200 km de pistes, soit un des plus importants sites d’Europe pour la pratique du ski de fond, de la randonnée nordique, de chiens de traîneaux ou encore de la marche nordique sur neige.",
#   budget: "€",
#   alt_min: 1050,
#   alt_max: 1650,
#   green_slopes: 5,
#   green_open_slopes: 4,
#   blue_slopes: 4,
#   blue_open_slopes: 4,
#   red_slopes: 4,
#   red_open_slopes: 3,
#   black_slopes: 2,
#   black_open_slopes: 2,
#   insee: "38225",
#   cardphoto: "https://autrans-meaudre.com/wp-content/uploads/2014/10/autrans-meaudre_najo-grez-11_1500.jpg",
#   bannerphoto: "https://vcdn.bergfex.at/images/resized/f3/925905e55a0a66f3_868f96f4c582a335@2x.jpg",
#   lat: "45.229519",
#   long: "5.581669",
#   logo: "https://www.agopop.fr/wp-content/uploads/2021/02/logo-AUTRANS-MEAUDRE-verti-Rg.png"
# )

# valloire = Station.create!(
#   name: "Valloire",
#   address: "73450 Valloire",
#   description: "Au pied des célèbres Col du Galibier et du Télégraphe, la station de ski de Valloire vous accueille pour vivre des moments plus forts sur les 160 km de pistes du domaine skiable Galibier Thabor.
#   Hôtels, appartements, chalets, gîtes... au pied des pistes, dans un environnement calme et plein de charme, Valloire met à votre disposition des hébergements variés et de qualité. Des solutions locatives pour tous les goûts et toutes les bourses !
#   Le domaine skiable Galibier - Thabor et ses 160 kilomètres de pistes, fait référence à deux sommets emblématiques de la région de plus de 3000 m et regroupe les stations de Valloire et de Valmeinier.",
#   budget: "€€",
#   alt_min: 1430,
#   alt_max: 2600,
#   total_slopes: 89,
#   green_slopes: 17,
#   blue_slopes: 30,
#   red_slopes: 34,
#   black_slopes: 8,
#   insee: "73306",
#   cardphoto: "https://cdn.snowplaza.com/images/ski-area/w_1024,h_768/valloire_214168.webp",
#   bannerphoto: "https://www.grand-hotel-valloire.com/cache/e/2/3/8/d/e238d87250be931c61ad71bf60a6b895f7686260.jpeg",
#   logo: "https://upload.wikimedia.org/wikipedia/commons/8/80/Valloire-logo.jpg"
# )

# la_plagne = Station.create!(
#   name: "La Plagne",
#   address: "73210 La Plagne",
#   description: "La Plagne est une station familiale de sports d’hiver et d’été, située en Savoie et implantée entre 1250 et 3250 mètres d'altitude. Depuis plus de 50 ans, la destination a acquis une renommée internationale grâce à son vaste domaine skiable tous niveaux de 225 kilomètres de pistes. Depuis 2003, la Plagne elle est une station composante de Paradiski (le domaine skiable qui la relie avec les stations voisines des Arcs et Peisey-Vallandry).
#   La station de la Plagne, est en fait le regroupement de 10 stations :
#   - 6 stations d'altitude (Aime la Plagne, Belle Plagne, Plagne Villages/Soleil, Plagne Bellecôte, Plagne Centre et Plagne 1800), toutes situées directement au pied des pistes, reliées gratuitement entre elles de 8h00 à minuit, permettant ainsi des vacances sans voiture
#   - 4 stations villages (Champagny en Vanoise, Plagne Montalbert, Montchavin et Les Coches) donnant accès à l'ensemble du domaine skiable.
#   Du village traditionnel au village d’altitude, la Plagne possède ainsi plus de 53 387 lits répartis sur ses 10 destinations, étagées entre 1250 et 2100 mètres.",
#   budget: "€€",
#   alt_min: 1250,
#   alt_max: 3250,
#   total_slopes: 134,
#   green_slopes: 9,
#   blue_slopes: 72,
#   red_slopes: 34,
#   black_slopes: 19,
#   insee: "73150",
#   cardphoto: "https://fr.ski-france.com/media/cache/gallery_default/20875.jpg",
#   bannerphoto: "https://www.la-plagne.com/sites/default/files/styles/slide_1920x1080/public/medias/images/DESTI_Aime-2000_batiment-vue_O-Allamand.jpg?h=5ca329e5&itok=hSJxWlYa",
#   logo: "https://go.la-plagne.com/logos/BellePlagne.png"
# )

# val_isere = Station.create!(
#   name: "Val d'Isère",
#   address: "73150 Val d'Isère",
#   description: "Val d'Isère - La station Implantée en fond de la Vallée de la Tarentaise (en Savoie), à quelques encablures seulement de sa voisine Tignes, la station de ski de Val d'Isère est aujourd’hui considérée comme l'une des meilleures destinations ski en France.
#   Val d’Isère doit avant tout sa notoriété à son panel de services de standing accessibles à tous. Élégance, qualité, bien-être y sont les mots d'ordre et attirent chaque hiver des skieurs venus de tous horizons pour profiter d’un domaine d’exception alliant des pistes olympiques et de Coupe du Monde, une multitude de spots de hors-piste et une très large variée de pistes.
#   Située à 1850m d’altitude, sa situation géographique et ses reliefs offrent de nombreuses possibilités pour aller explorer la montagne : des zones de ski de randonnée sont aménagées (balisées et sécurisées) pour skier sereinement, plusieurs activités hors-ski ont vu le jour afin de s’adapter à la situation actuelle (le VTT sur neige, le Moonbike, le Snooc, les minis motos neige, le golf sur neige, les balades en traineau à chiens) et bien-sûr les balades en raquettes, les visites guidées du village et les soins en institut. Les restaurants, étoilés pour certains, proposent un large choix de menus à emporter et/ou en livraison. De quoi recharger ses batteries, faire le plein d’oxygène et de grands espaces.
#   Les points forts de Val d’Isère :
#   • Son vaste choix de pistes variées jusqu’à haute altitude
#   • Le triptyque exposition + altitude + enneigement qui garantit une longue saison de ski de fin novembre à la première semaine de mai
#   • Ses hébergement skis aux pieds
#   • L’un des meilleurs domaines hors-pistes du monde",
#   budget: "€€",
#   alt_min: 1850,
#   alt_max: 3456,
#   total_slopes: 78,
#   green_slopes: 31,
#   blue_slopes: 15,
#   red_slopes: 20,
#   black_slopes: 12,
#   insee: "73304",
#   cardphoto: "https://www.lalibre.be/resizer/j6SK9ie6w5dPZ5tgUvrZQvR_cdw=/768x512/filters:quality(70):format(jpg):focal(1353.5x684:1363.5x674)/cloudfront-eu-central-1.images.arcpublishing.com/ipmgroup/YIBHARBL3ZGATIDFVBPP5ZLCKQ.jpg",
#   bannerphoto: "https://phototheque.mon-sejour-en-montagne.com/images/msem/1400_700/val-d-isere-photo2.jpg",
#   logo: "https://upload.wikimedia.org/wikipedia/commons/9/9d/Logo_val_d%27isere.png"
# )

# tignes = Station.create!(
#   name: "Tignes",
#   address: "73320 Tignes",
#   description: "Décalée, cosmopolite, sportive et innovante, Tignes vous offre l'expérience unique de vivre la montagne autrement. Pour les amateurs de sports d‘hiver, Tignes est avant tout une station de ski de renommée internationale qui propose de septembre à mai la meilleure neige et une offre de pistes très diverse.
#   Le domaine skiable Tignes/Val d'Isère (anciennement dénommé Espace Killy) se compose de 300 km de pistes de difficultés variables qui s'étendent entre 1 550 m et 3 450 m d'altitude.
#   En plus de ces pistes, poussez vos spatules un peu plus loin profitez également de 6 stades de slalom, 1 stade de bosses, 2 snowpark, 1 gliss'park.
#   A Tignes, le ski se pratique aussi l'été. Sur le glacier de la Grande Motte, les pistes bleues, rouges et noires vous procurent les joies uniques de la neige de juin à août.
#   En été, le snowpark aussi prend de la hauteur et s'installe sur le glacier, pour le plus grand plaisir des amateurs de freestyle !",
#   budget: "€€",
#   alt_min: 1550,
#   alt_max: 3456,
#   total_slopes: 80,
#   green_slopes: 6,
#   blue_slopes: 38,
#   red_slopes: 20,
#   black_slopes: 16,
#   insee: "73296",
#   cardphoto: "https://media.istockphoto.com/photos/tignes-alps-france-picture-id465967736?k=20&m=465967736&s=612x612&w=0&h=ctM2KRhmigcfVqZC1k4EHZVirbXG_sQJw3cwVBL832I=",
#   bannerphoto: "https://phototheque.mon-sejour-en-montagne.com/images/msem/1400_700/tignes-le-lac-photo2-1.jpg",
#   logo: "https://upload.wikimedia.org/wikipedia/fr/thumb/c/ce/Logo_Tignes.svg/1200px-Logo_Tignes.svg.png"
# )

# courchevel = Station.create!(
#   name: "Courchevel",
#   address: "73120 Courchevel",
#   description: "Courchevel est une station de sports d'hiver de la vallée de la Tarentaise située dans la commune de Courchevel (jusqu'en 2016, la commune de Saint-Bon-Tarentaise), dans le département de la Savoie en région Auvergne-Rhône-Alpes. Première station française aménagée en site vierge en 1946, elle fait partie du domaine skiable des Trois-Vallées.
#   La station est organisée autour de cinq villages : Saint-Bon-Tarentaise (chef-lieu communal), Courchevel Le Praz (appelé avant 2011 Courchevel 1300), Courchevel Village (anciennement Courchevel 1550), Courchevel Moriond (anciennement Courchevel 1650) et enfin Courchevel (anciennement Courchevel 1850). Ce dernier, qui donne son nom à la station, est le premier noyau de développement où s'applique le travail de l'architecte urbaniste Laurent Chappis et de l'ingénieur Maurice Michaud. Cette nouvelle urbanisation de la montagne a fait l'objet d'une inscription à l'inventaire supplémentaire des monuments historiques en 1998, et une trentaine de sites sont protégés au titre des monuments historiques.
#   La station ne se limite pas à la seule saison hivernale et ses pratiques du ski, elle s'est équipée notamment d'infrastructures collectives de loisirs et sportives, comme un centre aqualudique ouvert en décembre 2015, et propose d'autres pratiques en lien avec la montagne durant l'été, avec la randonnée ou le VTT, mais aussi son festival international d'art pyrotechnique ou encore l'organisation d'exposition d'art contemporain. Après avoir été un lieu d'hébergement et le théâtre d'épreuves sportives des Jeux Olympiques d'hiver d'Albertville 1992, Courchevel accueillera, conjointement avec Méribel, les Championnats du monde de ski alpin 2023",
#   budget: "€€",
#   alt_min: 1300,
#   alt_max: 2738,
#   total_slopes: 119,
#   green_slopes: 27,
#   blue_slopes: 44,
#   red_slopes: 38,
#   black_slopes: 10,
#   insee: "73227",
#   cardphoto: "https://cdn.france-montagnes.com/sites/default/files/styles/station_slideshow_large/public/station/hiver/DavidAndre-domaineskiable-BD.jpg?itok=9S5OGQHR",
#   bannerphoto: "https://www.les3vallees.com/media/cache/hero_default/hiver-paysage-discover-village-courchevel-1920x1080-davidandre-091.jpg",
#   logo: "https://www.courchevel.com/images/logo_couchevel_footer.png"
# )

# la_clusaz = Station.create!(
#   name: "La Clusaz",
#   address: "74220 La Clusaz",
#   description: "Connue et reconnue comme une des destinations alpines de référence depuis des décennies et terre de contraste alliant grands espaces et chalets modernes, ressourcement et activités, la Clusaz se découvre de multiples façons.
#   - Village de montagne, elle a une histoire.
#   - Entourée d’une nature riche et abondante, elle est un terrain de jeu infini.
#   - Préservée par ses autochtones, elle est fière d’accueillir les voyageurs venus se dépasser, se retrouver ou se ressourcer…
#   Imaginez une station alpine internationale, au coeur de l’environnement protégé des Alpes, où la douceur de vivre et le dynamisme seraient votre plaisir… Source de grand air et terrain de jeu immense, La Clusaz déroule ses espaces vierges, hors naturels. Située au pied de la chaîne des Aravis, la station a su cultiver ses traits de caractère tout en se projetant vers l’avenir. Servie par son environnement préservé et ses nombreuses richesses, c’est un monde à part qui vous accueille.
#   Comme toutes les bonnes choses, La Clusaz se laisse découvrir au rythme de vos envies et des rencontres, pour vous surprendre au détour d’un sentier, d’un apéro time, à la sortie d’un restaurant ou pendant un soin aux plantes de montagne…",
#   budget: "€€",
#   alt_min: 1040,
#   alt_max: 2477,
#   total_slopes: 86,
#   green_slopes: 16,
#   blue_slopes: 31,
#   red_slopes: 30,
#   black_slopes: 8,
#   insee: "74080",
#   cardphoto: "https://www.hautesavoiephotos.com/villages/la_clusaz_img1651.jpg",
#   bannerphoto: "https://www.mksport-mag.com/media/cache/place_detail_main_picture/2019/01/9357-village-c-pascal-lebeau.jpg",
#   logo: "https://www.laclusaz.com/download?t=page&id=768&ext=.png"
# )

# avoriaz = Station.create!(
#   name: "Avoriaz",
#   address: "74110 Morzine",
#   description: "La station de ski d'Avoriaz est située au cœur du domaine des Portes du Soleil, sur un plateau exposé plein sud. Née d'un défi écologique avant l'âge, Avoriaz est une station entièrement piétonne, interdite aux voitures, où tous les hébergements sont accessibles à ski et où les rues sont des pistes de ski.
#   D'une vallée à l'autre, les accros de la glisse trouvent à Avoriaz des itinéraires 100% naturels, ludiques et sécurisés entre France et Suisse. Ainsi, à Avoriaz, on peut skier tout une semaine sans emprunter deux fois le même tracé, quel que soit son niveau, sur un domaine agréable et apprivoisé.
#   Côté pratique, le Village des Enfants d'Annie Famose accueille les enfants et ados de 3 à 16 ans. Dans ce grand jardin d'hiver, l'apprentissage du ski et du snowboard se fait dans un esprit de jeu, par des moniteurs diplômés. Pour les ados, le Village propose des sessions backcountry et freeride pour explorer le domaine des Portes du Soleil.
#   Outre la glisse et le ski, Avoriaz propose également une très large palette d'activités et de loisirs : balade en traîneau, bowling, cinéma, vols en montgolfière, plongée sous glace, VTT sur neige, patin à glace, balnéo, bodyform, spa... de quoi satisfaire les plus exigeants.
#   Avoriaz est aussi réputée pour sa vie nocturne. Ainsi, à la nuit tombée, Avoriaz s'habille de lumière pour des soirées animées, qui débutent par des spectacles sur neige, se poursuivent dans les restaurants de spécialités et se prolongent dans les endroits branchés de la station... pubs et discothèques.",
#   budget: "€€",
#   alt_min: 1700,
#   alt_max: 2466,
#   total_slopes: 50,
#   green_slopes: 7,
#   blue_slopes: 25,
#   red_slopes: 13,
#   black_slopes: 5,
#   insee: "74191",
#   cardphoto: "https://cdn-elle.ladmedia.fr/var/plain_site/storage/images/loisirs/evasion/avoriaz-3-raisons-de-loger-au-belambra-les-cimes-du-soleil-3760142/90012656-1-fre-FR/Avoriaz-3-raisons-de-loger-au-Belambra-Les-Cimes-du-soleil.jpg",
#   bannerphoto: "https://media-exp1.licdn.com/dms/image/C561BAQF9xAIxCZlhbw/company-background_10000/0/1630412833345?e=2159024400&v=beta&t=oXCeeOVzz2h1WZrL0GboRlnACc8FqlOMN9u8RnWxo20",
#   logo: "https://www.mbh.fr/wp-content/uploads/2019/10/logo-avoriaz.png"
# )

# megeve = Station.create!(
#   name: "Megève",
#   address: "74120 Megève",
#   description: "A deux heures de Lyon vous attend le plus authentique village de montagne des Alpes. Le ski à Megève ce sont 445 kilomètres de pistes dans un décor exceptionnel mais pas seulement : gastronomie, événements, détente et shopping dans le paradis de l’après ski niché au cœur du Pays du Mont Blanc. Venez vivre l’expérience du ski dans un domaine sans pareil qui marie pistes, forêt, fermes d’alpage et terrasses  ensoleillées sur plusieurs massifs.  Un domaine skiable adapté aux familles qui trouveront à Megève des pentes douces et rassurantes pour se faire plaisir avec les enfants. Les amateurs de grands espaces se retrouveront sur le massif de la Cote 2000 qui bénéficie d’une neige de qualité grâce à son exposition. Les amateurs de freestyle ne sont pas en reste avec un espace dédié qui autorise des sauts en toute sécurité sur un air bag géant.  Vous l’aurez compris à Megève le paradis du ski vous attend à seulement 180 kilomètres de Lyon. Megève est un village typique de Haute-Savoie qui ne vous laissera pas indifférent. Doté d’une histoire et d’un patrimoine hors du commun, le village possède une âme qui va bien au-delà des images que l’on a de ce lieu unique. Ambassadrice d’une gastronomie locale revisitée par des Chefs étoilés, c’est une destination qui vit chaque saison. Les événements culturels et sportifs rythment la vie locale et chacun trouvera à Megève une émotion qui ne laissera pas indifférent. A vous de découvrir la légende qui se cache derrière Megève…",
#   budget: "€€",
#   alt_min: 1113,
#   alt_max: 2353,
#   total_slopes: 222,
#   green_slopes: 43,
#   blue_slopes: 63,
#   red_slopes: 83,
#   black_slopes: 33,
#   insee: "74173",
#   cardphoto: "http://media.sit.savoie-mont-blanc.com/620x425/55979/9-10955800.jpeg",
#   bannerphoto: "https://skipass.fr/p/resorts/687/default-megeve-7767f-1.jpg",
#   logo: "https://mairie.megeve.fr/wp-content/uploads/2018/03/logo-bonne-qualit%C3%A9-650x288.jpg"
# )

# deux_alpes = Station.create!(
#   name: "Les 2 Alpes",
#   address: "38860 Les Deux Alpes",
#   description: "Station de ski phare du département de l'Isère, les 2 Alpes jouie d'une réputation internationale grâce à son domaine d'altitude (le plus haut domaine skiable de France) depuis 3600 mètres d’altitude. Le glacier est l'assurance de skier sur une neige naturelle en toute saison. Le domaine vertical permet d’enchainer un dénivelé de 2300m entre 3600m et 1300m (dont 10km sur une piste bleue entre 3600m et 1600m). Plus on monte en altitude plus les pistes sont accessibles aux skieurs intermédiaires. Un départ et un retour station ski aux pieds. Que l’on soit en duo, en famille ou entre amis, débutant, intermédiaire ou expert, on peut évoluer tous ensemble ou sur des pistes parallèles et se retrouver facilement, et surtout le terrain de jeu est très varié, proposant des pistes balisées, hors-pistes, pistes ludiques, stade de slalom.
#   Les 2 Alpes, c’est côtoyer les hauts sommets mais aussi profiter d’espaces de liberté, partager des activités décalées, s’enivrer de panoramas époustouflants, enchaîner des dénivelés (3600m à 1300m), s’éclater avec un shopping branché, vibrer grâce à une ambiance festive et gourmande, apprécier des rencontres privilégiées, s’offrir une pause bien-être.",
#   budget: "€€",
#   alt_min: 1300,
#   alt_max: 3600,
#   total_slopes: 93,
#   green_slopes: 19,
#   blue_slopes: 42,
#   red_slopes: 21,
#   black_slopes: 11,
#   insee: "38253",
#   cardphoto: "https://upload.wikimedia.org/wikipedia/commons/thumb/8/8c/Les2Alpes.jpg/1200px-Les2Alpes.jpg",
#   bannerphoto: "https://woody.cloudly.space/app/uploads/les-deux-alpes/2020/11/thumbs/267-les-2-alpes-automne-hiver-1-1920x960.jpg",
#   logo: "https://www.ski-planet.com/photo/les-2-alpes/logo-les-2-alpes.jpg"
# )

# chamonix = Station.create!(
#   name: "Chamonix",
#   address: "74400 Chamonix",
#   description: "Station de ski estampillée 'Mont-Blanc Natural Resort', Chamonix-Mont-Blanc est une destination mythique ! Ici tout participe à la légende. Levez les yeux ! Vous êtes au centre du mythe, au pied du Mont Blanc, à portée du bonheur absolu.
#   Nul besoin d'être un champion pour prendre place dans la légende, entre le ski plaisir et la glisse extrême, à Chamonix, vous profiterez d'activités plus citadines ou plus festives d'un centre-ville animé jour et nuit.
#   A l'image des multiples reliefs qui rythment la vallée, le domaine skiable de Chamonix vous permet de découvrir et d'alterner, en famille ou entre amis, tous les plaisirs de la glisse. Ski de piste, snowboard, télémark, freeride, freestyle, snowpark, speedriding, ski découverte, hors-pistes inoubliables…
#   Débutants ou experts, la qualité des équipements et des sites naturels n'a pas son pareil pour vous procurer des sensations plurielles face au mont Blanc.",
#   budget: "€€",
#   alt_min: 1035,
#   alt_max: 3275,
#   total_slopes: 79,
#   green_slopes: 16,
#   blue_slopes: 31,
#   red_slopes: 21,
#   black_slopes: 11,
#   insee: "74056",
#   cardphoto: "https://images.lpcdn.ca/924x615/201512/04/1099568-chamonix-love-creux-sommets-parmi.jpg",
#   bannerphoto: "https://www.skiloc-chamonix.fr/wp-content/uploads/2018/01/station-de-ski-chamonix-flegere.png",
#   logo: "https://www.mbh.fr/wp-content/uploads/2020/03/alt-logo-chamonix.png"
# )

# les_saisies = Station.create!(
#   name: "Les Saisies",
#   address: "73620 Hauteluce",
#   description: "La convivialité d’une station familiale à taille humaine qui a su conserver, au fil de son évolution, une architecture traditionnelle & harmonieuse au sein d’une nature préservée.
#   Le grenier à neige de la Savoie : des conditions d’enneigement exceptionnelles à 1650 m d’altitude qui permettent une ouverture des domaines de décembre à fin avril. Une complémentarité entre domaine alpin et domaine nordique : choisissez d’arpenter l’Espace Diamant qui compte 192 km de pistes de tous niveaux entre Beaufortain et Val d’Arly ou de découvrir les 120 km d’itinéraires nordiques. Si vous n’aimez pas choisir, faites les deux !
#   Un large choix d’activités en été comme en hiver pour satisfaire toute la famille : sports en tout genre, patrimoine, excursions, visites, animations gratuites, découverte de la nature…)
#   Un soleil généreux qui inonde successivement tous les versants, dont les différentes orientations vous permettent de profiter pleinement des bienfaits de ses rayons. Vivez la montagne autrement : ici, au col, pas de sensation d’oppression due à des pics abruptes, mais plutôt des montagnes de douceur, de larges alpages entrecoupés de forêts accueillantes où il fait bon flâner et s’oxygéner…  Le Tyrol Français : l’éblouissante beauté des paysages avec panorama à 360° sur les différents massifs environnants (Beaufortain & Aravis), ainsi qu’une vue imprenable sur le plus haut sommet d’Europe : le Mont Blanc…",
#   budget: "€€",
#   alt_min: 1180,
#   alt_max: 2050,
#   total_slopes: 151,
#   green_slopes: 34,
#   blue_slopes: 59,
#   red_slopes: 47,
#   black_slopes: 11,
#   insee: "73132",
#   cardphoto: "https://cdn.france-montagnes.com/sites/default/files/styles/station_slideshow_large/public/station/hiver/station2.jpg?itok=knuLXOmW",
#   bannerphoto: "https://www.moka-mag.com/media/cache/place_detail_main_picture/2018/11/2793-les-saisies.jpg",
#   logo: "https://cheque-vacances-connect.com/collaborateur/wp-content/uploads/2021/06/lessaisies.jpg"
# )

# sept_laux = Station.create!(
#   name: "Les 7 Laux",
#   address: "38190 Les Adrets",
#   description: "Située au coeur du massif de Belledonne (en Isère), la station de ski des 7 Laux, se décompose en 3 sites:
#   -A l'est, Le Pleynet (1450 m), site pleine montagne, domine la vallée du Haut Bréda face aux cimes ciselées de la Belle Etoile et des Cabottes.
#   -A l'ouest, Prapoutel (1350 m), site urbain avec tous ses commerces (cinéma, discothèque...),
#   - et Pipay (1550 m), site nature, surplombent la vallée du Grésivaudan.
#   Attention, il faut compter environ 1 heure de voiture entre Prapoutel et le Pleynet (par Allevard)
#   Côté glisse, le domaine skiable des 7 Laux a la particularité d'être quasi entièrement renouvelé. En effet, en l'espace d'une quinzaine d'années, 90 % des remontées mécaniques des 7 Laux ont été changées et modernisées et les pistes ont été reprofilées.
#   Plus grand domaine skiable de la chaîne de Belledonne, les 7 Laux est une véritable espace de loisirs, proposant une grande diversité de glisses avec son snowpark, son accès sécurisé aux Vallons du Pra, deux sites de ski nordique, du snakegliss… Mais aussi des activités hors-glisse et de nombreuses animations pour toute la famille.",
#   budget: "€€",
#   alt_min: 1350,
#   alt_max: 2400,
#   total_slopes: 52,
#   green_slopes: 10,
#   blue_slopes: 10,
#   red_slopes: 18,
#   black_slopes: 14,
#   insee: "38002",
#   cardphoto: "https://d3u9sm4kpb9d1j.cloudfront.net/pictures/1454197",
#   bannerphoto: "https://woody.cloudly.space/app/uploads/les-sept-laux/2019/09/thumbs/dji-0328-1920x960.jpg",
#   logo: "https://upload.wikimedia.org/wikipedia/fr/thumb/a/a9/Logo_Les_7_Laux.svg/1280px-Logo_Les_7_Laux.svg.png"
# )

# chamrousse = Station.create!(
#   name: "Chamrousse",
#   address: "38410 Chamrousse ",
#   description: "La station de Chamrousse se trouve à la pointe du massif de Belledonne, à seulement 30 kilomètres de Grenoble. Elle s’étend sur trois niveaux : Chamrousse 1650 - Recoin, Chamrousse 1700 - Bachat Bouloud et Chamrousse 1750 - Roche Béranger reliés par les pistes et les sentiers forestiers, avec pour point culminant, la Croix de Chamrousse à 2250 mètres d’altitude.
#   Les sports d’hiver sont une tradition à Chamrousse, où les premières descentes à ski remontent à 1878. En 1968, six épreuves des Jeux Olympiques de Grenoble se sont déroulées sur nos pistes en descente, slalom géant et slalom spécial. Aujourd’hui 90 km de pistes attendent les amateurs de ski alpin et 40 km de ski nordique.",
#   budget: "€€",
#   alt_min: 1650,
#   alt_max: 2250,
#   total_slopes: 44,
#   green_slopes: 8,
#   blue_slopes: 15,
#   red_slopes: 15,
#   black_slopes: 6,
#   insee: "38567",
#   cardphoto: "https://cdn.france-montagnes.com/sites/default/files/styles/station_slideshow_large/public/station/hiver/OTChamrousse-Roche-Beranger-Aeolus--9-.jpg?itok=rJVv0dSC",
#   bannerphoto: "https://www.transaltitude.fr/media/filer_public_thumbnails/filer_public/11/5d/115debc2-6811-4654-8097-b8824085bccc/chamrousse_vue_avion_images-et-reves_1hd_rec.jpg__1920x350_q85_crop_subsampling-2.jpg",
#   logo: "https://www.chamrousse.com/medias/images/info_pages/logo-chamrousse-noir-fond-transparent-png-2968.png"
# )

# val_thorens = Station.create!(
#   name: "Val Thorens",
#   address: "73440 Val Thorens",
#   description: "Val Thorens, plus haute station d’Europe et point culminant du domaine des 3 Vallées, est le plus grand domaine skiable du monde avec plus de 600 km de pistes.
#   Situé au cœur d’un vaste cirque naturel dominé par ses 6 glaciers, la station de ski de Val Thorens offre une multitude d’itinéraires pour skier au soleil toute la journée.
#   Réputée pour la qualité de sa neige et ses remontées mécaniques à la pointe, bienvenue dans le paradis de la glisse. Carving, hors-pistes, ski de rando, snowpark, boardercross, télémark, il y en a pour tous les goûts. Avec un domaine situé à 99% au dessus de 2000 m, Val Thorens offre des conditions excellentes pour un maximum de plaisir.
#   Station skis aux pieds, sortez à skis, vous êtes déjà sur les pistes ! Entre champs de poudreuse et pistes parfaitement damées, pas question de performances, du débutant au confirmé le domaine de Val Thorens offre du plaisir quel que soit le niveau des skieurs !
#   Terrain de jeu idéal pour tous les amoureux de la montagne, ce domaine permet d’admirer des points de vue exceptionnels, notamment le spectacle grandiose qu’offre le mythique Glacier de Péclet ou « la plus belle vue des Alpes », selon le guide vert Michelin depuis la Cime de Caron. Un panorama époustouflant à 360° sur plus de 1000 sommets des Alpes (françaises, suisses et italiennes).",
#   budget: "€€",
#   alt_min: 1800,
#   alt_max: 3230,
#   total_slopes: 78,
#   green_slopes: 11,
#   blue_slopes: 29,
#   red_slopes: 30,
#   black_slopes: 8,
#   insee: "73304",
#   cardphoto: "https://www.snow-forecast.com/system/images/35751/large/Val-Thorens.jpg?1619614010",
#   bannerphoto: "https://static.montagnettes.com/wp-content/uploads/2020/06/1600par900-couverture-val-thorens-v2-1600x900.jpg",
#   logo: "https://upload.wikimedia.org/wikipedia/fr/thumb/b/b3/Logo_Val_Thorens_-_2009.svg/2560px-Logo_Val_Thorens_-_2009.svg.png"
# )

# grand_bornand = Station.create!(
#   name: "Le Grand Bornand",
#   address: "74450 Le Grand-Bornand",
#   description: "Le Grand-Bornand a, de tout temps, opté pour un développement... en pente douce. Sans doute le lien particulier qu’entretiennent les Bornandins – acteurs pour l’essentiel de l’économie de leur village – vis-à-vis d’une montagne aimée pour ce qu’elle est, et pas ce qu’on en a trop souvent fait, explique-t-il l’exception bornandine ; cette capacité à proposer, dans l’écrin préservé d’un authentique village de montagne, une offre touristique qui fait du bien au corps et à l’esprit soutenue par le souci de bien-vivre ensemble.
#   Entre lacs d’Annecy et Léman, Suisse et mont Blanc, au coeur de la Haute-Savoie et du territoire Annecy Mountains, Le Grand-Bornand est d’abord un village vivant à l’année, et il en cumule les atouts : plaisir d’être ensemble et temps retrouvé, mais aussi terre de loisirs et de découvertes illimitées. En témoigne la visite des jolies adresses qui irriguent les ruelles secrètes du village : ateliers d’artistes, boutiques et chalets cosy… Plus que jamais, Le Grand-Bornand invite à se retrouver autour de bonheurs simples et d’expériences à vivre ensemble et partager toute l’année, au rythme du temps (re)trouvé.",
#   budget: "€€",
#   alt_min: 1000,
#   alt_max: 2100,
#   total_slopes: 42,
#   green_slopes: 12,
#   blue_slopes: 14,
#   red_slopes: 13,
#   black_slopes: 3,
#   insee: "74136",
#   cardphoto: "https://www.savoie-haute-savoie-nordic.com/wp-content/uploads/2020/04/Le-grand-bornand.jpg",
#   bannerphoto: "https://www.barnes-montblanc.com/uploads/sectors/36/hero_pictures/53984/show.jpg?1573573424",
#   logo: "https://upload.wikimedia.org/wikipedia/fr/thumb/4/4c/Le_grand_bornand_%28logo%29.svg/1024px-Le_grand_bornand_%28logo%29.svg.png"
# )

# les_gets = Station.create!(
#   name: "Les Gets",
#   address: "61 route du Front de Neige 74260 LES GETS",
#   description: "Entre lac Léman et Mont Blanc, à 1 heure de l’aéroport de Genève, Les Gets est partie intégrante du territoire franco-suisse des Portes du Soleil, l’un des plus grands domaines skiables et VTT d’Europe. Sa situation sur un col est idéale pour un ensoleillement exceptionnel en toute saison.
#   En accès direct depuis la station, Les Portes du Soleil s’affichent tout simplement comme l’un des plus grands domaines skiables au monde ! Les Gets vous invite ainsi à un véritable safari pour jouer à « saute-frontières » entre la France et la Suisse sur quelques 650 km, 286 pistes et 196 remontées mécaniques. Un terrain de jeu illimité pour les appétits XXL !
#   Pour des envies de glisse plus locales, le domaine Les Gets-Morzine (71 pistes et 47 remontées mécaniques) se veut idéal.  Situés de part et d’autre de la station, les deux versants Chavannes (pour accéder à Morzine) et Mont-Chéry, offrent aux skieurs, débutants comme confirmés, une large palette technique et diversifiée pour se régaler tout au long de la journée entre sapins et alpages.
#   Sans oublier les zones ludiques pour les enfants et un front de neige au cœur de la station, d’où l’on part skis aux pieds.",
#   budget: "€€",
#   alt_min: 1000,
#   alt_max: 2466,
#   total_slopes: 112,
#   green_slopes: 4,
#   blue_slopes: 51,
#   red_slopes: 42,
#   black_slopes: 15,
#   insee: "74134",
#   cardphoto: "https://www.skieur.com/media/guide_station/img/les_gets1%C2%A9v_ducrettet_ot_les_gets.jpg",
#   bannerphoto: "https://hunterchalets.com/wp-content/uploads/2020/05/Copyright-JM.Baud_OTLesGets-1024x578.jpg",
#   logo: "https://www.lesgets.com/app/uploads/2020/02/logo-gets-bleu.png"
# )

puts "#{Station.count} stations has been created"
puts "#{Condition.count} conditions has been created"
