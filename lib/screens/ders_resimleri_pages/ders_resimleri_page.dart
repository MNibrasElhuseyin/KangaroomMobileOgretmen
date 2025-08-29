import 'package:flutter/material.dart';
import 'package:kangaroom_mobile/models/dersResimVideo/get_ders_resim_video.dart';
import 'package:kangaroom_mobile/services/api_service.dart';
import '../../widgets/custom_appbar.dart';
import 'ders_resimleri_cart_list.dart';
import 'ders_resimleri_form.dart';

class DersResimleriPage extends StatefulWidget {
  const DersResimleriPage({super.key});

  @override
  State<DersResimleriPage> createState() => _DersResimleriPageState();
}

class _DersResimleriPageState extends State<DersResimleriPage> {
  int _currentPage = 0;
  final int _rowsPerPage = 15;
  List<GetDersResimVideoModel> _allTableData = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadDersResimleri();
  }

  Future<void> _loadDersResimleri() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final dersResimleri = await ApiService.getList<GetDersResimVideoModel>(
        'DersResimVideo',
        GetDersResimVideoModel.fromJson,
        fallbackData: [],
      );

      setState(() {
        _allTableData = dersResimleri;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Ders resimleri yüklenirken hata oluştu: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _goToPreviousPage() {
    setState(() {
      if (_currentPage > 0) _currentPage--;
    });
  }

  void _goToNextPage() {
    setState(() {
      if ((_currentPage + 1) * _rowsPerPage < _allTableData.length) _currentPage++;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final horizontalPadding = screenWidth * 0.02;

    return Scaffold(
      appBar: const CustomAppBar(title: "Sosyal Ağ"),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                // FORM ALANI
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: 8),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: DersResimleriForm(onDataAdded: _loadDersResimleri),
                  ),
                ),

                // KART LİSTESİ ALANI
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: 8),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
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
                          const Padding(
                            padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
                            child: Text(
                              "Ders Resimleri Listesi",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.deepPurple,
                              ),
                            ),
                          ),
                          const Divider(height: 1, thickness: 1, indent: 16, endIndent: 16),
                          const SizedBox(height: 8),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                              child: DersResimleriCardList(
                                tableData: _allTableData,
                                currentPage: _currentPage,
                                rowsPerPage: _rowsPerPage,
                                onPrevious: _goToPreviousPage,
                                onNext: _goToNextPage,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
    );
  }
}