import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';

class PieChartSupportWidget extends StatelessWidget {
  final double support;  // Supporto in percentuale, ad esempio 50 per il 50%

  PieChartSupportWidget({
    required this.support,
  });

  @override
  Widget build(BuildContext context) {
    // Calcola il non supporto come la parte rimanente
    double nonSupport = 100 - (support*100);

    // Crea una mappa dei dati per il grafico a torta
    Map<String, double> dataMap = {
      "Supporto": (support*100),
      "Non Supporto": nonSupport,
    };

    return PieChart(
      dataMap: dataMap,
      chartType: ChartType.ring,
      chartRadius: MediaQuery.of(context).size.width / 8, // Ridotto per farlo più piccolo // Imposta il tipo di grafico (puoi anche usare ChartType.disc)
      colorList: [
        Colors.teal,  // Colore per il supporto
        Colors.grey,   // Colore per il non supporto
      ], // Regola la dimensione
      centerText: "Supporto: ${support.toStringAsFixed(2)}%", // Testo al centro del grafico
      legendOptions: LegendOptions(
        legendTextStyle: TextStyle(color: Colors.white),
        showLegends: true, // Mostra le legende
        legendPosition: LegendPosition.left, // Posizione della legenda
      ),
    );
  }
}
