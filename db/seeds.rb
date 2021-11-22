# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
Station.destroy_all

villard_de_lans = Station.create!(
                        name: 'Villard de Lans',
                        address: '62 Pl. Pierre Chabert, 38250 Villard-de-Lans',
                        description: "Située à moins de 30 minutes de route de Grenoble, sur le plateau du Vercors, la station de ski de Villard de Lans s’articule autour de son bourg (4000 habitants) animé en toute saison, de nombreux petits hameaux environnants (les Clots, l'Essarton, les Chaberts...) et de deux pôles d’hébergements implantés en pied de pistes : Le Balcon de Villard et Les Glovettes. C’est de là que skieurs et snowboardeurs empruntent les télécabines de Côte 2000 et du Pré des Preys pour rejoindre les pistes de ski de l’Espace Villard-Corrençon (domaine commun entre les deux stations voisines que sont Villard de Lans et Corrençon en Vercors). Avec 125 kilomètres de pistes de ski alpin tracés entre les forêts de sapins (côté Villard de Lans) et de pins (côté Corrençon) sur près de 1000 mètres de dénivelé, il s’agit ni plus ni moins que du plus vaste domaine skiable du Vercors (le 3ème à l’échelle de l’ensemble du département de l’Isère).Et que dire du tout aussi vaste domaine de ski nordique du Haut Vercors, totalisant 110 kilomètres de pistes accessibles depuis Bois Barbu ou bien encore depuis la Porte des Hauts Plateaux ? De vastes étendues ouvertes avec vue sur la Moucherolle succèdent aux nombreux passages en forêt offrant ainsi un cadre et une ambiance « grand-nord Canadien ».",
                        budget: 2,
                        alt_min: 1650,
                        alt_max: 2500,
                        total_slopes: 53,
                        green_slopes: 15,
                        blue_slopes: 12,
                        red_slopes: 16,
                        black_slopes: 10
                        )
les_arcs = Station.create!(
                        name: "Les Arcs",
                        address: "73700 Bourg-Saint-Maurice",
                        description:"Les Arcs est une station de sports d'hiver et un nom de domaine skiable de la vallée de la Tarentaise, situés sur le territoire communal des communes de Bourg-Saint-Maurice, Landry, Peisey-Nancroix, et de Villaroger, dans le département de la Savoie en région Auvergne-Rhône-Alpes. Les stations-villages des Arcs — Arc 1600, Arc 1800, Arc 2000 — sont des stations intégrées, dites de « troisième génération », voire de « quatrième génération » pour Arc 1950, installées sur la commune de Bourg-Saint-Maurice et édifiée à partir de la fin des années 1960. La dernière a été construite en 2003. Le domaine skiable associe également les stations de Peisey-Vallandry, situées sur les communes de Landry et Peisey-Nancroix, et de Villaroger. Les domaines des Arcs et de Peisey-Vallandry sont reliés, depuis 2003, par le téléphérique du « Vanoise Express » à celui de Grande Plagne, formant ainsi l'un des plus grands domaines de ski français, Paradiski, avec plus de 425 km de pistes revendiquées.",
                        budget: 2,
                        alt_min: 1200,
                        alt_max: 3226,
                        total_slopes: 107,
                        green_slopes: 1,
                        blue_slopes: 54,
                        red_slopes: 34,
                        black_slopes: 18
                      )
serre_che = Station.create!(
                        name: "Serre Chevalier",
                        address: "Le, Rte de Pré-Long, 05240 La Salle-les-Alpes",
                        description: "Serre Chevalier, dans le Briançonnais, est une station de sports d'hiver située dans la vallée de la Guisane dans le département des Hautes-Alpes, près du parc national des Écrins. Elle est créée en 1941 avec l'édification du téléphérique depuis Chantemerle vers le sommet de Serre-Chevalier.",
                        budget: 2,
                        alt_min: 1200,
                        alt_max: 2830 ,
                        total_slopes: 81,
                        green_slopes: 13,
                        blue_slopes: 26,
                        red_slopes: 29,
                        black_slopes: 13
                      )
autrans = Station.create!(name: "Domaine alpin Autrans",
                        address:"D218, 38880 Autrans",
                        description:"Autrans-Méaudre en Vercors est une station village à la fois alpine et nordique… ici nous pratiquons toutes les glisses ! En ski alpin, la station est le site idéal pour débuter, progresser et profiter de la glisse en famille ou entre amis. Le domaine nordique rivalise avec les plus beaux sites Européens en ski de fond, randonnée nordique, chiens de traîneaux ou marche nordique sur neige. ",
                        budget:1,
                        alt_min:1050,
                        alt_max:1650,
                        total_slopes:15,
                        green_slopes:5,
                        blue_slopes:4,
                        red_slopes:4,
                        black_slopes:2
                      )


puts "#{Station.count} stations has been created"
