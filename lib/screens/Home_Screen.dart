import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project_6/model/place.dart';
import 'package:project_6/providers/places_list_provider.dart';
import 'package:project_6/screens/add_item_screen.dart';
import 'package:project_6/widgets/list_item_widget.dart';

class HomeScreen extends ConsumerStatefulWidget {
  @override
  ConsumerState<HomeScreen> createState() {
    // TODO: implement createState
    return _HomeScreenState();
  }
}

class _HomeScreenState extends ConsumerState<HomeScreen>{
  late Future<void> _hasLoaded;
  void openAddItemPage(BuildContext context) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (ctx) => AddItemScreen()));
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _hasLoaded = ref.read(placesProvider.notifier).loadItems();
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    List<Place> places = ref.watch(placesProvider);
    Widget content = Center(
      child: Text(
        "Nothing here...",
        style: TextStyle(fontSize: 24, color: Colors.white),
      ),
    );
    if (places.isNotEmpty) {
      content = ListView.builder(
        itemBuilder: (ctx, i) => ListItemWidget(place: places[i]),
        itemCount: places.length,
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: Text("Your places"),
        actions: [
          IconButton(
            onPressed: () {
              openAddItemPage(context);
            },
            icon: Icon(Icons.add),
          ),
        ],
      ),
      body: FutureBuilder(future: _hasLoaded, builder: (context, snapshot) => (snapshot.connectionState==ConnectionState.waiting)?Center(child: CircularProgressIndicator(),):content,),
      //content,
    );
  }
}
