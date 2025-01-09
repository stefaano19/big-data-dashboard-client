import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:latlong2/latlong.dart';
import 'package:progetto_big_data_frontend/views/components/pie_chart_source.dart';
import 'package:progetto_big_data_frontend/views/components/us_map.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int totalRows = 0;
  int totalColumns = 0;
  int census = 0; 
  int survey = 0; 
  String topState = '';
  int countState = 0;
  List<Map<String, dynamic>> topProducts = [];
  double latStateCoordinates = 0.0;
  double lgStateCoordinates = 0.0;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchDataOnce();
  }

  Future<void> fetchDataOnce() async {
    if (!isLoading) return;
    await fetchData();
  }

  Future<void> fetchData() async {
    try {
      await Future.wait([
        fetchTotalRows(),
        fetchTotalColumns(),
        fetchTopState(),
        fetchTopProducts(),
        fetchSource(),
      ]);
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
      print("Errore durante la richiesta: $e");
    }
  }

  Future<void> fetchTopProducts() async {
    try {
      final response =
          await http.get(Uri.parse('http://127.0.0.1:8000/top_products'));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);

        if (mounted) {
          setState(() {
            topProducts = data.map((item) {
              return {
                'Product': item['Product'],
                'Count': item['Count'],
              };
            }).toList();
            isLoading = false;
          });
        }
      } else {
        throw Exception('Errore nella richiesta: ${response.statusCode}');
      }
    } catch (e) {
      print('Errore durante il caricamento dei dati: $e');
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  Future<void> fetchSource() async {
    try {
      final response =
          await http.get(Uri.parse('http://127.0.0.1:8000/source'));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
      
        

        if (mounted) {
          setState(() {

            census = data["census_count"] ?? 0;
            survey = data["survey_count"] ?? 0;
            isLoading = false;
          });
        }
      } else {
        throw Exception('Errore nella richiesta: ${response.statusCode}');
      }
    } catch (e) {
      print('Errore durante il caricamento dei dati: $e');
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  Future<void> fetchTotalColumns() async {
    try {
      final response =
          await http.get(Uri.parse('http://127.0.0.1:8000/tot_columns'));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (mounted) {
          setState(() {
            totalColumns = data['tot_columns'] ??
                0; // Valore predefinito 0 se 'tot_colonne' è nullo
          });
        }
      } else {
        throw Exception('Errore HTTP: ${response.statusCode}');
      }
    } catch (e) {
      // Log dell'errore per debugging
      print('Errore durante la richiesta: $e');

      if (mounted) {
        setState(() {
          totalColumns = 0; // Imposta un valore predefinito in caso di errore
        });
      }
    }
  }

  Future<void> fetchTopState() async {
    try {
      final response =
          await http.get(Uri.parse('http://127.0.0.1:8000/top_state'));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (mounted) {
          setState(() {
            topState = data['State'] ?? "Dati non disponibili";
            countState = data['Count'] ?? 0;
            latStateCoordinates = data["Latitude"] ?? 0.0;
            lgStateCoordinates = data["Longitude"] ?? 0.0;
          });
        }
      } else {
        throw Exception('Errore HTTP: ${response.statusCode}');
      }
    } catch (e) {
      // Log dell'errore per debugging
      print('Errore durante la richiesta: $e');

      if (mounted) {
        setState(() {
          topState = "Errore nel caricamento";
          countState = 0;
          latStateCoordinates = 0.0;
          lgStateCoordinates = 0.0;
        });
      }
    }
  }

  Future<void> fetchTotalRows() async {
    final response =
        await http.get(Uri.parse('http://127.0.0.1:8000/tot_rows'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      totalRows = data['tot_rows'];
    } else {
      throw Exception('Fallimento nel caricare i dati');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
  title: const Text("Analisi del Dataset"),
  centerTitle: true,
  backgroundColor: Colors.teal,
  elevation: 0, // To remove the shadow
  shape: RoundedRectangleBorder(
    borderRadius: const BorderRadius.only(
      topLeft: Radius.circular(30),
      topRight: Radius.circular(30),
      bottomLeft: Radius.circular(30), // Adjust the radius as needed
      bottomRight: Radius.circular(30),
    ),
  ),
  flexibleSpace: Container(
    color: Colors.teal, // AppBar background color
  ),
),


      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  height: 60,
                  // Adjust this height as needed
                  child: Center(
                    child: const Text(
                      "Esplora i dati sulla produzione animale in America nel 2024.",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                    ),
                  )),
              const SizedBox(height: 20),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Immagine
                  Expanded(
                    flex: 2,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.asset(
                          "/Users/stefanobrusco/Downloads/ProgettoBigData/progetto_big_data_frontend/lib/assets/images/foto1.jpg",
                          height: 400,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),
                  // Card con informazioni
                  Expanded(
                    flex: 1,
                    child: Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Text(
                              "Informazioni sul dataset",
                              style: TextStyle(
                                fontStyle: FontStyle.italic,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.teal,
                              ),
                            ),
                            const SizedBox(height: 20),
                            buildRow("Totale righe: ", totalRows),
                            const SizedBox(height: 10),
                            buildRow("Totale colonne: ", totalColumns),
                            const SizedBox(height: 10),
            (census != 0 && survey != 0)
          ? PieChartSourceWidget(
              totalCensus: census,  // Esempio: numero di dati dal censimento
              totalSurveys: survey, // Esempio: numero di dati dai sondaggi
            )
          : const CircularProgressIndicator(color: Colors.white)

                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                height: 60,
                // Adjust this height as needed
                child: Center(
                  child: const Text(
                    "Lo Stato leader nella produzione animale nel 2024",
                    style: TextStyle(
                        fontSize: 18,
                        color: Colors.teal,
                        fontWeight: FontWeight.w600),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Container(
                height: 400,
                width: double
                    .infinity, // Usa double.infinity per larghezza massima
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    // Mappa che occuperà lo spazio rimanente
                    Expanded(
                      flex: 2,
                      child: isLoading
                          ? const Center(child: CircularProgressIndicator())
                          : topState.isNotEmpty
                              ? USMapWithMarkers(markersData: [
                                  MarkerData(
                                    text: topState,
                                    latitude: latStateCoordinates,
                                    longitude: lgStateCoordinates,
                                    icon: const Icon(
                                      Icons.location_on,
                                      color: Colors.red,
                                      size: 40,
                                    ),
                                  ),
                                ], state: true,)
                              : const Center(child: Text("No data available")),
                    ),
                    const SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Center(
                          child: Card(
                            elevation: 4,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  const SizedBox(height: 10),
                                  buildRow("Stato: ", topState),
                                  const SizedBox(height: 10),
                                  buildRow(
                                      "Record Dataset relativi al $topState: ",
                                      countState),
                                ],
                              ),
                            ),
                          ),
                        )
                      ],
                    ) // Distanza tra mappa e card
                    // Card con le informazioni
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  height: 60,
                  // Adjust this height as needed
                  child: Center(
                    child: const Text(
                      "Top Produzione animale",
                      style: TextStyle(
                          fontSize: 18,
                          color: Colors.teal,
                          fontWeight: FontWeight.w600),
                    ),
                  )),
              SizedBox(
                height: 10,
              ),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                height: 600, // Adjust this height as needed
                child: isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : topProducts.isEmpty
                        ? const Center(
                            child: Text("Nessun prodotto disponibile"))
                        : ListView.builder(
                            itemCount: topProducts.length,
                            itemBuilder: (context, index) {
                              final productData = topProducts[index];
                              return Card(
                                elevation: 4,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        productData['Product'],
                                        style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white),
                                      ),
                                      Text(
                                        "record: ${productData['Count'].toString()}",
                                        style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget buildRow(String label, dynamic value) {
    return Row(
      children: [
        Text(
          "$label",
          style: const TextStyle(
              fontSize: 18, fontWeight: FontWeight.bold, color: Colors.teal),
        ),
        const SizedBox(width: 8),
        value != '' && value != 0
            ? Text(
                "$value",
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              )
            : const CircularProgressIndicator(color: Colors.white),
      ],
    );
  }
}
