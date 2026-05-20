
<!-- README.md is generated from README.Rmd. Please edit that file -->

# Awesome RLadies+ Content and Packages

[![Awesome](https://awesome.re/badge.svg)](https://awesome.re)

Curated lists of RLadies+ community resources (blogs, YouTube channels,
and R packages currently). Each entry is stored as a JSON metadata file
in this repository; the site-friendly aggregated JSON files are
generated into the `data/website/` directory by the script
`scripts/generate_website_jsons.R`.

To contribute: add a JSON file describing the blog (to `data/content/`)
or the package (to `data/packages/`) following the examples in the
repository and the JSON schema at `scripts/json_schema/`.

See `CONTRIBUTING.md` for style and metadata conventions.

## List of blogs

Created from the JSON files in `data/content/` (one JSON per blog). The
aggregated file is written to `data/website/awesome_content.json`.

- [Amanda’s Data Blog](amanda.rbind.io) by Amanda Peterson
- [Very Statisticious](https://aosmith.rbind.io) by Ariel Muldoon
- [Alison Hill](https://www.apreshill.com) by Alison Hill
- [Beatriz Milz’s blog](https://beatrizmilz.com/) by Beatriz Milz
- [Notes from a data witch](https://blog.djnavarro.net/) by Danielle
  Navarro
- [Emma R](https://buzzrbeeline.blog/) by Emma Rand
- [Building Stories with Data](https://cararthompson.com/blog) by Cara
  Thompson
- [Crystal Lewis](https://www.cghlewis.com) by Crystal Lewis
- [Citizen Statistician](citizen-statistician.org) by Mine
  Çetinkaya-Rundel, Rob Gould, Andrew Zieffler
- [Cosima Meyer](https://cosimameyer.com/) by Cosima Meyer
- [Cynthia D’Angelo](https://cynthiadangelo.com/) by Cynthia D’Angelo
- [Darya Vanichkina’s blog](https://www.daryavanichkina.com/posts.html)
  by Darya Vanichkina
- [Data Pedagogy](https://www.datapedagogy.com/) by Mine Dogucu
- [Dr. Mowinckel’s blog](https://drmowinckels.io) by Athanasia Monika
  Mowinckel
- [Elena Dudukina’s blog](https://elenadudukina.com) by Elena Dudukina
- [Ella Kaye](https://ellakaye.co.uk) by Ella Kaye
- [Emily Riederer](https://emilyriederer.com) by Emily Riederer
- [Estatística \| Fernanda Kelly Romeiro
  Silva](https://www.fernandakellyrs.com/) by Fernanda Kelly Romeiro
  Silva
- [Federica Gazzelloni](https://fgazzelloni.quarto.pub) by Federica
  Gazzelloni
- [Site \| FLORENCIA GRATTAROLA](https://flograttarola.com/) by
  Florencia Grattarola
- [Florencia D’Andrea](https://florenciadandrea.com) by Florencia
  D’Andrea
- [helena \* jambor](https://helenajambor.wordpress.com/) by Helena
  Jambor
- [Hypebright](https://hypebright.nl/index.php/en/home-en/blog/) by
  Veerle van Leemput
- [Isabel Zimmerman](https://isabelizimm.github.io/) by Isabel Zimmerman
- [%\>% Dreams](https://ivelasq.rbind.io/) by Isabella Velásquez
- [data whiskeRs](https://jadeyryan.com/blog) by Jadey Ryan
- [Data in life](https://jhylin.github.io/Data_in_life_blog/) by
  Jennifer HY Lin
- [JRaviLab](https://jravilab.github.io/) by Janani Ravi
- [Julia Silge](https://juliasilge.com/) by Julia Silge
- [Karina Bartolome](https://karbartolome-blog.netlify.app) by Karina
  Bartolome
- [Once Upon a Time
  Series](https://lgibson7.quarto.pub/once-upon-a-time-series/) by Lydia
  Gibson
- [Lore Abad](https://loreabad6.github.io/) by Lorena Abad
- [Macarena Quiroga](https://macarenaquiroga.netlify.app) by Macarena
  Quiroga
- [Maëlle’s R blog](https://masalmon.eu/) by Maëlle Salmon
- [Nicola Rennie](https://nrennie.rbind.io) by Nicola Rennie
- [Pao Corrales](https://paocorrales.github.io/) by Pao Corrales
- [Piping Hot Data](https://www.pipinghotdata.com) by Shannon Pileggi
- [R-Ladies Gaborone](https://r-ladiesgaborone2021.quarto.pub) by
  R-Ladies Gabarone
- [R-Ladies Melbourne Blog](https://r-ladiesmelbourne.github.io/) by
  R-Ladies Melbourde
- [Rizqy Amelia Zein](https://rameliaz.github.io/) by Rizqy Amelia Zein
- [Riinu’s scripting diary](https://www.riinu.me/) by Riinu Pius
- [R-Ladies São Paulo Blog](https://rladies-sp.org/) by R-Ladies São
  Paulo
- [RLadies+ Global Blog](https://rladies.org/blog/) by RLadies+
- [Data Science
  Blog](https://sabrinaschalz.wordpress.com/data-science-blog/) by
  Sabrina Schalz
- [Sarah Gillespie’s blog](https://sarahgillespie.github.io/SG/) by
  Sarah Gillespie
- [Sam Tyner-Monroe](https://sctyner.me) by Sam Tyner-Monroe
- [Shel Kariuki’s blog](https://shelkariuki.netlify.app/) by Shel
  Kariuki
- [Meeting People Where They R](https://silviacanelon.com) by Silvia
  Canelón
- [Soy Andrea blog](https://soyandrea.netlify.app/) by Andrea Gómez
  Vargas
- [Ciencia de Datos en Español](https://sporella.xyz) by Steph Orellana
  Bello
- [Steffi LaZerte](https://steffilazerte.ca/tips_and_tricks.html) by
  Steffi LaZerte
- [Surrounded by Data](https://surroundedbydata.netlify.app/) by Veerle
  van Son
- [Exploration Corner](https://thetidytrekker.com/blog.html) by Meghan
  Harris
- [Willing Consulting](https://www.willingconsulting.com/) by Carol
  Willing
- [Yanina Bellini Saibene](https://yabellini.netlify.app/blog/) by
  Yanina Bellini Saibene
- [Melissa Van Bussel (ggnot2)’s YouTube channel about
  R](https://www.youtube.com/c/ggnot2) by Melissa Van Bussel

## List of packages

Created from the JSON files in `data/packages/` (one JSON per package).
The aggregated file is written to `data/website/awesome_packages.json`.

- [adjclust](https://github.com/pneuvial/adjclust) by Christophe
  Ambroise, Shubham Chaturvedi, Alia Dehman, Pierre Neuvial, Guillem
  Rigaill, Nathalie Vialaneix, Gabriel Hoffman
- [ADTSA]() by Hossein Hassani, Masoud Yarmohammadi, Mohammad Reza
  Yeganegi, Leila Marvian Mashhad
- [agroclimatico](https://github.com/ropensci/agroclimatico) by Yanina
  Bellini Saibene, Elio Campitelli, Paola Corrales, Natalia Gattinoni,
  Ruida Zhong, Verónica Cruz-Alonso, Priscilla Minotti
- [airports](https://github.com/OpenIntroStat/airports) by Mine
  Çetinkaya-Rundel
- [anicon](https://github.com/emitanaka/anicon) by Emi Tanaka
- [AnnotationHub](https://github.com/Bioconductor/AnnotationHub) by
  Bioconductor Package Maintainer, Martin Morgan, Marc Carlson, Dan
  Tenenbaum, Sonali Arora, Valerie Oberchain, Kayla Morrell, Lori
  Shepherd
- [aochelpers](https://github.com/EllaKaye/aochelpers) by Ella Kaye
- [aperol](https://github.com/EllaKaye/aperol) by Ella Kaye, Kelly
  Bodwin, Collin Schwantes
- [artpack](https://github.com/Meghansaha/artpack) by Meghan Harris
- [arttools](https://github.com/djnavarro/arttools) by Danielle Navarro
- [ARUtools](https://github.com/ARUtools/ARUtools) by David Hope, Steffi
  LaZerte, Government of Canada
- [asciify](https://github.com/djnavarro/asciify) by Danielle Navarro
- [ASICS]() by Gaëlle Lefort, Rémi Servien, Patrick Tardivel, Nathalie
  Vialaneix
- [auditor](https://github.com/ModelOriented/auditor) by Alicja
  Gosiewska, Przemyslaw Biecek, Hubert Baniecki, Tomasz Mikołajczyk,
  Michal Burdukiewicz, Szymon Maksymiuk
- [avilistr](https://github.com/dalyanalytics/avilistr) by Jasmine Daly,
  AviList Core Team
- [aws.s3](https://github.com/cloudyr/aws.s3) by Thomas J. Leeper,
  Boettiger Carl, Andrew Martin, Mark Thompson, Tyler Hunt, Steven
  Akins, Bao Nguyen, Thierry Onkelinx, Andrii Degtiarov, Dhruv Aggarwal,
  Alyssa Columbus, Simon Urbanek
- [bakeoff](https://github.com/apreshill/bakeoff) by Alison Hill,
  Chester Ismay, Richard Iannone
- [basepenguins](https://github.com/EllaKaye/basepenguins) by Ella Kaye,
  Heather Turner, Achim Zeileis
- [BayesCVI](https://github.com/o-preedasawakul/BayesCVI) by Nathakhun
  Wiroonsri, Onthada Preedasawakul
- [BayesERtools](https://genentech.github.io/BayesERtools/) by Kenta
  Yoshida, François Mercier, Danielle Navarro, Genentech, Inc.
- [bayesrules](https://github.com/bayes-rules/bayesrules/) by Mine
  Dogucu, Alicia Johnson, Miles Ott
- [bcaquiferdata](https://github.com/bcgov/bcaquiferdata) by Steffi
  LaZerte, Christine Bieber, Province of British Columbia
- [bcgwcat](https://github.com/bcgov/bcgwcat/) by Steffi LaZerte,
  Andarge Baye, Province of British Columbia
- [bcgwlreports](https://github.com/bcgov/bcgwlreports) by Steffi
  LaZerte, Jon Goetz
- [BiocFileCache](https://github.com/Bioconductor/BiocFileCache) by Lori
  Shepherd, Martin Morgan
- [biwt]() by Jo Hardin <jo.hardin@pomona.edu>, Jo Hardin
- [BLModel]() by Andrzej Palczewski, Jan Palczewski, Alicja Gosiewska
- [blogdown](https://github.com/rstudio/blogdown) by Yihui Xie,
  Christophe Dervieux, Alison Presmanes Hill, Amber Thomas, Beilei Bian,
  Brandon Greenwell, Brian Barkley, Deependra Dhakal, Eric Nantz, Forest
  Fang, Garrick Aden-Buie, Hiroaki Yutani, Ian Lyttle, Jake Barlow,
  James Balamuta, JJ Allaire, Jon Calder, Jozef Hajnala, Juan Manuel
  Vazquez, Kevin Ushey, Leonardo Collado-Torres, Maëlle Salmon, Maria
  Paula Caldas, Nicolas Roelandt, Oliver Madsen, Raniere Silva, TC
  Zhang, Xianying Tan, Posit Software, PBC
- [BlueCarbon]() by Valentina Costa, Márcio Martins
- [bootLong](https://github.com/PratheepaJ/bootLong) by Jeganathan
  Pratheepa, Holmes, Susan
- [BradleyTerry2](https://github.com/hturner/BradleyTerry2) by Heather
  Turner, David Firth
- [BradleyTerryScalable](https://github.com/EllaKaye/BradleyTerryScalable)
  by Ella Kaye, David Firth
- [bs4cards](https://github.com/djnavarro/bs4cards) by Danielle Navarro
- [bundle](https://github.com/rstudio/bundle) by Julia Silge, Simon
  Couch, Qiushi Yan, Max Kuhn, Posit Software, PBC
- [butcher](https://github.com/tidymodels/butcher) by Joyce Cahoon,
  Davis Vaughan, Max Kuhn, Alex Hayes, Julia Silge, Posit Software, PBC
- [canvasXpress](https://github.com/neuhausi/canvasXpress) by Isaac
  Neuhaus, Connie Brett
- [capesData]() by Leonardo Biazoli, Mine Çetinkaya-Rundel, Eric
  Fernandes de Mello Araujo, Izabela R. Cardoso de Oliveira
- [casteval](https://github.com/phac-nml-phrsd/casteval) by Daniel Yu,
  Irena Papst, David Champredon, Government of Canada
- [cellranger](https://github.com/rsheets/cellranger) by Jennifer Bryan,
  Hadley Wickham
- [censored](https://github.com/tidymodels/censored) by Emil Hvitfeldt,
  Hannah Frick, Posit Software, PBC
- [cereal](https://github.com/r-lib/cereal/) by Julia Silge, Davis
  Vaughan, Posit Software, PBC
- [changepoint](https://github.com/rkillick/changepoint/) by Rebecca
  Killick, Kaylea Haynes, Harjit Hullait, Idris Eckley, Paul Fearnhead,
  Robin Long, Jamie Lee
- [chartkickR](https://github.com/BWOlatunji/chartkickR) by Bilikisu
  Olatunji
- [cherryblossom](https://github.com/OpenIntroStat/cherryblossom) by
  Mine Çetinkaya-Rundel
- [clinPK](https://github.com/InsightRX/clinPK) by Ron Keizer, Jasmine
  Hughes, Dominic Tong, Kara Woo, InsightRX
- [codemeta](https://github.com/cboettig/codemeta) by Carl Boettiger,
  Maëlle Salmon, Katrin Leinweber, Noam Ross, Arfon Smith, Jeroen Ooms,
  Sebastian Meyer, Michael Rustler, Hauke Sonnenberg, Sebastian
  Kreutzer, rOpenSci
- [codemetar](https://github.com/ropensci/codemetar) by Carl Boettiger,
  Anna Krystalli, Toph Allen, Maëlle Salmon, rOpenSci, Katrin Leinweber,
  Noam Ross, Arfon Smith, Jeroen Ooms, Sebastian Meyer, Michael Rustler,
  Hauke Sonnenberg, Sebastian Kreutzer, Thierry Onkelinx
- [colorhex](https://github.com/drmowinckels/colorhex) by Athanasia Mo
  Mowinckel, Julia Romanowska
- [connectapi](https://github.com/posit-dev/connectapi) by Kara Woo,
  Toph Allen, Neal Richardson, Sean Lopp, Cole Arendt, Posit, PBC
- [coseq]() by Andrea Rau, Cathy Maugis-Rabusseau, Antoine
  Godichon-Baggioni
- [covid19france]() by Amanda Dobbyn
- [covid19tunisia](https://github.com/MounaBelaid/covid19tunisia) by
  Mouna Belaid
- [covid19us]() by Amanda Dobbyn
- [cowsay](https://github.com/sckott/cowsay) by Scott Chamberlain,
  Amanda Dobbyn, Tyler Rinker, Thomas Leeper, Noam Ross, Rich FitzJohn,
  Carson Sievert, Kiyoko Gotanda, Andy Teucher, Karl Broman,
  Franz-Sebastian Krah, Lucy D’Agostino McGowan, Guangchuang Yu, Philipp
  Boersch-Supan, Andreas Brandmaier, Marion Louveaux, David Schoch
- [cransays](https://github.com/r-hub/cransays) by Hugo Gruson, Maëlle
  Salmon, Locke Data, Stephanie Locke, Mitchell O’Hara-Wild, Lluís
  Revilla Sancho, Jim Hester, Hadley Wickham
- [cstime](https://github.com/csids/cstime) by Chi Zhang, Richard Aubrey
  White, CSIDS
- [cubble](https://github.com/huizezhang-sherry/cubble) by H. Sherry
  Zhang, Dianne Cook, Ursula Laa, Nicolas Langrené, Patricia Menéndez
- [cvAUC](https://github.com/ledell/cvAUC) by Erin LeDell, Maya
  Petersen, Mark van der Laan
- [CyTOFpower]() by Anne-Maud Ferreira, Catherine Blish, Susan Holmes
- [dada2](https://github.com/benjjneb/dada2) by Benjamin Callahan
  <benjamin.j.callahan@gmail.com>, Paul McMurdie, Susan Holmes
- [dados](https://github.com/cienciadedatos/dados) by Riva Quiroga, Sara
  Mortara, Beatriz Milz, Andrea Sánchez-Tapia, Alejandra Andrea Tapia
  Silva, Beatriz Maurer Costa, Jean Prado, Renata Hirota, William
  Amorim, Emmanuelle Rodrigues Nunes
- [DALEXtra](https://github.com/ModelOriented/DALEXtra) by Szymon
  Maksymiuk, Przemyslaw Biecek, Hubert Baniecki, Anna Kozak
- [datalegreyar](https://github.com/emitanaka/datalegreyar) by Emi
  Tanaka
- [dataMaid](https://github.com/ekstroem/dataMaid) by Anne Helby
  Petersen, Claus Thorn Ekstrøm
- [datasauRus](https://github.com/jumpingrivers/datasauRus) by Colin
  Gillespie, Steph Locke, Alberto Cairo, Rhian Davies, Justin Matejka,
  George Fitzmaurice, Lucy D’Agostino McGowan, Richard Cotton, Tim Book,
  Jumping Rivers
- [dataspice](https://github.com/ropensci/dataspice) by Carl Boettiger,
  Scott Chamberlain, Auriel Fournier, Kelly Hondula, Anna Krystalli,
  Bryce Mecum, Maëlle Salmon, Kate Webbink, Kara Woo, Irene Steves
- [datelife](https://github.com/phylotastic/datelife) by Brian O’Meara,
  Jonathan Eastman, Tracy Heath, April Wright, Klaus Schliep, Scott
  Chamberlain, Peter Midford, Luke Harmon, Joseph Brown, Matt Pennell,
  Mike Alfaro, Luna L. Sanchez Reyes, Emily Jane McTavish
- [datos](https://github.com/cienciadedatos/datos) by Riva Quiroga,
  Edgar Ruiz, Mauricio Vargas, Mauro Lepore, Rayna Harris, Daniela
  Vasquez, Joshua Kunst
- [devtools](https://github.com/r-lib/devtools) by Hadley Wickham, Jim
  Hester, Winston Chang, Jennifer Bryan, Posit Software, PBC
- [dials](https://github.com/tidymodels/dials) by Max Kuhn, Hannah
  Frick, Posit Software, PBC
- [distory]() by John Chakerian, Susan Holmes, Emmanuel Paradis
- [dmrseq]() by Keegan Korthauer, Rafael Irizarry, Yuval Benjamini,
  Sutirtha Chakraborty
- [dobtools](https://github.com/aedobbyn/dobtools) by Amanda Dobbyn
- [dySEM](https://github.com/jsakaluk/dySEM) by John Sakaluk, Omar
  Camanto, Christopher Quinn-Nilas, Merissa Prine, Robyn Kilshaw,
  Alexandra Fisher
- [ebdbNet](https://github.com/andreamrau/ebdbNet) by Andrea Rau
- [ech](https://github.com/calcita/ech) by Gabriela Mathieu, Richard
  Detomasi, Tati Micheletti
- [edibble](https://github.com/emitanaka/edibble) by Emi Tanaka
- [emmeans](https://github.com/rvlenth/emmeans/) by Russell V. Lenth,
  Julia Piaskowski, Balazs Banfai, Ben Bolker, Paul Buerkner, Iago
  Giné-Vázquez, Maxime Hervé, Maarten Jung, Jonathon Love, Fernando
  Miguez, Hannes Riebl, Henrik Singmann
- [emodnet.wfs](https://github.com/EMODnet/emodnet.wfs) by Joana Beja,
  Anna Krystalli, Salvador Fernández-Bejarano, Thomas J Webb, European
  Marine Observation Data Network, VLIZ, Maëlle Salmon, Alec L.
  Robitaille, Liz Hare, François Michonneau
- [EPACmodel](https://github.com/phac-modelling-hub/EPACmodel) by Irena
  Papst, Michael WZ Li
- [EpiGenR](https://github.com/lucymli/EpiGenR) by Lucy M Li
- [ern]() by David Champredon, Warsame Yusuf, Irena Papst
- [escrocR](https://github.com/Irstea/escroc) by Hilaire Drouineau,
  Marine Ballutaud, Jeremy Lobry
- [ESPA](https://github.com/PratheepaJ/ESPA) by Jeganathan Pratheepa,
  Trindade, Alex
- [ExperimentHub](https://github.com/Bioconductor/ExperimentHub) by
  Bioconductor Package Maintainer, Martin Morgan, Marc Carlson, Dan
  Tenenbaum, Sonali Arora, Valerie Oberchain, Kayla Morrell, Lori
  Shepherd
- [EZtune]() by Jill Lundell
- [FactoMineR](https://github.com/husson/FactoMineR) by Francois Husson,
  Julie Josse, Sebastien Le, Jeremy Mazet
- [ferrn](https://github.com/huizezhang-sherry/ferrn/) by H. Sherry
  Zhang, Dianne Cook, Ursula Laa, Nicolas Langrené, Patricia Menéndez
- [flametree](https://github.com/djnavarro/flametree) by Danielle
  Navarro
- [forested](https://github.com/simonpcouch/forested) by Grayson White,
  Hannah Frick, Simon Couch, Posit Software, PBC
- [forwards](https://github.com/forwards/forwards) by Heather Turner,
  Oliver Keyes
- [gapminder](https://github.com/jennybc/gapminder) by Jennifer Bryan
- [gargle](https://github.com/r-lib/gargle) by Jennifer Bryan, Craig
  Citro, Hadley Wickham, Google Inc, Posit Software, PBC
- [GenBank](https://github.com/lucymli/GenBank) by Lucy M Li, Who to
  complain to
- [geomnet](https://github.com/sctyner/geomnet) by Sam Tyner, Heike
  Hofmann, Nicholas Tierney
- [ggauto](https://github.com/nrennie/ggauto) by Nicola Rennie
- [ggflowchart](https://github.com/nrennie/ggflowchart) by Nicola Rennie
- [ggplot2](https://github.com/tidyverse/ggplot2) by Hadley Wickham,
  Winston Chang, Lionel Henry, Thomas Lin Pedersen, Kohske Takahashi,
  Claus Wilke, Kara Woo, Hiroaki Yutani, Dewey Dunnington, Teun van den
  Brand, Posit, PBC
- [ggPMX](https://github.com/ggPMXdevelopment/ggPMX) by Amine Gassem,
  Bruno Bieth, Irina Baltcheva, Thomas Dumortier, Christian Bartels,
  Souvik Bhattacharya, Inga Ludwig, Ines Paule, Didier Renard, Matthew
  Fidler, Seid Hamzic, Benjamin Guiastrennec, Kyle T Baron, Qing Xi Ooi,
  Aleksandr Pogodaev, Danielle Navarro, Ibtissem Rebai, Mahmoud Ali,
  Novartis Pharma AG
- [ggseg.extra](https://github.com/ggsegverse/ggseg.extra) by Athanasia
  Mo Mowinckel, Didac Vidal-Piñeiro, John Muschelli
- [ggseg.formats](https://github.com/ggsegverse/ggseg.formats) by
  Athanasia Mo Mowinckel, Center for Lifespan Changes in Brain and
  Cognition, University of Oslo
- [ggseg](https://github.com/ggsegverse/ggseg) by Athanasia Mo
  Mowinckel, Didac Vidal-Piñeiro, Ramiro Magno, Center for Lifespan
  Changes in Brain and Cognition, University of Oslo, Norway
- [ggseg.meshes](https://github.com/ggsegverse/ggseg.meshes) by
  Athanasia Mo Mowinckel, Center for Lifespan Changes in Brain and
  Cognition, University of Oslo
- [ggseg3d](https://github.com/ggsegverse/ggseg3d) by Athanasia Mo
  Mowinckel, Didac Vidal-Piñeiro, Center for Lifespan Changes in Brain
  and Cognition, University of Oslo, three.js authors
- [ghclass](https://github.com/rundel/ghclass) by Colin Rundel, Mine
  Cetinkaya-Rundel, Therese Anders
- [GISINTEGRATION]() by Hossein Hassani, Leila Marvian Mashhad, Sara
  Stewart, Steve Macfeelys
- [glitter](https://github.com/lvaudor/glitter) by Lise Vaudor, Maëlle
  Salmon
- [glue](https://github.com/tidyverse/glue) by Jim Hester, Jennifer
  Bryan, Posit Software, PBC
- [gmailr](https://github.com/r-lib/gmailr) by Jim Hester, Jennifer
  Bryan, Posit Software, PBC
- [gnm](https://github.com/hturner/gnm) by Heather Turner, David Firth,
  Brian Ripley, Bill Venables, Douglas M. Bates, Martin Maechler
- [gnomesims](https://github.com/josefinabernardo/gnomesims) by Josefina
  Bernardo
- [goodpractice](https://github.com/ropensci-review-tools/goodpractice)
  by Mark Padgham, Ascent Digital Services UK Limited, Karina Marks,
  Daniel de Bortoli, Gabor Csardi, Hannah Frick, Owen Jones, Hannah
  Alexander, Ana Simmons, Fabian Scheipl
- [googleAnalyticsR](https://github.com/8-bit-sheep/googleAnalyticsR/)
  by Mark Edmondson, Erik Grönroos, Artem Klevtsov, Johann deBoer, David
  Watkins, Olivia Brode-Roger, Jas Sohi, Zoran Selinger, Octavian
  Corlade, Maegan Whytock, Masaki Terashi
- [googledrive](https://github.com/tidyverse/googledrive) by Lucy
  D’Agostino McGowan, Jennifer Bryan, Posit Software, PBC
- [googlesheets4](https://github.com/tidyverse/googlesheets4) by
  Jennifer Bryan, Posit Software, PBC
- [gtreg](https://github.com/shannonpileggi/gtreg) by Shannon Pileggi,
  Daniel D. Sjoberg
- [gtsummary](https://github.com/ddsjoberg/gtsummary) by Daniel D.
  Sjoberg, Joseph Larmarange, Michael Curry, Emily de la Rua, Jessica
  Lavery, Karissa Whiting, Emily C. Zabor, Xing Bai, Malcolm Barrett,
  Esther Drill, Jessica Flynn, Margie Hannum, Stephanie Lobaugh, Shannon
  Pileggi, Amy Tin, Gustavo Zapata Wainberg
- [GWASTools](https://github.com/smgogarten/GWASTools) by Stephanie M.
  Gogarten, Cathy Laurie, Tushar Bhangale, Matthew P. Conomos, Cecelia
  Laurie, Michael Lawrence, Caitlin McHugh, Ian Painter, Xiuwen Zheng,
  Jess Shen, Rohit Swarnkar, Adrienne Stilp, Sarah Nelson, David Levine,
  Sonali Kumari, Stephanie M. Gogarten
- [h2o](https://github.com/h2oai/h2o-3) by Tomas Fryda, Erin LeDell,
  Navdeep Gill, Spencer Aiello, Anqi Fu, Arno Candel, Cliff Click, Tom
  Kraljevic, Tomas Nykodym, Patrick Aboyoun, Michal Kurka, Michal
  Malohlava, Sebastien Poirier, Wendy Wong, Ludi Rehak, Eric Eckstrand,
  Brandon Hill, Sebastian Vidrio, Surekha Jadhawani, Amy Wang, Raymond
  Peck, Jan Gorecki, Matt Dowle, Yuan Tang, Lauren DiPerna, Veronika
  Maurerova, Yuliia Syzon, Adam Valenta, Marek Novotny, H2O.ai
- [h2o4gpu](https://github.com/h2oai/h2o4gpu) by Yuan Tang, Navdeep
  Gill, Erin LeDell, Vladimir Ovsyannikov, H2O.ai
- [Haplin](https://haplin.bitbucket.io) by Hakon K. Gjessing, Miriam
  Gjerdevik, Julia Romanowska, Oivind Skare
- [HaplinMethyl](https://github.com/jromanowska/HaplinMethyl/) by Julia
  Romanowska, Haakon K. Gjessing
- [hardhat](https://github.com/tidymodels/hardhat) by Hannah Frick,
  Davis Vaughan, Max Kuhn, Posit Software, PBC
- [Hassani.SACF]() by Hossein Hassani, Masoud Yarmohammdi, Mohammad Reza
  Yeganegi, Leila Marvian Mashhad
- [Hassani.Silva]() by Hossein Hassani, Emmanuel Sirimal Silva, Leila
  Marvian Mashhad
- [hellodatascience](https://github.com/hellodata-science/hellodatascience)
  by Mine Dogucu, Catalina Medina, Alma Castro
- [hexify](https://github.com/djnavarro/hexify) by Danielle Navarro
- [hicream](https://forge.inrae.fr/scales/hicream/-) by Elise Jorge,
  Sylvain Foissac, Toby Hocking, Pierre Neuvial, Nathalie Vialaneix,
  Gilles Blanchard, Guillermo Durand, Nicolas Enjalbert-Courrech,
  Etienne Roquain
- [highriskzone]() by Heidi Seibold, Monia Mahling, Sebastian Linne,
  Felix Guenther, Rickmer Schulte
- [hmsidwR](https://github.com/Fgazzelloni/hmsidwR) by Federica
  Gazzelloni
- [HTSCluster]() by Andrea Rau, Gilles Celeux, Marie-Laure
  Martin-Magniette, Cathy Maugis- Rabusseau
- [HTSFilter]() by Andrea Rau, Melina Gallopin, Gilles Celeux, Florence
  Jaffrézic
- [iAdapt]() by Alyssa Vanderbeek, Laura Cosgrove, Elizabeth
  Garrett-Mayer, Cody Chiuzan
- [igraph](https://github.com/igraph/rigraph) by Gábor Csárdi, Tamás
  Nepusz, Vincent Traag, Szabolcs Horvát, Fabio Zanini, Daniel Noom,
  Kirill Müller, Michael Antonov, Chan Zuckerberg Initiative, David
  Schoch, Maëlle Salmon, R Consortium
- [implicitMeasures](https://github.com/OttaviaE/implicitMeasures) by
  Ottavia M. Epifania, Pasquale Anselmi, Egidio Robusto
- [infer](https://github.com/tidymodels/infer) by Andrew Bray, Chester
  Ismay, Evgeni Chasnovski, Simon Couch, Ben Baumer, Mine
  Cetinkaya-Rundel, Ted Laderas, Nick Solomon, Johanna Hardin, Albert Y.
  Kim, Neal Fultz, Doug Friedman, Richie Cotton, Brian Fannin
- [infiltrodiscR]() by Carolina V. Giraldo, Sara E. Acevedo, Carlos A.
  Bonilla
- [janeaustenr](https://github.com/juliasilge/janeaustenr) by Julia
  Silge
- [jasmines](https://github.com/djnavarro/jasmines) by Danielle Navarro
- [jaysire](https://github.com/djnavarro/jaysire) by Danielle Navarro,
  Danielle Navarro
- [JTHelpers](https://github.com/jenniferthompson/JTHelpers) by Jennifer
  Thompson, Cole Beck, Zhiguo Zhao
- [Kmisc](https://github.com/sysilviakim/Kmisc) by Seo-young Silvia Kim
- [learnres](https://github.com/yabellini/learnres) by Yanina Bellini
  Saibene
- [levelup](https://github.com/trianglegirl/levelup) by Rhian Davies
- [LITAP](https://github.com/FRDC-SHL/LITAP) by Steffi LaZerte, Sheng
  Li, Agriculture and Agri-Food Canada
- [lmmpar](https://github.com/fulyagokalp/lmmpar) by Fulya Gokalp Yavuz,
  Barret Schloerke
- [logmult](https://github.com/nalimilan/logmult) by Milan
  Bouchet-Valat, Heather Turner, Michael Friendly, Jim Lemon, Gabor
  Csardi
- [lsr](https://github.com/djnavarro/lsr) by Danielle Navarro
- [lvm4net](http://github.com/igollini/lvm4net) by Isabella Gollini
- [meetupr](https://github.com/rladies/meetupr) by Athanasia Mo
  Mowinckel, Erin LeDell, Olga Mierzwa-Sulima, Lucy D’Agostino McGowan,
  Claudia Vitolo, Gabriela De Queiroz, Michael Beigelmacher, Augustina
  Ragwitz, Greg Sutcliffe, Rick Pack, Ben Ubah, Maëlle Salmon, Barret
  Schloerke, RLadies+
- [memer](https://github.com/sctyner/memer) by Sam Tyner, Haley Jeppson
- [messy](https://github.com/nrennie/messy) by Nicola Rennie
- [metaRNASeq]() by Guillemette Marot, Andrea Rau, Florence Jaffrezic,
  Samuel Blanck
- [methylCC](https://github.com/stephaniehicks/methylCC/) by
  Stephanie C. Hicks, Rafael Irizarry
- [Metrics](https://github.com/mfrasco/Metrics) by Ben Hamner, Michael
  Frasco, Erin LeDell
- [mice](https://github.com/amices/mice) by Stef van Buuren, Karin
  Groothuis-Oudshoorn, Gerko Vink, Rianne Schouten, Alexander Robitzsch,
  Patrick Rockenschaub, Lisa Doove, Shahab Jolani, Margarita
  Moreno-Betancur, Ian White, Philipp Gaffert, Florian Meinfelder,
  Bernie Gray, Vincent Arel-Bundock, Mingyang Cai, Thom Volker, Edoardo
  Costantini, Caspar van Lissa, Hanne Oberman, Stephen Wade, Florian van
  Leeuwen, Frederik Fabricius-Bjerre
- [missMDA](https://github.com/husson/missMDA) by Francois Husson, Julie
  Josse
- [mitey](https://github.com/kylieainslie/mitey) by Kylie Ainslie
- [mixKernel](https://forgemia.inra.fr/genotoul-bioinfo/mixKernel/-) by
  Nathalie Vialaneix, Celine Brouard, Remi Flamary, Julien Henry, Jerome
  Mariette
- [MLDataR](https://github.com/StatsGary/MLDataR) by Gary Hutson, Asif
  Laldin, Isabella Velásquez
- [mmaqshiny](https://github.com/meenakshi-kushwaha/mmaqshiny) by
  Adithi R. Upadhya, Pratyush Agrawal, Sreekanth Vakacherla, Meenakshi
  Kushwaha
- [model4you](https://github.com/cran/model4you) by Heidi Seibold, Achim
  Zeileis, Torsten Hothorn
- [modleR](https://github.com/Model-R/modleR) by Andrea Sánchez-Tapia,
  Sara Mortara, Diogo Rocha, Felipe Barros, Guilherme Gall, Tiago Castro
  Silva
- [monochromeR](https://github.com/cararthompson/monochromeR) by Cara
  Thompson
- [mortAAR](https://github.com/ISAAKiel/mortAAR) by Nils
  Mueller-Scheessel, Martin Hinz, Clemens Schmid, Christoph Rinne,
  Daniel Knitter, Wolfgang Hamer, Dirk Seidensticker, Franziska Faupel,
  Carolin Tietze, Nicole Grunert
- [multilevelmod](https://github.com/tidymodels/multilevelmod) by Max
  Kuhn, Hannah Frick, RStudio
- [namer](https://github.com/jumpingrivers/namer) by Colin Gillespie,
  Steph Locke, Maëlle Salmon, Ellis Valentiner, Charlie Hadley, Jumping
  Rivers, Han Oostdijk, Patrick Schratz
- [naturecounts](https://github.com/BirdsCanada/naturecounts) by Steffi
  LaZerte, Denis Lepage
- [nestr]() by Emi Tanaka
- [nettskjemar](https://github.com/CAPRO-UiO/nettskjemar) by Athanasia
  Mo Mowinckel, Trym Nohr Fjørtoft
- [neuromapr](https://github.com/lcbc-uio/neuromapr) by Athanasia Mo
  Mowinckel
- [NiLeDAM]() by Nathalie Vialaneix, Aurélie Mercadié, Jean-Marc Montel,
  Anne-Magali Seydoux-Guillaume
- [nimble](https://github.com/nimble-dev/nimble) by Perry de Valpine,
  Christopher Paciorek, Daniel Turek, Nick Michaud, Cliff
  Anderson-Bergman, Fritz Obermeyer, Claudia Wehrhahn Cortes, Abel
  Rodríguez, Duncan Temple Lang, Wei Zhang, Sally Paganin, Joshua Hug,
  Paul van Dam-Bates, Jagadish Babu, Lauren Ponisio, Peter Sujan
- [NMAoutlier](https://github.com/petropouloumaria/NMAoutlier) by Maria
  Petropoulou, Guido Schwarzer, Agapios Panos, Dimitris Mavridis
- [odbr](https://github.com/hsvab/odbr) by Haydee Svab, Beatriz Milz,
  Diego Rabatone Oliveira, Rafael H. M. Pereira
- [oddstream](https://github.com/pridiltal/oddstream) by Priyanga Dilini
  Talagala, Rob J. Hyndman, Kate Smith-Miles
- [opencage](https://github.com/ropensci/opencage) by Daniel
  Possenriede, Jesse Sadler, Maëlle Salmon, Noam Ross, Jake Russ, Julia
  Silge
- [openintro](https://github.com/OpenIntroStat/openintro/) by Mine
  Çetinkaya-Rundel, David Diez, Andrew Bray, Albert Y. Kim, Ben Baumer,
  Chester Ismay, Nick Paterno, Christopher Barr
- [ordinalClust]() by Margot Selosse, Julien Jacques, Christophe
  Biernacki
- [oregonfrogs](https://github.com/fgazzelloni/oregonfrogs) by Federica
  Gazzelloni
- [osmdata](https://github.com/ropensci/osmdata) by Joan Maspons, Mark
  Padgham, Bob Rudis, Robin Lovelace, Maëlle Salmon, Andrew Smith, James
  Smith, Andrea Gilardi, Enrico Spinielli, Anthony North, Martin
  Machyna, Marcin Kalicinski, Eli Pousson
- [overviewR](https://github.com/cosimameyer/overviewR) by Cosima Meyer,
  Dennis Hammerschmidt
- [oxcAAR]() by Hinz Martin, Clemens Schmid, Daniel Knitter, Carolin
  Tietze
- [palmerpenguins](https://github.com/allisonhorst/palmerpenguins) by
  Allison Horst, Alison Hill, Kristen Gorman
- [pangaear](https://github.com/ropensci/pangaear%20(devel)) by Scott
  Chamberlain, Kara Woo, Andrew MacDonald, Naupaka Zimmerman, Gavin
  Simpson
- [parmsurvfit](https://github.com/apjacobson/parmsurvfit) by Ashley
  Jacobson, Victor Wilson, Shannon Pileggi
- [partykit](http://partykit.r-forge.r-project.org/partykit/) by Torsten
  Hothorn, Heidi Seibold, Achim Zeileis
- [PCADSC](https://github.com/annennenne/PCADSC) by Anne Helby Petersen,
  Bo Markussen
- [phoenics](https://forge.inrae.fr/panoramics/phoenics/-) by Camille
  Guilmineau, Remi Servien, Nathalie Vialaneix
- [phyloseq](https://github.com/joey711/phyloseq) by Paul J. McMurdie,
  Susan Holmes, Gregory Jordan, Scott Chamberlain
- [pins](https://github.com/rstudio/pins-r) by Julia Silge, Hadley
  Wickham, Javier Luraschi, Posit Software, PBC
- [pkgdown](https://github.com/r-lib/pkgdown) by Hadley Wickham, Jay
  Hesselberth, Maëlle Salmon, Olivier Roy, Salim Brüggemann, Posit
  Software, PBC
- [pkgsearch](https://github.com/r-hub/pkgsearch) by Gábor Csárdi,
  Maëlle Salmon, R Consortium
- [PKPDsim](https://github.com/InsightRX/PKPDsim) by Ron Keizer, Jasmine
  Hughes, Dominic Tong, Kara Woo, Jordan Brooks, InsightRX
- [PlackettLuce](https://github.com/hturner/PlackettLuce) by Heather
  Turner, Ioannis Kosmidis, David Firth, Jacob van Etten
- [poissonreg](https://github.com/tidymodels/poissonreg) by Max Kuhn,
  Hannah Frick, Posit Software, PBC
- [PPforest](https://github.com/natydasilva/PPforest) by Natalia da
  Silva, Dianne Cook, Eun-Kyung Lee
- [pregnancy](https://github.com/EllaKaye/pregnancy) by Ella Kaye
- [prepdat](http://github.com/ayalaallon/prepdat) by Ayala S. Allon, Roy
  Luria, James Grange, Nachshon Meiran
- [PreProcessRecordLinkage]() by Hossein Hassani, Leila Marvian Mashhad
- [PrettyCols](https://github.com/nrennie/PrettyCols) by Nicola Rennie
- [projmgr](https://github.com/emilyriederer/projmgr) by Emily Riederer
- [ProliferativeIndex]() by Brittany Lasseigne, Ryne Ramaker
- [psidread](https://github.com/Qcrates/psidread) by Shuyi Qiu
- [psychomix]() by Hannah Frick, Friedrich Leisch, Carolin Strobl,
  Florian Wickelmaier, Achim Zeileis
- [qsmooth]() by Stephanie C. Hicks, Kwame Okrah, Koen Van den Berge,
  Hector Corrada Bravo, Rafael Irizarry
- [qtwAcademic](https://github.com/andreaczhang/qtwAcademic) by Chi
  Zhang
- [quadkeyr](https://github.com/ropensci/quadkeyr) by Florencia
  D’Andrea, Pilar Fernandez, Maria Paula Caldas, Vincent van Hees,
  Andrew Pulsipher, CDC’s Center for Forecasting and Outbreak Analytics,
  MIDAS-NIH COVID-19 urgent grant program, Paul G. Allen School for
  Global Health, Washington State University
- [qualtRics](https://github.com/ropensci/qualtRics) by Jasper Ginn,
  Jackson Curtis, Shaun Jackson, Samuel Kaminsky, Eric Knudsen, Joseph
  O’Brien, Daniel Seneca, Julia Silge, Phoebe Wong
- [quantro]() by Stephanie Hicks, Rafael Irizarry
- [quartose](https://github.com/djnavarro/quartose) by Danielle Navarro
- [QueryWikidataR](https://github.com/serenasignorelli/QueryWikidataR)
  by Serena Signorelli
- [queue](https://github.com/djnavarro/queue) by Danielle Navarro
- [rainbowr](https://github.com/djnavarro/rainbowr) by Danielle Navarro
- [RCMIP5](https://github.com/ktoddbrown/RCMIP5) by Ben Bond-Lamberty,
  Kathe Todd-Brown
- [rddapp]() by Ze Jin, Wang Liao, Irena Papst, Wenyu Zhang, Kimberly
  Hochstedler, Felix Thoemmes
- [readr](https://github.com/tidyverse/readr) by Hadley Wickham, Jim
  Hester, Romain Francois, Jennifer Bryan, Shelby Bearrows, Posit
  Software, PBC, <https://github.com/mandreyel/>, Jukka Jylänki, Mikkel
  Jørgensen
- [readxl](https://github.com/tidyverse/readxl) by Hadley Wickham,
  Jennifer Bryan, Posit, PBC, Marcin Kalicinski, Komarov Valery,
  Christophe Leitienne, Bob Colbert, David Hoerl, Evan Miller
- [redcapAPI](https://github.com/vubiostat/redcapAPI) by Benjamin
  Nutter, Shawn Garbett, Savannah Obregon, Thomas Obadia, Marcus Lehr,
  Brian High, Stephen Lane, Will Beasley, Will Gray, Nick Kennedy, Tan
  Hsi-Nien, Jeffrey Horner, Jeremy Stephens, Cole Beck, Bradley Johnson,
  Philip Chase, Paddy Tobias, Michael Chirico, William Sharp, Alexander
  Strübing
- [regscoreR](https://github.com/UBC-MDS/regscoreR) by Simran Sethi, Ha
  Dinh, Ruoqi Xu
- [reprex](https://github.com/tidyverse/reprex) by Jennifer Bryan, Jim
  Hester, David Robinson, Hadley Wickham, Christophe Dervieux, Posit
  Software, PBC
- [repurrrsive](https://github.com/jennybc/repurrrsive) by Jennifer
  Bryan, Charlotte Wickham, Posit Software, PBC
- [rHealthDataGov](https://github.com/rOpenHealth/rHealthDataGov) by
  Erin LeDell
- [rhub](https://github.com/r-hub/rhub) by Gábor Csárdi, Maëlle Salmon,
  R Consortium
- [riem](https://github.com/ropensci/riem) by Maëlle Salmon, Brooke
  Anderson, CHAI Project, rOpenSci, Daryl Herzmann, Jonathan Elchison
- [riverbed](https://github.com/lvaudor/riverbed) by Lise Vaudor
- [rjtools](https://github.com/rjournal/rjtools) by Mitchell
  O’Hara-Wild, Stephanie Kobakian, H. Sherry Zhang, Di Cook, Simon
  Urbanek, Christophe Dervieux, R Journal Technical Editor
- [RNAseqNet]() by Alyssa Imbert, Nathalie Vialaneix
- [roblog](https://github.com/ropenscilabs/roblog) by Maëlle Salmon,
  Stefanie Butland, rOpenSci, Amanda Dobbyn, Christophe Dervieux, Romain
  LESUR
- [rsample](https://github.com/tidymodels/rsample) by Hannah Frick,
  Fanny Chow, Max Kuhn, Michael Mahoney, Julia Silge, Hadley Wickham,
  Posit Software, PBC
- [rsparkling](https://github.com/h2oai/sparkling-water/tree/master/r)
  by Jakub Hava, Navdeep Gill, Erin LeDell, Michal Malohlava, JJ
  Allaire, H2O.ai, RStudio
- [RSSthemes](https://github.com/nrennie/RSSthemes) by Nicola Rennie,
  Royal Statistical Society
- [rstanemax](https://github.com/yoshidk6/rstanemax) by Kenta Yoshida,
  Danielle Navarro, Trustees of Columbia University
- [RUVcorr]() by Saskia Freytag
- [saguaRo](https://github.com/sborrego/saguaRo) by Stacey Borrego
- [scDD](https://github.com/kdkorthauer/scDD) by Keegan Korthauer
- [scShapes](https://github.com/Malindrie/scShapes) by Malindrie
  Dharmaratne
- [seer](https://github.com/thiyangt/seer) by Thiyanga Talagala, Rob J
  Hyndman, George Athanasopoulos
- [sendplot](https://github.com/lshep/sendplot) by Daniel P Gaile,
  Lori A. Shepherd, Lara Sucheston, Andrew Bruno, Kenneth F. Manly
- [sensiPhy](https://github.com/paternogbc/sensiPhy) by Gustavo Paterno,
  Gijsbert Werner, Caterina Penone, Pablo Martinez
- [SeroTrackR](https://github.com/dionnecargy/SeroTrackR) by Dionne
  Argyropoulos
- [sessioncheck](https://github.com/djnavarro/sessioncheck) by Danielle
  Navarro
- [sfnetworks](https://github.com/luukvdmeer/sfnetworks) by Lucas van
  der Meer, Lorena Abad, Andrea Gilardi, Robin Lovelace
- [ShapeRotator](https://github.com/marta-vidalgarcia/ShapeRotator) by
  Marta Vidal-Garcia, Lashi Bandara, J. Scott Keogh
- [shinycustomloader]() by Emi Tanaka and Niichan
- [shinyfa](https://github.com/dalyanalytics/shinyfa) by Jasmine Daly
- [shinyLP](https://github.com/jasdumas/shinyLP) by Jasmine Daly
- [shinymatic](https://github.com/karbartolome/shinymatic) by Karina
  Bartolome
- [shinyMobile](https://github.com/RinteRface/shinyMobile) by David
  Granjon, Veerle van Leemput, AthlyticZ, Victor Perrier, John Coene,
  Isabelle Rudolf, Dieter Menne, Marvelapp, Vladimir Kharlampidi
- [shinymodels](https://github.com/tidymodels/shinymodels) by Max Kuhn,
  Shisham Adhikari, Julia Silge, Simon Couch, Posit Software, PBC
- [siga](https://github.com/AgRoMeteorologiaINTA/siga) by Yanina Bellini
  Saibene, Elio Campitelli, Paola Corrales, Natalia Gattinoni, INTA
- [simex](https://github.com/wolfganglederer/simex) by Wolfgang Lederer,
  Heidi Seibold, Helmut Küchenhoff, Chris Lawrence, Rasmus Froberg
  Brøndum
- [SISINTAR](https://github.com/inta-suelos/SISINTAR) by Yanina Bellini
  Saibene, Elio Campitelli, Paola Corrales
- [SISIR](https://forgemia.inra.fr/sfcb/sisir/-) by Victor Picheny, Remi
  Servien, Nathalie Vialaneix
- [sknifedatar](https://github.com/rafzamb/sknifedatar) by Rafael
  Zambrano, Karina Bartolome, Rodrigo Serrano
- [slingshot](https://github.com/kstreet13/slingshot) by Kelly Street,
  Davide Risso, Diya Das, Sandrine Dudoit, Koen Van den Berge, Robrecht
  Cannoodt
- [smbdata](https://github.com/emitanaka/smbdata) by Emi Tanaka, Sue
  Welham, Salvador Gezan, Suzanne Clark, Andrew Mead
- [SOMbrero](https://github.com/tuxette/SOMbrero) by Nathalie Vialaneix,
  Elise Maigne, Jerome Mariette, Madalina Olteanu, Fabrice Rossi, Laura
  Bendhaiba, Julien Boelaert
- [SparseSignatures](https://github.com/danro9685/SparseSignatures) by
  Daniele Ramazzotti, Avantika Lal, Keli Liu, Luca De Sano, Robert
  Tibshirani, Arend Sidow
- [spatialsample](https://github.com/tidymodels/spatialsample) by
  Michael Mahoney, Julia Silge, Posit Software, PBC
- [SPBB](https://github.com/PratheepaJ/SPBBspatial) by Pratheepa
  Jeganathan
- [statsr](https://github.com/StatsWithR/statsr) by Colin Rundel, Mine
  Cetinkaya-Rundel, Merlise Clyde, David Banks
- [stray](https://github.com/pridiltal/stray) by Priyanga Dilini
  Talagala, Rob J Hyndman, Kate Smith-Miles
- [subsemble](https://github.com/ledell/subsemble) by Erin LeDell,
  Stephanie Sapp, Mark van der Laan
- [superheat]() by Rebecca Barter, Bin Yu
- [SuperLearner](https://github.com/ecpolley/SuperLearner) by Eric
  Polley, Erin LeDell, Chris Kennedy, Sam Lendle, Mark van der Laan
- [tableHTML](https://github.com/LyzandeR/tableHTML) by Theo Boutaris,
  Clemens Zauchner, Dana Jomar
- [tailloss](http://github.com/igollini/tailloss) by Isabella Gollini,
  Jonathan Rougier
- [tailor](https://github.com/tidymodels/tailor) by Simon Couch, Hannah
  Frick, Emil HvitFeldt, Max Kuhn, Posit Software, PBC
- [tanggle](https://github.com/KlausVigo/tanggle) by Klaus Schliep,
  Marta Vidal-Garcia, Claudia Solis-Lemus, Leann Biancani, Eren Ada, L.
  Francisco Henao Diaz, Guangchuang Yu, Joshua Justison
- [TEQC]() by M. Hummel, S. Bonnin, E. Lowy, G. Roma, Sarah Bonnin
- [TextMiningTutorial](https://github.com/yabellini/TextMiningTutorial)
  by Yanina Bellini Saibene
- [tidylo](https://github.com/juliasilge/tidylo) by Tyler Schnoebelen,
  Julia Silge, Alex Hayes
- [tidyquintro](https://github.com/drmowinckels/tidyquintro) by
  Athanasia Mo Mowinckel
- [tidytext](https://github.com/juliasilge/tidytext) by Gabriela De
  Queiroz, Colin Fay, Emil Hvitfeldt, Os Keyes, Kanishka Misra, Tim
  Mastny, Jeff Erickson, David Robinson, Julia Silge
- [TidyTuesdayAltText](https://github.com/spcanelon/TidyTuesdayAltText)
  by Silvia Canelón, Thomas Mock, Elizabeth Hare
- [tinkr](https://github.com/ropensci/tinkr) by Maëlle Salmon, Zhian N.
  Kamvar, Jeroen Ooms, Nick Wellnhofer, rOpenSci, Peter Daengeli
- [tourr](https://github.com/ggobi/tourr) by Hadley Wickham, Dianne
  Cook, Nick Spyrison, Ursula Laa, H. Sherry Zhang, Stuart Lee
- [trackeR](https://github.com/trackerproject/trackeR) by Ioannis
  Kosmidis, Hannah Frick, Robin Hornak
- [traudem](https://github.com/lucarraro/traudem) by Luca Carraro,
  University of Zurich, Maëlle Salmon, Wael Sadek, Kirill Müller
- [treediff](https://forge.inrae.fr/scales/treediff/-) by Nathalie
  Vialaneix, Gwendaelle Cardenas, Marie Chavent, Sylvain Foissac, Pierre
  Neuvial, Nathanael Randriamihamison
- [tsfeatures](https://github.com/robjhyndman/tsfeatures) by Rob
  Hyndman, Yanfei Kang, Pablo Montero-Manso, Mitchell O’Hara-Wild,
  Thiyanga Talagala, Earo Wang, Yangzhuoran Yang, Souhaib Ben Taieb, Cao
  Hanqing, D K Lake, Nikolay Laptev, J R Moorman, Bohan Zhang
- [ttbbeer](https://github.com/jasdumas/ttbbeer) by Jasmine Daly
- [TutorialgRaficosFN](https://github.com/yabellini/TutorialgRaficosFN)
  by Yanina Bellini Saibene, Yanina Bellini Saibene
- [TutorialIterar](https://github.com/yabellini/TutorialIterar) by
  Yanina Bellini Saibene
- [typeR](https://github.com/Fgazzelloni/typeR) by Federica Gazzelloni
- [uiothemes](https://github.com/drmowinckels/uiothemes) by Athanasia Mo
  Mowinckel
- [ukbabynames](https://github.com/mine-cetinkaya-rundel/ukbabynames) by
  Mine Çetinkaya-Rundel, Thomas J. Leeper, Nicholas Goguen-Compagnoni,
  Sara Lemus
- [UniversalCVI]() by Nathakhun Wiroonsri, Onthada Preedasawakul
- [USAboundaries](https://github.com/ropensci/USAboundaries) by Lincoln
  Mullen, Jordan Bratt, United States Census Bureau, Jacci Ziebert
- [USCensus2020](https://github.com/shreshtha48/USCensus2020) by
  shreshtha modi
- [usdata](https://github.com/OpenIntroStat/usdata) by Mine
  Çetinkaya-Rundel, David Diez, Leah Dorazio
- [usethis](https://github.com/r-lib/usethis) by Hadley Wickham,
  Jennifer Bryan, Malcolm Barrett, Andy Teucher, Posit Software, PBC
- [vagalumeR](https://github.com/r-music/vagalumeR) by Bruna Wundervald
- [vcdExtra](https://github.com/friendly/vcdExtra) by Michael Friendly,
  David Meyer, Achim Zeileis, Duncan Murdoch, Heather Turner, David
  Firth, Daniel Sabanes Bove, Matt Kumar, Shuguang Sun, Gavin Klorfine
- [vcr](https://github.com/ropensci/vcr/) by Scott Chamberlain, Aaron
  Wolen, Maëlle Salmon, Daniel Possenriede, Hadley Wickham, rOpenSci
- [verbaliseR](https://github.com/cararthompson/verbaliseR) by Cara
  Thompson
- [verdadecu](https://github.com/Demografiando/verdadecu) by Adriana
  Robles, Javier Borja
- [vetiver](https://github.com/rstudio/vetiver-r/) by Julia Silge, Posit
  Software, PBC
- [vivo](https://github.com/ModelOriented/vivo) by Anna Kozak,
  Przemyslaw Biecek
- [Vizumap](https://github.com/lydialucchesi/Vizumap) by Lydia Lucchesi,
  Petra Kuhnert, Christopher Wikle, Benedict
- [votesmart](https://github.com/decktools/votesmart/) by Deck
  Technologies, Amanda Dobbyn, Max Wood, Alyssa Frazee
- [vroom](https://github.com/tidyverse/vroom) by Jim Hester, Hadley
  Wickham, Jennifer Bryan, Shelby Bearrows,
  <https://github.com/mandreyel/>, Jukka Jylänki, Mikkel Jørgensen,
  Posit Software, PBC
- [vultureUtils](https://github.com/kaijagahm/vultureUtils) by Kaija
  Gahm
- [washi](https://github.com/WA-Department-of-Agriculture/washi) by
  Jadey Ryan, Molly McIlquham, Dani Gelardi, Washington State Department
  of Agriculture
- [wcep](https://github.com/sarah-0k/wcep) by Jeffrey Bakal, Cynthia
  Westerhout, Sarah Rathwell, Caroline Falvey, Huiman Barnhart, Na Zhang
- [weathercan](https://github.com/ropensci/weathercan/) by Steffi
  LaZerte, Sam Albers, Nick Brown, Kevin Cazelles, Richard Littauer,
  Shandiya Balasubramaniam, Mark Ciechanowski, Jeremy Selva, Kelli F.
  Johnson, Russ Allen, Everett Snieder, Josh Persi, Mahjabin Oyshi
- [widyr](https://github.com/juliasilge/widyr) by David Robinson,
  Kanishka Misra, Julia Silge
- [wingen](https://github.com/AnushaPB/wingen) by Anusha Bishop, Anne
  Chambers, Ian Wang
- [woody](https://github.com/lvaudor/woody) by Lise Vaudor
- [workflows](https://github.com/tidymodels/workflows) by Davis Vaughan,
  Simon Couch, Hannah Frick, Posit Software, PBC
- [workflowsets](https://github.com/tidymodels/workflowsets) by Hannah
  Frick, Max Kuhn, Simon Couch, Posit Software, PBC
- [worrrd](https://github.com/anthonypileggi/worrrd) by Anthony Pileggi,
  Shannon Pileggi
- [XICOR]() by Susan Holmes, Sourav Chatterjee
- [zalpha]() by Clare Horscroft, Clare Horscroft

## License

[![CC0](https://upload.wikimedia.org/wikipedia/commons/6/69/CC0_button.svg)](https://creativecommons.org/publicdomain/zero/1.0/)
