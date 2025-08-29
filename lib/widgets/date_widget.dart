import 'package:flutter/material.dart';

class DatePickerWidget extends StatefulWidget {
  final DateTime initialDate;
  final ValueChanged<DateTime> onDateSelected;

  const DatePickerWidget({
    super.key,
    required this.initialDate,
    required this.onDateSelected,
  });

  @override
  State<DatePickerWidget> createState() => _DatePickerWidgetState();
}

class _DatePickerWidgetState extends State<DatePickerWidget> {
  late DateTime _selectedDate; // Seçilen tarihi tutacak değişken

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.initialDate; // Başlangıç tarihini ayarla
  }

  // Tarih seçme diyaloğunu gösteren fonksiyon
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate, // Mevcut seçili tarihi başlangıç olarak ver
      firstDate: DateTime(2000), // Seçilebilecek en erken tarih
      lastDate: DateTime(2101), // Seçilebilecek en geç tarih
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.light(
              primary: Theme.of(context).primaryColor, // Seçici rengi
              onPrimary: Colors.white, // Seçici üzerindeki yazı rengi
              onSurface: Colors.black, // Takvimdeki yazı rengi
            ),
            dialogBackgroundColor: Colors.white, // Diyalog arka plan rengi
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked; // Yeni seçilen tarihi güncelle
      });
      widget.onDateSelected(picked); // Callback'i çağır
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell( // Tıklanabilir alan oluşturmak için
      onTap: () => _selectDate(context), // Tıklayınca tarih seçiciyi aç
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween, // İçerikleri yay
        children: [
          Text(
            '${_selectedDate.day.toString().padLeft(2, '0')}/${_selectedDate.month.toString().padLeft(2, '0')}/${_selectedDate.year}', // Seçilen tarihi göster
            style: const TextStyle(
              fontSize: 14,
            ),
          ),
          Icon(Icons.calendar_today, color: Colors.grey.shade600, size: 20), // Takvim ikonu
        ],
      ),
    );
  }
}