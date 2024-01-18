import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project_6/model/place.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart' as pathProvider;
import 'package:sqflite/sqflite.dart' as sql;
import 'package:sqflite/sqlite_api.dart';
int _debug=0;
class PlacesListNotifier extends StateNotifier<List<Place>> {
  PlacesListNotifier() : super([]);
  Future<Database> getDataBase() async {
    final dbPath = await sql.getDatabasesPath();
    return sql.openDatabase(
      path.join(dbPath, 'places.db'),
      onCreate: (db, version) {db.execute(
          'CREATE TABLE user_places (id TEXT PRIMARY KEY, title TEXT, image TEXT, lat REAL, lng REAL, address TEXT)');},
      version: 1,
    );
    //return db;
  }

  Future<void> loadItems() async {
    final db = await getDataBase();
    //print('ok1');
    final data = await db.query('user_places');
    print('a ${++_debug}');
    final places = data
        .map(
          (row){print(row);return Place(
              name: row['title'] as String,
              file:
                  (row['image'] == null) ? null : File(row['image'] as String),
              location: (row['lat']==null)? null:PlaceLocation(
                latitude: row['lat'] as double,
                longitude: row['lng'] as double,
                formatted_address: row['formatted_address'] as String,
              ),
              id: row['id'] as String);
          }
        );
        print('ok3 ${++_debug} ${places.toList().length}');
        state = places.toList();
  }

  void addItem(Place place) async {
    File? copiedImage;
    String? filename;
    //final result = await sql.getDatabasesPath();
    if (place.file != null) {
      final directory = await pathProvider.getApplicationDocumentsDirectory();
      filename = path.basename(place.file!.path);
      copiedImage = await place.file!.copy('${directory.path}/$filename');
    }

    final db = await getDataBase();
    print('ok1');
    db.insert('user_places', {
      'id': place.id,
      'title': place.name,
      'image': (copiedImage == null) ? null : copiedImage.path,
      'lat': (place.location == null) ? null : place.location!.latitude,
      'lng': (place.location == null) ? null : place.location!.longitude,
      'address':
          (place.location == null) ? null : place.location!.formatted_address
    });
    print(place.location!.latitude);
    state = [place, ...state];
  }

  void removeItem(Place place) async {
    final db = await getDataBase();
    db.delete('user_places', where: 'id = ?', whereArgs: [place.id]);
    state = state
        .where(
          (element) => element != place,
        )
        .toList();
  }
}

final placesProvider = StateNotifierProvider<PlacesListNotifier, List<Place>>(
    (ref) => PlacesListNotifier());
