import 'package:flutter/material.dart';
import '../../models/mesaj/get_mesaj.dart';
import '../../models/mesaj/get_ogrenci_list_all.dart';
import '../../models/mesaj/post_mesaj.dart'; // <-- Post model import edildi
import '../../services/api_service.dart';

class MessageController extends ChangeNotifier {
  List<GetMesajModel> _mesajlar = [];
  List<GetMesajModel> get mesajlar => _mesajlar;

  List<GetOgrenciListAllModel> _ogrenciler = [];
  List<GetOgrenciListAllModel> get ogrenciler => _ogrenciler;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _error;
  String? get error => _error;

  int _currentPage = 0;
  int get currentPage => _currentPage;

  final int rowsPerPage = 5;

  // Sayfa açıldığında verileri yükle
  Future<void> fetchData() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final fetchedOgrenciler =
          await ApiService.getList<GetOgrenciListAllModel>(
            'Mesaj/OgrenciListesi',
            (json) => GetOgrenciListAllModel.fromJson(json),
          );
      _ogrenciler = [
        GetOgrenciListAllModel(id: -1, ad: "Tüm", soyad: "Sınıf"),
        ...fetchedOgrenciler,
      ];

      final fetchedMesajlar = await ApiService.getList<GetMesajModel>(
        'Mesaj',
        (json) => GetMesajModel.fromJson(json),
      );
      _mesajlar = fetchedMesajlar;
    } catch (e) {
      final message = e.toString();
      // Kullanıcıya daha anlaşılır hata mesajı göster
      if (message.contains('Exception: ')) {
        _error = message.replaceFirst('Exception: ', '');
      } else {
        _error = message;
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Sayfa değiştirme (ileri)
  void nextPage() {
    if ((_currentPage + 1) * rowsPerPage < _mesajlar.length) {
      _currentPage++;
      notifyListeners();
    }
  }

  // Sayfa değiştirme (geri)
  void previousPage() {
    if (_currentPage > 0) {
      _currentPage--;
      notifyListeners();
    }
  }

  // Mesaj gönderme (POST)
  Future<bool> sendMessage(PostMesajModel messageModel) async {
    bool success = await ApiService.post(
      'Mesaj',
      messageModel.toJson(),
      wrapInList: false, // önceki önerimden geldi, tek obje gönderiyoruz
    );
    if (success) {
      await fetchData();
    }
    return success;
  }
}
