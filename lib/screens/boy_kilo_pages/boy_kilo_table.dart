import 'package:flutter/material.dart';
import 'package:kangaroom_mobile/models/boyKilo/get_boy_kilo.dart';
import 'package:kangaroom_mobile/widgets/tables/custom_table.dart'; // path'i projene göre kontrol et
import 'boy_kilo_controller.dart';
import 'boy_kilo_edit_dialog.dart';

class BoyKiloTable extends StatefulWidget {
  final BoyKiloController controller;
  const BoyKiloTable({super.key, required this.controller});

  @override
  State<BoyKiloTable> createState() => _BoyKiloTableState();
}

class _BoyKiloTableState extends State<BoyKiloTable> {
  static const int _pageSize = 10;
  int _currentPage = 0;

  List<BoyKiloModel> get _all => widget.controller.boyKiloListesi;

  int get _totalPages {
    if (_all.isEmpty) return 1;
    return (_all.length / _pageSize).ceil();
  }

  List<BoyKiloModel> get _pageItems {
    if (_all.isEmpty) return const [];
    final start = _currentPage * _pageSize;
    final end =
        (start + _pageSize) > _all.length ? _all.length : (start + _pageSize);
    return _all.sublist(start, end);
  }

  List<String> get _headers => const [
    'Ad Soyad',
    'Tarih',
    'Boy (cm)',
    'Kilo (kg)',
    'Açıklama',
  ];

  List<List<String>> _rows(List<BoyKiloModel> list) {
    return list.map((k) {
      final adSoyad =
          '${k.ad} ${k.soyad}'.trim(); // Modelde ad/soyad var, adSoyad YOK
      return [
        adSoyad,
        k.tarih.toString(),
        k.boy.toString(),
        k.kilo.toString(),
        k.aciklama ?? '',
      ];
    }).toList();
  }

  Future<void> _openEditDialog(int rowIndex) async {
    final BoyKiloModel record = _pageItems[rowIndex];

    final initial = <String>[
      '${record.ad} ${record.soyad}'.trim(),
      record.tarih.toString(),
      record.boy.toString(),
      record.kilo.toString(),
      record.aciklama ?? '',
    ];

    final result = await showDialog<dynamic>(
      context: context,
      builder:
          (_) => BoyKiloEditDialog(
            id: record.id.toString(),
            initialFields: initial,
            onDelete: () async {
              final ok = await widget.controller.deleteRecord(record.id);
              if (ok) {
                await widget.controller.fetchBoyKiloList();
                if (!mounted) return false;

                // Silmeden sonra son sayfa boş kaldıysa sayfayı geri al
                final newTotal =
                    (_all.isEmpty) ? 1 : (_all.length / _pageSize).ceil();
                if (_currentPage >= newTotal) {
                  setState(
                    () => _currentPage = (newTotal - 1).clamp(0, newTotal - 1),
                  );
                } else {
                  setState(() {});
                }
              }
              return ok;
            },
          ),
    );

    if (result == 'updated') {
      await widget.controller.fetchBoyKiloList();
      if (!mounted) return;
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = widget.controller.isLoadingBoyKilo;

    return Padding(
      padding: const EdgeInsets.all(12.0),
      child:
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : CustomTable(
                columnCount: _headers.length,
                columnHeaders: _headers,
                rowData: _rows(_pageItems),

                // ✅ "Tümünü Seç" istemiyoruz
                hasCheckboxColumn: false,
                checkboxStates: const [],

                // ✅ Pagination: 10 kayıt/sayfa
                hasPagination: true,
                currentPage: _currentPage,
                totalPages: _totalPages,
                onPrevious:
                    _currentPage > 0
                        ? () => setState(() => _currentPage -= 1)
                        : null,
                onNext:
                    (_currentPage + 1) < _totalPages
                        ? () => setState(() => _currentPage += 1)
                        : null,

                // ✅ Satır tıklama -> düzenle/sil diyalogu
                onRowTap: (rowIndex) => _openEditDialog(rowIndex),
              ),
    );
  }
}
