import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImageSelector extends StatefulWidget {
  ImageSelector({super.key, required this.getFile});
  final void Function(File?) getFile;
  @override
  State<ImageSelector> createState() => _ImageSelectorState();
}

class _ImageSelectorState extends State<ImageSelector> {
  File? selectedFile;
  void takeImage(bool isGallery) async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(
        source: isGallery ? ImageSource.gallery : ImageSource.camera);
    if (pickedImage == null) {
      return;
    }
    setState(() {
      selectedFile = File(pickedImage.path);
    });
    widget.getFile(selectedFile);
  }
  void onImageTap(){
    showDialog(
    context: context,
    builder: (BuildContext context) {
      return SimpleDialog(
        title: const Text('Select option'),
        children: [
          SimpleDialogOption(
            onPressed: () {Navigator.pop(context); takeImage(true); },
            child: const Text('Add photo from gallery'),
          ),
          SimpleDialogOption(
            onPressed: () { Navigator.pop(context); takeImage(false); },
            child: const Text('Take photo'),
          ),
          SimpleDialogOption(
            onPressed: () { Navigator.pop(context); setState(() {
               selectedFile = null;
            }); widget.getFile(null);},
            child: const Text('Remove image'),
          ),
          SimpleDialogOption(
            onPressed: () { Navigator.pop(context);},
            child: const Text('close'),
          ),
        ],
      );
      }
    );
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    Widget content =
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      ElevatedButton.icon(
        onPressed: () {
          takeImage(true);
        },
        icon: Icon(Icons.camera),
        label: Text("Select Image"),
      ),
      SizedBox(width: 20),
      ElevatedButton.icon(
        onPressed: () {
          takeImage(false);
        },
        icon: Icon(Icons.camera_alt),
        label: Text("Take Image"),
      )
    ]);
    if (selectedFile != null) {
      content = GestureDetector(onTap: onImageTap, child: Image.file(selectedFile!, fit: BoxFit.cover,));
    }
    return Container(
      margin: EdgeInsets.all(20),
      decoration: BoxDecoration(
        border: Border.all(
            width: 1,
            color: Theme.of(context).colorScheme.onBackground.withOpacity(0.6)),
      ),
      height: 250,
      width: double.infinity,
      child: content,
    );
  }
}
