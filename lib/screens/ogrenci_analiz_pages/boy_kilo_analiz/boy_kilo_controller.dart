import 'package:flutter/material.dart';
import 'package:kangaroom_mobile/models/ogrenciAnaliz/get_ogrenci_boy_kilo.dart';
import 'package:kangaroom_mobile/services/api_service.dart';

class BoyKiloController extends ChangeNotifier {
  List<GetOgrenciBoyKilo> _boyKiloList = [];
  bool _isLoading = false;
  String? _error;

  List<GetOgrenciBoyKilo> get boyKiloList => _boyKiloList;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchBoyKiloData(int ogrenciID) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final result = await ApiService.getList<GetOgrenciBoyKilo>(
        'OgrenciAnaliz/BoyKilo',
        (json) => GetOgrenciBoyKilo.fromJson(json),
        queryParams: {'id': ogrenciID.toString()},
      );
      _boyKiloList = result;
    } catch (e) {
      _error = e.toString();
      _boyKiloList = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}