import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:fl_chart/fl_chart.dart';

class ProductData {
  final String name;
  final int count;

  ProductData({required this.name, required this.count});

  factory ProductData.fromJson(Map<String, dynamic> json) {
    return ProductData(
      name: json['name'],
      count: json['count'],
    );
  }
}

class ProductionPage extends StatefulWidget {
  @override
  _ProductionPageState createState() => _ProductionPageState();
}

class _ProductionPageState extends State<ProductionPage> {
  List<ProductData> productData = [];
  String year = '2023';
  String state = 'CALIFORNIA';
  final List<String> yearOptions = ['2022', '2023', '2024'];
  final List<String> stateOptions = ['CALIFORNIA', 'TEXAS', 'FLORIDA'];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    final Uri url = Uri.parse(
        'http://127.0.0.1:8000/production_by_state_year?year=$year&state=$state');

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final Map<String, dynamic> dataMap = data['Data'];

      setState(() {
        productData = dataMap.entries.map((entry) {
          return ProductData(name: entry.key, count: entry.value);
        }).toList();
      });
    } else {
      throw Exception('Failed to load data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Produzioni per Anno e Stato '),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: DropdownButton<String>(
                    value: year,
                    onChanged: (String? newValue) {
                      setState(() {
                        year = newValue!;
                      });
                      fetchData();
                    },
                    items: yearOptions
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    isExpanded: true,
                    hint: Text('Select Year'),
                    style: TextStyle(fontSize: 16, color: Colors.black),
                   
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: DropdownButton<String>(
                    value: state,
                    onChanged: (String? newValue) {
                      setState(() {
                        state = newValue!;
                      });
                      fetchData();
                    },
                    items: stateOptions
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    isExpanded: true,
                    hint: Text('Select State'),
                    style: TextStyle(fontSize: 16, color: Colors.black),
                    
                  ),
                ),
              ],
            ),
            SizedBox(height: 30),
            productData.isEmpty
                ? Center(child: CircularProgressIndicator())
                : Expanded(
                    child: BarChart(
                      BarChartData(
                        gridData: FlGridData(show: true, drawHorizontalLine: true),
                        titlesData: FlTitlesData(
                          bottomTitles: AxisTitles( sideTitles: SideTitles(showTitles: true)),
                          leftTitles:  AxisTitles( sideTitles: SideTitles(showTitles: false)),
                          rightTitles: AxisTitles( sideTitles: SideTitles(showTitles: true)),
                          topTitles: AxisTitles( sideTitles: SideTitles(showTitles: false)),
                        ),
                        borderData: FlBorderData(
                          show: true,
                          border: Border.all(color: Colors.black, width: 1),
                        ),
                        barGroups: productData
                            .map(
                              (item) => BarChartGroupData(
                                x: productData.indexOf(item),
                                barRods: [
                                  BarChartRodData(
                                    toY: item.count.toDouble(),
                                    color: Colors.teal,
                                    width: 16,
                                    borderRadius: BorderRadius.zero,
                                  ),
                                ],
                                showingTooltipIndicators: [0],
                              ),
                            )
                            .toList(),
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
