import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class DataPage extends StatefulWidget {
  const DataPage({Key? key}) : super(key: key);

  @override
  _DataPageState createState() => _DataPageState();
}

class _DataPageState extends State<DataPage> {
  List<dynamic> yearsData = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchDataYears();
  }

  Future<void> fetchDataYears() async {
    try {
      final response =
          await http.get(Uri.parse('http://127.0.0.1:8000/data_years'));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if(mounted){
          setState(() {
          yearsData = data; // Assumendo che data sia una lista di oggetti
          isLoading = false;
        });
        }
        
      } else {
        throw Exception('Errore HTTP: ${response.statusCode}');
      }
    } catch (e) {
      print('Errore durante la richiesta: $e');
      if(mounted){
         setState(() {
        isLoading = false;
      });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Dati raccolti per ogni anno"),
        backgroundColor: Colors.teal,
        centerTitle: true,
      ),
      body: Padding(
  padding: const EdgeInsets.all(16.0),
  child: isLoading
      ? const Center(child: CircularProgressIndicator())
      : yearsData.isEmpty
          ? const Center(child: Text("Nessun dato disponibile"))
          : GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4, // Numero di card per riga
                crossAxisSpacing: 16.0, // Spaziatura orizzontale tra le card
                mainAxisSpacing: 16.0, // Spaziatura verticale tra le card
                childAspectRatio: 2.2, // Rapporto larghezza/altezza delle card
              ),
              itemCount: yearsData.length,
              itemBuilder: (context, index) {
                final yearData = yearsData[index];
                return buildYearCard(yearData);
              },
            ),
),

    );
  }

  Widget buildYearCard(Map<String, dynamic> yearData) {
    final year = yearData['Year'] ?? 'Anno non disponibile';
    final count = yearData['Count'] ?? 0;


    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
              "Anno: ",
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.teal,
              ),
            ),
            SizedBox(width: 2,),
            Text(
              "$year",
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
              ],
            ),
            const SizedBox(height: 8),
            buildRow("Conteggio: ", count),
            const SizedBox(height: 16),
          ],
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
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.teal,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          "$value",
          style: const TextStyle(fontSize: 16, color: Colors.white),
        ),
      ],
    );
  }
}
