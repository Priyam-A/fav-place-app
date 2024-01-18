//import 'dart:io';

import 'dart:convert';
//import 'dart:html';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:http/http.dart' as http;
import 'package:project_6/model/place.dart';
import 'package:project_6/screens/map_display_screen.dart';
//import 'package:image_picker/image_picker.dart';

class LocationSelector extends StatefulWidget {
  LocationSelector({super.key, required this.getLocation});
  final void Function(PlaceLocation? placeLocation) getLocation;
  @override
  State<LocationSelector> createState() => _LocationSelectorState();
}

class _LocationSelectorState extends State<LocationSelector> {
  bool isLoading = false;
  PlaceLocation? loc;
  bool isError = false;
  //Location? location;
  void getLocation() async {
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
      isLoading = true;
    });
    locationData = await location.getLocation();
    if (locationData.latitude == null || locationData.longitude == null) {
      setState(() {
        isError = true;
      });
    }
    final url = Uri.parse(
        'https://maps.googleapis.com/maps/api/geocode/json?latlng=${locationData.latitude},${locationData.longitude}&key=API_KEY');
    final response = await http.get(url);
    final data = json.decode(response.body);
    loc = PlaceLocation(
        latitude: locationData.latitude!,
        longitude: locationData.longitude!,
        formatted_address: data['results'][0]['formatted_address']);
    widget.getLocation(loc);
    setState(() {
      isLoading = false;
    });
  }
  
  void selectLocation(LatLng location) async{
    final url = Uri.parse(
        'https://maps.googleapis.com/maps/api/geocode/json?latlng=${location.latitude},${location.longitude}&key=API_KEY');
    final response = await http.get(url);
    final data = json.decode(response.body);
    loc = PlaceLocation(
        latitude: location.latitude,
        longitude: location.longitude,
        formatted_address: data['results'][0]['formatted_address']);
    widget.getLocation(loc);
    setState(() {
      isLoading = false;
    });
  }
  

  void onLocationTap() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
            title: const Text('Select option'),
            children: [
              SimpleDialogOption(
                onPressed: () {
                  Navigator.pop(context);
                  getLocation();
                },
                child: const Text('Add photo from gallery'),
              ),
              /*
          SimpleDialogOption(
            onPressed: () { Navigator.pop(context); getLocation(); },
            child: const Text('Take photo'),
          ),
          */
              SimpleDialogOption(
                onPressed: () {
                  Navigator.pop(context);
                  setState(() {
                    loc = null;
                  });
                  widget.getLocation(null);
                },
                child: const Text('Remove image'),
              ),
              SimpleDialogOption(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('close'),
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    Widget content =
        Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
      ElevatedButton.icon(
        onPressed: () {
          getLocation();
        },
        icon: Icon(Icons.location_on),
        label: Text("Current Location"),
      ),
      //SizedBox(width: 20),
      ElevatedButton.icon(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (ctx) => MapDisplayScreen(isSelecting: true,getData: selectLocation),
            ),
          );
        },
        icon: Icon(Icons.map),
        label: Text("Choose Location"),
      )
    ]);
    if (isLoading) {
      content = CircularProgressIndicator();
    }
    if (loc != null) {
      content = GestureDetector(onTap: () {}, child: loc!.image);
    }
    if (isError) {
      content = Column(children: [
        Text(
          "Something went wrong!",
        ),
        SizedBox(height: 10),
        content
      ]);
    }
    return Container(
      margin: EdgeInsets.all(20),
      decoration: BoxDecoration(
        border: Border.all(
            width: 1,
            color: Theme.of(context).colorScheme.onBackground.withOpacity(0.6)),
      ),
      height: 180,
      width: double.infinity,
      alignment: Alignment.center,
      child: content,
    );
  }
}
