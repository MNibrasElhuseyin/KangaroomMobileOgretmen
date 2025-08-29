import 'package:flutter/material.dart';
import 'package:kangaroom_mobile/screens/sinif_takip_pages/sinif_takip_controller.dart';
import 'package:kangaroom_mobile/widgets/tables/custom_table.dart';
import 'package:kangaroom_mobile/widgets/date_widget.dart';
import 'package:kangaroom_mobile/screens/sinif_takip_pages/yoklama_button.dart';
import 'package:kangaroom_mobile/screens/sinif_takip_pages/kayit_et_button.dart';
import 'package:kangaroom_mobile/models/sinifTakip/DuyguDurum/post_duygu_durum.dart';
import 'package:kangaroom_mobile/models/sinifTakip/Uyku/post_uyku.dart';
import 'package:kangaroom_mobile/models/sinifTakip/Beslenme/post_beslenme.dart';
import 'package:kangaroom_mobile/models/sinifTakip/Ilac/post_ilac.dart';
import 'package:kangaroom_mobile/models/sinifTakip/Yoklama/post_yoklama.dart';
import '../../widgets/ogunTakip_widget.dart';
import 'HeaderSection.dart';
import 'yoklama_card_list.dart';
import 'duygu_durum_card_list.dart';
import 'uyku_card_list.dart';
import 'beslenme_card_list.dart';
import 'ilac_card_list.dart';
import 'kiyafet_card_list.dart';

class SinifTakipView extends StatefulWidget {
  final SinifTakipController controller;
  final Function(int)? onMenuItemSelected;

  const SinifTakipView({
    super.key,
    required this.controller,
    this.onMenuItemSelected,
  });

  @override
  State<SinifTakipView> createState() => _SinifTakipViewState();
}

class _SinifTakipViewState extends State<SinifTakipView> {
  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onControllerChange);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onControllerChange);
    super.dispose();
  }

  void _onControllerChange() {
    setState(() {});
  }

  void _onAttendanceChanged(int studentIndex, bool isPresent) {
    widget.controller.updateAttendanceStatus(studentIndex, isPresent);
  }

  // Genel kaydet butonuna basıldığında çalışacak fonksiyon
  Future<void> _onGenericSavePressed() async {
    setState(() {}); // Refresh after save
  }

  Future<void> _onMoodChanged(int studentIndex, int newDurum) async {
    try {
      // Önce yerel state'i güncelle (anında UI feedback için)
      widget.controller.updateDuyguDurum(studentIndex, newDurum);
    } catch (e) {
      debugPrint('Duygu durumu güncelleme hatası: $e');
    }
  }

  Future<void> _onSleepChanged(int studentIndex, int newDurum) async {
    try {
      // Önce yerel state'i güncelle (anında UI feedback için)
      widget.controller.updateUyku(studentIndex, newDurum);
    } catch (e) {
      debugPrint('Uyku durumu güncelleme hatası: $e');
    }
  }

  Future<void> _onBeslenmeChanged(int studentIndex, int newDurum) async {
    try {
      // Önce yerel state'i güncelle (anında UI feedback için)
      widget.controller.updateBeslenmeDurum(studentIndex, newDurum);
    } catch (e) {
      debugPrint('Beslenme durumu güncelleme hatası: $e');
    }
  }

  Future<void> _onIlacChanged(int studentIndex, int newDurum) async {
    try {
      // Önce yerel state'i güncelle (anında UI feedback için)
      widget.controller.updateIlacDurum(studentIndex, newDurum);
    } catch (e) {
      debugPrint('İlaç durumu güncelleme hatası: $e');
    }
  }

  // Kıyafet değişikliği - sadece controller'a kaydet, hemen API'ye gönderme
  void _onKiyafetChanged(int studentIndex, String itemType, bool isSelected) {
    widget.controller.updateKiyafetChange(studentIndex, itemType, isSelected);
  }

  // Yoklama al butonuna basıldığında çalışacak fonksiyon (eski yoklama butonu için)
  Future<void> _onYoklamaAlPressed() async {
    final result = await widget.controller.saveAttendanceData();

    if (!mounted) return;

    if (result) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Yoklama başarıyla kaydedildi.')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Yoklama kaydedilirken bir hata oluştu.')),
      );
    }
  }

  // Hangi menüde değişiklik indicator'ı gösterileceğini belirle
  bool _shouldShowChangeIndicator(int menuIndex) {
    switch (menuIndex) {
      case 0:
        return widget.controller.hasYoklamaChanges();
      case 1:
        return widget.controller.hasDuyguDurumChanges();
      case 2:
        return widget.controller.hasUykuChanges();
      case 3:
        return widget.controller.hasBeslenmeChanges();
      case 4:
        return widget.controller.hasIlacChanges();
      case 5:
        return widget.controller.hasKiyafetChanges();
      default:
        return false;
    }
  }

  // Hangi kaydet butonunu göstereceğini belirle
  Widget _buildSaveButton(int menuIndex) {
    // Yoklama için eski YoklamaButton'u kullan (geriye uyumluluk için)
    if (menuIndex == 0) {
      return YoklamaButton(
        onPressed: widget.controller.hasYoklamaChanges() ? _onYoklamaAlPressed : null,
      );
    }

    // Diğer menüler için GenelKayitButton kullan
    return GenelKayitButton(
      controller: widget.controller,
      menuType: menuIndex,
      onPressed: _onGenericSavePressed,
    );
  }

  @override
  Widget build(BuildContext context) {
    final titles = [
      'Yoklama',
      'Duygu Durum',
      'Uyku',
      'Beslenme',
      'İlaç',
      'Kıyafet',
    ];

    final selectedDate = widget.controller.selectedDate;
    final selectedMenu = widget.controller.selectedMenuItem;
    final isLoading = widget.controller.isLoading;

    return Column(
      children: [
        HeaderSection(
          selectedMenuItem: selectedMenu,
          onItemSelected: (index) {
            widget.controller.setSelectedMenuItem(index);
            if (widget.onMenuItemSelected != null) {
              widget.onMenuItemSelected!(index);
            }
          },
          iconSize: 28.0,
          fontSize: 11.0,
        ),
        const SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: DatePickerWidget(
                      initialDate: selectedDate ?? DateTime.now(),
                      onDateSelected: (date) {
                        widget.controller.setSelectedDate(date);
                      },
                    ),
                  ),
                ),
                // Beslenme menüsü için öğün seçici
                if (selectedMenu == 3)
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: OgunDropdown(
                        seciliOgun: widget.controller.selectedOgun,
                        onOgunChanged: (ogun) {
                          widget.controller.setSelectedOgun(ogun);
                        },
                      ),
                    ),
                  ),
                // Tüm menüler için kaydet butonu
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: _buildSaveButton(selectedMenu),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 8),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Builder(
                builder: (context) {
                  if (selectedDate == null) {
                    return const Center(
                      child: Text(
                        'Lütfen bir tarih seçiniz',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    );
                  }

                  if (isLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              titles[selectedMenu],
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                            // Herhangi bir menüde değişiklik varsa indicator göster
                            if (_shouldShowChangeIndicator(selectedMenu))
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.orange[100],
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: Colors.orange[300]!,
                                  ),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.edit,
                                      size: 14,
                                      color: Colors.orange[700],
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      'Değişiklik var',
                                      style: TextStyle(
                                        fontSize: 11,
                                        color: Colors.orange[700],
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                          ],
                        ),
                      ),
                      const Divider(
                        height: 1,
                        thickness: 1,
                        indent: 16,
                        endIndent: 16,
                      ),
                      const SizedBox(height: 8),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(16.0, 0, 16.0, 8.0),
                          child: _buildContentWidget(selectedMenu),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildContentWidget(int selectedMenu) {
    switch (selectedMenu) {
      case 0: // Yoklama
        return YoklamaCardList(
          students: widget.controller.getTableData(selectedMenu),
          rowsPerPage: widget.controller.rowsPerPage,
          currentPage: widget.controller.currentPage,
          onPrevious: widget.controller.goToPreviousPage,
          onNext: widget.controller.goToNextPage,
          controller: widget.controller,
        );
      case 1: // Duygu Durum
        return DuyguDurumCardList(
          students: widget.controller.duyguDurumList,
          rowsPerPage: widget.controller.rowsPerPage,
          currentPage: widget.controller.currentPage,
          onPrevious: widget.controller.goToPreviousPage,
          onNext: widget.controller.goToNextPage,
          onEmojiSelected: _onMoodChanged,
        );
      case 2: // Uyku
        return UykuCardList(
          students: widget.controller.uykuList,
          rowsPerPage: widget.controller.rowsPerPage,
          currentPage: widget.controller.currentPage,
          onPrevious: widget.controller.goToPreviousPage,
          onNext: widget.controller.goToNextPage,
          onStatusSelected: _onSleepChanged,
        );
      case 3: // Beslenme
        return BeslenmeCardList(
          students: widget.controller.filteredBeslenmeList,
          rowsPerPage: widget.controller.rowsPerPage,
          currentPage: widget.controller.currentPage,
          onPrevious: widget.controller.goToPreviousPage,
          onNext: widget.controller.goToNextPage,
          onStatusSelected: _onBeslenmeChanged,
        );
      case 4: // İlaç
        return IlacCardList(
          students: widget.controller.ilacList,
          rowsPerPage: widget.controller.rowsPerPage,
          currentPage: widget.controller.currentPage,
          onPrevious: widget.controller.goToPreviousPage,
          onNext: widget.controller.goToNextPage,
          onStatusSelected: _onIlacChanged,
        );
      case 5: // Kıyafet
        return KiyafetCardList(
          students: widget.controller.kiyafetList,
          rowsPerPage: widget.controller.rowsPerPage,
          currentPage: widget.controller.currentPage,
          onPrevious: widget.controller.goToPreviousPage,
          onNext: widget.controller.goToNextPage,
          onItemSelected: _onKiyafetChanged,
        );
      default: // Fallback tablo
        return CustomTable(
          columnCount: widget.controller.getColumnHeaders(selectedMenu).length,
          columnHeaders: widget.controller.getColumnHeaders(selectedMenu),
          rowData: widget.controller.getPaginatedTableData(selectedMenu),
          hasPagination: true,
          currentPage: widget.controller.currentPage,
          totalPages: widget.controller.getTotalPages(selectedMenu),
          onPrevious: widget.controller.goToPreviousPage,
          onNext: widget.controller.goToNextPage,
        );
    }
  }
}