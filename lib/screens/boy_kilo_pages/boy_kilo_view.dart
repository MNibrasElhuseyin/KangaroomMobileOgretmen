import 'package:flutter/material.dart';
import 'package:kangaroom_mobile/models/boyKilo/get_boy_kilo.dart';
import 'package:kangaroom_mobile/models/boyKilo/get_ogrenci_list.dart';
import 'package:kangaroom_mobile/models/boyKilo/post_boy_kilo.dart';
import 'package:kangaroom_mobile/widgets/ay_secici.dart';
import 'package:kangaroom_mobile/widgets/date_widget.dart';
import 'package:kangaroom_mobile/widgets/yil_secici.dart';
import 'package:kangaroom_mobile/widgets/custom_text_field.dart';
import '../../widgets/app_constant.dart';
import '../../widgets/tables/custom_table.dart';

import 'boy_kilo_controller.dart';
import 'boy_kilo_edit_dialog.dart';

class BoyKiloView extends StatefulWidget {
  final BoyKiloController controller;
  const BoyKiloView({super.key, required this.controller});

  @override
  State<BoyKiloView> createState() => _BoyKiloViewState();
}

class _BoyKiloViewState extends State<BoyKiloView> {
  GetOgrenciListModel? _selectedOgrenci;
  DateTime _selectedDate = DateTime.now();
  final _boyCtrl = TextEditingController();
  final _kiloCtrl = TextEditingController();
  final _aciklamaCtrl = TextEditingController();

  int? _filterYear;
  int? _filterMonth;

  bool _isInitLoading = true;
  bool _isPosting = false;
  bool _isDeleting = false;
  bool _formOpen = false;
  String? _errorMessage;

  static const int _pageSize = 10;
  int _page = 1;

  @override
  void initState() {
    super.initState();
    _bootstrap();
  }

  Future<void> _bootstrap() async {
    setState(() {
      _isInitLoading = true;
      _errorMessage = null;
    });
    try {
      await widget.controller.fetchOgrenciList();
      await widget.controller.fetchBoyKiloList();
    } catch (e) {
      final message = e.toString();
      // Kullanıcıya daha anlaşılır hata mesajı göster
      String cleanMessage;
      if (message.contains('Exception: ')) {
        cleanMessage = message.replaceFirst('Exception: ', '');
      } else {
        cleanMessage = message;
      }
      // Hata durumunda boş liste göster ve hata mesajını sakla
      widget.controller.ogrenciListesi = [];
      widget.controller.boyKiloListesi = [];
      setState(() {
        _errorMessage = cleanMessage;
      });
    } finally {
      setState(() => _isInitLoading = false);
    }
  }

  String _fmtDate(DateTime d) =>
      "${d.year.toString().padLeft(4, '0')}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}";
  String _fmtNum(double v) => v % 1 == 0 ? v.toInt().toString() : v.toString();
  String _norm(String s) => s.replaceAll(',', '.');

  int? _parseMonth(String? raw) {
    final a = (raw ?? '').trim();
    if (a.isEmpty || a == 'Tüm Aylar') return null;
    final n = int.tryParse(a);
    if (n != null && n >= 1 && n <= 12) return n;
    const map = {
      'Ocak': 1,
      'Şubat': 2,
      'Subat': 2,
      'Mart': 3,
      'Nisan': 4,
      'Mayıs': 5,
      'Mayis': 5,
      'Haziran': 6,
      'Temmuz': 7,
      'Ağustos': 8,
      'Agustos': 8,
      'Eylül': 9,
      'Eylul': 9,
      'Ekim': 10,
      'Kasım': 11,
      'Kasim': 11,
      'Aralık': 12,
      'Aralik': 12,
    };
    return map[a];
  }

  String _monthLabel(int? m) {
    if (m == null) return 'Tüm Aylar';
    const names = [
      '',
      'Ocak',
      'Şubat',
      'Mart',
      'Nisan',
      'Mayıs',
      'Haziran',
      'Temmuz',
      'Ağustos',
      'Eylül',
      'Ekim',
      'Kasım',
      'Aralık',
    ];
    return (m >= 1 && m <= 12) ? names[m] : 'Tüm Aylar';
  }

  List<BoyKiloModel> _applyFilter(List<BoyKiloModel> list) {
    if (_filterYear == null && _filterMonth == null) return list;
    return list.where((k) {
      final t = k.tarih;
      if (t == null || t.length < 7) return false;
      final y = int.tryParse(t.substring(0, 4));
      final m = int.tryParse(t.substring(5, 7));
      if (_filterYear != null && y != _filterYear) return false;
      if (_filterMonth != null && m != _filterMonth) return false;
      return true;
    }).toList();
  }

  Future<void> _save() async {
    if (_selectedOgrenci == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Lütfen öğrenci seçin")));
      return;
    }
    if (_boyCtrl.text.isEmpty || _kiloCtrl.text.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Boy ve Kilo zorunludur")));
      return;
    }
    final boy = double.tryParse(_norm(_boyCtrl.text));
    final kilo = double.tryParse(_norm(_kiloCtrl.text));
    if (boy == null || kilo == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Boy/Kilo sayısal olmalıdır")),
      );
      return;
    }

    final model = PostBoyKiloModel(
      ogrenciId: _selectedOgrenci!.id,
      boy: boy,
      kilo: kilo,
      aciklama: _aciklamaCtrl.text,
      tarih: _fmtDate(_selectedDate),
    );

    setState(() => _isPosting = true);
    final ok = await widget.controller.saveRecord(model);
    setState(() => _isPosting = false);

    if (ok) {
      _boyCtrl.clear();
      _kiloCtrl.clear();
      _aciklamaCtrl.clear();
      await widget.controller.fetchBoyKiloList();
      setState(() => _page = 1);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Kayıt eklendi")));
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Kayıt eklenemedi")));
    }
  }

  Future<void> _editRow(BoyKiloModel k) async {
    final res = await showDialog(
      context: context,
      builder:
          (ctx) => BoyKiloEditDialog(
            id: k.id.toString(),
            initialFields: [
              "${k.ad} ${k.soyad}",
              (k.tarih ?? ''),
              _fmtNum(k.boy),
              _fmtNum(k.kilo),
              k.aciklama ?? "",
            ],
            // ⬇️ Silme işlemini gerçekten yapan callback
            onDelete: () async {
              final ok = await widget.controller.deleteRecord(k.id);
              return ok; // true dönerse dialog 'deleted' ile kapanacak
            },
          ),
    );

    if (!mounted) return;

    // ⬇️ Silme sonucu
    if (res == 'deleted') {
      await widget.controller.fetchBoyKiloList();
      setState(() {}); // tabloyu yenile
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Kayıt silindi')));
      return;
    }

    // ⬇️ Güncelleme sonucu (liste dönüyorsa)
    if (res is List<String>) {
      final newBoy = double.tryParse(_norm(res[2]));
      final newKilo = double.tryParse(_norm(res[3]));
      final newAcik = res[4];
      if (newBoy == null || newKilo == null) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Boy/Kilo sayı olmalı')));
        return;
      }

      final ok = await widget.controller.updateRecordFull(
        id: k.id,
        boy: newBoy,
        kilo: newKilo,
        aciklama: newAcik,
      );

      if (ok) {
        await widget.controller.fetchBoyKiloList();
        setState(() {});
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Kayıt güncellendi')));
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Güncelleme başarısız')));
      }
    }
  }


  @override
  void dispose() {
    _boyCtrl.dispose();
    _kiloCtrl.dispose();
    _aciklamaCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isInitLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    // Hata durumunda modern error UI göster
    if (_errorMessage != null) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.wifi_off_rounded, size: 56, color: Colors.redAccent),
            const SizedBox(height: 12),
            const Text(
              'Bağlantı sorunu',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 6),
            Text(
              _errorMessage!,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.red),
            ),
          ],
        ),
      );
    }

    final ogrenciler = widget.controller.ogrenciListesi;
    final allKayitlar = widget.controller.boyKiloListesi;
    final filtered = _applyFilter(allKayitlar);

    final totalPages =
        (filtered.isEmpty)
            ? 1
            : ((filtered.length + _pageSize - 1) ~/ _pageSize);
    if (_page > totalPages) _page = totalPages;
    final start = (_page - 1) * _pageSize;
    final pageItems = filtered.skip(start).take(_pageSize).toList();

    final rowData =
        pageItems
            .map(
              (k) => [
                "${k.ad} ${k.soyad}",
                k.tarih ?? '-',
                _fmtNum(k.boy),
                _fmtNum(k.kilo),
                k.aciklama ?? "",
              ],
            )
            .toList();

    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        children: [
          // FORM - responsive
          Card(
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            color: Colors.white,
            child: ExpansionTile(
              initiallyExpanded: _formOpen,
              onExpansionChanged: (v) => setState(() => _formOpen = v),
              title: const Text("Yeni Kayıt"),
              childrenPadding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
              children: [
                LayoutBuilder(
                  builder: (context, constraints) {
                    bool isSmall = constraints.maxWidth < 600;
                    return Column(
                      children: [
                        isSmall
                            ? Column(
                              children: [
                                _buildOgrenciDropdown(ogrenciler),
                                const SizedBox(height: 8),
                                _buildDatePicker(),
                              ],
                            )
                            : Row(
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: _buildOgrenciDropdown(ogrenciler),
                                ),
                                const SizedBox(width: 8),
                                Expanded(child: _buildDatePicker()),
                              ],
                            ),
                        const SizedBox(height: 8),
                        isSmall
                            ? Column(
                              children: [
                                _buildBoyField(),
                                const SizedBox(height: 8),
                                _buildKiloField(),
                                const SizedBox(height: 8),
                                _buildAciklamaField(),
                              ],
                            )
                            : Row(
                              children: [
                                Expanded(child: _buildBoyField()),
                                const SizedBox(width: 8),
                                Expanded(child: _buildKiloField()),
                                const SizedBox(width: 8),
                                Expanded(child: _buildAciklamaField()),
                              ],
                            ),
                        const SizedBox(height: 8),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppConstants.primaryColor,
                            ),
                            onPressed: _isPosting ? null : _save,
                            child: Text(
                              _isPosting ? "Kaydediliyor..." : "Kaydet",
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // FİLTRELER
          Row(
            children: [
              const Padding(
                padding: EdgeInsets.only(right: 8.0),
                child: Text(
                  'Kayıtlar',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
              SizedBox(
                width: 120,
                child: YilSecici(
                  // Yıl seçilmemişse 'Tümü' göster
                  seciliYil:
                      _filterYear == null ? 'Tümü' : _filterYear.toString(),
                  onChanged: (y) {
                    final v = (y ?? '').trim();
                    setState(() {
                      // 'Tümü' (veya boş) → null yap (yani yıl filtresi yok)
                      _filterYear =
                          (v.isEmpty || v == 'Tümü' || v == 'Tumu')
                              ? null
                              : int.tryParse(v);
                      _page = 1;
                    });
                  },
                  isWeb: false,
                ),
              ),

              const SizedBox(width: 8),
              SizedBox(
                width: 150,
                child: AySecici(
                  seciliAy: _monthLabel(_filterMonth),
                  onChanged: (ay) {
                    setState(() {
                      _filterMonth = _parseMonth(ay);
                      _page = 1;
                    });
                  },
                  isWeb: false,
                ),
              ),
              const Spacer(),
              if (_isDeleting)
                const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
            ],
          ),
          const SizedBox(height: 8),

          // TABLO
          Expanded(
            child: Card(
              elevation: 0,
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child:
                    (rowData.isEmpty)
                        ? const Center(child: Text("Kayıt bulunamadı"))
                        : CustomTable(
                          columnCount: 5,
                          columnHeaders: const [
                            "Öğrenci",
                            "Tarih",
                            "Boy (cm)",
                            "Kilo (kg)",
                            "Açıklama",
                          ],
                          rowData: rowData,
                          hasCheckboxColumn: false,
                          hasPagination: totalPages > 1,
                          currentPage: _page - 1,
                          totalPages: totalPages,
                          onPrevious:
                              _page > 1 ? () => setState(() => _page--) : null,
                          onNext:
                              _page < totalPages
                                  ? () => setState(() => _page++)
                                  : null,
                          onRowTap: (i) => _editRow(pageItems[i]),
                        ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOgrenciDropdown(List<GetOgrenciListModel> ogrenciler) {
    return DropdownButtonFormField<GetOgrenciListModel>(
      value: _selectedOgrenci,
      hint: const Text("Öğrenci Seçin"),
      items:
          ogrenciler
              .map(
                (o) => DropdownMenuItem(
                  value: o,
                  child: Text("${o.ad} ${o.soyad}"),
                ),
              )
              .toList(),
      onChanged: (v) => setState(() => _selectedOgrenci = v),
      decoration: const InputDecoration(
        border: OutlineInputBorder(),
        isDense: true,
        contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 10),
      ),
    );
  }

  Widget _buildDatePicker() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade400),
        borderRadius: BorderRadius.circular(8),
      ),
      child: DatePickerWidget(
        initialDate: _selectedDate,
        onDateSelected: (d) => setState(() => _selectedDate = d),
      ),
    );
  }

  Widget _buildBoyField() => CustomTextField(
    controller: _boyCtrl,
    labelText: "Boy (cm)",
    keyboardType: TextInputType.number,
  );

  Widget _buildKiloField() => CustomTextField(
    controller: _kiloCtrl,
    labelText: "Kilo (kg)",
    keyboardType: TextInputType.number,
  );

  Widget _buildAciklamaField() => CustomTextField(
    controller: _aciklamaCtrl,
    labelText: "Açıklama",
    keyboardType: TextInputType.text,
  );
}
