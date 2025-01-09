import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class MarkerData {
  final double latitude;
  final double longitude;
  final Icon icon;
  final String text;

  MarkerData({
    required this.text,
    required this.latitude,
    required this.longitude,
    required this.icon,
  });
}

class USMapWithMarkers extends StatefulWidget {
  final List<MarkerData> markersData; 
  final bool state;// Dati immutabili dei marker

  const USMapWithMarkers({
    super.key,
    required this.markersData, required this.state,
  });

  @override
  _USMapWithMarkersState createState() => _USMapWithMarkersState();
}

class _USMapWithMarkersState extends State<USMapWithMarkers> {
  late List<MarkerData> computedMarkers; // Marker calcolati
  late double mapCenterLatitude; // Centro della mappa
  late double mapCenterLongitude;

  @override
  void initState() {
    super.initState();

    // Inizializza marker e centro mappa
    if (widget.markersData.isNotEmpty) {
      final firstMarker = widget.markersData[0];
      mapCenterLatitude = firstMarker.latitude;
      mapCenterLongitude = firstMarker.longitude;

      // Se state è true, non calcolare i marker concentrici
      if (widget.state) {
        computedMarkers = widget.markersData;
      } else {
        // Calcola i marker disposti in modo concentrico
        computedMarkers = createConcentricMarkers(
          mapCenterLatitude,
          mapCenterLongitude,
          widget.markersData,
        );
      }

      print("Marker calcolati:");
      for (var marker in computedMarkers) {
        print(
            "Lat: ${marker.latitude}, Lng: ${marker.longitude}, Testo: ${marker.text}");
      }
    } else {
      // Valori predefiniti se non ci sono marker
      mapCenterLatitude = 37.8;
      mapCenterLongitude = -96.9;
      computedMarkers = []; // Lista vuota di marker
    }
  }


  List<MarkerData> createConcentricMarkers(
    double centerLat, double centerLng, List<MarkerData> markers) {
  const double initialRadius = 0.2; // Initial radius (in degrees)
  const double radiusIncrement = 0.1; // Increment of the radius for each circle
  const int baseMarkersPerCircle = 8; // Base number of markers for the first circle

  List<MarkerData> arrangedMarkers = [];
  int currentCircle = 0;
  int markersInCurrentCircle = 0;

  for (int i = 0; i < markers.length; i++) {
    // Calculate the radius for the current circle
    double radius = initialRadius + (currentCircle * radiusIncrement);

    // Increase the number of markers per circle as the circle grows
    int markersPerCircle = baseMarkersPerCircle + currentCircle; // Increase markers per circle as radius increases

    // Calculate the angle between the markers on the current circle
    double angle = (360 / markersPerCircle) * markersInCurrentCircle;
    double offsetLat = radius * sin(angle * pi / 180);
    double offsetLng = radius * cos(angle * pi / 180);

    // Create the marker at the calculated offset location
    arrangedMarkers.add(
      MarkerData(
        text: markers[i].text,
        latitude: centerLat + offsetLat,
        longitude: centerLng + offsetLng,
        icon: markers[i].icon,
      ),
    );

    markersInCurrentCircle++;
    if (markersInCurrentCircle >= markersPerCircle) {
      markersInCurrentCircle = 0;
      currentCircle++;
    }
  }

  return arrangedMarkers;
}


  @override
  Widget build(BuildContext context) {
    print("Rendering map with markers: ${widget.markersData.length} marker(s)");
    double initialZoomLevel = widget.state ? 5.0 : 8.0; // Zoom level based on state
    return FlutterMap(
      options: MapOptions(
        initialCenter: LatLng(mapCenterLatitude, mapCenterLongitude),
        initialZoom: initialZoomLevel // Zoom iniziale
      ),
      children: [
        TileLayer(
          urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
          subdomains: ['a', 'b', 'c'],
        ),
        MarkerLayer(
          markers: computedMarkers.map((marker) {
            print(
                "Aggiungendo marker: ${marker.text} a (${marker.latitude}, ${marker.longitude})");
            return Marker(
              point: LatLng(marker.latitude, marker.longitude),
              child: Tooltip(
                message: marker.text,
                child: marker.icon,
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
