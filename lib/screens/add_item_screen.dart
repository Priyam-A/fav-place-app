import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project_6/model/place.dart';
import 'package:project_6/providers/places_list_provider.dart';
import 'package:project_6/widgets/select_image.dart';
import 'package:project_6/widgets/select_location.dart';

class AddItemScreen extends ConsumerWidget {
  AddItemScreen({super.key});
  final formKey = GlobalKey<FormState>();
  File? _file;
  PlaceLocation? _placeLocation;
  void save(BuildContext context) {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
      Navigator.of(context).pop();
    }
  }

  void getFile(File?  file){
    _file = file;
  }
  
  void getLocation(PlaceLocation? placeLocation){
    _placeLocation = placeLocation;
  }
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Item'),
      ),
      body: SingleChildScrollView(
        child: Column(
          
          children: [Form( 
            key: formKey,
            child: 
              TextFormField(
                style: TextStyle(color: Colors.white, fontSize: 20),
                maxLength: 50,
                decoration: InputDecoration(
                  label: Text(
                    'Enter favourite place',
                  ),
                ),
                validator: (value) {
                  if (value != null && value.trim().isNotEmpty) {
                    return null;
                  } else {
                    return 'Please enter a valid value';
                  }
                },
                onSaved: (newValue) {
                  ref.read(placesProvider.notifier).addItem(
                        Place(name: newValue!, file: _file, location: _placeLocation),
                      );
                },
              ),
          ),
              ImageSelector(getFile: getFile,),
              LocationSelector(getLocation: getLocation),
              ElevatedButton.icon(
                onPressed: (){save(context);},
                label: Text('Add place'),
                icon: Icon(Icons.add),
              )
            ],
          ),
      ),
      );
  }
}
