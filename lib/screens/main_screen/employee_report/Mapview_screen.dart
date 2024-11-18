import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapviewScreen extends StatefulWidget {
  final double latitude;
  final double longitude;

  const MapviewScreen({Key? key, required this.latitude, required this.longitude}) : super(key: key);

  @override
  _MapviewScreenState createState() => _MapviewScreenState();
}

class _MapviewScreenState extends State<MapviewScreen> {
  late GoogleMapController _controller;
  Set<Marker> _markers = {};

  @override
  void initState() {
    super.initState();
    _loadMarker(widget.latitude, widget.longitude);
  }

  // Load the marker for a single location
  void _loadMarker(double latitude, double longitude) {
    Set<Marker> tempMarkers = {};

    // Add the marker for the single location
    tempMarkers.add(
      Marker(
        markerId: MarkerId('marker_0'),
        position: LatLng(latitude, longitude),
        infoWindow: InfoWindow(
          title: "Location",
          snippet: "Latitude: $latitude, Longitude: $longitude",
        ),
      ),
    );

    // Update the markers on the map
    setState(() {
      _markers = tempMarkers;
    });

    // Center the map on the passed latitude and longitude
    _centerMapToLocation(latitude, longitude);
  }

  // Function to center the map on the passed latitude and longitude
  void _centerMapToLocation(double latitude, double longitude) async {
    _controller.animateCamera(CameraUpdate.newLatLngZoom(
      LatLng(latitude, longitude),
      14.4746, // Adjust zoom level as needed
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Map View'),
      ),
      body: GoogleMap(
        zoomControlsEnabled: true,
        initialCameraPosition: CameraPosition(
          target: LatLng(widget.latitude, widget.longitude), // Use passed latitude and longitude
          zoom: 14.4746,
        ),
        onMapCreated: (GoogleMapController controller) {
          _controller = controller;

          // Center the map to the given coordinates once the map is created
          _centerMapToLocation(widget.latitude, widget.longitude);
        },
        markers: _markers,
        myLocationEnabled: true,
        zoomGesturesEnabled: true,
        scrollGesturesEnabled: true,
        tiltGesturesEnabled: true,
        rotateGesturesEnabled: true,
      ),
    );
  }
}
