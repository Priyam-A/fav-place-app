import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
//import 'package:project_6/model/place.dart';

class MapDisplayScreen extends StatefulWidget {
  MapDisplayScreen(
      {super.key,
      this.loc = const LatLng(51.5072, -0.1276),
      required this.isSelecting,
      this.getData});
  final void Function(LatLng ltlng)? getData;
  final LatLng loc;
  final bool isSelecting;
  @override
  State<MapDisplayScreen> createState() => _MapDisplayScreenState();
}

class _MapDisplayScreenState extends State<MapDisplayScreen> {
  LatLng? _latLong;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (!widget.isSelecting) {
      _latLong = widget.loc;
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    return Scaffold(
      appBar: AppBar(
        title:
            Text(widget.isSelecting ? 'Select Location' : 'Preview Location'),
        actions: [
          if (widget.isSelecting)
            IconButton(
              onPressed: (widget.getData == null)
                  ? () {}
                  : () {
                      if (_latLong == null)
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Please add some place'),
                          ),
                        );
                      else {
                        widget.getData!(_latLong!);
                        Navigator.pop(context);
                      }
                    },
              icon: Icon(Icons.add),
            ),
        ],
      ),
      body: GoogleMap(
        onTap: (argument) {
          if (widget.isSelecting) {
            setState(() {
              _latLong = argument;
            });
          }
        },
        initialCameraPosition: CameraPosition(
          target: _latLong ?? LatLng(51.5072, -0.1276),
          zoom: 16,
        ),
        markers: {
          if (!(_latLong == null && widget.isSelecting))
            Marker(markerId: MarkerId('m1'), position: _latLong!)
        },
      ),
    );
  }
}
