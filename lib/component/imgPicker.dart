import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerWidget extends StatefulWidget {
  final Function(File)? onImageSelected;

  const ImagePickerWidget({Key? key, this.onImageSelected}) : super(key: key);

  @override
  _ImagePickerWidgetState createState() => _ImagePickerWidgetState();
}

class _ImagePickerWidgetState extends State<ImagePickerWidget> {
  late File _pickedImage;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 15.0),
      child: ElevatedButton(
        onPressed: () {
          _showImagePicker(context);
        },
        child: Text('Pilih Bukti Laporan'),
      ),
    );
  }

  Future<void> _showImagePicker(BuildContext context) async {
    final picker = ImagePicker();
    final pickedFile = await showDialog<File?>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Text('Pilih Bukti Laporan'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              leading: Icon(Icons.photo_library),
              title: Text('Galeri'),
              onTap: () async {
                Navigator.pop(context, await _getImage(ImageSource.gallery));
              },
            ),
            ListTile(
              leading: Icon(Icons.camera_alt),
              title: Text('Kamera'),
              onTap: () async {
                Navigator.pop(context, await _getImage(ImageSource.camera));
              },
            ),
          ],
        ),
      ),
    );

    // Handle pickedFile as per your application's requirements
    if (pickedFile != null) {
      setState(() {
        _pickedImage = pickedFile;
      });
      if (widget.onImageSelected != null) {
        widget.onImageSelected!(_pickedImage);
      }
      print('Picked file path: ${pickedFile.path}');
    }
  }

  Future<File?> _getImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.getImage(source: source);
    if (pickedFile != null) {
      return File(pickedFile.path);
    }
    return null;
  }
}
