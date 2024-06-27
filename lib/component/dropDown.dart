import 'package:flutter/material.dart';

class DropdownWidget extends StatefulWidget {
  final List<String> items;
  final Function(String?)? onChanged;

  const DropdownWidget({Key? key, required this.items, this.onChanged}) : super(key: key);

  @override
  _DropdownWidgetState createState() => _DropdownWidgetState();
}

class _DropdownWidgetState extends State<DropdownWidget> {
  String? _selectedItem;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 15.0),
      child: DropdownButtonFormField<String>(
        value: _selectedItem,
        items: widget.items
            .map(
              (item) => DropdownMenuItem<String>(
                value: item,
                child: Text(item),
              ),
            )
            .toList(),
        onChanged: (value) {
          setState(() {
            _selectedItem = value;
          });
          if (widget.onChanged != null) {
            widget.onChanged!(value);
          }
        },
        decoration: InputDecoration(
          hintText: 'Pilih Kecamatan Kejadian',
          filled: true,
          fillColor: Colors.white,
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.black,
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Color(0xFFF8F8F8),
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          
        ),
      ),
    );
  }
}
