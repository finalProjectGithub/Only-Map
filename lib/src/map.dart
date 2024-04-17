// ignore: unused_import
import 'package:flutter/material.dart';
import 'package:mapbox_gl/mapbox_gl.dart';

class maps extends StatefulWidget {
  const maps({super.key});
    @override
  State createState() => FullMapState();
}
 class FullMapState extends State<maps> {
  MapboxMapController? mapController;
  var isLight = true;

  _onMapCreated(MapboxMapController controller) {
    mapController = controller;
  }



  @override
  Widget build(BuildContext context) {
    return  Scaffold(body: MapboxMap(
          accessToken: const String.fromEnvironment("pk.eyJ1IjoiYS1hZGl0eWEwMDciLCJhIjoiY2x1d3FnemkyMGdyMDJrcXJ4eWFoNzNzcCJ9.RTnlwCsLzU7g9vYkQ442GQ"),
          onMapCreated: _onMapCreated,
          initialCameraPosition: const CameraPosition(target: LatLng(12.9716, 77.5946)),
         
        ),);
  }
}