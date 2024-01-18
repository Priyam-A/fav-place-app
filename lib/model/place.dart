import 'dart:io';

import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
//import 'package:uuid/uuid.dart';

class PlaceLocation{
  PlaceLocation({required this.latitude, required this.longitude, required this.formatted_address});
  final double latitude;
  final double longitude;
  String formatted_address;
  Image get image{
    return Image.network('https://maps.googleapis.com/maps/api/staticmap?center=$latitude,$longitude&zoom=12&size=600x300&maptype=roadmap&markers=color:red%12Clabel:S%7C$latitude,$longitude&key=API_KEY',
            fit: BoxFit.cover,
            height: double.infinity,
            width: double.infinity,);
  }
}
class Place {
  Place({required this.name, this.file, this.location, String? id}): id = id??Uuid().v4();
  final String id;
  final String name;
  final File? file;
  final PlaceLocation? location;
}
