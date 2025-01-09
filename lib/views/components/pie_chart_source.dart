import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';

class PieChartSourceWidget extends StatelessWidget {
  final int totalCensus;  // Numero di dati dal censimento
  final int totalSurveys; // Numero di dati dai sondaggi

  PieChartSourceWidget({
    required this.totalCensus,
    required this.totalSurveys,
  });

  @override
  Widget build(BuildContext context) {
    // Calcola i valori da visualizzare
    final total = totalCensus + totalSurveys;

    // Crea una mappa dei dati per il grafico a torta
    Map<String, double> dataMap = {
      "Censimento": (totalCensus / total) * 100,
      "Sondaggi": (totalSurveys / total) * 100,
    };

    return PieChart(
      dataMap: dataMap,
      chartType: ChartType.ring, // Imposta il tipo di grafico (puoi anche usare ChartType.disc)
      colorList: [
        Colors.blue, // Colore per "Censimento"
        Colors.green, // Colore per "Sondaggi"
      ],
      chartRadius: MediaQuery.of(context).size.width / 6, // Regola la dimensione
      centerText: "Fonti:", // Testo al centro del grafico
      legendOptions: LegendOptions(
        legendTextStyle: TextStyle(color: Colors.white),
        showLegends: true, // Mostra le legende
        legendPosition: LegendPosition.left, // Posizione della legenda
      ),
    );
  }
}
