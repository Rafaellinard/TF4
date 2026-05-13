// ============================================================
// DADOS OFICIAIS — Álbum Panini FIFA World Cup 2026
// Fonte: CNN Brasil / Lista oficial Panini
// 48 seleções × 18 jogadores = 864 jogadores
// ============================================================
import "figurinha.dart";

const List<Map<String, dynamic>> selecoesDados = [
  // ═══════════════════════════════════════════════
  // GRUPO A
  // ═══════════════════════════════════════════════
  { "grupo": "A", "pais": "Mexico", "sigla": "MEX",         "emoji": "🇲🇽", "jogadores": ["Escudo MEX", "Selecao MEX", "Luis Malagon","Johan Vasquez","Jorge Sanchez","Cesar Montes","Jesus Gallardo","Israel Reyes","Diego Lainez","Carlos Rodriguez","Edson Alvarez","Orbelin Pineda","Marcel Ruiz","Erick Sanchez","Hirving Lozano","Santiago Gimenez","Raul Jimenez","Alexis Vega","Roberto Alvarado","Cesar Huerta"] },
  { "grupo": "A", "pais": "Africa do Sul", "sigla": "RSA",  "emoji": "🇿🇦", "jogadores": ["Escudo RSA", "Selecao RSA", "Ronwen Williams","Sipho Chaine","Aubrey Modiba","Samukele Kabini","Mbekezeli Mbokazi","Khulumani Ndamane","Siyabonga Ngezana","Khuliso Mudau","Nkosinathi Sibisi","Teboho Mokoena","Thalente Mbatha","Bathuisi Aubaas","Yaya Sithole","Sipho Mbule","Lyle Foster","Ioraam Rayners","Mohau Nkota","Oswin Appolis"] },
  { "grupo": "A", "pais": "Coreia do Sul", "sigla": "KOR",  "emoji": "🇰🇷", "jogadores": ["Escudo KOR", "Selecao KOR", "Hyeon-woo Jo","Seung-Gyu Kim","Min-jae Kim","Yu-min Cho","Young-woo Seol","Han-beom Lee","Tae-seok Lee","Myung-jae Lee","Jae-sung Lee","In-beom Hwang","Kang-in Lee","Seung-ho Paik","Jens Castrop","Dong-gyeong Lee","Gue-sung Cho","Heung-min Son","Hee-chan Hwang","Hyeon-Gyu Oh"] },
  { "grupo": "A", "pais": "Rep. Tcheca", "sigla": "CZE",    "emoji": "🇨🇿", "jogadores": ["Escudo CZE", "Selecao CZE", "Matej Kovar","Jindrich Stanek","Ladislav Krejci","Vladimir Coufal","Jaroslav Zeleny","Tomas Holes","David Zima","Michal Sadilek","Lukas Provod","Lukas Cerv","Tomas Soucek","Pavel Sulc","Matej Vydra","Vasil Kusej","Tomas Chory","Vaclav Cerny","Adam Hlozek","Patrik Schick"] },

  // ═══════════════════════════════════════════════
  // GRUPO B
  // ═══════════════════════════════════════════════
  { "grupo": "B", "pais": "Canada", "sigla": "CAN",         "emoji": "🇨🇦", "jogadores": ["Escudo CAN", "Selecao CAN", "Dayne St. Clair","Alphonso Davies","Alistair Johnston","Samuel Adekugbe","Richie Laryea","Derek Cornelius","Moise Bombito","Kamal Miller","Stephen Eustaquio","Ismael Kone","Jonathan Osorio","Jacob Shaffelburg","Mathieu Choiniere","Niko Sigur","Tajon Buchanan","Liam Millar","Cyle Larin","Jonathan David"] },
  { "grupo": "B", "pais": "Bosnia", "sigla": "BIH",         "emoji": "🇧🇦", "jogadores": ["Escudo BIH", "Selecao BIH", "Nikola Vasilj","Amar Dedic","Sead Kolasimac","Tarik Muharemovic","Nihad Mujakic","Nikola Katic","Amir Hadziahmetovic","Benjamin Tahirovic","Armin Gigovic","Ivan Sunjic","Ivan Basic","Dzenis Burnic","Esmir Bajraktarevic","Amar Memic","Ermedin Demirovic","Edin Dzeko","Samed Bazdar","Haris Tabakovic"] },
  { "grupo": "B", "pais": "Catar", "sigla": "QAT",          "emoji": "🇶🇦", "jogadores": ["Escudo QAT", "Selecao QAT", "Meshaal Barsham","Sultan Albrake","Lucas Mendes","Homam Ahmed","Boualem Khoukhi","Pedro Miguel","Tarek Salman","Mohamed Al-Mannai","Karim Boudiaf","Assim Madibo","Ahmed Fatehi","Mohammed Waad","Abdulaziz Hatem","Hassan Al-Haydos","Edmilson Junior","Akram Hassan Afif","Ahmed Al Ganehi","Almoez Ali"] },
  { "grupo": "B", "pais": "Suica", "sigla": "SUI",          "emoji": "🇨🇭", "jogadores": ["Escudo SUI", "Selecao SUI", "Gregor Kobel","Yvon Mvogo","Manuel Akanji","Ricardo Rodriguez","Nico Elvedi","Aurele Amenda","Silvan Widmer","Granit Xhaka","Denis Zakaria","Remo Freuler","Fabian Rieder","Ardon Jashari","Johan Manzambi","Michel Aebischer","Breel Embolo","Ruben Vargas","Dan Ndoye","Zeki Amdouni"] },

  // ═══════════════════════════════════════════════
  // GRUPO C
  // ═══════════════════════════════════════════════
  { "grupo": "C", "pais": "Brasil", "sigla": "BRA",         "emoji": "🇧🇷", "jogadores": ["Escudo BRA", "Selecao BRA", "Alisson","Bento","Marquinhos","Eder Militao","Gabriel Magalhaes","Danilo","Wesley","Lucas Paqueta","Casemiro","Bruno Guimaraes","Luiz Henrique","Vinicius Junior","Rodrygo","Joao Pedro","Matheus Cunha","Gabriel Martinelli","Raphinha","Estevao"] },
  { "grupo": "C", "pais": "Marrocos", "sigla": "MAR",       "emoji": "🇲🇦", "jogadores": ["Escudo MAR", "Selecao MAR", "Yassine Bounou","Munir El Kajoui","Achraf Hakimi","Noussair Mazraoui","Nayef Aguerd","Romain Saiss","Jawad El Yamiq","Adam Masina","Sofyan Amrabat","Azzedine Ounahi","Eliesse Ben Seghir","Bilal El Khannouss","Ismael Saibari","Youssef En-Nesyri","Abde Ezzalzouli","Soufiane Rahimi","Brahim Diaz","Ayoub El Kaabi"] },
  { "grupo": "C", "pais": "Haiti", "sigla": "HAI",          "emoji": "🇭🇹", "jogadores": ["Escudo HAI", "Selecao HAI", "Johny Placide","Carlens Arcus","Martin Experience","Jean-Kevin Duverne","Ricardo Ade","Duke Lacroix","Garven Metusala","Hannes Delcroix","Leverton Pierre","Danley Jean Jacques","Jean-Ricner Bellegarde","Christopher Attys","Derrick Etienne Jr.","Josue Casimir","Ruben Providence","Duckens Nazon","Louicius Deedson","Frantzdy Pierrot"] },
  { "grupo": "C", "pais": "Escocia", "sigla": "SCO",        "emoji": "🏴󠁧󠁢󠁳󠁣󠁴󠁿", "jogadores": ["Escudo SCO", "Selecao SCO", "Angus Gunn","Jack Hendry","Kieran Tierney","Aaron Hickey","Andrew Robertson","Scott McKenna","John Souttar","Anthony Ralston","Grant Hanley","Scott McTominay","Billy Gilmour","Lewis Ferguson","Ryan Christie","Kenny McLean","John McGinn","Lyndon Dykes","Che Adams","Ben Doak"] },

  // ═══════════════════════════════════════════════
  // GRUPO D
  // ═══════════════════════════════════════════════
  { "grupo": "D", "pais": "Estados Unidos", "sigla": "USA", "emoji": "🇺🇸", "jogadores": ["Escudo USA", "Selecao USA", "Matt Freese","Chris Richards","Tim Ream","Mark McKenzie","Alex Freeman","Antonee Robinson","Tyler Adams","Tanner Tessmann","Weston McKennie","Christian Roldan","Timothy Weah","Diego Luna","Malik Tillman","Christian Pulisic","Brenden Aaronson","Ricardo Pepi","Haji Wright","Folarin Balogun"] },
  { "grupo": "D", "pais": "Paraguai", "sigla": "PAR",       "emoji": "🇵🇾", "jogadores": ["Escudo PAR", "Selecao PAR", "Roberto Fernandez","Orlando Gill","Gustavo Gomez","Fabian Balbuena","Juan Jose Caceres","Omar Alderete","Junior Alonso","Mathias Villasanti","Diego Gomez","Damian Bobadilla","Andres Cubas","Matias Galarza","Julio Enciso","Antonio Sanabria","Alejandro Romero","Braian Ojeda","Anibal Godoy","Nicolas Gimenez"] },
  { "grupo": "D", "pais": "Australia", "sigla": "AUS",      "emoji": "🇦🇺", "jogadores": ["Escudo AUS", "Selecao AUS", "Mathew Ryan","Joe Gauci","Harry Souttar","Alessandro Circati","Jordan Bos","Aziz Behich","Cameron Burgess","Lewis Miller","Milos Degenek","Jackson Irvine","Riley McGree","Aiden ONeill","Connor Metcalfe","Patrick Yazbek","Craig Goodwin","Kusini Yengi","Nestory Irankunda","Mohamed Toure"] },
  { "grupo": "D", "pais": "Turquia", "sigla": "TUR",        "emoji": "🇹🇷", "jogadores": ["Escudo TUR", "Selecao TUR", "Ugurcan Cakir","Mert Muldur","Zeki Celik","Abdulkerim Bardakci","Caglar Soyuncu","Merih Demiral","Ferdi Kadioglu","Kaan Ayhan","Ismail Yuksek","Hakan Calhanoglu","Orkun Kokcu","Arda Guler","Irfan Can Kahveci","Yunus Akgun","Can Uzun","Baris Alper Yilmaz","Kerem Akturkoglu","Kenan Yildiz"] },

  // ═══════════════════════════════════════════════
  // GRUPO E
  // ═══════════════════════════════════════════════
  { "grupo": "E", "pais": "Alemanha", "sigla": "GER",       "emoji": "🇩🇪", "jogadores": ["Escudo GER", "Selecao GER", "Marc-Andre ter Stegen","Jonathan Tah","David Raum","Nico Schlotterbeck","Antonio Rudiger","Waldemar Anton","Ridle Baku","Maximilian Mittelstadt","Joshua Kimmich","Florian Wirtz","Felix Nmecha","Leon Goretzka","Jamal Musiala","Serge Gnabry","Kai Havertz","Leroy Sane","Karim Adeyemi","Nick Woltemade"] },
  { "grupo": "E", "pais": "Curacao", "sigla": "CUW",        "emoji": "🇨🇼", "jogadores": ["Escudo CUW", "Selecao CUW", "Eloy Room","Armando Obispo","Sherel Floranus","Jurien Gaari","Joshua Brenet","Roshon Van Eijma","Shurandy Sambo","Livano Comenencia","Godfried Roemeratoe","Juninho Bacuna","Leandro Bacuna","Tahith Chong","Kenji Gorre","Jearl Margaritha","Jurgen Locadia","Jeremy Antonisse","Gervane Kastaneer","Sontje Hansen"] },
  { "grupo": "E", "pais": "Costa do Marfim", "sigla": "CIV","emoji": "🇨🇮", "jogadores": ["Escudo CIV", "Selecao CIV", "Yahia Fofana","Ghislain Konan","Wilfried Singo","Odilon Kossounou","Evan Ndicka","Willy Boly","Emmanuel Agbadou","Ousmane Diomande","Franck Kessie","Seko Fofana","Ibrahim Sangare","Jean-Philippe Gbamin","Amad Diallo","Sebastien Haller","Simon Adingra","Yan Diomande","Evann Guessand","Oumar Diakite"] },
  { "grupo": "E", "pais": "Equador", "sigla": "ECU",        "emoji": "🇪🇨", "jogadores": ["Escudo ECU", "Selecao ECU", "Hernan Galindez","Gonzalo Valle","Piero Hincapie","Pervis Estupinan","Willian Pacho","Angelo Preciado","Joel Ordonez","Moises Caicedo","Alan Franco","Kendry Paez","Pedro Vite","John Veboah","Leonardo Campana","Gonzalo Plata","Nilson Angulo","Alan Minda","Kevin Rodriguez","Enner Valencia"] },

  // ═══════════════════════════════════════════════
  // GRUPO F
  // ═══════════════════════════════════════════════
  { "grupo": "F", "pais": "Holanda", "sigla": "NED",        "emoji": "🇳🇱", "jogadores": ["Escudo NED", "Selecao NED", "Bart Verbruggen","Virgil van Dijk","Micky van de Ven","Jurrien Timber","Denzel Dumfries","Nathan Ake","Jeremie Frimpong","Jan Paul van Hecke","Tijjani Reijnders","Ryan Gravenberch","Teun Koopmeiners","Frenkie de Jong","Xavi Simons","Justin Kluivert","Memphis Depay","Donyell Malen","Wout Weghorst","Cody Gakpo"] },
  { "grupo": "F", "pais": "Japao", "sigla": "JPN",          "emoji": "🇯🇵", "jogadores": ["Escudo JPN", "Selecao JPN", "Zion Suzuki","Henry Mochizuki","Ayumu Seko","Junnosuke Suzuki","Shogo Taniguchi","Tsuyoshi Watanabe","Kaishu Sano","Yuki Soma","Ao Tanaka","Daichi Kamada","Takefusa Kubo","Ritsu Doan","Keito Nakamura","Takumi Minamino","Shuto Machino","Junya Ito","Koki Ogawa","Ayase Ueda"] },
  { "grupo": "F", "pais": "Suecia", "sigla": "SWE",         "emoji": "🇸🇪", "jogadores": ["Escudo SWE", "Selecao SWE", "Victor Johansson","Isak Hien","Gabriel Gudmundsson","Emil Holm","Victor Lindelof","Gustaf Lagerbielke","Lucas Bergvall","Hugo Larsson","Jesper Karlstrom","Yasin Ayari","Mattias Svanberg","Daniel Svensson","Ken Sema","Roony Bardghji","Dejan Kulusevski","Anthony Elanga","Alexander Isak","Viktor Gyokeres"] },
  { "grupo": "F", "pais": "Tunisia", "sigla": "TUN",        "emoji": "🇹🇳", "jogadores": ["Escudo TUN", "Selecao TUN", "Bechir Ben Said","Aymen Dahmen","Van Valery","Montassar Talbi","Yassine Meriah","Ali Abdi","Dylan Bronn","Ellyes Skhiri","Aissa Laidouni","Ferjani Sassi","Mohamed Ali Ben Romdhane","Hannibal Mejbri","Elias Achouri","Elias Saad","Hazem Mastouri","Ismael Gharbi","Sayfallah Ltaief","Naim Sliti"] },

  // ═══════════════════════════════════════════════
  // GRUPO G
  // ═══════════════════════════════════════════════
  { "grupo": "G", "pais": "Belgica", "sigla": "BEL",        "emoji": "🇧🇪", "jogadores": ["Escudo BEL", "Selecao BEL", "Thibaut Courtois","Arthur Theate","Timothy Castagne","Zeno Debast","Brandon Mechele","Maxim De Cuyper","Thomas Meunier","Youri Tielemans","Amadou Onana","Nicolas Raskin","Alexis Saelemaekers","Hans Vanaken","Kevin De Bruyne","Jeremy Doku","Charles De Ketelaere","Leandro Trossard","Lois Openda","Romelu Lukaku"] },
  { "grupo": "G", "pais": "Egito", "sigla": "EGY",          "emoji": "🇪🇬", "jogadores": ["Escudo EGY", "Selecao EGY", "Mohamed El Shenawy","Mohamed Hany","Mohamed Hamdy","Yasser Ibrahim","Khaled Sobhi","Ramy Rabia","Hossam Abdelmaguid","Ahmed Fatouh","Marwan Attia","Zizo","Hamdy Fathy","Mohamed Lasheen","Emam Ashour","Osama Faisal","Mohamed Salah","Mostafa Mohamed","Trezeguet","Omar Marmoush"] },
  { "grupo": "G", "pais": "Ira", "sigla": "IRN",            "emoji": "🇮🇷", "jogadores": ["Escudo IRN", "Selecao IRN", "Alireza Beiranvand","Morteza Pouraliganji","Ehsan Hajsafi","Milad Mohammadi","Shoja Khalilzadeh","Ramin Rezaeian","Hossein Kanaani","Sadegh Moharrami","Saleh Hardani","Saeed Ezatolahi","Saman Ghoddos","Omid Noorafkan","Roozbeh Cheshmi","Mohammad Mohebi","Sardar Azmoun","Mehdi Taremi","Alireza Jahanbakhsh","Ali Gholizadeh"] },
  { "grupo": "G", "pais": "Nova Zelandia", "sigla": "NZL",  "emoji": "🇳🇿", "jogadores": ["Escudo NZL", "Selecao NZL", "Max Crocombe","Alex Paulsen","Michael Boxall","Liberato Cacace","Tim Payne","Tyler Bindon","Francis de Vries","Finn Surman","Joe Bell","Sarpreet Singh","Ryan Thomas","Matthew Garbett","Marko Stamenic","Ben Old","Chris Wood","Elijah Just","Callum McCowatt","Kosta Barbarouses"] },

  // ═══════════════════════════════════════════════
  // GRUPO H
  // ═══════════════════════════════════════════════
  { "grupo": "H", "pais": "Espanha", "sigla": "ESP",        "emoji": "🇪🇸", "jogadores": ["Escudo ESP", "Selecao ESP", "Unai Simon","Robin Le Normand","Aymeric Laporte","Dean Huijsen","Pedro Porro","Dani Carvajal","Marc Cucurella","Martin Zubimendi","Rodri","Pedri","Fabian Ruiz","Mikel Merino","Lamine Yamal","Dani Olmo","Nico Williams","Ferran Torres","Alvaro Morata","Mikel Oyarzabal"] },
  { "grupo": "H", "pais": "Cabo Verde", "sigla": "CPV",     "emoji": "🇨🇻", "jogadores": ["Escudo CPV", "Selecao CPV", "Vozinha","Logan Costa","Pico","Diney","Steven Moreira","Wagner Pina","Joao Paulo","Yannick Semedo","Kevin Pina","Patrick Andrade","Jamiro Monteiro","Deroy Duarte","Garry Rodrigues","Jovane Cabral","Ryan Mendes","Dailon Livramento","Willy Semedo","Bebe"] },
  { "grupo": "H", "pais": "Arabia Saudita", "sigla": "KSA", "emoji": "🇸🇦", "jogadores": ["Escudo KSA", "Selecao KSA", "Nawaf Alaqidi","Abdulrahman Al-Sanbi","Saud Abdulhamid","Nawaf Boushal","Jihad Thakri","Moteb Al-Harbi","Hassan Altambakti","Musab Aljuwayr","Ziyad Aljohani","Abdullah Alkhaibari","Nasser Aldawsari","Saleh Abu Alshamat","Marwan Alsahafi","Salem Aldawsari","Abdulrahman Al-Aboud","Feras Albrikan","Saleh Alshehri","Abdullah Al-Hamdan"] },
  { "grupo": "H", "pais": "Uruguai", "sigla": "URU",        "emoji": "🇺🇾", "jogadores": ["Escudo URU", "Selecao URU", "Sergio Rochet","Santiago Mele","Ronald Araujo","Jose Maria Gimenez","Sebastian Caceres","Mathias Olivera","Guillermo Varela","Nahitan Nandez","Federico Valverde","Giorgian De Arrascaeta","Rodrigo Bentancur","Manuel Ugarte","Nicolas de la Cruz","Maxi Araujo","Darwin Nunez","Federico Vinas","Rodrigo Aguirre","Facundo Pellistri"] },

  // ═══════════════════════════════════════════════
  // GRUPO I
  // ═══════════════════════════════════════════════
  { "grupo": "I", "pais": "Franca", "sigla": "FRA",         "emoji": "🇫🇷", "jogadores": ["Escudo FRA", "Selecao FRA", "Mike Maignan","Theo Hernandez","William Saliba","Jules Kounde","Ibrahima Konate","Dayot Upamecano","Lucas Digne","Aurelien Tchouameni","Eduardo Camavinga","Manu Kone","Adrien Rabiot","Michael Olise","Ousmane Dembele","Bradley Barcola","Desire Doue","Kingsley Coman","Hugo Ekitike","Kylian Mbappe"] },
  { "grupo": "I", "pais": "Senegal", "sigla": "SEN",        "emoji": "🇸🇳", "jogadores": ["Escudo SEN", "Selecao SEN", "Eduardo Mendy","Yehvann Diouf","Moussa Niakhate","Abdoulaye Seck","Ismail Jakobs","El Hadji Malick Diouf","Kalidou Koulibaly","Idrissa Gana Gueye","Pape Matar Sarr","Pape Gueye","Habib Diarra","Lamine Camara","Sadio Mane","Ismaila Sarr","Boulaye Dia","Iliman Ndiaye","Nicolas Jackson","Krepin Diatta"] },
  { "grupo": "I", "pais": "Iraque", "sigla": "IRQ",         "emoji": "🇮🇶", "jogadores": ["Escudo IRQ", "Selecao IRQ", "Jalal Hassan","Rebin Sulaka","Hussein Ali","Akam Hashem","Merchas Doski","Zaid Tahseen","Manaf Younis","Zidane Iqbal","Amir Al-Ammari","Ibrahim Bayesh","Ali Jasim","Youssef Amyn","Aimar Sher","Marko Farji","Osama Rashid","Ali Al-Hamadi","Aymen Hussein","Mohanad Ali"] },
  { "grupo": "I", "pais": "Noruega", "sigla": "NOR",        "emoji": "🇳🇴", "jogadores": ["Escudo NOR", "Selecao NOR", "Orjan Nyland","Julian Ryerson","Leo Ostigard","Kristoffer Ajer","Marcus Holmgren Pedersen","David Moller Wolfe","Torbjorn Heggem","Morten Thorsby","Martin Odegaard","Sander Berge","Andreas Schjelderup","Patrick Berg","Erling Haaland","Alexander Sorloth","Aron Donnum","Jorgen Strand Larsen","Antonio Nusa","Oscar Bobb"] },

  // ═══════════════════════════════════════════════
  // GRUPO J
  // ═══════════════════════════════════════════════
  { "grupo": "J", "pais": "Argentina", "sigla": "ARG",      "emoji": "🇦🇷", "jogadores": ["Escudo ARG", "Selecao ARG", "Emiliano Martinez","Nahuel Molina","Cristian Romero","Nicolas Otamendi","Nicolas Tagliafico","Leonardo Balerdi","Enzo Fernandez","Alexis Mac Allister","Rodrigo De Paul","Exequiel Palacios","Leandro Paredes","Nico Paz","Franco Mastantuono","Nico Gonzalez","Lionel Messi","Lautaro Martinez","Julian Alvarez","Giuliano Simeone"] },
  { "grupo": "J", "pais": "Algeria", "sigla": "ALG",        "emoji": "🇩🇿", "jogadores": ["Escudo ALG", "Selecao ALG", "Rais Mbohli","Djibril Benbouzid","Ramy Bensebaini","Djamel Benlamri","Aissa Mandi","Hicham Boudaoui","Nabil Bentaleb","Said Benrahma","Houssem Aouar","Sofiane Feghouli","Baghdad Bounedjah","Riyad Mahrez","Islam Slimani","Youcef Atal","Ramiz Zerrouki","Andy Delort","Amine Gouiri","Mehdi Zerkane"] },
  { "grupo": "J", "pais": "Nigeria", "sigla": "NGA",        "emoji": "🇳🇬", "jogadores": ["Escudo NGA", "Selecao NGA", "Stanley Nwabali","Maduka Okoye","Semi Ajayi","William Troost-Ekong","Calvin Bassey","Zaidu Sanusi","Bright Osayi-Samuel","Ola Aina","Wilfred Ndidi","Alex Iwobi","Frank Onyeka","Raphael Onyedika","Samuel Chukwueze","Ademola Lookman","Moses Simon","Emmanuel Dennis","Victor Osimhen","Cyriel Dessers"] },
  { "grupo": "J", "pais": "Croacia", "sigla": "CRO",        "emoji": "🇭🇷", "jogadores": ["Escudo CRO", "Selecao CRO", "Dominik Livakovic","Josip Juranovic","Dejan Lovren","Josko Gvardiol","Borna Sosa","Luka Modric","Mateo Kovacic","Marcelo Brozovic","Ivan Perisic","Andrej Kramaric","Bruno Petkovic","Mario Pasalic","Nikola Vlasic","Luka Ivanusec","Ante Budimir","Josip Stanisic","Martin Erlic","Petar Sucic"] },

  // ═══════════════════════════════════════════════
  // GRUPO K
  // ═══════════════════════════════════════════════
  { "grupo": "K", "pais": "Portugal", "sigla": "POR",       "emoji": "🇵🇹", "jogadores": ["Escudo POR", "Selecao POR", "Rui Patricio","Diogo Costa","Joao Cancelo","Ruben Dias","Pepe","Nuno Mendes","Antonio Silva","Joao Palhinha","Bruno Fernandes","Bernardo Silva","Vitinha","Joao Felix","Rafael Leao","Diogo Jota","Goncalo Ramos","Pedro Neto","Francisco Conceicao","Cristiano Ronaldo"] },
  { "grupo": "K", "pais": "Dinamarca", "sigla": "DEN",      "emoji": "🇩🇰", "jogadores": ["Escudo DEN", "Selecao DEN", "Kasper Schmeichel","Jannik Vestergaard","Joachim Andersen","Victor Nelsson","Andreas Christensen","Joakim Maehle","Alexander Bah","Rasmus Kristensen","Christian Eriksen","Pierre-Emile Hojbjerg","Mathias Jensen","Robert Skov","Andreas Skov Olsen","Jesper Lindstrom","Jonas Wind","Rasmus Hojlund","Viktor Gyokeres","Mikkel Damsgaard"] },
  { "grupo": "K", "pais": "Serbia", "sigla": "SRB",         "emoji": "🇷🇸", "jogadores": ["Escudo SRB", "Selecao SRB", "Predrag Rajkovic","Vanja Milinkovic-Savic","Strahinja Pavlovic","Nikola Milenkovic","Milos Veljkovic","Nemanja Gudelj","Sasa Lukic","Nemanja Maksimovic","Filip Kostic","Dusan Tadic","Andrija Zivkovic","Marko Grujic","Aleksandar Mitrovic","Luka Jovic","Dusan Vlahovic","Sergej Milinkovic-Savic","Srdjan Babic","Ivan Ilic"] },
  { "grupo": "K", "pais": "Indonesia", "sigla": "IDN",      "emoji": "🇮🇩", "jogadores": ["Escudo IDN", "Selecao IDN", "Ernando Ari","Maarten Paes","Rizky Ridho","Jay Idzes","Elkan Baggott","Pratama Arhan","Sandy Walsh","Marc Klok","Thom Haye","Nathan Tjoe-A-On","Justin Hubner","Shayne Pattynama","Kevin Diks","Marselino Ferdinan","Ragnar Oratmangoen","Rafael Struick","Hokky Caraka","Witan Sulaeman"] },

  // ═══════════════════════════════════════════════
  // GRUPO L
  // ═══════════════════════════════════════════════
  { "grupo": "L", "pais": "Inglaterra", "sigla": "ENG",     "emoji": "🏴󠁧󠁢󠁥󠁮󠁧󠁿", "jogadores": ["Escudo ENG", "Selecao ENG", "Jordan Pickford","Dean Henderson","Kyle Walker","John Stones","Marc Guehi","Ezri Konsa","Trent Alexander-Arnold","Luke Shaw","Declan Rice","Jude Bellingham","Phil Foden","Conor Gallagher","Cole Palmer","Bukayo Saka","Jarrod Bowen","Harry Kane","Ollie Watkins","Marcus Rashford"] },
  { "grupo": "L", "pais": "Venezuela", "sigla": "VEN",      "emoji": "🇻🇪", "jogadores": ["Escudo VEN", "Selecao VEN", "Wuilker Farinaz","Rafael Romo","Nahuel Ferraresi","Yordan Osorio","Miguel Navarro","Jon Aramburu","Gerald Penaranda","Jefferson Savarino","Tomas Rincon","Yangel Herrera","Yeferson Soteldo","Adalberto Penaranda","Eduard Bello","Darwin Machis","Jan Hurtado","Salomon Rondon","Josef Martinez","Jhonder Cadiz"] },
  { "grupo": "L", "pais": "Peru", "sigla": "PER",           "emoji": "🇵🇪", "jogadores": ["Escudo PER", "Selecao PER", "Pedro Gallese","Diego Romero","Luis Advincula","Alexander Callens","Miguel Trauco","Marcos Lopez","Oliver Sonne","Renato Tapia","Rodrigo Vilca","Sergio Pena","Wilder Cartagena","Andy Polo","Andre Carrillo","Piero Quispe","Bryan Reyna","Gianluca Lapadula","Edison Flores","Raul Ruidiaz"] },
  { "grupo": "L", "pais": "Colombia", "sigla": "COL",       "emoji": "🇨🇴", "jogadores": ["Escudo COL", "Selecao COL", "Camilo Vargas","David Ospina","Daniel Munoz","Davinson Sanchez","Carlos Cuesta","Jhon Lucumi","Johan Mojica","Luis Diaz","James Rodriguez","Richard Rios","Gustavo Puerta","Lerma Jefferson","Sebastian Villa","Juan Cuadrado","Jhon Arias","Rafael Santos Borre","Jhon Duran","Radamel Falcao"] },
];

// ─── Figurinhas especiais ────────────────────────────────────────────────────
const List<Map<String, dynamic>> especialsDados = [
  { "categoria": "Trofeu e Simbolos", "sigla": "FWC",    "emoji": "🏆", "cor": 0xFFF59E0B, "itens": ["FIFA World Cup Trophy","Logo Oficial Copa 2026","Bola Oficial Adidas","Mascote Oficial 2026","Poster Oficial","Copa Historia"] },
  { "categoria": "Paises Sede", "sigla": "HOST",          "emoji": "🌎", "cor": 0xFF3B82F6, "itens": ["Estados Unidos","Mexico","Canada","Los Angeles","Nova York","Dallas","San Francisco","Miami","Seattle","Boston","Guadalajara","Monterrey","Cidade do Mexico","Toronto","Vancouver"] },
  { "categoria": "Estadios Sede", "sigla": "STD",        "emoji": "🏟", "cor": 0xFF8B5CF6, "itens": ["SoFi Stadium","MetLife Stadium","AT&T Stadium","Levis Stadium","Hard Rock Stadium","Lumen Field","Gillette Stadium","Estadio Akron","Estadio BBVA","Estadio Azteca","BMO Field","BC Place","NRG Stadium","Arrowhead Stadium","Lincoln Financial Field","Mercedes-Benz Stadium"] },
  { "categoria": "Figurinhas Douradas", "sigla": "GOLD",  "emoji": "✨", "cor": 0xFFF59E0B, "itens": ["Messi Dourada","Cristiano Ronaldo Dourada","Mbappe Dourada","Vinicius Jr Dourada","Bellingham Dourada","Pedri Dourada","Haaland Dourada","Lautaro Dourada","Bruno Fernandes Dourada","Musiala Dourada"] },
  { "categoria": "Eternos 22 Legends", "sigla": "LEG",   "emoji": "🌟", "cor": 0xFFEC4899, "itens": ["Ronaldo Fenomeno","Ronaldinho Gaucho","Zinedine Zidane","Pele","Diego Maradona","Roberto Carlos","Thierry Henry","Cafu","Xavi Hernandez","Andres Iniesta","Oliver Kahn","Paolo Maldini"] },
  { "categoria": "Campeoes Historicos", "sigla": "CAMP",  "emoji": "🥅", "cor": 0xFF00C864, "itens": ["Brasil Penta Campeao","Alemanha 4x Campea","Italia 4x Campea","Argentina 3x Campea","Franca 2x Campea","Uruguay 2x Campeao","England Campea 1966","Espanha Campea 2010"] },
  { "categoria": "Uniformes Oficiais", "sigla": "KIT",   "emoji": "🎽", "cor": 0xFF06B6D4, "itens": ["Brasil Titular","Brasil Reserva","Argentina Titular","Franca Titular","Alemanha Titular","Portugal Titular","Espanha Titular","Inglaterra Titular"] },
];

// ─── Gerar listas ────────────────────────────────────────────────────────────
List<Figurinha> gerarFigurinhas() {
  final List<Figurinha> lista = [];
  int id = 1;
  for (final sel in selecoesDados) {
    int numDentroSelecao = 1;
    final sigla = sel["sigla"] as String;
    for (final nome in (sel["jogadores"] as List<dynamic>).cast<String>()) {
      lista.add(Figurinha(
        id: id,
        numero: "$sigla $numDentroSelecao",
        nome: nome,
        pais: sel["pais"] as String,
        emoji: sel["emoji"] as String,
        grupo: sel["grupo"] as String,
      ));
      id++;
      numDentroSelecao++;
    }
  }
  return lista;
}

List<Figurinha> gerarEspeciais() {
  final List<Figurinha> lista = [];
  int id = 1000;
  for (final cat in especialsDados) {
    int numDentro = 1;
    final sigla = cat["sigla"] as String;
    for (final nome in (cat["itens"] as List<dynamic>).cast<String>()) {
      lista.add(Figurinha(
        id: id,
        numero: "$sigla $numDentro",
        nome: nome,
        pais: cat["categoria"] as String,
        emoji: cat["emoji"] as String,
        grupo: "ESP",
      ));
      id++;
      numDentro++;
    }
  }
  return lista;
}

final List<Figurinha> todasFigurinhas   = gerarFigurinhas();
final List<Figurinha> todasEspeciais    = gerarEspeciais();
final List<Figurinha> todasAsFigurinhas = [...todasFigurinhas, ...todasEspeciais];

Figurinha? getFigurinhaById(int id) {
  try { return todasAsFigurinhas.firstWhere((f) => f.id == id); }
  catch (_) { return null; }
}

List<String> get todasSelecoes =>
    selecoesDados.map((s) => s["pais"] as String).toList();
