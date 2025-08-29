import 'package:flutter/material.dart';
import 'dart:io';
import 'file_picker_service.dart';
import 'form_components.dart';
import 'package:kangaroom_mobile/screens/ders_resimleri_pages/ders_resimleri_controller.dart';
import 'package:kangaroom_mobile/models/dersResimVideo/get_ders_list.dart';
import 'package:kangaroom_mobile/models/dersResimVideo/post_ders_resim_video.dart';
import '/services/api_service.dart';
import 'package:kangaroom_mobile/models/dersResimVideo/post_ders_list.dart';

class DersResimleriForm extends StatefulWidget {
  const DersResimleriForm({super.key, required this.onDataAdded});

  final VoidCallback onDataAdded;

  @override
  State<DersResimleriForm> createState() => _DersResimleriFormState();
}

class _DersResimleriFormState extends State<DersResimleriForm> {
  final TextEditingController aciklamaController = TextEditingController();
  final TextEditingController yeniDersAdiController = TextEditingController();
  final FilePickerService _filePickerService = FilePickerService();
  final DersResimleriController _controller = DersResimleriController();

  String? selectedDers;
  int selectedOgrenci = -1; // Default olarak -1 (Tümü)
  List<GetDersListModel> dersler = [];
  List<String> dersListesi = [];
  bool isLoading = false; // LOADING DURUMU

  @override
  void initState() {
    super.initState();
    _loadOgrenciler();
    _loadDersler();
  }

  Future<void> _loadOgrenciler() async {
    setState(() {
      _controller.isLoadingOgrenciler = true;
    });

    try {
      await _controller.fetchOgrenciler();
      setState(() {});
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Öğrenci listesi yüklenirken hata oluştu: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        _controller.isLoadingOgrenciler = false;
      });
    }
  }

  Future<void> _loadDersler() async {
    try {
      await _controller.fetchDersData();
      dersler = _controller.dersler;
      dersListesi = dersler.map((e) => e.ad).toList();
      setState(() {});
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Ders listesi yüklenirken hata oluştu: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _showYeniDersEkleDialog() {
    yeniDersAdiController.clear();
    final TextEditingController yeniAciklamaController =
        TextEditingController();

    showDialog(
      context: context,
      builder:
          (_) => StatefulBuilder(
            builder: (context, setStateDialog) {
              final dersAdi = yeniDersAdiController.text.trim();

              return AlertDialog(
                title: const Text("Yeni Ders Ekle"),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: yeniDersAdiController,
                      decoration: const InputDecoration(
                        labelText: "Ders Adı *",
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (_) => setStateDialog(() {}),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: yeniAciklamaController,
                      decoration: const InputDecoration(
                        labelText: "Açıklama (opsiyonel)",
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ],
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text("İptal"),
                  ),
                  if (dersAdi.isNotEmpty)
                    ElevatedButton(
                      onPressed: () async {
                        final postModel = PostDersListModel(
                          ad: dersAdi,
                          aciklama: yeniAciklamaController.text.trim(),
                          personelId: 0, // <-- Buraya gerçek personelId'yi ver!
                        );
                        setState(() => isLoading = true); // LOADING BAŞLAT
                        final success = await _controller.postDersEkleBatch([
                          postModel,
                        ]);
                        setState(() => isLoading = false); // LOADING DURDUR
                        if (success) {
                          await _loadDersler();
                          setState(() {
                            selectedDers = dersAdi;
                          });
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Ders başarıyla eklendi'),
                              backgroundColor: Colors.green,
                            ),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Ders eklenemedi!'),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurple,
                      ),
                      child: const Text(
                        "Kaydet",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                ],
              );
            },
          ),
    );
  }

  Future<void> _submitForm() async {
    if (selectedDers == null || selectedDers!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Lütfen ders seçiniz'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final dersModel = dersler.firstWhere(
      (d) => d.ad == selectedDers,
      orElse: () => GetDersListModel(id: -1, ad: ""),
    );
    if (dersModel.id == -1) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Ders ID bulunamadı'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (_filePickerService.selectedFiles.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Lütfen dosya seçiniz'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final filePaths =
        _filePickerService.selectedFiles.map((f) => f.path).toList();

    setState(() {
      isLoading = true; // LOADING BAŞLAT
    });

    final postModel = PostDersResimVideoModel(
      dersId: dersModel.id,
      ogrenciId: selectedOgrenci,
      files: filePaths,
    );

    final success = await _controller.postDersResimleriBatch([postModel]);

    setState(() {
      isLoading = false; // LOADING DURDUR
    });

    if (success) {
      aciklamaController.clear();
      _filePickerService.clearFiles();
      selectedOgrenci = -1;
      setState(() {});

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Dosya(lar) başarıyla kaydedildi'),
          backgroundColor: Colors.green,
        ),
      );
      widget.onDataAdded();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Kayıt başarısız!'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        AbsorbPointer(
          absorbing: isLoading,
          child: Opacity(
            opacity: isLoading ? 0.5 : 1,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FormComponents.buildDersAdiSelector(
                  selectedDers: selectedDers,
                  dersListesi: dersListesi,
                  onDersChanged:
                      (value) => setState(() => selectedDers = value),
                  onYeniDersPressed: _showYeniDersEkleDialog,
                ),
                const SizedBox(height: 12),
                FormComponents.buildOgrenciSelector(
                  selectedOgrenci: selectedOgrenci,
                  ogrenciListesi:
                      _controller.ogrenciler
                          .map(
                            (o) => {
                              "id": o.id,
                              "ad": o.ad,
                              "soyad": o.soyad,
                              "sinif": "",
                            },
                          )
                          .toList(),
                  isLoading: _controller.isLoadingOgrenciler,
                  onOgrenciChanged:
                      (newValue) =>
                          setState(() => selectedOgrenci = newValue ?? -1),
                ),
                const SizedBox(height: 12),
                FormComponents.buildAciklamaField(aciklamaController),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: ElevatedButton.icon(
                        onPressed: () => _filePickerService.pickFiles(context),
                        icon: Icon(
                          _filePickerService.selectedFiles.isEmpty
                              ? Icons.upload_file
                              : (_filePickerService.fileType == 'image'
                                  ? Icons.image
                                  : Icons.videocam),
                          color: Colors.white,
                          size: 18,
                        ),
                        label: Text(
                          _filePickerService.selectedFiles.isEmpty
                              ? "Dosya Seç"
                              : "Dosya Değiştir",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepPurple,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          minimumSize: const Size(0, 40),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      flex: 1,
                      child: ElevatedButton(
                        onPressed:
                            (selectedDers != null && !isLoading)
                                ? _submitForm
                                : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepPurple,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          minimumSize: const Size(0, 40),
                        ),
                        child: const Text(
                          "Kaydet",
                          style: TextStyle(color: Colors.white, fontSize: 12),
                        ),
                      ),
                    ),
                  ],
                ),
                // if (_filePickerService.selectedFiles.isNotEmpty)
                //   Column(
                //     crossAxisAlignment: CrossAxisAlignment.start,
                //     children: [
                //       Text(
                //         "Seçilen Dosyalar:",
                //         style: TextStyle(fontWeight: FontWeight.bold),
                //       ),
                //       ..._filePickerService.selectedFiles.map(
                //         (f) => Text(f.path.split(Platform.pathSeparator).last),
                //       ),
                //       const SizedBox(height: 8),
                //       ElevatedButton.icon(
                //         onPressed: _filePickerService.clearFiles,
                //         icon: const Icon(Icons.delete),
                //         label: const Text("Tümünü Temizle"),
                //         style: ElevatedButton.styleFrom(
                //           backgroundColor: Colors.red,
                //           foregroundColor: Colors.white,
                //           minimumSize: const Size(0, 36),
                //         ),
                //       ),
                //     ],
                //   ),
                if (_filePickerService.fileError != null)
                  FormComponents.buildErrorMessage(
                    _filePickerService.fileError!,
                  ),
              ],
            ),
          ),
        ),
        if (isLoading)
          const Positioned.fill(
            child: Center(child: CircularProgressIndicator()),
          ),
      ],
    );
  }

  @override
  void dispose() {
    aciklamaController.dispose();
    yeniDersAdiController.dispose();
    super.dispose();
  }
}
