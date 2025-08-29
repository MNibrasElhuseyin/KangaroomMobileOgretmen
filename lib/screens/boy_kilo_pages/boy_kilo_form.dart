import 'package:flutter/material.dart';
import 'package:kangaroom_mobile/models/boyKilo/get_ogrenci_list.dart';
import 'package:kangaroom_mobile/models/boyKilo/post_boy_kilo.dart';
import 'package:kangaroom_mobile/widgets/date_widget.dart';
import '../../widgets/app_constant.dart';
import '../../widgets/custom_text_field.dart';
import 'boy_kilo_controller.dart';

class BoyKiloForm extends StatefulWidget {
  final BoyKiloController controller;
  final VoidCallback? onSaved; // kayıt sonrası tabloyu yenilemek için

  const BoyKiloForm({super.key, required this.controller, this.onSaved});

  @override
  State<BoyKiloForm> createState() => _BoyKiloFormState();
}

class _BoyKiloFormState extends State<BoyKiloForm> {
  GetOgrenciListModel? _selectedOgrenci;
  DateTime _selectedDate = DateTime.now();
  final _boyCtrl = TextEditingController();
  final _kiloCtrl = TextEditingController();
  final _aciklamaCtrl = TextEditingController();
  bool _posting = false;

  @override
  void dispose() {
    _boyCtrl.dispose();
    _kiloCtrl.dispose();
    _aciklamaCtrl.dispose();
    super.dispose();
  }

  String _fmtDate(DateTime d) =>
      "${d.year.toString().padLeft(4, '0')}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}";

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
    final boy = double.tryParse(_boyCtrl.text.replaceAll(',', '.'));
    final kilo = double.tryParse(_kiloCtrl.text.replaceAll(',', '.'));
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

    setState(() => _posting = true);
    final ok = await widget.controller.saveRecord(model);
    setState(() => _posting = false);

    if (ok) {
      await widget.controller.fetchBoyKiloList();
      _boyCtrl.clear();
      _kiloCtrl.clear();
      _aciklamaCtrl.clear();
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("Kayıt eklendi")));
      }
      widget.onSaved?.call();
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Kayıt eklenemedi")));
    }
  }

  @override
  Widget build(BuildContext context) {
    final ogrenciler = widget.controller.ogrenciListesi;
    final isLoadingOgr = widget.controller.isLoadingOgrenciler;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: LayoutBuilder(
        builder: (context, constraints) {
          // <600px: dikey; >=600px: yatay; >=1000px: geniş ekranda sağa hizalı buton
          final bool isSmall = constraints.maxWidth < 600;
          final bool isWide = constraints.maxWidth >= 1000;

          final gapW = isSmall ? 0.0 : 8.0;
          final gapH = 8.0;

          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minWidth: constraints.maxWidth),
              child: Column(
                children: [
                  // Öğrenci + Tarih
                  isSmall
                      ? Column(
                        children: [
                          _buildOgrenciDropdown(isLoadingOgr, ogrenciler),
                          SizedBox(height: gapH),
                          _buildDatePicker(),
                        ],
                      )
                      : Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 2,
                            child: _buildOgrenciDropdown(
                              isLoadingOgr,
                              ogrenciler,
                            ),
                          ),
                          SizedBox(width: gapW),
                          Expanded(child: _buildDatePicker()),
                        ],
                      ),
                  SizedBox(height: gapH),

                  // Boy - Kilo - Açıklama
                  isSmall
                      ? Column(
                        children: [
                          _buildBoyField(),
                          SizedBox(height: gapH),
                          _buildKiloField(),
                          SizedBox(height: gapH),
                          _buildAciklamaField(),
                        ],
                      )
                      : Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(child: _buildBoyField()),
                          SizedBox(width: gapW),
                          Expanded(child: _buildKiloField()),
                          SizedBox(width: gapW),
                          Expanded(flex: 2, child: _buildAciklamaField()),
                        ],
                      ),
                  SizedBox(height: gapH),

                  // Kaydet Butonu
                  Align(
                    alignment:
                        isWide ? Alignment.centerRight : Alignment.center,
                    child: SizedBox(
                      width: isSmall ? double.infinity : 220,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppConstants.primaryColor,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        onPressed: _posting ? null : _save,
                        child: Text(
                          _posting ? "Kaydediliyor..." : "Kaydet",
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // ---- Yardımcı widget metodları

  Widget _buildOgrenciDropdown(
    bool isLoadingOgr,
    List<GetOgrenciListModel> ogrenciler,
  ) {
    if (isLoadingOgr) {
      return const Center(child: CircularProgressIndicator());
    }
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
        contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 12),
      ),
    );
  }

  Widget _buildDatePicker() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
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
    keyboardType: const TextInputType.numberWithOptions(
      decimal: true,
      signed: false,
    ),
  );

  Widget _buildKiloField() => CustomTextField(
    controller: _kiloCtrl,
    labelText: "Kilo (kg)",
    keyboardType: const TextInputType.numberWithOptions(
      decimal: true,
      signed: false,
    ),
  );

  Widget _buildAciklamaField() => CustomTextField(
    controller: _aciklamaCtrl,
    labelText: "Açıklama",
    keyboardType: TextInputType.text,
  );
}
