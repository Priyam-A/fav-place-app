import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project_6/model/place.dart';
import 'package:project_6/providers/places_list_provider.dart';
import 'package:project_6/screens/place_screen.dart';
import 'package:transparent_image/transparent_image.dart';

class ListItemWidget extends ConsumerWidget {
  ListItemWidget({super.key, required this.place});
  final Place place;
  ImageProvider get imageProvider{
    if (place.file==null){
      if(place.location==null){
        return MemoryImage(kTransparentImage);
      }
      return place.location!.image.image;
    }
    return FileImage(place.file!);
  }
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // TODO: implement build
    ref.watch(placesProvider);
    return Dismissible(
      key: ValueKey(place.id),
      onDismissed: (direction) {
        ref.read(placesProvider.notifier).removeItem(place);
      },
      child: ListTile(
        leading: CircleAvatar(backgroundImage: imageProvider),
        

          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (ctx) => PlaceScreen(
                  place: place,
                ),
              ),
            );
          },
          title: Text(
            place.name,
           style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          subtitle: Text( (place.location==null)?'':place.location!.formatted_address, style: TextStyle(color: Colors.white),),
        ),
 //     ),
    );
  }
}
