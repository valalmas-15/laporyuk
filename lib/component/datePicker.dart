import 'package:flutter/material.dart';

class DatePickerWidget extends StatefulWidget {
  final TextEditingController controller;

  const DatePickerWidget({Key? key, required this.controller})
      : super(key: key);

  @override
  _DatePickerWidgetState createState() => _DatePickerWidgetState();
}

class _DatePickerWidgetState extends State<DatePickerWidget> {
  DateTime? _selectedDate;

  @override
  Widget build(BuildContext context) {
    return Padding(
  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15), // Sesuaikan dengan ukuran padding yang diinginkan
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        'Tanggal:',
        style: TextStyle(fontSize: 18.0),
      ),
      SizedBox(height: 8.0), // Spasi antara Text dan TextFormField
      TextFormField(
        controller: widget.controller,
        readOnly: true,
        decoration: InputDecoration(
          hintText: 'Pilih Tanggal',
          suffixIcon: Icon(Icons.calendar_today),
        ),
        onTap: () {
          _selectDate(context);
        },
      ),
    ],
  ),
);

  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        widget.controller.text = "${picked.day}/${picked.month}/${picked.year}";
      });
    }
  }
}
