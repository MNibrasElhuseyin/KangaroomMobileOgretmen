import 'package:flutter/material.dart';
import '../../models/boyKilo/get_ogrenci_list.dart';
import '../../widgets/custom_appbar.dart';
import '../../widgets/app_constant.dart';
import 'kiyafet_talep_controller.dart';

class KiyafetTalepView extends StatefulWidget {
  const KiyafetTalepView({super.key});

  @override
  State<KiyafetTalepView> createState() => _KiyafetTalepViewState();
}

class _KiyafetTalepViewState extends State<KiyafetTalepView> {
  late KiyafetTalepController _controller;

  @override
  void initState() {
    super.initState();
    _controller = KiyafetTalepController();
    _controller.fetchData();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  int _colorIndexByCard(int index) => index % AppConstants.cardColors.length;

  Color _tileBaseColor(int index) =>
      AppConstants.cardColors[_colorIndexByCard(index)];

  Color _tileFillColor(int index, bool selected) {
    if (selected) return AppConstants.primaryColor;
    return _tileBaseColor(index).withOpacity(0.85);
  }

  Color _tileBorderColor(int index, bool selected) {
    if (selected) return AppConstants.accentColor.withOpacity(0.9);
    return _tileBaseColor(index).withOpacity(0.75);
  }

  Color _contrastOn(Color c) =>
      c.computeLuminance() > 0.5 ? Colors.black87 : Colors.white;

  Widget _buildKiyafetSelectionBox(int index) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final isSelected = _controller.isKiyafetSelected(index);
        final base = isSelected ? AppConstants.primaryColor : _tileBaseColor(index);
        final fill = _tileFillColor(index, isSelected);
        final border = _tileBorderColor(index, isSelected);
        final contrast = _contrastOn(base);
        return GestureDetector(
          onTap: () => _controller.toggleKiyafetSelection(index),
          child: Container(
            width: double.infinity,
            height: 56,
            margin: const EdgeInsets.symmetric(horizontal: 1, vertical: 1),
            decoration: BoxDecoration(
              color: fill,
              border: Border.all(color: border, width: isSelected ? 2 : 1),
              borderRadius: BorderRadius.circular(12.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.06),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 26,
                    height: 26,
                    decoration: BoxDecoration(
                      color: contrast.withOpacity(0.18),
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(
                        color: contrast.withOpacity(0.35),
                        width: 0.8,
                      ),
                    ),
                    child: Icon(
                      _controller.icons[index],
                      size: 15,
                      color: contrast,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    _controller.labels[index],
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 11.5,
                      fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                      color: contrast,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildKategoriSection() {
    final double horizontalPadding = MediaQuery.of(context).size.width * 0.02;

    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: horizontalPadding,
        vertical: 6.0,
      ),
      padding: const EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.0),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.04),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.category,
                size: 16,
                color: Theme.of(context).primaryColor,
              ),
              const SizedBox(width: 4),
              Text(
                'Kıyafet Seçimi',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).primaryColor,
                ),
              ),
              const SizedBox(width: 4),
              const Text(
                '*',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Colors.red,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 4,
              mainAxisSpacing: 4,
              childAspectRatio: 2.8,
            ),
            itemCount: 4,
            itemBuilder: (context, index) => _buildKiyafetSelectionBox(index),
          ),
        ],
      ),
    );
  }

  Widget _buildOgrenciSection() {
    final double horizontalPadding = MediaQuery.of(context).size.width * 0.02;

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Container(
          margin: EdgeInsets.symmetric(
            horizontal: horizontalPadding,
            vertical: 8.0,
          ),
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12.0),
            border: Border.all(color: Colors.grey.shade200),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.06),
                spreadRadius: 1,
                blurRadius: 4,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.person,
                    size: 18,
                    color: Theme.of(context).primaryColor,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    'Öğrenci Seçimi',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  const SizedBox(width: 4),
                  const Text(
                    '*',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.red,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<GetOgrenciListModel>(
                    value: _controller.selectedStudent,
                    hint: const Text('Öğrenci seçiniz'),
                    isExpanded: true,
                    items: _controller.students.map((GetOgrenciListModel student) {
                      return DropdownMenuItem<GetOgrenciListModel>(
                        value: student,
                        child: Text(student.modelAdSoyad),
                      );
                    }).toList(),
                    onChanged: (GetOgrenciListModel? newValue) {
                      _controller.setSelectedStudent(newValue);
                    },
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildAciklamaSection() {
    final double horizontalPadding = MediaQuery.of(context).size.width * 0.02;

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Container(
          margin: EdgeInsets.symmetric(
            horizontal: horizontalPadding,
            vertical: 8.0,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12.0),
            border: Border.all(color: Colors.grey.shade200),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.06),
                spreadRadius: 1,
                blurRadius: 4,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InkWell(
                onTap: () => _controller.toggleAciklamaExpanded(),
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: _controller.isAciklamaExpanded
                        ? Theme.of(context).primaryColor.withOpacity(0.10)
                        : Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.description,
                            size: 18,
                            color: _controller.isAciklamaExpanded
                                ? Theme.of(context).primaryColor
                                : Colors.grey.shade600,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Açıklama',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: _controller.isAciklamaExpanded
                                  ? Theme.of(context).primaryColor
                                  : Colors.grey.shade700,
                            ),
                          ),
                          const SizedBox(width: 4),
                          const Text(
                            '*',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.red,
                            ),
                          ),
                        ],
                      ),
                      AnimatedRotation(
                        turns: _controller.isAciklamaExpanded ? 0.5 : 0,
                        duration: const Duration(milliseconds: 300),
                        child: Icon(
                          Icons.keyboard_arrow_down,
                          color: _controller.isAciklamaExpanded
                              ? Theme.of(context).primaryColor
                              : Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                height: _controller.isAciklamaExpanded ? 120 : 0,
                child: _controller.isAciklamaExpanded
                    ? Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextField(
                    controller: _controller.descriptionController,
                    maxLines: 3,
                    onChanged: (_) => _controller.notifyListeners(),
                    decoration: InputDecoration(
                      hintText: 'Kıyafet talebi ile ilgili açıklama yazınız...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Theme.of(context).primaryColor),
                      ),
                      contentPadding: const EdgeInsets.all(12),
                      filled: true,
                      fillColor: Colors.grey.shade50,
                    ),
                  ),
                )
                    : const SizedBox.shrink(),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSendButton() {
    final double horizontalPadding = MediaQuery.of(context).size.width * 0.02;

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Container(
          margin: EdgeInsets.symmetric(
            horizontal: horizontalPadding,
            vertical: 8.0,
          ),
          child: Column(
            children: [
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: _controller.isFormValid() ? () async {
                    await _controller.sendKiyafetTalep(context);
                  } : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _controller.isFormValid()
                        ? Theme.of(context).primaryColor
                        : Colors.grey.shade400,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: _controller.isFormValid() ? 2 : 0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.send,
                        size: 20,
                        color: _controller.isFormValid() ? Colors.white : Colors.grey.shade600,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Kıyafet İste',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: _controller.isFormValid() ? Colors.white : Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '* İşaretli alanlar zorunludur',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHistorySection() {
    final double horizontalPadding = MediaQuery.of(context).size.width * 0.02;

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Container(
          margin: EdgeInsets.symmetric(
            horizontal: horizontalPadding,
            vertical: 8.0,
          ),
          constraints: BoxConstraints(
            minHeight: 400,
            maxHeight: MediaQuery.of(context).size.height * 0.6,
          ),
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 8.0),
                  child: Text(
                    "Kıyafet Talep Geçmişi",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ),
                const Divider(height: 1, thickness: 1, indent: 16, endIndent: 16),
                const SizedBox(height: 8),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 8.0),
                    child: _controller.isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : _buildKiyafetTalepCards(),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildKiyafetTalepCards() {
    final currentData = _controller.getPaginatedTableData();

    return Column(
      children: [
        Expanded(
          child: currentData.isEmpty
              ? Container(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.checkroom_outlined, size: 64, color: Colors.grey),
                const SizedBox(height: 16),
                Text(
                  'Henüz kıyafet talebi bulunmuyor',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Yukarıdaki formu kullanarak kıyafet talebi oluşturabilirsiniz.',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[500],
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          )
              : ListView.separated(
            itemCount: currentData.length,
            separatorBuilder: (_, __) => const SizedBox(height: 8),
            itemBuilder: (context, index) {
              final talepBilgisi = currentData[index];
              final kiyafetTurleri = _extractKiyafetTurleri(talepBilgisi[2]);
              final aciklama = _extractAciklama(talepBilgisi[2]);

              return Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                elevation: 2,
                shadowColor: Colors.grey.withOpacity(0.15),
                margin: const EdgeInsets.symmetric(vertical: 2),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.deepPurple[50],
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(
                            color: Colors.deepPurple[200]!,
                            width: 1,
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.person,
                              size: 16,
                              color: Colors.deepPurple[700],
                            ),
                            const SizedBox(width: 6),
                            Expanded(
                              child: Text(
                                talepBilgisi[0],
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.deepPurple[800],
                                ),
                              ),
                            ),
                            Text(
                              talepBilgisi[1],
                              style: TextStyle(
                                fontSize: 11,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                      if (aciklama.isNotEmpty)
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(8),
                          margin: const EdgeInsets.only(bottom: 8),
                          decoration: BoxDecoration(
                            color: Colors.grey[50],
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(color: Colors.grey[300]!),
                          ),
                          child: Text(
                            aciklama,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[700],
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ),
                      if (kiyafetTurleri.isNotEmpty)
                        Wrap(
                          spacing: 6,
                          runSpacing: 4,
                          children: [
                            if (kiyafetTurleri.contains('Üst Kıyafet'))
                              _buildKiyafetTypeItem(
                                'Üst Kıyafet',
                                true,
                                Icons.checkroom,
                                Colors.blue[600]!,
                              ),
                            if (kiyafetTurleri.contains('Alt Kıyafet'))
                              _buildKiyafetTypeItem(
                                'Alt Kıyafet',
                                true,
                                Icons.content_cut,
                                Colors.green[600]!,
                              ),
                            if (kiyafetTurleri.contains('Üst Çamaşır'))
                              _buildKiyafetTypeItem(
                                'Üst Çamaşır',
                                true,
                                Icons.dry_cleaning,
                                Colors.purple[600]!,
                              ),
                            if (kiyafetTurleri.contains('Alt Çamaşır'))
                              _buildKiyafetTypeItem(
                                'Alt Çamaşır',
                                true,
                                Icons.local_laundry_service,
                                Colors.orange[600]!,
                              ),
                          ],
                        ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: _controller.currentPage > 0 ? _controller.goToPreviousPage : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              ),
              child: const Text(
                "← Önceki",
                style: TextStyle(fontSize: 12),
              ),
            ),
            const SizedBox(width: 12),
            Text(
              'Sayfa ${_controller.currentPage + 1}',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(width: 12),
            ElevatedButton(
              onPressed: _controller.currentPage < _controller.getTotalPages() - 1 ? _controller.goToNextPage : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              ),
              child: const Text(
                "Sonraki →",
                style: TextStyle(fontSize: 12),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildKiyafetTypeItem(String label, bool isSelected, IconData icon, Color color) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: isSelected ? color.withOpacity(0.1) : Colors.grey[100],
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 16,
            color: isSelected ? color : Colors.grey[600],
          ),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: isSelected ? color : Colors.grey[700],
            ),
          ),
        ],
      ),
    );
  }

  List<String> _extractKiyafetTurleri(String icerik) {
    List<String> turler = [];
    if (icerik.contains('Üst Çamaşır')) turler.add('Üst Çamaşır');
    if (icerik.contains('Alt Çamaşır')) turler.add('Alt Çamaşır');
    if (icerik.contains('Üst Kıyafet')) turler.add('Üst Kıyafet');
    if (icerik.contains('Alt Kıyafet')) turler.add('Alt Kıyafet');
    return turler;
  }

  String _extractAciklama(String icerik) {
    final regex = RegExp(r'\(([^)]+)\)');
    final matches = regex.allMatches(icerik);
    if (matches.isNotEmpty) {
      return matches.last.group(1) ?? '';
    }
    return '';
  }

  @override
  Widget build(BuildContext context) {
    print('🔍 Kıyafet talep view build - errorMessage: ${_controller.errorMessage}');
    return Scaffold(
      appBar: const CustomAppBar(title: "Kıyafet Talep"),
      body: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          print('🔍 AnimatedBuilder - errorMessage: ${_controller.errorMessage}');
          return _controller.errorMessage != null
              ? Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.wifi_off_rounded, size: 56, color: Colors.redAccent),
                const SizedBox(height: 12),
                const Text(
                  'Bağlantı sorunu',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 6),
                const Text(
                  '📶 İnternet bağlantınızı kontrol ediniz',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.red),
                ),
              ],
            ),
          )
              : SingleChildScrollView(
            child: Column(
              children: [
                _buildKategoriSection(),
                _buildOgrenciSection(),
                _buildAciklamaSection(),
                _buildSendButton(),
                _buildHistorySection(),
                const SizedBox(height: 20),
              ],
            ),
          );
        },
      ),
    );
  }
}