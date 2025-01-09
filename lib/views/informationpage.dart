import 'package:flutter/material.dart';
import 'package:progetto_big_data_frontend/views/datapage.dart';
import 'package:progetto_big_data_frontend/views/productionpage.dart';
import 'package:progetto_big_data_frontend/views/relatedproductspage.dart';

class InformationPage extends StatelessWidget {
  const InformationPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Informazioni Dettagliate"),
        backgroundColor: Colors.teal,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // Numero di card per riga
            crossAxisSpacing: 16.0, // Spaziatura orizzontale tra le card
            mainAxisSpacing: 16.0, // Spaziatura verticale tra le card
            childAspectRatio: 1.5, // Rapporto larghezza/altezza delle card
          ),
          itemCount: 3, // Numero di card
          itemBuilder: (context, index) {
            return buildCard(context, index);
          },
        ),
      ),
    );
  }

  Widget buildCard(BuildContext context, int index) {
    String cardTitle;
    String cardSubtitle;
    void Function()? onTap;

    switch (index) {
      case 0:
        cardTitle = "Dati per Anno";
        cardSubtitle = "Visualizza quanti dati sono stati raccolti ogni anno";
        onTap = () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const DataPage()),
          );
        };
        break;
      case 1:
        cardTitle = "Produzioni correlate";
        cardSubtitle = "Visualizza tutte le correlazioni fra le varie produzioni dei Paesi";
        onTap = () {
           Navigator.push(
           context,
            MaterialPageRoute(builder: (context) => RelatedProductsPage()),
          );
        };
        break;
      case 2:
        cardTitle = "Un'Altra Pagina";
        cardSubtitle = "Vai a un'altra pagina";
        onTap = () {
          Navigator.push(
          context,
            MaterialPageRoute(builder: (context) => ProductionPage()),
           );
        };
        break;
      default:
        cardTitle = "Default";
        cardSubtitle = "Descrizione non disponibile";
        onTap = () {};
    }

    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                cardTitle,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.teal,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                cardSubtitle,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
