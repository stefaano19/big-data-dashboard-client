import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class SimpleUSMap extends StatefulWidget {


  const SimpleUSMap({Key? key}) : super(key: key);

  @override
  _SimpleUSMapState createState() => _SimpleUSMapState();
}

class _SimpleUSMapState extends State<SimpleUSMap> {
  late double mapCenterLatitude = 37.8;
  late double mapCenterLongitude = -96.9;

  @override
  void initState() {
    super.initState();
    // Optionally, set map center based on the data or keep the default
  }

  @override
  Widget build(BuildContext context) {
    // Create a list of markers based on widget data

    return Scaffold(
      body: FlutterMap(
        options: MapOptions(
          initialCenter: LatLng(mapCenterLatitude, mapCenterLongitude),
          initialZoom: 5, // Initial zoom level
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
            subdomains: ['a', 'b', 'c'],
          ),
          MarkerLayer(
            markers: [], // Add markers to the map
          ),
        ],
      ),
    );
  }
}

