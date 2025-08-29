import 'package:flutter/material.dart';

// API: BLOK BAŞLANGICI
import 'package:kangaroom_mobile/services/api_service.dart';

import 'package:kangaroom_mobile/models/sinifTakip/Yoklama/get_yoklama.dart';
import 'package:kangaroom_mobile/models/sinifTakip/DuyguDurum/get_duygu_durum.dart';
import 'package:kangaroom_mobile/models/sinifTakip/DuyguDurum/post_duygu_durum.dart';
import 'package:kangaroom_mobile/models/sinifTakip/Uyku/get_uyku.dart';
import 'package:kangaroom_mobile/models/sinifTakip/Uyku/post_uyku.dart';
import 'package:kangaroom_mobile/models/sinifTakip/Beslenme/get_beslenme.dart';
import 'package:kangaroom_mobile/models/sinifTakip/Beslenme/post_beslenme.dart';
import 'package:kangaroom_mobile/models/sinifTakip/Ilac/get_ilac.dart';
import 'package:kangaroom_mobile/models/sinifTakip/Ilac/post_ilac.dart';
import 'package:kangaroom_mobile/models/sinifTakip/Kiyafet/get_kiyafet.dart';
import 'package:kangaroom_mobile/models/sinifTakip/Kiyafet/post_kiyafet.dart';
import 'package:kangaroom_mobile/models/sinifTakip/Yoklama/post_yoklama.dart';
// API: BLOK SONU

class SinifTakipController extends ChangeNotifier {
  // API: BLOK BAŞLANGICI
  List<GetYoklamaModel> _yoklamaList = [];
  List<GetDuyguDurumModel> _duyguDurumList = [];
  List<GetUykuModel> _uykuList = [];
  List<GetBeslenmeModel> _beslenmeList = [];
  List<GetIlacModel> _ilacList = [];
  List<GetKiyafetModel> _kiyafetList = [];

  List<GetYoklamaModel> get yoklamaList => _yoklamaList;
  List<GetDuyguDurumModel> get duyguDurumList => _duyguDurumList;
  List<GetUykuModel> get uykuList => _uykuList;
  List<GetBeslenmeModel> get beslenmeList => _beslenmeList;
  List<GetIlacModel> get ilacList => _ilacList;
  List<GetKiyafetModel> get kiyafetList => _kiyafetList;
  // API: BLOK SONU

  // Yoklama durumları için Map (öğrenci index'i -> attendance status)
  Map<int, bool> _attendanceStatus = {};
  Map<int, bool> get attendanceStatus => _attendanceStatus;

  // Kıyafet değişikliklerini takip etmek için Map
  Map<int, Map<String, dynamic>> _kiyafetChanges = {};

  // Duygu durum değişikliklerini takip etmek için Map
  Map<int, int> _duyguDurumChanges = {};

  // Uyku değişikliklerini takip etmek için Map
  Map<int, int> _uykuChanges = {};

  // Beslenme değişikliklerini takip etmek için Map
  Map<int, int> _beslenmeChanges = {};

  // İlaç değişikliklerini takip etmek için Map
  Map<int, int> _ilacChanges = {};

  // Seçilen menü ve sayfa bilgisi
  int _selectedMenuItem = 0;
  int _currentPage = 0;
  final int _rowsPerPage = 15;

  // Seçilen tarih (opsiyonel)
  DateTime? _selectedDate;

  // Seçilen öğün (beslenme menüsü için)
  String _selectedOgun = "Sabah";

  // Son API çağrısı yapılan tarih ve menü (güçlü kontrol için)
  DateTime? _lastFetchedDate;
  int? _lastFetchedMenu;

  // Loading kontrolü
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  int get selectedMenuItem => _selectedMenuItem;
  int get currentPage => _currentPage;
  int get rowsPerPage => _rowsPerPage;
  DateTime? get selectedDate => _selectedDate;
  String get selectedOgun => _selectedOgun;

  // Seçilen öğüne göre filtrelenmiş beslenme listesi
  List<GetBeslenmeModel> get filteredBeslenmeList {
    int ogunIndex;
    switch (_selectedOgun) {
      case "Sabah":
        ogunIndex = 0;
        break;
      case "Öğle":
        ogunIndex = 1;
        break;
      case "İkindi":
        ogunIndex = 2;
        break;
      default:
        ogunIndex = 0;
    }
    return _beslenmeList.where((item) => item.ogun == ogunIndex).toList();
  }

  SinifTakipController() {
    _selectedDate = DateTime.now();
    fetchDataForMenu(_selectedMenuItem);
  }

  void setSelectedDate(DateTime date) {
    if (_selectedDate != null && _selectedDate == date) return;
    _selectedDate = date;
    resetPage();
    _clearAllChanges(); // Tarih değiştiğinde tüm değişiklikleri temizle
    fetchDataForMenu(_selectedMenuItem);
    notifyListeners();
  }

  Future<void> setSelectedOgun(String ogun) async {
    if (_selectedOgun == ogun) return;
    _selectedOgun = ogun;
    resetPage();
    _clearBeslenmeChanges(); // Öğün değiştiğinde beslenme değişikliklerini temizle
    if (_selectedDate != null) {
      final tarihStr = _selectedDate!.toIso8601String().split('T').first;
      await fetchBeslenmeData(tarihStr);
    }
    notifyListeners();
  }

  void setSelectedMenuItem(int index) {
    if (_selectedMenuItem == index) return;
    _selectedMenuItem = index;
    resetPage();
    _clearAllChanges(); // Menü değiştiğinde tüm değişiklikleri temizle
    if (_selectedDate != null) {
      fetchDataForMenu(index);
    }
    notifyListeners();
  }

  void resetPage() {
    _currentPage = 0;
  }

  void goToPreviousPage() {
    if (_currentPage > 0) {
      _currentPage--;
      notifyListeners();
    }
  }

  void goToNextPage() {
    int totalPages =
        _selectedMenuItem == 3
            ? getTotalPagesForBeslenme()
            : getTotalPages(_selectedMenuItem);

    if (_currentPage < totalPages - 1) {
      _currentPage++;
      notifyListeners();
    }
  }

  // Tüm değişiklikleri temizle
  void _clearAllChanges() {
    _kiyafetChanges.clear();
    _duyguDurumChanges.clear();
    _uykuChanges.clear();
    _beslenmeChanges.clear();
    _ilacChanges.clear();
  }

  // Kıyafet değişikliklerini temizle
  void _clearKiyafetChanges() {
    _kiyafetChanges.clear();
  }

  // Duygu durum değişikliklerini temizle
  void _clearDuyguDurumChanges() {
    _duyguDurumChanges.clear();
  }

  // Uyku değişikliklerini temizle
  void _clearUykuChanges() {
    _uykuChanges.clear();
  }

  // Beslenme değişikliklerini temizle
  void _clearBeslenmeChanges() {
    _beslenmeChanges.clear();
  }

  // İlaç değişikliklerini temizle
  void _clearIlacChanges() {
    _ilacChanges.clear();
  }

  // Değişiklik kontrolü metodları
  bool hasKiyafetChanges() {
    return _kiyafetChanges.isNotEmpty;
  }

  bool hasDuyguDurumChanges() {
    return _duyguDurumChanges.isNotEmpty;
  }

  bool hasUykuChanges() {
    return _uykuChanges.isNotEmpty;
  }

  bool hasBeslenmeChanges() {
    return _beslenmeChanges.isNotEmpty;
  }

  bool hasIlacChanges() {
    return _ilacChanges.isNotEmpty;
  }

  bool _hasAttendanceChanges() {
    for (int i = 0; i < _yoklamaList.length; i++) {
      final currentStatus = _yoklamaList[i].modelDurum;
      final isPresent = _attendanceStatus[i] ?? false;
      if ((currentStatus.toLowerCase() == 'geldi' ||
              currentStatus.toLowerCase() == 'present') !=
          isPresent) {
        return true;
      }
    }
    return false;
  }

  bool hasYoklamaChanges() {
    return _hasAttendanceChanges();
  }

  // Kıyafet değişikliğini kaydet (henüz API'ye gönderme)
  void updateKiyafetChange(int studentIndex, String itemType, bool isSelected) {
    if (studentIndex < 0 || studentIndex >= _kiyafetList.length) {
      debugPrint('Geçersiz student index: $studentIndex');
      return;
    }

    final student = _kiyafetList[studentIndex];

    if (!_kiyafetChanges.containsKey(studentIndex)) {
      _kiyafetChanges[studentIndex] = {
        'id': student.id,
        'ogrenciId': student.ogrenciId,
        'ustKiyafet': student.ustKiyafet,
        'altKiyafet': student.altKiyafet,
        'ustCamasir': student.ustCamasir,
        'altCamasir': student.altCamasir,
      };
    }

    switch (itemType) {
      case 'ustKiyafet':
        _kiyafetChanges[studentIndex]!['ustKiyafet'] = isSelected ? 1 : 0;
        break;
      case 'altKiyafet':
        _kiyafetChanges[studentIndex]!['altKiyafet'] = isSelected ? 1 : 0;
        break;
      case 'ustCamasir':
        _kiyafetChanges[studentIndex]!['ustCamasir'] = isSelected ? 1 : 0;
        break;
      case 'altCamasir':
        _kiyafetChanges[studentIndex]!['altCamasir'] = isSelected ? 1 : 0;
        break;
    }

    _kiyafetList[studentIndex] = GetKiyafetModel(
      id: student.id,
      ogrenciId: student.ogrenciId,
      adSoyad: student.adSoyad,
      ustKiyafet: _kiyafetChanges[studentIndex]!['ustKiyafet'],
      altKiyafet: _kiyafetChanges[studentIndex]!['altKiyafet'],
      ustCamasir: _kiyafetChanges[studentIndex]!['ustCamasir'],
      altCamasir: _kiyafetChanges[studentIndex]!['altCamasir'],
    );

    notifyListeners();
  }

  // Yoklama durumunu güncelle
  void updateAttendanceStatus(int studentIndex, bool isPresent) {
    _attendanceStatus[studentIndex] = isPresent;
    notifyListeners();
  }

  // Duygu durum değişikliğini kaydet
  void updateDuyguDurum(int studentIndex, int newDurum) {
    if (studentIndex >= 0 && studentIndex < _duyguDurumList.length) {
      // Değişikliği kaydet
      _duyguDurumChanges[studentIndex] = newDurum;

      // Local state'i güncelle
      _duyguDurumList[studentIndex].durum = newDurum;
      notifyListeners();
    }
  }

  // Uyku durumu değişikliğini kaydet
  void updateUyku(int studentIndex, int newDurum) {
    if (studentIndex >= 0 && studentIndex < _uykuList.length) {
      // Değişikliği kaydet
      _uykuChanges[studentIndex] = newDurum;

      _uykuList[studentIndex].durum = newDurum;
      notifyListeners();
    }
  }

  // Beslenme durumu değişikliğini kaydet
  void updateBeslenmeDurum(int studentIndex, int newDurum) {
    final filteredList = filteredBeslenmeList;
    if (studentIndex < 0 || studentIndex >= filteredList.length) {
      debugPrint('Geçersiz student index: $studentIndex');
      return;
    }

    final targetStudent = filteredList[studentIndex];

    // Ana listedeki bu öğrenciyi bulup güncelleyelim
    for (int i = 0; i < _beslenmeList.length; i++) {
      if (_beslenmeList[i].id == targetStudent.id &&
          _beslenmeList[i].ogrenciId == targetStudent.ogrenciId &&
          _beslenmeList[i].ogun == targetStudent.ogun) {
        // Değişikliği kaydet
        _beslenmeChanges[i] = newDurum;

        _beslenmeList[i] = GetBeslenmeModel(
          id: _beslenmeList[i].id,
          ogrenciId: _beslenmeList[i].ogrenciId,
          adSoyad: _beslenmeList[i].adSoyad,
          durum: newDurum,
          ogun: _beslenmeList[i].ogun,
        );
        break;
      }
    }

    notifyListeners();
  }

  // İlaç durumu değişikliğini kaydet
  void updateIlacDurum(int studentIndex, int newDurum) {
    if (studentIndex >= 0 && studentIndex < _ilacList.length) {
      // Değişikliği kaydet
      _ilacChanges[studentIndex] = newDurum;

      _ilacList[studentIndex] = GetIlacModel(
        id: _ilacList[studentIndex].id,
        ogrenciId: _ilacList[studentIndex].ogrenciId,
        adSoyad: _ilacList[studentIndex].adSoyad,
        ilac: _ilacList[studentIndex].ilac,
        saat: _ilacList[studentIndex].saat,
        durum: newDurum,
      );
      notifyListeners();
    }
  }

  // Tüm sayfadaki öğrencileri seç/seçme
  void toggleSelectAllCurrentPage(bool value) {
    final startIndex = _currentPage * _rowsPerPage;
    final endIndex = (startIndex + _rowsPerPage).clamp(0, _yoklamaList.length);

    for (int i = startIndex; i < endIndex; i++) {
      _attendanceStatus[i] = value;
    }
    notifyListeners();
  }

  // Mevcut sayfadaki tüm öğrenciler seçili mi kontrol et
  bool areAllCurrentPageSelected() {
    final startIndex = _currentPage * _rowsPerPage;
    final endIndex = (startIndex + _rowsPerPage).clamp(0, _yoklamaList.length);

    if (startIndex >= endIndex) return false;

    for (int i = startIndex; i < endIndex; i++) {
      if (!(_attendanceStatus[i] ?? false)) return false;
    }
    return true;
  }

  // KAYDET METODLARI

  // Yoklama verilerini kaydet
  Future<bool> saveAttendanceData() async {
    if (_selectedDate == null || _yoklamaList.isEmpty) {
      debugPrint(
        'Yoklama kaydedilemedi: Tarih seçili değil veya yoklama listesi boş',
      );
      return false;
    }

    try {
      setLoading(true);
      List<PostYoklamaModel> postModels = [];
      final tarihStr = _selectedDate!.toIso8601String().split('T').first;

      for (int i = 0; i < _yoklamaList.length; i++) {
        final student = _yoklamaList[i];
        final isPresent = _attendanceStatus[i] ?? false;
        postModels.add(
          PostYoklamaModel(
            id: student.id,
            ogrenciId: student.ogrenciId,
            tarih: tarihStr,
            durum: isPresent ? 1 : 0,
            personelId: null,
          ),
        );
      }

      final result = await postOgrenciYoklamaBatch(postModels);
      if (result) {
        debugPrint('Yoklama verileri kaydedildi: ${postModels.length} öğrenci');
        // Veriyi yenile
        if (_selectedDate != null) {
          final tarihStr = _selectedDate!.toIso8601String().split('T').first;
          await fetchYoklamaData(tarihStr);
        }
        setLoading(false);
        return true;
      } else {
        debugPrint('Bazı yoklama verileri kaydedilemedi');
        setLoading(false);
        return false;
      }
    } catch (e) {
      debugPrint('Yoklama kaydetme hatası: $e');
      setLoading(false);
      return false;
    }
  }

  // Duygu durum değişikliklerini kaydet - TAMAMEN YENİ
  Future<bool> saveDuyguDurumChanges() async {
    if (_selectedDate == null || _duyguDurumChanges.isEmpty) {
      debugPrint(
        'Duygu durum kaydedilemedi: Tarih seçili değil veya değişiklik yok',
      );
      return false;
    }

    try {
      setLoading(true);
      List<PostDuyguDurumModel> postModels = [];

      for (var entry in _duyguDurumChanges.entries) {
        final studentIndex = entry.key;
        final newDurum = entry.value;

        if (studentIndex < _duyguDurumList.length) {
          final student = _duyguDurumList[studentIndex];
          final tarihStr = _selectedDate!.toIso8601String().split('T').first;
          postModels.add(
            PostDuyguDurumModel(
              id: student.id, // Güncelleme modu için ID gönderiyoruz
              ogrenciId: student.ogrenciId,
              tarih: tarihStr,
              durum: newDurum,
            ),
          );
        }
      }

      final result = await postOgrenciDuyguDurumBatch(postModels);
      if (result) {
        debugPrint(
          '${_duyguDurumChanges.length} duygu durum değişikliği kaydedildi',
        );
        _clearDuyguDurumChanges();
        // Veriyi yenile
        if (_selectedDate != null) {
          final tarihStr = _selectedDate!.toIso8601String().split('T').first;
          await fetchDuyguDurumData(tarihStr);
        }
        setLoading(false);
        return true;
      } else {
        debugPrint('Bazı duygu durum değişiklikleri kaydedilemedi');
        setLoading(false);
        return false;
      }
    } catch (e) {
      debugPrint('Duygu durum kaydetme hatası: $e');
      setLoading(false);
      return false;
    }
  }

  // Uyku değişikliklerini kaydet - TAMAMEN YENİ
  Future<bool> saveUykuChanges() async {
    if (_selectedDate == null || _uykuChanges.isEmpty) {
      debugPrint('Uyku kaydedilemedi: Tarih seçili değil veya değişiklik yok');
      return false;
    }

    try {
      setLoading(true);
      List<PostUykuModel> postModels = [];

      for (var entry in _uykuChanges.entries) {
        final studentIndex = entry.key;
        final newDurum = entry.value;

        if (studentIndex < _uykuList.length) {
          final student = _uykuList[studentIndex];
          final tarihStr = _selectedDate!.toIso8601String().split('T').first;

          postModels.add(
            PostUykuModel(
              id: student.id, // Güncelleme modu için ID gönderiyoruz
              durum: newDurum,
              tarih: tarihStr,
              ogrenciId: student.ogrenciId,
            ),
          );
        }
      }

      final result = await postOgrenciUykuBatch(postModels);
      if (result) {
        debugPrint('${_uykuChanges.length} uyku değişikliği kaydedildi');
        _clearUykuChanges();
        // Veriyi yenile
        if (_selectedDate != null) {
          final tarihStr = _selectedDate!.toIso8601String().split('T').first;
          await fetchUykuData(tarihStr);
        }
        setLoading(false);
        return true;
      } else {
        debugPrint('Bazı uyku değişiklikleri kaydedilemedi');
        setLoading(false);
        return false;
      }
    } catch (e) {
      debugPrint('Uyku kaydetme hatası: $e');
      setLoading(false);
      return false;
    }
  }

  // Beslenme değişikliklerini kaydet - TAMAMEN YENİ
  Future<bool> saveBeslenmeChanges() async {
    if (_selectedDate == null || _beslenmeChanges.isEmpty) {
      debugPrint(
        'Beslenme kaydedilemedi: Tarih seçili değil veya değişiklik yok',
      );
      return false;
    }

    try {
      setLoading(true);
      List<PostBeslenmeModel> postModels = [];

      for (var entry in _beslenmeChanges.entries) {
        final studentIndex = entry.key;
        final newDurum = entry.value;

        if (studentIndex < _beslenmeList.length) {
          final student = _beslenmeList[studentIndex];
          final tarihStr = _selectedDate!.toIso8601String().split('T').first;
          postModels.add(
            PostBeslenmeModel(
              id: student.id, // Güncelleme modu için ID gönderiyoruz
              ogun: student.ogun,
              durum: newDurum,
              tarih: tarihStr,
              ogrenciId: student.ogrenciId,
            ),
          );
        }
      }

      final result = await postOgrenciBeslenmeBatch(postModels);
      if (result) {
        debugPrint(
          '${_beslenmeChanges.length} beslenme değişikliği kaydedildi',
        );
        _clearBeslenmeChanges();
        // Veriyi yenile
        if (_selectedDate != null) {
          final tarihStr = _selectedDate!.toIso8601String().split('T').first;
          await fetchBeslenmeData(tarihStr);
        }
        setLoading(false);
        return true;
      } else {
        debugPrint('Bazı beslenme değişiklikleri kaydedilemedi');
        setLoading(false);
        return false;
      }
    } catch (e) {
      debugPrint('Beslenme kaydetme hatası: $e');
      setLoading(false);
      return false;
    }
  }

  // İlaç değişikliklerini kaydet - TAMAMEN YENİ
  Future<bool> saveIlacChanges() async {
    if (_selectedDate == null || _ilacChanges.isEmpty) {
      debugPrint('İlaç kaydedilemedi: Tarih seçili değil veya değişiklik yok');
      return false;
    }

    try {
      setLoading(true);
      List<PostIlacModel> postModels = [];

      for (var entry in _ilacChanges.entries) {
        final studentIndex = entry.key;
        final newDurum = entry.value;

        if (studentIndex < _ilacList.length) {
          final student = _ilacList[studentIndex];
          postModels.add(
            PostIlacModel(
              id: student.id, // Güncelleme modu için ID gönderiyoruz
              durum: newDurum,
              ogrenciId: student.ogrenciId,
            ),
          );
        }
      }

      final result = await postOgrenciIlacBatch(postModels);
      if (result) {
        debugPrint('${_ilacChanges.length} ilaç değişikliği kaydedildi');
        _clearIlacChanges();
        // Veriyi yenile
        if (_selectedDate != null) {
          final tarihStr = _selectedDate!.toIso8601String().split('T').first;
          await fetchIlacData(tarihStr);
        }
        setLoading(false);
        return true;
      } else {
        debugPrint('Bazı ilaç değişiklikleri kaydedilemedi');
        setLoading(false);
        return false;
      }
    } catch (e) {
      debugPrint('İlaç kaydetme hatası: $e');
      setLoading(false);
      return false;
    }
  }

  // Tüm kıyafet değişikliklerini kaydet
  Future<bool> saveKiyafetChanges({int? personelId}) async {
    if (_selectedDate == null || _kiyafetChanges.isEmpty) {
      debugPrint(
        'Kıyafet kaydedilemedi: Tarih seçili değil veya değişiklik yok',
      );
      return false;
    }

    try {
      setLoading(true);
      List<PostKiyafetModel> postModels = [];
      final tarihStr = _selectedDate!.toIso8601String().split('T').first;

      for (var entry in _kiyafetChanges.entries) {
        final changeData = entry.value;
        postModels.add(
          PostKiyafetModel(
            id: changeData['id'],
            ogrenciId: changeData['ogrenciId'],
            tarih: tarihStr,
            altKiyafet: changeData['altKiyafet'] ?? 0,
            ustKiyafet: changeData['ustKiyafet'] ?? 0,
            altCamasir: changeData['altCamasir'] ?? 0,
            ustCamasir: changeData['ustCamasir'] ?? 0,
            personelId: null,
          ),
        );
      }

      final result = await postOgrenciKiyafetBatch(postModels);
      if (result) {
        debugPrint('${_kiyafetChanges.length} kıyafet değişikliği kaydedildi');
        _clearKiyafetChanges();
        // Veriyi yenile
        if (_selectedDate != null) {
          final tarihStr = _selectedDate!.toIso8601String().split('T').first;
          await fetchKiyafetData(tarihStr);
        }
        setLoading(false);
        return true;
      } else {
        debugPrint('Bazı kıyafet değişiklikleri kaydedilemedi');
        setLoading(false);
        return false;
      }
    } catch (e) {
      debugPrint('Kıyafet kaydetme hatası: $e');
      setLoading(false);
      return false;
    }
  }

  // Kayıt Et butonu için alias metodlar
  Future<bool> postKiyafetDegisiklikleri() async {
    return await saveKiyafetChanges();
  }

  Future<bool> postDuyguDurumDegisiklikleri() async {
    return await saveDuyguDurumChanges();
  }

  Future<bool> postUykuDegisiklikleri() async {
    return await saveUykuChanges();
  }

  Future<bool> postBeslenmeDegisiklikleri() async {
    return await saveBeslenmeChanges();
  }

  Future<bool> postIlacDegisiklikleri() async {
    return await saveIlacChanges();
  }

  Future<bool> postYoklamaDegisiklikleri() async {
    return await saveAttendanceData();
  }

  Future<void> fetchDataForMenu(int menuIndex) async {
    if (_selectedDate == null) return;

    if (_lastFetchedDate != null &&
        _lastFetchedMenu != null &&
        _lastFetchedDate == _selectedDate &&
        _lastFetchedMenu == menuIndex) {
      return;
    }

    setLoading(true);

    final tarihStr = _selectedDate!.toIso8601String().split('T').first;

    switch (menuIndex) {
      case 0:
        await fetchYoklamaData(tarihStr);
        break;
      case 1:
        await fetchDuyguDurumData(tarihStr);
        break;
      case 2:
        await fetchUykuData(tarihStr);
        break;
      case 3:
        await fetchBeslenmeData(tarihStr);
        break;
      case 4:
        await fetchIlacData(tarihStr);
        break;
      case 5:
        await fetchKiyafetData(tarihStr);
        break;
      default:
        break;
    }

    _lastFetchedDate = _selectedDate;
    _lastFetchedMenu = menuIndex;

    setLoading(false);
  }

  // API: BLOK BAŞLANGICI

  String urlForPage = "SinifTakip";

  // Yoklama POST metodu
  Future<bool> postOgrenciYoklamaBatch(
    List<PostYoklamaModel> postModels,
  ) async {
    try {
      for (int i = 0; i < postModels.length; i++) {
        final isPresent = _attendanceStatus[i] ?? false;
        postModels[i].durum = isPresent ? 1 : 0;
      }

      final jsonList = postModels.map((e) => e.toJson()).toList();
      final result = await ApiService.post('SinifTakip/Yoklama', jsonList);

      if (result) {
        print('✅ Toplu yoklama kaydı başarılı');
      }

      return result;
    } catch (e) {
      print('❌ Toplu yoklama post hatası: $e');
      return false;
    }
  }

  // Duygu durum POST metodu
  Future<bool> postOgrenciDuyguDurumBatch(
    List<PostDuyguDurumModel> postModels,
  ) async {
    try {
      final jsonList = postModels.map((e) => e.toJson()).toList();
      final result = await ApiService.post('SinifTakip/DuyguDurum', jsonList);

      if (result) {
        print('✅ Toplu duygu durum kaydı başarılı');
      }

      return result;
    } catch (e) {
      print('❌ Toplu duygu durum post hatası: $e');
      return false;
    }
  }

  // Uyku POST metodu
  Future<bool> postOgrenciUykuBatch(List<PostUykuModel> postModels) async {
    try {
      final jsonList = postModels.map((e) => e.toJson()).toList();
      final result = await ApiService.post('SinifTakip/Uyku', jsonList);

      if (result) {
        print('✅ Toplu uyku kaydı başarılı');
      }

      return result;
    } catch (e) {
      print('❌ Toplu uyku post hatası: $e');
      return false;
    }
  }

  // Beslenme POST metodu
  Future<bool> postOgrenciBeslenmeBatch(
    List<PostBeslenmeModel> postModels,
  ) async {
    try {
      final jsonList = postModels.map((e) => e.toJson()).toList();
      final result = await ApiService.post('SinifTakip/Beslenme', jsonList);

      if (result) {
        print('✅ Toplu beslenme kaydı başarılı');
      }

      return result;
    } catch (e) {
      print('❌ Toplu beslenme post hatası: $e');
      return false;
    }
  }

  // İlaç POST metodu
  Future<bool> postOgrenciIlacBatch(List<PostIlacModel> postModels) async {
    try {
      final jsonList = postModels.map((e) => e.toJson()).toList();
      final result = await ApiService.post('SinifTakip/Ilac', jsonList);

      if (result) {
        print('✅ Toplu ilaç kaydı başarılı');
      }

      return result;
    } catch (e) {
      print('❌ Toplu ilaç post hatası: $e');
      return false;
    }
  }

  // Kıyafet POST metodu
  Future<bool> postOgrenciKiyafetBatch(
    List<PostKiyafetModel> postModels,
  ) async {
    try {
      final jsonList = postModels.map((e) => e.toJson()).toList();
      final result = await ApiService.post('SinifTakip/Kiyafet', jsonList);
      if (result) {
        print('✅ Toplu kıyafet kaydı başarılı');
      }
      return result;
    } catch (e) {
      print('❌ Toplu kıyafet post hatası: $e');
      return false;
    }
  }

  Future<void> fetchYoklamaData(String tarih) async {
    try {
      _yoklamaList = await ApiService.getList<GetYoklamaModel>(
        '$urlForPage/Yoklama',
        (json) => GetYoklamaModel.fromJson(json),
        queryParams: {'tarih': tarih},
      );
      _initializeAttendanceStatus();
    } catch (e) {
      _yoklamaList = [];
      _attendanceStatus.clear();
      debugPrint("Yoklama API hatası: $e");
    }
  }

  Future<void> fetchDuyguDurumData(String tarih) async {
    try {
      _duyguDurumList = await ApiService.getList<GetDuyguDurumModel>(
        '$urlForPage/DuyguDurum',
        (json) => GetDuyguDurumModel.fromJson(json),
        queryParams: {'tarih': tarih},
      );
    } catch (e) {
      _duyguDurumList = [];
      debugPrint("DuyguDurum API hatası: $e");
    }
  }

  Future<void> fetchUykuData(String tarih) async {
    try {
      _uykuList = await ApiService.getList<GetUykuModel>(
        '$urlForPage/Uyku',
        (json) => GetUykuModel.fromJson(json),
        queryParams: {'tarih': tarih},
      );
    } catch (e) {
      _uykuList = [];
      debugPrint("Uyku API hatası: $e");
    }
  }

  Future<void> fetchBeslenmeData(String tarih) async {
    try {
      _beslenmeList = await ApiService.getList<GetBeslenmeModel>(
        '$urlForPage/Beslenme',
        (json) => GetBeslenmeModel.fromJson(json),
        queryParams: {'tarih': tarih},
      );
    } catch (e) {
      _beslenmeList = [];
      debugPrint("Beslenme API hatası: $e");
    }
  }

  Future<void> fetchIlacData(String tarih) async {
    try {
      _ilacList = await ApiService.getList<GetIlacModel>(
        '$urlForPage/Ilac',
        (json) => GetIlacModel.fromJson(json),
        queryParams: {'tarih': tarih},
      );
    } catch (e) {
      _ilacList = [];
      debugPrint("İlaç API hatası: $e");
    }
  }

  Future<void> fetchKiyafetData(String tarih) async {
    try {
      _kiyafetList = await ApiService.getList<GetKiyafetModel>(
        '$urlForPage/Kiyafet',
        (json) => GetKiyafetModel.fromJson(json),
        queryParams: {'tarih': tarih},
      );
      _clearKiyafetChanges();
    } catch (e) {
      _kiyafetList = [];
      debugPrint("Kıyafet API hatası: $e");
    }
  }

  // API: BLOK SONU

  // Tablo verileri için düzenleme
  List<List<String>> getTableData(int itemIndex) {
    switch (itemIndex) {
      case 0:
        return _yoklamaList
            .map((model) => [model.modelAdSoyad, model.modelDurum])
            .toList();
      case 1:
        return _duyguDurumList
            .map((model) => [model.modelAdSoyad, model.modelDurum])
            .toList();
      case 2:
        return _uykuList
            .map((model) => [model.modelAdSoyad, model.modelDurum])
            .toList();
      case 3:
        return filteredBeslenmeList
            .map(
              (model) => [
                model.modelAdSoyad,
                model.modelOgun,
                model.modelDurum,
              ],
            )
            .toList();
      case 4:
        return _ilacList
            .map(
              (model) => [
                model.modelAdSoyad,
                model.modelIlac,
                model.modelSaat,
                model.modelDurum,
              ],
            )
            .toList();
      case 5:
        return _kiyafetList
            .map(
              (model) => [
                model.modelAdSoyad,
                model.modelUstKiyafet,
                model.modelAltKiyafet,
                model.modelUstCamasir,
                model.modelAltCamasir,
              ],
            )
            .toList();
      default:
        return [];
    }
  }

  List<String> getColumnHeaders(int itemIndex) {
    switch (itemIndex) {
      case 0:
        return ['Öğrenci Adı', 'Yoklama Durumu'];
      case 1:
        return ['Öğrenci Adı', 'Duygu Durumu'];
      case 2:
        return ['Öğrenci Adı', 'Uyku Durumu'];
      case 3:
        return ['Öğrenci Adı', 'Öğün', 'Beslenme Durumu'];
      case 4:
        return ['Öğrenci Adı', 'İlaç Adı', 'İlaç Saati', 'İlaç Durumu'];
      case 5:
        return [
          'Öğrenci Adı',
          'Üst Kıyafet',
          'Alt Kıyafet',
          'Üst Çamaşır',
          'Alt Çamaşır',
        ];
      default:
        return ['ID', 'Açıklama'];
    }
  }

  List<List<String>> getPaginatedTableData(int itemIndex) {
    List<List<String>> allData = getTableData(itemIndex);
    int startIndex = _currentPage * _rowsPerPage;
    int endIndex = startIndex + _rowsPerPage;

    if (startIndex >= allData.length) return [];
    return allData.sublist(
      startIndex,
      endIndex > allData.length ? allData.length : endIndex,
    );
  }

  int getTotalPages(int itemIndex) {
    List<List<String>> allData = getTableData(itemIndex);
    return (allData.length / _rowsPerPage).ceil();
  }

  // Beslenme için özel sayfa sayısı hesaplama
  int getTotalPagesForBeslenme() {
    return (filteredBeslenmeList.length / _rowsPerPage).ceil();
  }

  // Yoklama listesinden attendanceStatus'u başlatır
  void _initializeAttendanceStatus() {
    _attendanceStatus.clear();
    for (int i = 0; i < _yoklamaList.length; i++) {
      final currentStatus = _yoklamaList[i].modelDurum;
      _attendanceStatus[i] =
          currentStatus.toLowerCase() == 'geldi' ||
          currentStatus.toLowerCase() == 'present';
    }
  }
}
