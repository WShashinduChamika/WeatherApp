import 'package:demo4/screens/weather_screens/Weather.dart';
import 'package:demo4/services/database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class SimpleMap extends StatefulWidget {
  const SimpleMap({super.key});

  @override
  State<SimpleMap> createState() => _SimpleMapState();
}

class _SimpleMapState extends State<SimpleMap> {
  GoogleMapController? mapController;
  static const CameraPosition intialPostion = CameraPosition(
    target: LatLng(37.42796133580664, -122.045789655962),
    zoom: 14.0,
  );
  Set<Marker> markers = {};
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Simple Map'),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: intialPostion,
            zoomControlsEnabled: false,
            markers: markers,
            mapType: MapType.normal,
            onMapCreated: (GoogleMapController controller) {
              mapController = controller;
            },
          ),
          Positioned(
            left: 40.0,
            top: 50.0,
            child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const WeatherDetails()),
                  );
                },
                child: Text('go to weather ')),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          Position position = await _determinePosition();
          User? user = await FirebaseAuth.instance.currentUser;
          DatabaseService(uid: user!.uid).setLocation(
              position.latitude.toString(), position.longitude.toString());
          //print(position.latitude);
          //print(position.longitude);
          mapController?.animateCamera(
            CameraUpdate.newCameraPosition(
              CameraPosition(
                target: LatLng(position.latitude, position.longitude),
                zoom: 14.0,
              ),
            ),
          );
          markers.clear();
          markers.add(
            Marker(
              markerId: const MarkerId('current location'),
              position: LatLng(position.latitude, position.longitude),
            ),
          );
          setState(() {});
        },
        label: const Text('current location'),
        icon: const Icon(Icons.location_city_outlined),
      ),
    );
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    //
    if (!serviceEnabled) {
      return Future.error("Location is not enabled");
    }
    //
    permission = await Geolocator.checkPermission();
    //
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('locatiion is denide');
      }
    }
    //
    Position position = await Geolocator.getCurrentPosition();
    return position;
  }
}
