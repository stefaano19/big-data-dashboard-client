import 'dart:math';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:progetto_big_data_frontend/views/components/simple_us_map.dart';
import 'dart:convert';
import 'package:progetto_big_data_frontend/views/components/us_map.dart';

class MapPage extends StatefulWidget {
  const MapPage({Key? key}) : super(key: key);

  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  String selectedState = 'Alabama';
  String selectedProduct = 'Alabama';
  String productionData = '';
  List<String> typeAnimals = [];
  double lat = 37.8; // Latitudine iniziale
  double lng = -96.9; // Longitudine iniziale
  List<MarkerData> markersData = [];
  bool isLoading = false;
  List<Widget> animalLegend = [];
  bool _showStateSuggestions = true;
  bool _showProductSuggestions = true;
  bool state = false;

  final TextEditingController stateController = TextEditingController();
  final TextEditingController productController = TextEditingController();

  final List<String> usaStates = [
    'Alabama',
    'Alaska',
    'Arizona',
    'Arkansas',
    'California',
    'Colorado',
    'Connecticut',
    'Delaware',
    'Florida',
    'Georgia',
    'Hawaii',
    'Idaho',
    'Illinois',
    'Indiana',
    'Iowa',
    'Kansas',
    'Kentucky',
    'Louisiana',
    'Maine',
    'Maryland',
    'Massachusetts',
    'Michigan',
    'Minnesota',
    'Mississippi',
    'Missouri',
    'Montana',
    'Nebraska',
    'Nevada',
    'New Hampshire',
    'New Jersey',
    'New Mexico',
    'New York',
    'North Carolina',
    'North Dakota',
    'Ohio',
    'Oklahoma',
    'Oregon',
    'Pennsylvania',
    'Rhode Island',
    'South Carolina',
    'South Dakota',
    'Tennessee',
    'Texas',
    'Utah',
    'Vermont',
    'Virginia',
    'Washington',
    'West Virginia',
    'Wisconsin',
    'Wyoming',
  ];

  Map<String, Icon> animalIcons = {
    "Acquacoltura": Icon(FontAwesomeIcons.fish, color: Colors.blue),
    "Fagiani": Icon(FontAwesomeIcons.dove, color: Colors.green),
    "Conigli": Icon(FontAwesomeIcons.kiwiBird, color: Colors.brown),
    "Cavalli": Icon(FontAwesomeIcons.horse, color: Colors.purple),
    "Miele": Icon(FontAwesomeIcons.paw, color: Colors.yellow),
    "Galline": Icon(FontAwesomeIcons.dove, color: Colors.orange),
    "Grasso": Icon(FontAwesomeIcons.oilCan, color: Colors.blueGrey),
    "Pecore e Capre": Icon(FontAwesomeIcons.paw, color: Colors.white),
    "Pesca Sportiva": Icon(FontAwesomeIcons.fish, color: Colors.blueAccent),
    "Bestiame": Icon(FontAwesomeIcons.cow, color: Colors.green),
    "Pollame": Icon(FontAwesomeIcons.drumstickBite, color: Colors.red),
    "Mellorina": Icon(FontAwesomeIcons.iceCream, color: Colors.pink),
    "Maiali": Icon(FontAwesomeIcons.bacon, color: Colors.redAccent),
    "Animali": Icon(FontAwesomeIcons.paw, color: Colors.yellow),
    "Emu": Icon(FontAwesomeIcons.kiwiBird, color: Colors.greenAccent),
    "Agnelli e Montoni": Icon(FontAwesomeIcons.paw, color: Colors.pink),
    "Acqua": Icon(FontAwesomeIcons.water, color: Colors.blue),
    "Latte": Icon(FontAwesomeIcons.glassWater, color: Colors.white),
    "Anatre": Icon(FontAwesomeIcons.dove, color: Colors.green),
    "Pesci Ornamentali": Icon(FontAwesomeIcons.fish, color: Colors.lightBlue),
    "Manzi": Icon(FontAwesomeIcons.cow, color: Colors.brown),
    "Carne Rossa": Icon(FontAwesomeIcons.utensils, color: Colors.deepOrange),
    "Alpaca": Icon(FontAwesomeIcons.paw, color: Colors.purple),
    "Burro": Icon(FontAwesomeIcons.paw, color: Colors.yellow),
    "Ghiaccio": Icon(FontAwesomeIcons.snowflake, color: Colors.cyan),
    "Siero di Latte": Icon(FontAwesomeIcons.glassWater, color: Colors.green),
    "Panna": Icon(FontAwesomeIcons.paw, color: Colors.pink),
    "Lama": Icon(FontAwesomeIcons.paw, color: Colors.red),
    "Lana": Icon(FontAwesomeIcons.paw, color: Colors.blueGrey),
    "Cervi": Icon(FontAwesomeIcons.paw, color: Colors.brown),
    "Latticello": Icon(FontAwesomeIcons.mugHot, color: Colors.white),
    "Granita": Icon(FontAwesomeIcons.iceCream, color: Colors.orange),
    "Animali Speciali": Icon(FontAwesomeIcons.paw, color: Colors.amber),
    "Yogurt": Icon(FontAwesomeIcons.bowlFood, color: Colors.white),
    "Vitelli": Icon(FontAwesomeIcons.cow, color: Colors.pink),
    "Pesce": Icon(FontAwesomeIcons.fish, color: Colors.blue),
    "Molluschi": Icon(FontAwesomeIcons.fish, color: Colors.green),
    "Crostacei": Icon(FontAwesomeIcons.shrimp, color: Colors.teal),
    "Totale Animali": Icon(FontAwesomeIcons.paw, color: Colors.red),
    "Formaggio": Icon(FontAwesomeIcons.cheese, color: Colors.yellow),
    "Pesce e Vongole Giganti": Icon(FontAwesomeIcons.fish, color: Colors.cyan),
    "Gelati": Icon(FontAwesomeIcons.iceCream, color: Colors.pink),
    "Mohair": Icon(FontAwesomeIcons.paw, color: Colors.white),
    "Struzzi": Icon(FontAwesomeIcons.kiwiBird, color: Colors.green),
    "Oche": Icon(FontAwesomeIcons.dove, color: Colors.white),
    "Bovini": Icon(FontAwesomeIcons.cow, color: Colors.brown),
    "Nandu": Icon(FontAwesomeIcons.kiwiBird, color: Colors.red),
    "Alci": Icon(FontAwesomeIcons.paw, color: Colors.green),
    "Farina": Icon(FontAwesomeIcons.utensils, color: Colors.orange),
    "Pratiche": Icon(FontAwesomeIcons.seedling, color: Colors.blue),
    "Pesci da Esca": Icon(FontAwesomeIcons.fish, color: Colors.teal),
    "Strutto": Icon(FontAwesomeIcons.utensils, color: Colors.yellow),
    "Totale Animali Speciali": Icon(FontAwesomeIcons.paw, color: Colors.pink),
    "Piccioni": Icon(FontAwesomeIcons.dove, color: Colors.grey),
    "Bisonti": Icon(FontAwesomeIcons.paw, color: Colors.orange),
    "Tacchini": Icon(FontAwesomeIcons.dove, color: Colors.brown),
    "Mangime": Icon(FontAwesomeIcons.bowlFood, color: Colors.green),
    "Chukar": Icon(FontAwesomeIcons.kiwiBird, color: Colors.purple),
    "Pernici": Icon(FontAwesomeIcons.dove, color: Colors.green),
    "Pecore": Icon(FontAwesomeIcons.paw, color: Colors.white),
    "Quaglie": Icon(FontAwesomeIcons.kiwiBird, color: Colors.green),
    "Visoni": Icon(FontAwesomeIcons.paw, color: Colors.red),
    "Prodotti Lattiero-caseari":
        Icon(FontAwesomeIcons.mugHot, color: Colors.white),
    "Capre": Icon(FontAwesomeIcons.paw, color: Colors.green),
    "Grassi di Pollame":
        Icon(FontAwesomeIcons.drumstickBite, color: Colors.orange),
    "Uova": Icon(FontAwesomeIcons.egg, color: Colors.yellow),
    "Sego": Icon(FontAwesomeIcons.oilCan, color: Colors.yellow),
    "Carabao": Icon(FontAwesomeIcons.paw, color: Colors.teal),
    "Prodotti Animali": Icon(FontAwesomeIcons.utensils, color: Colors.amber),
    "Cera d'Api": Icon(FontAwesomeIcons.b, color: Colors.orange),
  };

  List<String> usaProduct = [
    "Acquacultura",
    "Fagiani",
    "Conigli",
    "Cavalli",
    "Miele",
    "Galline",
    "Grasso",
    "Pecore e Capre",
    "Pesca Sportiva",
    "Bestiame",
    "Pollame",
    "Mellorina",
    "Maiali",
    "Animali",
    "Emu",
    "Agnello e Montone",
    "Acqua",
    "Latte",
    "Anatre",
    "Pesci Ornamentali",
    "Manzo",
    "Carne Rossa",
    "Alpaca",
    "Burro",
    "Ghiaccio",
    "Siero di Latte",
    "Panna",
    "Lama",
    "Lana",
    "Cervi",
    "Latticello",
    "Granita",
    "Animali Speciali",
    "Yogurt",
    "Vitelli",
    "Pesce",
    "Molluschi",
    "Crostacei",
    "Totale Animali",
    "Formaggio",
    "Pesce e Vongole Giganti",
    "Gelati",
    "Mohair",
    "Struzzi",
    "Oche",
    "Bovini",
    "Nandu",
    "Alci",
    "Farina",
    "Pratiche",
    "Pesci da Esca",
    "Strutto",
    "Totale Animali Speciali",
    "Piccioni",
    "Bisonti",
    "Tacchini",
    "Mangime",
    "Chukar",
    "Perdici",
    "Pecore",
    "Quaglie",
    "Visoni",
    "Prodotti Lattiero-caseari",
    "Capre",
    "Grassi di Pollame",
    "Uova",
    "Sego",
    "Carabao",
    "Prodotti Animali",
    "Cera d'Api",
  ];

  Future<void> fetchProductionDataState(String state) async {
    setState(() {
      isLoading = true; // Set loading to true
    });

    try {
      print("Fetching data for state: $state");

      final response = await http.get(
        Uri.parse('http://127.0.0.1:8000/production_state?state=$state'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final stateData = data['Data'] as List<dynamic>;
        lat = data["Latitude"];
        lng = data["Longitude"];
        print("Data received: $data");

        Map<String, List<String>> animalLocations =
            {}; // Map animal types to their locations
        Set<String> uniqueTypes = {}; // Set to hold unique animal types

        for (var item in stateData) {
          String animalType = item['Animal_Type'];
          List locations = item['Locations'];

          uniqueTypes.add(animalType); // Add the animal type to the unique set

          // Add the locations to the map for the corresponding animal type
          animalLocations
              .putIfAbsent(animalType, () => [])
              .addAll(locations.map((loc) => loc.toString()));
        }

        // Create markers
        List<MarkerData> newMarkers =
            createMarkers(lat, lng, uniqueTypes.toList());

        // Create the legend items based on animal types and their locations
        List<Widget> legendItems = createLegendItems(animalLocations);

        if (mounted) {
          setState(() {
            markersData = newMarkers;
            animalLegend = legendItems;
            isLoading = false; // Set loading to false
          });
        }
      } else {
        if (mounted) {
          setState(() {
            productionData = 'Dati non validi ricevuti';
            markersData = [];
            isLoading = false;
            animalLegend = [];
          });
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          productionData = 'Errore nella connessione al server';
          markersData = [];
          isLoading = false;
          animalLegend = [];
        });
      }
    }
  }

  Future<void> fetchProductionDataProduct(String product) async {
    setState(() {
      isLoading = true; // Imposto lo stato di caricamento a true
    });

    try {
      print("Fetching data for product: $product");

      final response = await http.get(
        Uri.parse('http://127.0.0.1:8000/production_states?product=$product'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        // Estraggo latitudine e longitudine generali
        final stateData = data['States'] as List<dynamic>;

        print("Data received: $data");

        // Mappe e set per i dati
        Map<String, List<String>> animalLocations =
            {}; // Map di animali e località
        List<MarkerData> newMarkers = []; // Lista dei marker

        // Itero sui dati per creare marker e mappa delle località
        for (var state in stateData) {
          String stateName = state['State'];
          double? lat = state['Latitude'];
          double? lng = state['Longitude'];

          // Crea marker per lo stato
          if (lat != null && lng != null) {
            newMarkers.add(MarkerData(
              latitude: lat,
              longitude: lng,
              text: stateName,
              icon: const Icon(
                Icons.location_on,
                color: Colors.red,
                size: 40,
              ),
            ));
          }
          animalLocations.putIfAbsent(stateName, () => []);
        }

        // Crea elementi per la legenda basata sui tipi di animali
        List<Widget> legendItems = createLegendItems(animalLocations);

        // Aggiorno lo stato con i nuovi dati
        if (mounted) {
          setState(() {
            print("Popolamento leggenda...");
            markersData = newMarkers;
            animalLegend = legendItems;
            isLoading = false; // Fine del caricamento
          });
        }
      } else {
        // Gestione di errori per risposta non valida
        if (mounted) {
          setState(() {
            productionData = 'Dati non validi ricevuti';
            markersData = [];
            isLoading = false;
            animalLegend = [];
          });
        }
      }
    } catch (e) {
      // Gestione degli errori di connessione
      if (mounted) {
        setState(() {
          productionData = 'Errore nella connessione al server';
          markersData = [];
          isLoading = false;
          animalLegend = [];
        });
      }
    }
  }

// Method to create the legend items with locations for each animal type

  createLegendItems(Map<String, List<String>> animalLocations) {
    List<Widget> legendItems = [];

    animalLocations.forEach((animalType, locations) {
      print(
          'Adding legend for animal type: $animalType'); // Debug: Check if we are iterating through all animal types
      legendItems.add(
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                getIcon(animalType), // Icon for the animal
                const SizedBox(width: 8),
                Text(animalType,
                    style: const TextStyle(fontSize: 14, color: Colors.white)),
              ],
            ),
            const SizedBox(height: 4),
            if (locations.isNotEmpty)
              Text(
                "Località: ",
                style: TextStyle(color: Colors.white),
              ),
            Wrap(
              spacing: 4, // Space between items
              runSpacing: 4, // Space between rows
              children: locations.map((location) {
                return Text(
                  "$location, ",
                  style: const TextStyle(fontSize: 12, color: Colors.white),
                );
              }).toList(),
            ),
          ],
        ),
      );
    });

    print(
        'Total legend items: ${legendItems.length}'); // Debug: Check how many items are being added
    return legendItems;
  }

  Icon getIcon(String animalType) {
    // Restituisce l'icona associata o una di default se non trovata
    return animalIcons[animalType] ??
        const Icon(
          Icons.location_on,
          color: Colors.red,
          size: 40,
        );
  }

  List<MarkerData> createMarkers(
      double latitude, double longitude, List<String> typeAnimals) {
    print("Creando marker per ${typeAnimals.length} animali");

    return List.generate(typeAnimals.length, (i) {
      print("Creando marker: ${typeAnimals[i]} a ($latitude, $longitude)");
      return MarkerData(
          text: typeAnimals[i],
          latitude: latitude,
          longitude: longitude,
          icon: getIcon(typeAnimals[i]));
    });
  }

  List<String> getFilteredStates(String query) {
    return usaStates
        .where((state) => state.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }

  List<String> getFilteredProduct(String query) {
    return usaProduct
        .where((product) => product.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mappa Interattiva'),
        centerTitle: true,
        backgroundColor: Colors.teal,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextField(
                controller: stateController,
                decoration: const InputDecoration(
                  labelText: 'Cerca lo Stato',
                  labelStyle:
                      TextStyle(color: Colors.black), // Etichetta in nero
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black), // Bordo nero
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Colors.black), // Bordo nero abilitato
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Colors.black,
                        width: 2.0), // Bordo nero evidenziato
                  ),
                ),
                style: const TextStyle(
                    color: Colors.black), // Colore del testo in nero
                onChanged: (value) {
                  setState(() {
                    _showStateSuggestions = true;
                    _showProductSuggestions = false;
                  });
                },
              ),
              const SizedBox(height: 10),
              // Display filtered state suggestions
              if (_showStateSuggestions && stateController.text.isNotEmpty)
                ListView(
                  shrinkWrap: true,
                  children:
                      getFilteredStates(stateController.text).map((state) {
                    return Container(
                      color: Colors.white, // Sfondo bianco per la lista
                      child: ListTile(
                        title: Text(
                          state,
                          style: const TextStyle(
                              color: Colors.black), // Testo in nero
                        ),
                        onTap: () {
                          setState(() {
                            selectedState = state;
                            stateController.text = state;
                            _showStateSuggestions = false;
                          });
                        },
                      ),
                    );
                  }).toList(),
                ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  fetchProductionDataState(selectedState);
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
                child: const Text('Ricerca Produzione',
                    style: TextStyle(color: Colors.white)),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: productController,
                decoration: const InputDecoration(
                  labelText: 'Ricerca tipo allevamento o prodotto',
                  labelStyle:
                      TextStyle(color: Colors.black), // Etichetta in nero
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black), // Bordo nero
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Colors.black), // Bordo nero abilitato
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Colors.black,
                        width: 2.0), // Bordo nero evidenziato
                  ),
                ),
                style: const TextStyle(
                    color: Colors.black), // Colore del testo in nero
                onChanged: (value) {
                  setState(() {
                    _showProductSuggestions = true;
                    _showStateSuggestions = false;
                  });
                },
              ),
              const SizedBox(height: 10),

              // Visualizza i suggerimenti filtrati
              if (_showProductSuggestions && productController.text.isNotEmpty)
                ListView(
                  shrinkWrap: true,
                  children:
                      getFilteredProduct(productController.text).map((product) {
                    return Container(
                      color: Colors.white, // Sfondo bianco per la lista
                      child: ListTile(
                        title: Text(
                          product,
                          style: const TextStyle(
                              color: Colors.black), // Testo in nero
                        ),
                        onTap: () {
                          setState(() {
                            selectedProduct = product;
                            productController.text = product;
                            _showProductSuggestions = false;
                            state = true; // Nascondi i suggerimenti
                          });
                        },
                      ),
                    );
                  }).toList(),
                ),
              const SizedBox(height: 10),

              ElevatedButton(
                onPressed: () {
                  fetchProductionDataProduct(selectedProduct);
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
                child: const Text(
                  'Ricerca Stati',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              const SizedBox(height: 10),

              // Condizione di caricamento
              if (isLoading)
                Center(child: CircularProgressIndicator())
              else
                Container(
                  decoration: BoxDecoration(
                    color: Colors.black, // Sfondo nero
                    borderRadius: BorderRadius.circular(
                        10), // Arrotonda i bordi con un raggio di 10
                  ),
                  child: Row(
                    children: [
                      if (markersData.isEmpty)
                        // Mostra la mappa semplice se non ci sono marker e non sta caricando
                        Expanded(
                          child: const SizedBox(
                            height: 800,
                            width: double
                                .infinity, // Assicura che la mappa occupi tutta la larghezza
                            child: SimpleUSMap(),
                          ),
                        )
                      else if (markersData.isNotEmpty)

                        // Mostra la mappa con i marker e la legenda se ci sono marker e non sta caricando
                        Expanded(
                          child: SizedBox(
                            height: state
                                ? 800
                                : 1500, // Se 'state' è vero, l'altezza è 800, altrimenti 1500
                            width: 800, // Altezza e larghezza regolabili
                            child: USMapWithMarkers(
                                markersData: markersData, state: state),
                          ),
                        ),
                      if (!isLoading &&
                          markersData.isNotEmpty &&
                          animalLegend.isNotEmpty)
                        // Mostra la card con la legenda se ci sono marker e la legenda
                        Expanded(
                          child: Card(
                            elevation: 4,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            color: Colors.black, // Sfondo del Card nero
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                children: animalLegend,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                )
            ],
          ),
        ),
      ),
    );
  }
}
