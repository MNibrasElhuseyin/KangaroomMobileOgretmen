import 'package:flutter/material.dart';
import '../../models/boyKilo/get_ogrenci_list.dart';
import '../../models/kiyafetTalep/get_kiyafet_talep.dart';
import '../../models/kiyafetTalep/post_kiyafet_talep.dart';
import '../../services/api_service.dart';
import '../../config/global_config.dart';

class KiyafetTalepController extends ChangeNotifier {
  int _currentPage = 0;
  final int _rowsPerPage = 15;

  bool _isLoading = false;
  String? _errorMessage;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  GetOgrenciListModel? selectedStudent;
  final TextEditingController descriptionController = TextEditingController();
  bool isAciklamaExpanded = false;

  List<bool> isChecked = [false, false, false, false];
  final List<String> labels = [
    'Üst Çamaşır',
    'Alt Çamaşır',
    'Üst Kıyafet',
    'Alt Kıyafet',
  ];

  final List<IconData> icons = [
    Icons.checkroom,
    Icons.accessibility,
    Icons.style,
    Icons.person_outline,
  ];

  List<GetOgrenciListModel> students = [];
  List<GetKiyafetTalepModel> kiyafetTalepleri = [];

  final List<String> columnHeaders = ['Öğrenci', 'Tarih', 'İçerik'];

  int get currentPage => _currentPage;
  int get rowsPerPage => _rowsPerPage;

  void toggleKiyafetSelection(int index) {
    isChecked[index] = !isChecked[index];
    notifyListeners();
  }

  bool isKiyafetSelected(int index) {
    return isChecked[index];
  }

  void setSelectedStudent(GetOgrenciListModel? student) {
    selectedStudent = student;
    notifyListeners();
  }

  void toggleAciklamaExpanded() {
    isAciklamaExpanded = !isAciklamaExpanded;
    notifyListeners();
  }

  bool isFormValid() {
    bool studentSelected = selectedStudent != null;
    bool categorySelected = isChecked.contains(true);
    // Açıklama alanı zorunlu değil
    return studentSelected && categorySelected;
  }

  List<List<String>> getPaginatedTableData() {
    final startIndex = _currentPage * _rowsPerPage;
    final endIndex = (startIndex + _rowsPerPage).clamp(
      0,
      kiyafetTalepleri.length,
    );
    return kiyafetTalepleri
        .sublist(startIndex, endIndex)
        .map(
          (talep) => [
            talep.modelOgrenciAdSoyad,
            talep.modelTarih,
            talep.modelIcerik,
          ],
        )
        .toList();
  }

  int getTotalPages() {
    if (kiyafetTalepleri.isEmpty) return 1;
    return (kiyafetTalepleri.length / _rowsPerPage).ceil();
  }

  void goToPreviousPage() {
    if (_currentPage > 0) {
      _currentPage--;
      notifyListeners();
    }
  }

  void goToNextPage() {
    if (_currentPage < getTotalPages() - 1) {
      _currentPage++;
      notifyListeners();
    }
  }

  Future<void> fetchData() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final fetchedStudents = await ApiService.getList<GetOgrenciListModel>(
        'KiyafetTalep/OgrenciListesi',
        (json) => GetOgrenciListModel.fromJson(json),
      );
      students = fetchedStudents;

      final fetchedKiyafetTalepleri =
          await ApiService.getList<GetKiyafetTalepModel>(
            'KiyafetTalep',
            (json) => GetKiyafetTalepModel.fromJson(json),
          );
      kiyafetTalepleri = fetchedKiyafetTalepleri;
    } catch (e) {
      // API service'den gelen hatayı diğer sayfalar gibi aynı formata çevir
      print('❌ Kıyafet talep hatası: $e');
      _errorMessage = '📶 İnternet bağlantınızı kontrol ediniz';
      print('❌ Error message set edildi: $_errorMessage');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> sendKiyafetTalep(BuildContext context) async {
    if (!isFormValid()) {
      return;
    }

    _isLoading = true;
    notifyListeners();

    try {
      final postModel = PostKiyafetModel(
        personelId: GlobalConfig.personelID,
        ogrenciId: selectedStudent!.id,
        ustKiyafet: isChecked[2] ? 1 : 0,
        altKiyafet: isChecked[3] ? 1 : 0,
        ustCamasir: isChecked[0] ? 1 : 0,
        altCamasir: isChecked[1] ? 1 : 0,
        aciklama: descriptionController.text,
      );

      bool success = await ApiService.post(
        'KiyafetTalep',
        postModel.toJson(),
        wrapInList: false,
      );

      if (success) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Kıyafet talebi başarıyla gönderildi.'),
              backgroundColor: Colors.green,
            ),
          );
        }
        clearForm();
        await fetchData();
      } else {
        throw Exception('API isteği başarısız oldu.');
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Hata oluştu: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearForm() {
    selectedStudent = null;
    descriptionController.clear();
    isAciklamaExpanded = false;
    isChecked = [false, false, false, false];
    notifyListeners();
  }

  @override
  void dispose() {
    descriptionController.dispose();
    super.dispose();
  }
}
