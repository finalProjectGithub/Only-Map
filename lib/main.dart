import 'package:flutter/material.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:location/location.dart';
import 'dart:async';
import 'dart:math';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MapboxMapPage(),
    );
  }
}

class CoordinatesWidget extends StatelessWidget {
  final double latitude;
  final double longitude;

  const CoordinatesWidget({
    required this.latitude,
    required this.longitude,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10.0),
      color: Colors.white,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Latitude: $latitude',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 5.0),
          Text(
            'Longitude: $longitude',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}

class ColorBlock extends StatefulWidget {
  @override
  _ColorBlockState createState() => _ColorBlockState();
}

class _ColorBlockState extends State<ColorBlock> {
  late Timer _timer;
  final _random = Random();
  int _randomNumber = 0;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        _randomNumber = _random.nextInt(31); // Generate a random number between 0 and 30
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  Color _getColor() {
    if (_randomNumber > 15) {
      return Colors.red;
    } else if (_randomNumber < 8) {
      return Colors.green;
    } else {
      return Colors.yellow;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 50,
      height: 50,
      color: _getColor(),
    );
  }
}

class MapboxMapPage extends StatefulWidget {
  @override
  _MapboxMapPageState createState() => _MapboxMapPageState();
}

class _MapboxMapPageState extends State<MapboxMapPage> {
  late MapboxMapController mapController;
  late LocationData currentLocation;
  late Location location;
  Symbol? currentSymbol;

  void _onMapCreated(MapboxMapController controller) {
    mapController = controller;
  }

  void _zoomIn() {
    mapController.animateCamera(CameraUpdate.zoomIn());
  }

  void _zoomOut() {
    mapController.animateCamera(CameraUpdate.zoomOut());
  }

  Future<void> _getCurrentLocation() async {
    try {
      currentLocation = await location.getLocation();
      _updateLocationOnMap();
    } catch (e) {
      print("Error getting location: $e");
    }
  }

  void _updateLocationOnMap() async {
    if (currentLocation != null) {
      final double lat = currentLocation.latitude ?? 0.0;
      final double lng = currentLocation.longitude ?? 0.0;
      mapController.animateCamera(
        CameraUpdate.newLatLng(
          LatLng(lat, lng),
        ),
      );

      // Add a marker at the current location
      currentSymbol = await mapController.addSymbol(
        SymbolOptions(
          geometry: LatLng(lat, lng),
          iconImage: 'car-15',
          iconSize: 2,
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    location = Location();
    location.onLocationChanged.listen((LocationData currentLocation) {
      setState(() {
        this.currentLocation = currentLocation;
        _updateLocationOnMap();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          MapboxMap(
            accessToken: "pk.eyJ1IjoiYS1hZGl0eWEwMDciLCJhIjoiY2x1d3FnemkyMGdyMDJrcXJ4eWFoNzNzcCJ9.RTnlwCsLzU7g9vYkQ442GQ",
            onMapCreated: _onMapCreated,
            initialCameraPosition: const CameraPosition(
              target: LatLng(45.5231, -122.6765),
              zoom: 11.0,
            ),
          ),
          Positioned(
            top: 20.0,
            right: 20.0,
            child: Column(
              children: [
                FloatingActionButton(
                  onPressed: _zoomIn,
                  child: Icon(Icons.add),
                ),
                SizedBox(height: 10.0),
                FloatingActionButton(
                  onPressed: _zoomOut,
                  child: Icon(Icons.remove),
                ),
                SizedBox(height: 10.0),
                FloatingActionButton(
                  onPressed: _getCurrentLocation,
                  child: Icon(Icons.location_on),
                ),
              ],
            ),
          ),
          Positioned(
            top: 20.0,
            left: 20.0,
            child: ColorBlock(),
          ),
          Positioned(
            bottom: 20.0,
            left: 20.0,
            child: CoordinatesWidget(
              latitude: currentLocation.latitude ?? 0.0,
              longitude: currentLocation.longitude ?? 0.0,
            ),
          ),
        ],
      ),
    );
  }
}
