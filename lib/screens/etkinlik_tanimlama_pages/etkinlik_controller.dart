import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'etkinlik_kart.dart';
import '../../models/etkinlikTanimlama/get_etkinlik_tanimlama.dart';
import '../../models/etkinlikTanimlama/patch_etkinlik_tanimlama.dart';
import '../../models/etkinlikTanimlama/post_etkinlik_tanimlama.dart';
import '../../models/etkinlikTanimlama/delete_etkinlik_tanimlama.dart';
import '../../services/api_service.dart';
import 'package:http/http.dart' as http;

class EtkinlikController extends ChangeNotifier {
  DateTime? selectedDate;
  TimeOfDay? selectedTime;
  File? selectedFile;
  final TextEditingController nameController = TextEditingController();
  final TextEditingController feeController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  final List<EtkinlikKart> eventCards = [];
  final List<GetEtkinlikTanimlamaModel> events = [];

  EtkinlikController() {
    _initializeEventCards();
    nameController.addListener(_notifyListeners);
    feeController.addListener(_validateFeeAndNotify);
    _loadEvents();
  }

  void _notifyListeners() {
    notifyListeners();
  }

  void _validateFeeAndNotify() {
    final feeText = feeController.text;
    if (feeText.isNotEmpty && !RegExp(r'^\d*\.?\d+$').hasMatch(feeText)) {
      notifyListeners();
    } else {
      _notifyListeners();
    }
  }

  bool get isFormValid {
    final feeText = feeController.text;
    final isNumeric =
        feeText.isEmpty || RegExp(r'^\d*\.?\d+$').hasMatch(feeText);
    return selectedDate != null &&
        selectedTime != null &&
        nameController.text.isNotEmpty &&
        feeText.isNotEmpty &&
        isNumeric &&
        selectedFile != null;
  }

  void _initializeEventCards() {
    eventCards.clear();
    print('Events uzunluğu: ${events.length}'); // Hata ayıklam
    for (int i = 0; i < events.length; i++) {
      final event = events[i];
      print('Etkinlik işleniyor: ${event.modelAd}'); // Hata ayıklam
      try {
        eventCards.add(
          EtkinlikKart(
            id: event.modelID,
            isim: event.modelAd,
            ucret: event.modelUcret,
            tarih: DateTime.parse(event.modelTarih),
            saat: _parseTimeOfDay(event.modelSaat),
            dosya: null,
            aciklama:
                event.modelAciklama.isNotEmpty ? event.modelAciklama : null,
            resimBinary: null, // <-- bunu kaldır
            resim: event.resim, // <-- path'i kullan
            isWeb: false,
            index: i,
            onDelete: () => deleteEvent(i),
            onUpdate: (updatedData) => updateEvent(i, updatedData),
          ),
        );
      } catch (e) {
        print('Kart oluşturma hatası: $e'); // Hata ayıklam
      }
    }
    print(
      'Oluşturulan etkinlik kartları sayısı: ${eventCards.length}',
    ); // Hata ayıklam
    notifyListeners(); // UI'yı güncelle
  }

  Future<void> _loadEvents() async {
    try {
      events.clear();
      final loadedEvents = await ApiService.getList<GetEtkinlikTanimlamaModel>(
        'EtkinlikTanimlama',
        (json) => GetEtkinlikTanimlamaModel.fromJson(json),
      );
      events.addAll(loadedEvents);
      print('Yüklenen etkinlik sayısı: ${events.length}'); // Hata ayıklam
      _initializeEventCards();
    } catch (e) {
      print('Etkinlik yükleme hatası: $e');
    }
    notifyListeners(); // UI'yı güncelle
  }

  Future<String?> uploadImage(File file) async {
    var request = http.MultipartRequest(
      'POST',
      Uri.parse('http://37.148.210.227:8000/EtkinlikTanimlama/upload-image'),
    );
    request.files.add(await http.MultipartFile.fromPath('file', file.path));
    var response = await request.send();

    if (response.statusCode == 200) {
      final respStr = await response.stream.bytesToString();
      final url = jsonDecode(respStr)['url'];
      return url;
    } else {
      return null;
    }
  }

  Future<void> _sendToApi(dynamic model, String method) async {
    bool success = false;
    switch (method) {
      case 'POST':
        success = await ApiService.post(
          'EtkinlikTanimlama',
          model.toJson(),
          wrapInList: false,
        );
        break;
      case 'PATCH':
        success = await ApiService.patch(
          'EtkinlikTanimlama',
          model.toJson(),
          wrapInList: false,
        );
        break;
      case 'DELETE':
        success = await ApiService.delete(
          'EtkinlikTanimlama',
          model.toJson(),
          wrapInList: false,
        );
        break;
    }
    if (success) {
      await _loadEvents();
    }
  }

  // ...existing code...
  Future<bool> saveEvent(BuildContext context) async {
    if (!isFormValid) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Lütfen geçerli bir ücret girin (sadece sayısal değerler).',
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
      return false;
    }

    String? imageUrl;
    if (selectedFile != null) {
      imageUrl = await uploadImage(selectedFile!);
      if (imageUrl == null) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Resim yüklenemedi!'),
              backgroundColor: Colors.red,
            ),
          );
        }
        return false;
      }
    }

    final newEvent = PostEtkinlikTanimlamaModel(
      tarih: selectedDate!.toIso8601String().split('T')[0],
      saat:
          '${selectedTime!.hour.toString().padLeft(2, '0')}:${selectedTime!.minute.toString().padLeft(2, '0')}',
      ad: nameController.text,
      tutar: feeController.text,
      aciklama:
          descriptionController.text.isNotEmpty
              ? descriptionController.text
              : '',
      resim: imageUrl ?? '',
    );

    await _sendToApi(newEvent, 'POST');

    _clearFields();
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Etkinlik başarıyla kaydedildi!'),
          backgroundColor: Colors.green,
        ),
      );
    }
    return true;
  }
  // ...existing code...

  void updateEvent(int index, Map<String, dynamic> updatedData) {
    if (index >= 0 && index < events.length) {
      final event = events[index];
      final updatedEvent = PatchEtkinlikTanimlamaModel(
        id: event.id,
        tarih: updatedData['tarih'] ?? event.tarih,
        saat: updatedData['saat'] ?? event.saat,
        ad: updatedData['ad'] ?? event.ad,
        tutar: updatedData['tutar'] ?? event.tutar,
        aciklama: updatedData['aciklama'] ?? event.aciklama,
      );
      _sendToApi(updatedEvent, 'PATCH');
    }
  }

  void deleteEvent(int index) {
    if (index >= 0 && index < events.length) {
      final event = events[index];
      final deleteModel = DeleteEtkinlikTanimlamaModel(id: event.id);
      _sendToApi(deleteModel, 'DELETE');
    }
  }

  void _clearFields() {
    selectedDate = null;
    selectedTime = null;
    selectedFile = null;
    nameController.clear();
    feeController.clear();
    descriptionController.clear();
    notifyListeners();
  }

  Future<String?> _fileToBase64(File file) async {
    final bytes = await file.readAsBytes();
    return base64Encode(bytes);
  }

  TimeOfDay _parseTimeOfDay(String time) {
    final parts = time.split(':');
    return TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
  }

  List<EtkinlikKart> getEventCards() => eventCards;
  EtkinlikKart? getEventCard(int index) =>
      index >= 0 && index < eventCards.length ? eventCards[index] : null;
  int get eventCount => eventCards.length;

  @override
  void dispose() {
    nameController.dispose();
    feeController.dispose();
    descriptionController.dispose();
    super.dispose();
  }
}
