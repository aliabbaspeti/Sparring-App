
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';



const LatLng currentLocation = LatLng(24.8937, 67.2163); 
// ignore: must_be_immutable
class Staticmap extends StatelessWidget {
  Staticmap({super.key, required this.location});
  final String location;
   
   String latitude = '';
   String longitude = '';
  final String apiKey = 'AIzaSyArLwdj4n4U2gZShrEaBLO7mPlzrhSjq1k';
  
  @override
  Widget build(BuildContext context) {
    // List<String> locationParts = location.split(',');
    // latitude = locationParts.isNotEmpty ? locationParts[0].trim() : '';
    // longitude = locationParts.length > 1 ? locationParts[1].trim() : '';
    // String staticMapUrl =
    //   'https://maps.googleapis.com/maps/api/staticmap?center=25.3643184,55.3982258&zoom=14&size=400x300&markers=color:red%7Clabel:A%7C25.3643184,55.3982258&key=AIzaSyArLwdj4n4U2gZShrEaBLO7mPlzrhSjq1k';

    return const Scaffold(
      body: GoogleMap(
        initialCameraPosition: CameraPosition(target: currentLocation,
        zoom: 14),
      ),
    );
  }
}

