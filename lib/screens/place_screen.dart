import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:project_6/model/place.dart';
import 'package:project_6/screens/map_display_screen.dart';

class PlaceScreen extends StatelessWidget {
  PlaceScreen({super.key, required this.place});
  final Place place;
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    Widget? fileContent;
    Widget? locationContent;
    bool hasLocation = place.location != null;
    bool hasImage = place.file!=null;
    late Widget body;
    if (hasLocation) {
      locationContent = Column(mainAxisSize: MainAxisSize.min, children: [
        GestureDetector(
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (ctx)=> MapDisplayScreen(isSelecting: false, loc: LatLng(place.location!.latitude,place.location!.longitude),),),),
          child: CircleAvatar(
            backgroundImage: place.location!.image.image,
            radius: 80,
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal:30, vertical: 10),
          decoration: BoxDecoration(
            gradient:
                LinearGradient(colors: [Colors.transparent, (!hasImage)?Theme.of(context).colorScheme.background:Colors.black54],begin: Alignment.topCenter, end: Alignment.bottomCenter),
          ),
          child: Text(place.location!.formatted_address,textAlign: TextAlign.center, style: TextStyle(fontSize: 18, color: Colors.white),),
        )
      ]);
    }
    if (hasImage){
      fileContent = Image.file(
                  place.file!,
                  fit: BoxFit.cover,
                  height: double.infinity,
                  width: double.infinity,
                );
      body = Stack(
              children: [
                fileContent,
                if (hasLocation)
                Positioned(child: locationContent!, bottom: 0, left: 0, right: 0)
              ],);
              
    }else{
      body =  Center(
              child: (hasLocation)
                  ?  locationContent : Text(
                      place.name,
                      //textAlign: TextAlign.center,
                      style: TextStyle(
                        color: const Color.fromARGB(133, 255, 255, 255),
                        fontSize: 24,
                      ),
                    )
                  );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(place.name),
      ),
      body: body
    );
  }
}
