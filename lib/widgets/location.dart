import 'package:flutter/material.dart';
// import 'package:geolocator/geolocator.dart';
import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../models/project_model.dart';

import 'package:location/location.dart';

class LocationScreen extends StatefulWidget {
  const LocationScreen({super.key, required this.onSelectLocation});
  final void Function(ProjectLocation location) onSelectLocation;

  @override
  _LocationScreenState createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  final String _currentLocation = 'Unknown';

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  ProjectLocation? _pickedlocation;
  var _isGettingLocation = false;

  String get locationImage {
    if (_pickedlocation == null) {
      return '';
    }
    final lat = _pickedlocation!.latitude;
    final long = _pickedlocation!.longitude;
    return 'https://maps.googleapis.com/maps/api/staticmap?center=$lat,$long&zoom=13&size=600x300&maptype=roadmap&markers=color:blue%7Clabel:A%7C$lat,$long&key=YOUR_API_KEY&signature=YOUR_SIGNATURE';
  }

  Future<void> _getCurrentLocation() async {
    Location location = Location();

    bool serviceEnabled;
    PermissionStatus permissionGranted;
    LocationData locationData;

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return;
      }
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return;
      }
    }
    setState(() {
      _isGettingLocation = true;
    });

    locationData = await location.getLocation();
    final lat = locationData.latitude;
    final long = locationData.longitude;

    if (lat == null || long == null) {
      return;
    }

    final url = Uri.parse(
        'https://maps.googleapis.com/maps/api/geocode/json?latlng=$lat,$long&key=YOUR_API_KEY');
    final response = await http.get(url);
    final resData = json.decode(response.body);
    final address = resData['results'][0]['formatted_address'];

    setState(() {
      _pickedlocation =
          ProjectLocation(latitude: lat, longitude: long, address: address);
      _isGettingLocation = false;
    });

    widget.onSelectLocation(_pickedlocation!);
    print(locationData.latitude);
    print(locationData.longitude);
  }

  void _selectLocationOnMap() {
    // Implement your logic for selecting location on the map
  }

  @override
  Widget build(BuildContext context) {
    Widget previewContent = const Text('No Location Chosen');
    if (_isGettingLocation) {
      previewContent = const CircularProgressIndicator();
    }

    if (_pickedlocation != null) {
      previewContent = Image.network(locationImage,
          fit: BoxFit.cover, width: double.infinity, height: double.infinity);
    }

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Current Location:'),
            // Text(
            //   // _currentLocation,
            //   style: TextStyle(
            //     fontSize: 18,
            //     fontWeight: FontWeight.bold,
            //   ),
            // ),
            Container(
              height: 300,
              width: 400,
              decoration: BoxDecoration(border: Border.all()),
              child: previewContent,
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.location_on),
                  onPressed: _getCurrentLocation,
                ),
                IconButton(
                  icon: const Icon(Icons.map),
                  onPressed: _selectLocationOnMap,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
