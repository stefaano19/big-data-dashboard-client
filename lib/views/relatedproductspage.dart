import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:progetto_big_data_frontend/views/components/pie_chart_support.dart';

class RelatedProductsPage extends StatefulWidget {
  const RelatedProductsPage({Key? key}) : super(key: key);

  @override
  _RelatedProductsPageState createState() => _RelatedProductsPageState();
}

class _RelatedProductsPageState extends State<RelatedProductsPage> {
  List<dynamic> associationRulesData = [];
  bool isLoading = true;

  Map<String, String> animalVerbs = {
    "Acquacoltura": "pratica",
    "Fagiani": "alleva",
    "Conigli": "alleva",
    "Cavalli": "alleva",
    "Miele": "produce",
    "Galline": "alleva",
    "Grasso": "produce",
    "Pecore e Capre": "alleva",
    "Pesca Sportiva": "pratica",
    "Bestiame": "alleva",
    "Pollame": "alleva",
    "Mellorina": "produce",
    "Maiali": "alleva",
    "Animali": "alleva",
    "Emu": "alleva",
    "Agnelli e Montoni": "alleva",
    "Acqua": "produce",
    "Latte": "produce",
    "Anatre": "alleva",
    "Pesci Ornamentali": "alleva",
    "Manzi": "alleva",
    "Carne Rossa": "produce",
    "Alpaca": "alleva",
    "Burro": "produce",
    "Ghiaccio": "produce",
    "Siero di Latte": "produce",
    "Panna": "produce",
    "Lama": "alleva",
    "Lana": "produce",
    "Cervi": "alleva",
    "Latticello": "produce",
    "Granita": "produce",
    "Animali Speciali": "alleva",
    "Yogurt": "produce",
    "Vitelli": "alleva",
    "Pesce": "alleva",
    "Molluschi": "alleva",
    "Crostacei": "alleva",
    "Totale Animali": "alleva",
    "Formaggio": "produce",
    "Pesce e Vongole Giganti": "alleva",
    "Gelati": "produce",
    "Mohair": "alleva",
    "Struzzi": "alleva",
    "Oche": "alleva",
    "Bovini": "alleva",
    "Nandu": "alleva",
    "Alci": "alleva",
    "Farina": "produce",
    "Pratiche": "alleva",
    "Pesci da Esca": "alleva",
    "Strutto": "produce",
    "Totale Animali Speciali": "alleva",
    "Piccioni": "alleva",
    "Bisonti": "alleva",
    "Tacchini": "alleva",
    "Mangime": "produce",
    "Chukar": "alleva",
    "Pernici": "alleva",
    "Pecore": "alleva",
    "Quaglie": "alleva",
    "Visoni": "alleva",
    "Prodotti Lattiero-caseari": "produce",
    "Capre": "alleva",
    "Grassi di Pollame": "produce",
    "Uova": "produce",
    "Sego": "produce",
    "Carabao": "alleva",
    "Prodotti Animali": "produce",
    "Cera d'Api": "produce",
  };

  @override
  void initState() {
    super.initState();
    fetchAssociationRules();
  }

  Future<void> fetchAssociationRules() async {
    try {
      final response =
          await http.get(Uri.parse('http://127.0.0.1:8000/association_rules'));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (mounted) {
          setState(() {
            associationRulesData = data[
                'association_rules']; // Assumendo che la risposta sia una lista di regole
            isLoading = false;
          });
        }
      } else {
        throw Exception('Errore HTTP: ${response.statusCode}');
      }
    } catch (e) {
      print('Errore durante la richiesta: $e');
      if (mounted) {
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
        title: const Text("Produzioni correlate"),
        backgroundColor: Colors.teal,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : associationRulesData.isEmpty
                ? const Center(child: Text("Nessuna regola disponibile"))
                : ListView.builder(
                    itemCount: associationRulesData.length,
                    itemBuilder: (context, index) {
                      final rule = associationRulesData[index];
                      return buildAssociationRuleCard(rule);
                    },
                  ),
      ),
    );
  }

Widget buildAssociationRuleCard(Map<String, dynamic> rule) {
  // Ottieni le liste di antecedent e consequent
  final antecedentList = rule['antecedent'] ?? [];
  final consequentList = rule['consequent'] ?? [];
  final confidence = rule['confidence'] ?? 'N/D';
  final support = rule['support'] ?? 'N/D';

  // Calcola le percentuali di confidence e support
  final double confidenceValue = (confidence != null && confidence is double) ? confidence : 0.0;
  final double supportValue = (support != null && support is double) ? support : 0.0;

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
          // Descrizione principale
          Text(
            "Uno Stato Americano che:",
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          // Visualizzazione degli antecedenti
          Row(
            children: [
              Text(
                "Antecedente/i:",
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.teal,
                ),
              ),
              Text(
                "${antecedentList.map((antecedent) => '${animalVerbs[antecedent] ?? antecedent} ($antecedent)').join(', ')}",
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          // Visualizzazione dei conseguenti
          Row(
            children: [
              Text(
                "Conseguente/i: ",
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.teal,
                ),
              ),
              Text(
                "${consequentList.map((consequent) => '${animalVerbs[consequent] ?? consequent} ($consequent)').join(', ')}",
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          // Percentuale di confidence
          Text(
            "Con una probabilità del ${confidence != null ? (confidenceValue * 100).toStringAsFixed(2) + "%" : 'N/D'}",
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 4),
          // Lift e Support
          Text(
            "${support != null ? (supportValue * 100).toStringAsFixed(2) + '% delle transizioni contiene questa combinazione ': 'N/D'}",
            style: const TextStyle(
              fontSize: 16,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          // Aggiungi il grafico a torta (PieChart)
          Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: PieChartSupportWidget(support: support)
          ),
        ],
      ),
    ),
  );
}



}