import 'package:flutter/material.dart';
import 'package:location/location.dart' as location;

class LocationPickerWidget extends StatefulWidget {
  final location.Location locationService;
  final Function(location.LocationData)? onLocationSelected;

  const LocationPickerWidget({Key? key, required this.locationService, this.onLocationSelected}) : super(key: key);

  @override
  _LocationPickerWidgetState createState() => _LocationPickerWidgetState();
}

class _LocationPickerWidgetState extends State<LocationPickerWidget> {
  location.LocationData? _locationData;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 15.0),
      child: ElevatedButton(
        onPressed: () async {
          _locationData = await widget.locationService.getLocation();
          print('Latitude: ${_locationData!.latitude}, Longitude: ${_locationData!.longitude}');
          if (widget.onLocationSelected != null) {
            widget.onLocationSelected!(_locationData!);
          }
        },
        child: Text('Pilih Lokasi'),
      ),
    );
  }
}
