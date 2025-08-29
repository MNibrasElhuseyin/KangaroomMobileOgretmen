import 'package:flutter/material.dart';
import '../../widgets/custom_appbar.dart';
import 'message_card_list.dart';
import 'package:kangaroom_mobile/screens/mesaj_pages/massege_form.dart';
import 'message_controller.dart';
import '../../models/mesaj/post_mesaj.dart'; // <-- Burayı ekledik

class MesajPage extends StatefulWidget {
  const MesajPage({super.key});

  @override
  State<MesajPage> createState() => _MesajPageState();
}

class _MesajPageState extends State<MesajPage> {
  final MessageController _controller = MessageController();
  int? _selectedOgrenciId = -1;

  void _onOgrenciChanged(int? ogrenciId) {
    setState(() {
      _selectedOgrenciId = ogrenciId;
    });
  }

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onControllerChanged);
    _controller.fetchData();
  }

  @override
  void dispose() {
    _controller.removeListener(_onControllerChanged);
    _controller.dispose();
    super.dispose();
  }

  void _onControllerChanged() {
    if (mounted) setState(() {});
  }

  void _onSendButtonPressed(String icerik, int? ogrenciId) async {
    if (icerik.trim().isEmpty) return;

    final model = PostMesajModel(icerik: icerik, ogrenciID: ogrenciId ?? -1);

    bool success = await _controller.sendMessage(model);

    if (success) {
      setState(() {
        // Mesaj gönderildikten sonra filtre aynı kalacak, istenirse -1 yapılabilir
        _controller.previousPage();
        while (_controller.currentPage > 0) {
          _controller.previousPage();
        }
      });
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(success ? 'Mesaj gönderildi!' : 'Mesaj gönderilemedi!'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_controller.isLoading) {
      return const Scaffold(
        appBar: CustomAppBar(title: "Mesajlar"),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (_controller.error != null) {
      return Scaffold(
        appBar: const CustomAppBar(title: "Mesajlar"),
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.wifi_off_rounded,
                size: 56,
                color: Colors.redAccent,
              ),
              const SizedBox(height: 12),
              const Text(
                'Bağlantı sorunu',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 6),
              Text(
                _controller.error!,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.red),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: const CustomAppBar(title: "Mesajlar"),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Container(
                constraints: const BoxConstraints(
                  minHeight: 200,
                  maxHeight: 250,
                ),
                padding: const EdgeInsets.all(12.0),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(8.0),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: MessageForm(
                  ogrenciler: _controller.ogrenciler,
                  onSend: _onSendButtonPressed,
                  selectedOgrenciId: _selectedOgrenciId,
                  onOgrenciChanged: _onOgrenciChanged,
                ),
              ),
              const SizedBox(height: 8.0),
              Expanded(
                child: MessageCardList(
                  messages: _controller.mesajlar,
                  rowsPerPage: _controller.rowsPerPage,
                  filterOgrenciId: _selectedOgrenciId,
                  ogrenciler: _controller.ogrenciler,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
