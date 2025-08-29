// lib/screens/boy_kilo_pages/boy_kilo_edit_dialog.dart
import 'package:flutter/material.dart';

class BoyKiloEditDialog extends StatefulWidget {
  final String id; // sadece iç kullanım (kayıt id)
  final List<String> initialFields; // [Ad, Tarih, Boy, Kilo, Açıklama]
  final Future<bool> Function()? onDelete; // Silme callback

  const BoyKiloEditDialog({
    super.key,
    required this.id,
    required this.initialFields,
    this.onDelete,
  });

  @override
  State<BoyKiloEditDialog> createState() => _BoyKiloEditDialogState();
}

class _BoyKiloEditDialogState extends State<BoyKiloEditDialog> {
  late final TextEditingController _tarihCtrl;
  late final TextEditingController _boyCtrl;
  late final TextEditingController _kiloCtrl;
  late final TextEditingController _aciklamaCtrl;

  final _formKey = GlobalKey<FormState>();
  bool _hasChanged = false;
  bool _deleting = false;

  @override
  void initState() {
    super.initState();
    _tarihCtrl = TextEditingController(text: widget.initialFields[1]);
    _boyCtrl = TextEditingController(text: widget.initialFields[2]);
    _kiloCtrl = TextEditingController(text: widget.initialFields[3]);
    _aciklamaCtrl = TextEditingController(text: widget.initialFields[4]);

    // Değişiklik kontrolü
    for (final ctrl in [_tarihCtrl, _boyCtrl, _kiloCtrl, _aciklamaCtrl]) {
      ctrl.addListener(() {
        final initial = widget.initialFields;
        final changed =
            _tarihCtrl.text != initial[1] ||
            _boyCtrl.text != initial[2] ||
            _kiloCtrl.text != initial[3] ||
            _aciklamaCtrl.text != initial[4];
        if (changed != _hasChanged) {
          setState(() => _hasChanged = changed);
        }
      });
    }
  }

  @override
  void dispose() {
    _tarihCtrl.dispose();
    _boyCtrl.dispose();
    _kiloCtrl.dispose();
    _aciklamaCtrl.dispose();
    super.dispose();
  }

  String? _validateNumber(String? v) {
    if (v == null || v.trim().isEmpty) return 'Boş olamaz';
    final d = double.tryParse(v.replaceAll(',', '.'));
    if (d == null) return 'Sayı girin';
    return null;
  }

  Future<void> _handleDelete() async {
    if (widget.onDelete == null) return;

    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Kaydı Sil'),
        content: const Text('Bu kaydı silmek istediğinize emin misiniz?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Vazgeç'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Evet, Sil'),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    setState(() => _deleting = true);
    final ok = await widget.onDelete!.call();
    if (!mounted) return;
    setState(() => _deleting = false);

    if (ok && mounted) {
      Navigator.pop(context, 'deleted'); // Ana ekrana silindi bilgisi döndür
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Silme sırasında hata oluştu.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      // ✅ Başlığa ad soyad yazıldı
      title: Text(widget.initialFields[0]),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // ❌ Ad Soyad alanı kaldırıldı
              TextFormField(
                controller: _tarihCtrl,
                decoration: const InputDecoration(
                  labelText: 'Tarih (YYYY-MM-DD)',
                ),
                validator: (v) {
                  if (v == null || v.trim().isEmpty) return 'Zorunlu';
                  final p = v.split('-');
                  if (p.length != 3) return 'YYYY-MM-DD formatında girin';
                  return null;
                },
              ),
              TextFormField(
                controller: _boyCtrl,
                decoration: const InputDecoration(labelText: 'Boy (cm)'),
                keyboardType: TextInputType.number,
                validator: _validateNumber,
              ),
              TextFormField(
                controller: _kiloCtrl,
                decoration: const InputDecoration(labelText: 'Kilo (kg)'),
                keyboardType: TextInputType.number,
                validator: _validateNumber,
              ),
              TextFormField(
                controller: _aciklamaCtrl,
                decoration: const InputDecoration(labelText: 'Açıklama'),
              ),
              const SizedBox(height: 8),
              if (_deleting) const LinearProgressIndicator(),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed:
              (_deleting || widget.onDelete == null) ? null : _handleDelete,
          style: TextButton.styleFrom(foregroundColor: Colors.red),
          child: const Text('Sil'),
        ),
        TextButton(
          onPressed: _deleting ? null : () => Navigator.pop(context, null),
          child: const Text('İptal'),
        ),
        ElevatedButton(
          onPressed: (!_hasChanged || _deleting)
              ? null
              : () {
                  if (_formKey.currentState?.validate() != true) return;
                  Navigator.pop<List<String>>(context, [
                    widget.initialFields[0], // Ad Soyad yine data olarak döner
                    _tarihCtrl.text.trim(),
                    _boyCtrl.text.trim(),
                    _kiloCtrl.text.trim(),
                    _aciklamaCtrl.text.trim().isEmpty
                        ? 'Normal gelişim'
                        : _aciklamaCtrl.text.trim(),
                  ]);
                },
          child: const Text('Güncelle'),
        ),
      ],
    );
  }
}