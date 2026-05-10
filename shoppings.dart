// Shoppings reais por capital brasileira
const Map<String, List<String>> shoppingsPorCapital = {
  "Rio Branco":    ["Shopping Rio Branco","Triangulo Shopping"],
  "Maceió":        ["Maceió Shopping","Pátio Maceió","Shopping Farol"],
  "Macapá":        ["Shopping Macapá","Lagoa Shopping"],
  "Manaus":        ["Manauara Shopping","Sumaúma Park Shopping","Studio 5 Shopping"],
  "Salvador":      ["Shopping Barra","Salvador Shopping","Shopping Paralela","Shopping da Bahia","Boulevard Shopping"],
  "Fortaleza":     ["Shopping Iguatemi Fortaleza","North Shopping","RioMar Fortaleza","Shopping Parangaba","Aldeota Shopping"],
  "Brasília":      ["Shopping Brasília","Conjunto Nacional","Park Shopping","Pátio Brasil","Shopping Terraço"],
  "Vitória":       ["Shopping Vitória","Laranjeiras Shopping","Praia da Costa Shopping"],
  "Goiânia":       ["Shopping Flamboyant","Goiânia Shopping","Buriti Shopping","Passeio das Águas"],
  "São Luís":      ["Shopping da Ilha","São Luís Shopping","Riomar São Luís"],
  "Cuiabá":        ["Shopping Pantanal","Shopping Estação","Goiabeiras Shopping"],
  "Campo Grande":  ["Shopping Campo Grande","Bosque Shopping","Norte Sul Plaza"],
  "Belo Horizonte":["BH Shopping","Diamond Mall","Shopping Del Rey","Pátio Savassi","Shopping Bourbon"],
  "Belém":         ["Pátio Belém","Shopping Bosque Grão-Pará","Boulevard Shopping Belém"],
  "João Pessoa":   ["Manaíra Shopping","Mangabeira Shopping","Partage Shopping"],
  "Curitiba":      ["Shopping Curitiba","Shopping Mueller","Palladium Shopping","ParkShoppingBarigui"],
  "Recife":        ["RioMar Recife","Shopping Recife","Shopping Tacaruna","Caruaru Shopping"],
  "Teresina":      ["Shopping da Cidade","Riverside Shopping","Teresina Shopping"],
  "Rio de Janeiro":["Shopping Tijuca","Shopping Nova América","BarraShopping","Shopping Rio Sul","Via Parque"],
  "Natal":         ["Shopping Midway Mall","Natal Shopping","Partage Norte Shopping"],
  "Porto Alegre":  ["Shopping Iguatemi Porto Alegre","Bourbon Shopping","Shopping Total","Praia de Belas"],
  "Porto Velho":   ["Porto Velho Shopping","Rioverde Shopping"],
  "Boa Vista":     ["Roraima Garden Shopping","Shopping Boa Vista"],
  "Florianópolis": ["Beiramar Shopping","Shopping Iguatemi Florianópolis","Norte Shopping"],
  "São Paulo":     ["Shopping Ibirapuera","Shopping Morumbi","Shopping Center Norte","Shopping Eldorado","Aricanduva Shopping"],
  "Aracaju":       ["Riomar Aracaju","Shopping Jardins","Aracaju Parque Shopping"],
  "Palmas":        ["Capim Dourado Shopping","Palmas Shopping"],
};

// Estado → Capital
const Map<String, String> estadoParaCapital = {
  "AC":"Rio Branco","AL":"Maceió","AP":"Macapá","AM":"Manaus","BA":"Salvador",
  "CE":"Fortaleza","DF":"Brasília","ES":"Vitória","GO":"Goiânia","MA":"São Luís",
  "MT":"Cuiabá","MS":"Campo Grande","MG":"Belo Horizonte","PA":"Belém","PB":"João Pessoa",
  "PR":"Curitiba","PE":"Recife","PI":"Teresina","RJ":"Rio de Janeiro","RN":"Natal",
  "RS":"Porto Alegre","RO":"Porto Velho","RR":"Boa Vista","SC":"Florianópolis",
  "SP":"São Paulo","SE":"Aracaju","TO":"Palmas",
};

List<String> get todasCapitais => shoppingsPorCapital.keys.toList()..sort();
