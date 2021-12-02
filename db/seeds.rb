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
  URI.open("https://api.meteo-concept.com/api/forecast/daily/#{date}/period/2?token=f9e68c52be15a27603ac5ee02abf853316482e6d2ac1c111f58ed481816938b8&insee=#{station.insee}") do |stream|
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

def new_condition(station)
  (0..7).each do |date|
    real_date = Time.zone.now + date.day
    p real_date
    Condition.create!(
      station: station,
      date_on: real_date,
      weather: weather(date, station),
      frost_prob: frost(date, station),
      fog_prob: fog(date, station),
      snow: snow(station)
    )
  end
end

villard_de_lans = Station.create!(
  name: 'Villard de Lans',
  address: '62 Pl. Pierre Chabert, 38250 Villard-de-Lans',
  description: "Située à moins de 30 minutes de route de Grenoble, sur le plateau du Vercors, la station de ski de Villard de Lans s’articule autour de son bourg (4000 habitants) animé en toute saison, de nombreux petits hameaux environnants (les Clots, l'Essarton, les Chaberts...) et de deux pôles d’hébergements implantés en pied de pistes : Le Balcon de Villard et Les Glovettes. C’est de là que skieurs et snowboardeurs empruntent les télécabines de Côte 2000 et du Pré des Preys pour rejoindre les pistes de ski de l’Espace Villard-Corrençon (domaine commun entre les deux stations voisines que sont Villard de Lans et Corrençon en Vercors).",
  budget: "3",
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
  bannerphoto: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTS5vZhMyuth_mGtyMLrBsLbzQxZToXEkYF9g&usqp=CAU",
  lat: "45.046258",
  long: "5.557192",
  logo: "https://cdn-s-www.ledauphine.com/images/3B8C29C7-F38B-4A54-B500-7A6C21977D93/NW_raw/le-nouveau-logo-des-deux-stations-photo-le-dl-noel-coolen-1633098536.jpg",
  snowurl: "les-glovettes#belvedere",
  webcamurl:"1462285756",
  planurl: "https://www.esf-villard-de-lans.net/phototheque/800x400/plan%20pistes%20alpin.jpg"
)

les_arcs = Station.create!(
  name: "Les Arcs",
  address: "73700 Bourg-Saint-Maurice",
  description: "Les Arcs est une station de sports d'hiver et un nom de domaine skiable de la vallée de la Tarentaise, situés sur le territoire communal des communes de Bourg-Saint-Maurice, Landry, Peisey-Nancroix, et de Villaroger, dans le département de la Savoie en région Auvergne-Rhône-Alpes. Les stations-villages des Arcs — Arc 1600, Arc 1800, Arc 2000 — sont des stations intégrées, dites de « troisième génération », voire de « quatrième génération » pour Arc 1950, installées sur la commune de Bourg-Saint-Maurice et édifiée à partir de la fin des années 1960. La dernière a été construite en 2003.",
  budget: "4",
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
  snowurl: "arc-1950",
  webcamurl:"1454327366",
  planurl: "https://vcdn.bergfex.at/images/resized/4b/2370568a8e60fa4b_a5e8db6f64f0c493@2x.jpg"
)

serre_che = Station.create!(
  name: "Serre Chevalier",
  address: "Le, Rte de Pré-Long, 05240 La Salle-les-Alpes",
  description: "Située à proximité du Parc national des Ecrins, Serre Chevalier Vallée est le regroupement de la ville de Briançon (ville inscrite au patrimoine mondial de l'UNESCO) et de 3 villages : Saint-Chaffrey/Chantemerle, Villeneuve/La Salle les Alpes et le Monêtier les Bains.
  Avec 250 km de pistes, Serre Chevalier Vallée est le 1er domaine non relié français. Des pistes adaptées pour toutes les glisses, du ski en vallon ou en forêt de mélèzes, des ambiances haute montagne avec des hors pistes de renom, confèrent à cette station un caractère sportif et ludique.",
  budget: "4",
  alt_min: 1200,
  alt_max: 2830,
  green_slopes: 13,
  green_open_slopes: 11,
  blue_slopes: 26,
  blue_open_slopes: 23,
  red_slopes: 29,
  red_open_slopes: 28,
  black_slopes: 13,
  black_open_slopes: 7,
  insee: "05161",
  cardphoto: "https://www.yonder.fr/sites/default/files/destinations/serre%20chevalier%20figure%20snow%20Serre%20Chevalier%20Vall%C3%A9e%20Brian%C3%A7on%20-%20%40laurapeythieu.jpg",
  bannerphoto: "https://www.terresens.com/wp-content/uploads/2018/03/Thibaut_Blais2.jpg",
  lat: "44.946249",
  long: "6.558491",
  logo: "https://www.e-briancon.com/wp-content/uploads/2017/08/logo-serre-chevalier.jpg",
  snowurl: "le-monetier-les-bains#pic-de-l-yret",
  webcamurl:"1480515718",
  planurl: "https://ublo-file-manager.valraiso.net/assets/esfserrechechantemerle/1200_700/plan-pistes-serreche.jpg"
)

autrans = Station.create!(
  name: "Domaine alpin Autrans",
  address: "D218, 38880 Autrans",
  description: "Située en Isère (région Auvergne-Rhône-Alpes), dans le secteur septentrional du massif du Vercors, localement appelé « Les Quatre-Montagnes » ou encore « Le Val d’Autrans - Méaudre», à proximité de Grenoble (40 km), de Valence et de Lyon, la station-village d’Autrans - Méaudre en Vercors attire les familles et les débutants de par son domaine skiable au relief doux et son architecture montagnarde.",
  budget: "1",
  alt_min: 1050,
  alt_max: 1650,
  green_slopes: 5,
  green_open_slopes: 4,
  blue_slopes: 4,
  blue_open_slopes: 4,
  red_slopes: 4,
  red_open_slopes: 3,
  black_slopes: 2,
  black_open_slopes: 2,
  insee: "38225",
  cardphoto: "https://autrans-meaudre.com/wp-content/uploads/2014/10/autrans-meaudre_najo-grez-11_1500.jpg",
  bannerphoto: "https://vcdn.bergfex.at/images/resized/f3/925905e55a0a66f3_868f96f4c582a335@2x.jpg",
  lat: "45.229519",
  long: "5.581669",
  logo: "https://www.agopop.fr/wp-content/uploads/2021/02/logo-AUTRANS-MEAUDRE-verti-Rg.png",
  snowurl: "autrans-la-sure",
  webcamurl:"1290174408",
  planurl: "https://zupimages.net/up/21/48/6esj.jpeg"
)

valloire = Station.create!(
  name: "Valloire",
  address: "73450 Valloire",
  description: "Au pied des célèbres Col du Galibier et du Télégraphe, la station de ski de Valloire vous accueille pour vivre des moments plus forts sur les 160 km de pistes du domaine skiable Galibier Thabor.
  Hôtels, appartements, chalets, gîtes... au pied des pistes, dans un environnement calme et plein de charme, Valloire met à votre disposition des hébergements variés et de qualité. Des solutions locatives pour tous les goûts et toutes les bourses !",
  budget: "3",
  alt_min: 1430,
  alt_max: 2600,
  green_slopes: 17,
  green_open_slopes: 15,
  blue_slopes: 30,
  blue_open_slopes: 26,
  red_slopes: 34,
  red_open_slopes: 23,
  black_slopes: 8,
  black_open_slopes: 4,
  insee: "73306",
  cardphoto: "https://cdn.snowplaza.com/images/ski-area/w_1024,h_768/valloire_214168.webp",
  bannerphoto: "https://www.grand-hotel-valloire.com/cache/e/2/3/8/d/e238d87250be931c61ad71bf60a6b895f7686260.jpeg",
  lat: "45.163904",
  long: "6.425500",
  logo: "https://upload.wikimedia.org/wikipedia/commons/8/80/Valloire-logo.jpg",
  snowurl: "valloire",
  webcamurl:"1584650720",
  planurl: "https://www.valloire.com/medias/images/prestataires/plan-pistes-371.jpg"
)

la_plagne = Station.create!(
  name: "La Plagne",
  address: "73210 La Plagne",
  description: "La Plagne est une station familiale de sports d’hiver et d’été, située en Savoie et implantée entre 1250 et 3250 mètres d'altitude. Depuis plus de 50 ans, la destination a acquis une renommée internationale grâce à son vaste domaine skiable tous niveaux de 225 kilomètres de pistes. Depuis 2003, la Plagne elle est une station composante de Paradiski (le domaine skiable qui la relie avec les stations voisines des Arcs et Peisey-Vallandry).",
  budget: "3",
  alt_min: 1250,
  alt_max: 3250,
  green_slopes: 9,
  green_open_slopes: 9,
  blue_slopes: 72,
  blue_open_slopes: 67,
  red_slopes: 34,
  red_open_slopes: 25,
  black_slopes: 19,
  black_open_slopes: 11,
  insee: "73150",
  cardphoto: "https://fr.ski-france.com/media/cache/gallery_default/20875.jpg",
  bannerphoto: "https://www.la-plagne.com/sites/default/files/styles/slide_1920x1080/public/medias/images/DESTI_Aime-2000_batiment-vue_O-Allamand.jpg?h=5ca329e5&itok=hSJxWlYa",
  lat: "45.507937",
  long: "6.677156",
  logo: "https://go.la-plagne.com/logos/BellePlagne.png",
  snowurl: "plagne-centre",
  webcamurl:"1350036198",
  planurl: "https://www.esf-belleplagne.com/phototheque/800x400/Plan%20pistes%20BP.png"
)

val_isere = Station.create!(
  name: "Val d'Isère",
  address: "73150 Val d'Isère",
  description: "Val d'Isère - La station Implantée en fond de la Vallée de la Tarentaise (en Savoie), à quelques encablures seulement de sa voisine Tignes, la station de ski de Val d'Isère est aujourd’hui considérée comme l'une des meilleures destinations ski en France.
  Val d’Isère doit avant tout sa notoriété à son panel de services de standing accessibles à tous. Élégance, qualité, bien-être y sont les mots d'ordre et attirent chaque hiver des skieurs venus de tous horizons pour profiter d’un domaine d’exception.",
  budget: "5",
  alt_min: 1850,
  alt_max: 3456,
  green_slopes: 31,
  green_open_slopes: 28,
  blue_slopes: 15,
  blue_open_slopes: 14,
  red_slopes: 20,
  red_open_slopes: 14,
  black_slopes: 12,
  black_open_slopes: 5,
  insee: "73304",
  cardphoto: "https://www.lalibre.be/resizer/j6SK9ie6w5dPZ5tgUvrZQvR_cdw=/768x512/filters:quality(70):format(jpg):focal(1353.5x684:1363.5x674)/cloudfront-eu-central-1.images.arcpublishing.com/ipmgroup/YIBHARBL3ZGATIDFVBPP5ZLCKQ.jpg",
  bannerphoto: "https://phototheque.mon-sejour-en-montagne.com/images/msem/1400_700/val-d-isere-photo2.jpg",
  lat:"45.450262",
  long:"6.977531",
  logo: "https://upload.wikimedia.org/wikipedia/commons/9/9d/Logo_val_d%27isere.png",
  snowurl: "val-disere#bellevarde",
  webcamurl:"1581970567",
  planurl: "https://ublo-file-manager.valraiso.net/assets/esftignesvalclaret/880x400/plan-des-pistes-2016-17-900x450-2017-18.jpg"
)

tignes = Station.create!(
  name: "Tignes",
  address: "73320 Tignes",
  description: "Décalée, cosmopolite, sportive et innovante, Tignes vous offre l'expérience unique de vivre la montagne autrement. Pour les amateurs de sports d‘hiver, Tignes est avant tout une station de ski de renommée internationale qui propose de septembre à mai la meilleure neige et une offre de pistes très diverse.
  Le domaine skiable Tignes/Val d'Isère (anciennement dénommé Espace Killy) se compose de 300 km de pistes de difficultés variables qui s'étendent entre 1 550 m et 3 450 m d'altitude.",
  budget: "5",
  alt_min: 1550,
  alt_max: 3456,
  green_slopes: 6,
  green_open_slopes: 5,
  blue_slopes: 38,
  blue_open_slopes: 36,
  red_slopes: 20,
  red_open_slopes: 14,
  black_slopes: 16,
  black_open_slopes: 11,
  insee: "73296",
  cardphoto: "https://media.istockphoto.com/photos/tignes-alps-france-picture-id465967736?k=20&m=465967736&s=612x612&w=0&h=ctM2KRhmigcfVqZC1k4EHZVirbXG_sQJw3cwVBL832I=",
  bannerphoto: "https://phototheque.mon-sejour-en-montagne.com/images/msem/1400_700/tignes-le-lac-photo2-1.jpg",
  lat:"45.468640",
  long:"6.907050",
  logo: "https://upload.wikimedia.org/wikipedia/fr/thumb/c/ce/Logo_Tignes.svg/1200px-Logo_Tignes.svg.png",
  snowurl: "tignes-le-lac#aiguille-percee",
  webcamurl:"1582055006",
  planurl: "https://ublo-file-manager.valraiso.net/assets/esftignesvalclaret/880x400/plan-des-pistes-2016-17-900x450-2017-18.jpg"
)

courchevel = Station.create!(
  name: "Courchevel",
  address: "73120 Courchevel",
  description: "Courchevel est une station de sports d'hiver de la vallée de la Tarentaise située dans la commune de Courchevel (jusqu'en 2016, la commune de Saint-Bon-Tarentaise), dans le département de la Savoie en région Auvergne-Rhône-Alpes. Première station française aménagée en site vierge en 1946, elle fait partie du domaine skiable des Trois-Vallées.",
  budget: "5",
  alt_min: 1300,
  alt_max: 2738,
  green_slopes: 27,
  green_open_slopes: 26,
  blue_slopes: 44,
  blue_open_slopes: 40,
  red_slopes: 38,
  red_open_slopes: 31,
  black_slopes: 10,
  black_open_slopes: 5,
  insee: "73227",
  cardphoto: "https://cdn.france-montagnes.com/sites/default/files/styles/station_slideshow_large/public/station/hiver/DavidAndre-domaineskiable-BD.jpg?itok=9S5OGQHR",
  bannerphoto: "https://www.les3vallees.com/media/cache/hero_default/hiver-paysage-discover-village-courchevel-1920x1080-davidandre-091.jpg",
  lat:"45.432828",
  long:"6.621404",
  logo: "https://www.courchevel.com/images/logo_couchevel_footer.png",
  snowurl: "courchevel-1850",
  webcamurl:"1505220061",
  planurl: "https://zupimages.net/up/21/48/r3dj.jpeg"
)

la_clusaz = Station.create!(
  name: "La Clusaz",
  address: "74220 La Clusaz",
  description: "Connue et reconnue comme une des destinations alpines de référence depuis des décennies et terre de contraste alliant grands espaces et chalets modernes, ressourcement et activités, la Clusaz se découvre de multiples façons.
  - Village de montagne, elle a une histoire.
  - Entourée d’une nature riche et abondante, elle est un terrain de jeu infini.
  - Préservée par ses autochtones, elle est fière d’accueillir les voyageurs venus se dépasser, se retrouver ou se ressourcer...",
  budget: "3",
  alt_min: 1040,
  alt_max: 2477,
  green_slopes: 16,
  green_open_slopes: 14,
  blue_slopes: 31,
  blue_open_slopes: 23,
  red_slopes: 30,
  red_open_slopes: 26,
  black_slopes: 8,
  black_open_slopes: 3,
  insee: "74080",
  cardphoto: "https://www.hautesavoiephotos.com/villages/la_clusaz_img1651.jpg",
  bannerphoto: "https://www.mksport-mag.com/media/cache/place_detail_main_picture/2019/01/9357-village-c-pascal-lebeau.jpg",
  lat:"45.904149",
  long:"6.425063",
  logo: "https://www.laclusaz.com/download?t=page&id=768&ext=.png",
  snowurl: "la-clusaz",
  webcamurl: "1611904694",
  planurl: "https://www.laclusaz.com/medias/images/info_pages/multitailles/1200x900_plan-domaine-alpin-la-clusaz-1033.jpg"
)

avoriaz = Station.create!(
  name: "Avoriaz",
  address: "74110 Morzine",
  description: "La station de ski d'Avoriaz est située au cœur du domaine des Portes du Soleil, sur un plateau exposé plein sud. Née d'un défi écologique avant l'âge, Avoriaz est une station entièrement piétonne, interdite aux voitures, où tous les hébergements sont accessibles à ski et où les rues sont des pistes de ski.
  D'une vallée à l'autre, les accros de la glisse trouvent à Avoriaz des itinéraires 100% naturels, ludiques et sécurisés entre France et Suisse. Ainsi, à Avoriaz, on peut skier tout une semaine sans emprunter deux fois le même tracé, quel que soit son niveau, sur un domaine agréable et apprivoisé.",
  budget: "5",
  alt_min: 1700,
  alt_max: 2466,
  green_slopes: 7,
  green_open_slopes: 7,
  blue_slopes: 25,
  blue_open_slopes: 24,
  red_slopes: 13,
  red_open_slopes: 10,
  black_slopes: 5,
  black_open_slopes: 2,
  insee: "74191",
  cardphoto: "https://cdn-elle.ladmedia.fr/var/plain_site/storage/images/loisirs/evasion/avoriaz-3-raisons-de-loger-au-belambra-les-cimes-du-soleil-3760142/90012656-1-fre-FR/Avoriaz-3-raisons-de-loger-au-Belambra-Les-Cimes-du-soleil.jpg",
  bannerphoto: "https://media-exp1.licdn.com/dms/image/C561BAQF9xAIxCZlhbw/company-background_10000/0/1630412833345?e=2159024400&v=beta&t=oXCeeOVzz2h1WZrL0GboRlnACc8FqlOMN9u8RnWxo20",
  lat:"46.193869",
  long:"6.770071",
  logo: "https://www.mbh.fr/wp-content/uploads/2019/10/logo-avoriaz.png",
  snowurl: "avoriaz",
  webcamurl:" 1558388745",
  planurl: "https://zupimages.net/up/21/48/0wdg.jpeg"
)

megeve = Station.create!(
  name: "Megève",
  address: "74120 Megève",
  description: "A deux heures de Lyon vous attend le plus authentique village de montagne des Alpes. Le ski à Megève ce sont 445 kilomètres de pistes dans un décor exceptionnel mais pas seulement : gastronomie, événements, détente et shopping dans le paradis de l’après ski niché au cœur du Pays du Mont Blanc. Venez vivre l’expérience du ski dans un domaine sans pareil qui marie pistes, forêt, fermes d’alpage et terrasses  ensoleillées sur plusieurs massifs.  Un domaine skiable adapté aux familles qui trouveront à Megève des pentes douces et rassurantes pour se faire plaisir avec les enfants.",
  budget: "4",
  alt_min: 1113,
  alt_max: 2353,
  green_slopes: 43,
  green_open_slopes: 42,
  blue_slopes: 63,
  blue_open_slopes: 57,
  red_slopes: 83,
  red_open_slopes: 70,
  black_slopes: 33,
  black_open_slopes: 21,
  insee: "74173",
  cardphoto: "http://media.sit.savoie-mont-blanc.com/620x425/55979/9-10955800.jpeg",
  bannerphoto: "https://skipass.fr/p/resorts/687/default-megeve-7767f-1.jpg",
  lat:"45.858096",
  long:"6.616235",
  logo: "https://mairie.megeve.fr/wp-content/uploads/2018/03/logo-bonne-qualit%C3%A9-650x288.jpg",
  snowurl: "megeve",
  webcamurl:"1583830168",
  planurl: "https://m.ski-planet.com/photo/megeve/pistes.jpg",
)

deux_alpes = Station.create!(
  name: "Les 2 Alpes",
  address: "38860 Les Deux Alpes",
  description: "Station de ski phare du département de l'Isère, les 2 Alpes jouie d'une réputation internationale grâce à son domaine d'altitude (le plus haut domaine skiable de France) depuis 3600 mètres d’altitude. Le glacier est l'assurance de skier sur une neige naturelle en toute saison. Le domaine vertical permet d’enchainer un dénivelé de 2300m entre 3600m et 1300m (dont 10km sur une piste bleue entre 3600m et 1600m).",
  budget: "4",
  alt_min: 1300,
  alt_max: 3600,
  green_slopes: 19,
  green_open_slopes: 16,
  blue_slopes: 42,
  blue_open_slopes: 41,
  red_slopes: 21,
  red_open_slopes: 15,
  black_slopes: 11,
  black_open_slopes: 6,
  insee: "38253",
  cardphoto: "https://upload.wikimedia.org/wikipedia/commons/thumb/8/8c/Les2Alpes.jpg/1200px-Les2Alpes.jpg",
  bannerphoto: "https://woody.cloudly.space/app/uploads/les-deux-alpes/2020/11/thumbs/267-les-2-alpes-automne-hiver-1-1920x960.jpg",
  lat:"45.009607",
  long:"6.123940",
  logo: "https://www.ski-planet.com/photo/les-2-alpes/logo-les-2-alpes.jpg",
  snowurl: "les-2-alpes",
  webcamurl:"1385511010",
  planurl: "https://vcdn.bergfex.at/images/resized/08/2c7f2624b9d8b408_a8a73e0a04579e5d@2x.jpg"
)

chamonix = Station.create!(
  name: "Chamonix",
  address: "74400 Chamonix",
  description: "Station de ski estampillée 'Mont-Blanc Natural Resort', Chamonix-Mont-Blanc est une destination mythique ! Ici tout participe à la légende. Levez les yeux ! Vous êtes au centre du mythe, au pied du Mont Blanc, à portée du bonheur absolu.
  Nul besoin d'être un champion pour prendre place dans la légende, entre le ski plaisir et la glisse extrême, à Chamonix, vous profiterez d'activités plus citadines ou plus festives d'un centre-ville animé jour et nuit.",
  budget: "4",
  alt_min: 1035,
  alt_max: 3275,
  green_slopes: 16,
  green_open_slopes: 15,
  blue_slopes: 31,
  blue_open_slopes: 28,
  red_slopes: 21,
  red_open_slopes: 14,
  black_slopes: 11,
  black_open_slopes: 5,
  insee: "74056",
  cardphoto: "https://images.lpcdn.ca/924x615/201512/04/1099568-chamonix-love-creux-sommets-parmi.jpg",
  bannerphoto: "https://www.skiloc-chamonix.fr/wp-content/uploads/2018/01/station-de-ski-chamonix-flegere.png",
  lat:"45.919218",
  long:"6.865332",
  logo: "https://www.mbh.fr/wp-content/uploads/2020/03/alt-logo-chamonix.png",
  snowurl: "chamonix",
  webcamurl:"1385510422",
  planurl: "https://zupimages.net/up/21/48/huz8.jpeg"
)

les_saisies = Station.create!(
  name: "Les Saisies",
  address: "73620 Hauteluce",
  description: "La convivialité d’une station familiale à taille humaine qui a su conserver, au fil de son évolution, une architecture traditionnelle & harmonieuse au sein d’une nature préservée.
  Le grenier à neige de la Savoie : des conditions d’enneigement exceptionnelles à 1650 m d’altitude qui permettent une ouverture des domaines de décembre à fin avril. Une complémentarité entre domaine alpin et domaine nordique : choisissez d’arpenter l’Espace Diamant qui compte 192 km de pistes de tous niveaux entre Beaufortain et Val d’Arly ou de découvrir les 120 km d’itinéraires nordiques. Si vous n’aimez pas choisir, faites les deux !",
  budget: "3",
  alt_min: 1180,
  alt_max: 2050,
  green_slopes: 34,
  green_open_slopes: 32,
  blue_slopes: 59,
  blue_open_slopes: 51,
  red_slopes: 47,
  red_open_slopes: 33,
  black_slopes: 11,
  black_open_slopes: 6,
  insee: "73132",
  cardphoto: "https://cdn.france-montagnes.com/sites/default/files/styles/station_slideshow_large/public/station/hiver/station2.jpg?itok=knuLXOmW",
  bannerphoto: "https://www.moka-mag.com/media/cache/place_detail_main_picture/2018/11/2793-les-saisies.jpg",
  lat:"45.757149",
  long:"6.539512",
  logo: "https://cheque-vacances-connect.com/collaborateur/wp-content/uploads/2021/06/lessaisies.jpg",
  snowurl: "les-saisies",
  webcamurl:"1462285077",
  planurl: "https://www.sports-hiver.com/img/resort_media/planpistes/STATANMSM01730031/2416.jpg"
)

sept_laux = Station.create!(
  name: "Les 7 Laux",
  address: "38190 Les Adrets",
  description: "Située au coeur du massif de Belledonne (en Isère), la station de ski des 7 Laux, se décompose en 3 sites:
  -A l'est, Le Pleynet (1450 m), site pleine montagne, domine la vallée du Haut Bréda face aux cimes ciselées de la Belle Etoile et des Cabottes.
  -A l'ouest, Prapoutel (1350 m), site urbain avec tous ses commerces (cinéma, discothèque...),
  - et Pipay (1550 m), site nature, surplombent la vallée du Grésivaudan.",
  budget: "2",
  alt_min: 1350,
  alt_max: 2400,
  green_slopes: 10,
  green_open_slopes: 9,
  blue_slopes: 10,
  blue_open_slopes: 10,
  red_slopes: 18,
  red_open_slopes: 15,
  black_slopes: 14,
  black_open_slopes: 8,
  insee: "38002",
  cardphoto: "https://d3u9sm4kpb9d1j.cloudfront.net/pictures/1454197",
  bannerphoto: "https://woody.cloudly.space/app/uploads/les-sept-laux/2019/09/thumbs/dji-0328-1920x960.jpg",
  lat:"45.256498",
  long:"5.992611",
  logo: "https://upload.wikimedia.org/wikipedia/fr/thumb/a/a9/Logo_Les_7_Laux.svg/1280px-Logo_Les_7_Laux.svg.png",
  snowurl: "prapoutel",
  webcamurl:"1430822829",
  planurl: "https://www.sports-hiver.com/img/resort_media/planpistes/STATANMSM01380020/4400.jpg"
)

chamrousse = Station.create!(
  name: "Chamrousse",
  address: "38410 Chamrousse ",
  description: "La station de Chamrousse se trouve à la pointe du massif de Belledonne, à seulement 30 kilomètres de Grenoble. Elle s’étend sur trois niveaux : Chamrousse 1650 - Recoin, Chamrousse 1700 - Bachat Bouloud et Chamrousse 1750 - Roche Béranger reliés par les pistes et les sentiers forestiers, avec pour point culminant, la Croix de Chamrousse à 2250 mètres d’altitude.",
  budget: "2",
  alt_min: 1650,
  alt_max: 2250,
  green_slopes: 8,
  green_open_slopes: 8,
  blue_slopes: 15,
  blue_open_slopes: 14,
  red_slopes: 15,
  red_open_slopes: 12,
  black_slopes: 6,
  black_open_slopes: 3,
  insee: "38567",
  cardphoto: "https://cdn.france-montagnes.com/sites/default/files/styles/station_slideshow_large/public/station/hiver/OTChamrousse-Roche-Beranger-Aeolus--9-.jpg?itok=rJVv0dSC",
  bannerphoto: "https://www.transaltitude.fr/media/filer_public_thumbnails/filer_public/11/5d/115debc2-6811-4654-8097-b8824085bccc/chamrousse_vue_avion_images-et-reves_1hd_rec.jpg__1920x350_q85_crop_subsampling-2.jpg",
  lat:"45.125045",
  long:"5.876118",
  logo: "https://www.chamrousse.com/medias/images/info_pages/logo-chamrousse-noir-fond-transparent-png-2968.png",
  snowurl: "chamrousse-1700-bachat-bouloud",
  webcamurl:"1347033121",
  planurl: "https://zupimages.net/up/21/48/cm88.jpeg"
)

val_thorens = Station.create!(
  name: "Val Thorens",
  address: "73440 Val Thorens",
  description: "Val Thorens, plus haute station d’Europe et point culminant du domaine des 3 Vallées, est le plus grand domaine skiable du monde avec plus de 600 km de pistes.
  Situé au cœur d’un vaste cirque naturel dominé par ses 6 glaciers, la station de ski de Val Thorens offre une multitude d’itinéraires pour skier au soleil toute la journée.",
  budget: "5",
  alt_min: 1800,
  alt_max: 3230,
  green_slopes: 11,
  green_open_slopes: 11,
  blue_slopes: 29,
  blue_open_slopes: 28,
  red_slopes: 30,
  red_open_slopes: 24,
  black_slopes: 8,
  black_open_slopes: 6,
  insee: "73304",
  cardphoto: "https://www.snow-forecast.com/system/images/35751/large/Val-Thorens.jpg?1619614010",
  bannerphoto: "https://static.montagnettes.com/wp-content/uploads/2020/06/1600par900-couverture-val-thorens-v2-1600x900.jpg",
  lat:"45.298975",
  long:"6.576871",
  logo: "https://upload.wikimedia.org/wikipedia/fr/thumb/b/b3/Logo_Val_Thorens_-_2009.svg/2560px-Logo_Val_Thorens_-_2009.svg.png",
  snowurl: "val-thorens",
  webcamurl:"1583634468",
  planurl: "https://ublo-file-manager.valraiso.net/assets/esfvalthorens/800_400/skimap-val-thorens.jpg"
)

grand_bornand = Station.create!(
  name: "Le Grand Bornand",
  address: "74450 Le Grand-Bornand",
  description: "Le Grand-Bornand a, de tout temps, opté pour un développement... en pente douce. Sans doute le lien particulier qu’entretiennent les Bornandins – acteurs pour l’essentiel de l’économie de leur village – vis-à-vis d’une montagne aimée pour ce qu’elle est, et pas ce qu’on en a trop souvent fait, explique-t-il l’exception bornandine ; cette capacité à proposer, dans l’écrin préservé d’un authentique village de montagne, une offre touristique qui fait du bien au corps et à l’esprit soutenue par le souci de bien-vivre ensemble.",
  budget: "2",
  alt_min: 1000,
  alt_max: 2100,
  green_slopes: 12,
  green_open_slopes: 10,
  blue_slopes: 14,
  blue_open_slopes: 13,
  red_slopes: 13,
  red_open_slopes: 10,
  black_slopes: 3,
  black_open_slopes: 2,
  insee: "74136",
  cardphoto: "https://www.savoie-haute-savoie-nordic.com/wp-content/uploads/2020/04/Le-grand-bornand.jpg",
  bannerphoto: "https://www.barnes-montblanc.com/uploads/sectors/36/hero_pictures/53984/show.jpg?1573573424",
  lat:"45.943026",
  long:"6.429957",
  logo: "https://upload.wikimedia.org/wikipedia/fr/thumb/4/4c/Le_grand_bornand_%28logo%29.svg/1024px-Le_grand_bornand_%28logo%29.svg.png",
  snowurl: "le-grand-bornand",
  webcamurl:"1578916164",
  planurl: "https://www.legrandbornand.com/medias/images/info_pages/multitailles/1920x1440_plan-aravis-2019-2146.jpg"
)

les_gets = Station.create!(
  name: "Les Gets",
  address: "61 route du Front de Neige 74260 LES GETS",
  description: "Entre lac Léman et Mont Blanc, à 1 heure de l’aéroport de Genève, Les Gets est partie intégrante du territoire franco-suisse des Portes du Soleil, l’un des plus grands domaines skiables et VTT d’Europe. Sa situation sur un col est idéale pour un ensoleillement exceptionnel en toute saison.
  En accès direct depuis la station, Les Portes du Soleil s’affichent tout simplement comme l’un des plus grands domaines skiables au monde !",
  budget: "5",
  alt_min: 1000,
  alt_max: 2466,
  green_slopes: 4,
  green_open_slopes: 4,
  blue_slopes: 51,
  blue_open_slopes: 45,
  red_slopes: 42,
  red_open_slopes: 38,
  black_slopes: 15,
  black_open_slopes: 10,
  insee: "74134",
  cardphoto: "https://www.skieur.com/media/guide_station/img/les_gets1%C2%A9v_ducrettet_ot_les_gets.jpg",
  bannerphoto: "https://hunterchalets.com/wp-content/uploads/2020/05/Copyright-JM.Baud_OTLesGets-1024x578.jpg",
  lat:"46.159494",
  long:"6.669911",
  logo: "https://www.lesgets.com/app/uploads/2020/02/logo-gets-bleu.png",
  snowurl: "les-gets",
  webcamurl:"1583619096",
  planurl: "https://www.lesgets.com/app/uploads/2020/09/Plan-des-pistes-LGM-h20-21-sans-pub-HD-scaled.jpg"
)

Station.all.each do |station|
  new_condition(station)
end

puts "#{Station.count} stations has been created"
puts "#{Condition.count} conditions has been created"
