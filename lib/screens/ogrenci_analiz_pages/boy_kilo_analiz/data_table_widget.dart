import 'package:flutter/material.dart';
import 'package:kangaroom_mobile/widgets/app_constant.dart';

class BoyKiloTable extends StatelessWidget {
  final List<String> tarihler;
  final List<double> boylar;
  final List<double> kilolar;

  const BoyKiloTable({
    super.key,
    required this.tarihler,
    required this.boylar,
    required this.kilolar,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(minWidth: 600),
        child: PaginatedDataTable(
          header: const Text(
            "Boy - Kilo Verileri",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          rowsPerPage: 5,
          columns: const [
            DataColumn(
              label: Text("Tarih", style: TextStyle(color: Colors.white)),
            ),
            DataColumn(
              label: Text("Boy", style: TextStyle(color: Colors.white)),
            ),
            DataColumn(
              label: Text("Kilo", style: TextStyle(color: Colors.white)),
            ),
          ],
          source: BoyKiloDataSource(tarihler, boylar, kilolar),
          columnSpacing: 24,
          headingRowColor: MaterialStatePropertyAll(AppConstants.primaryColor),
        ),
      ),
    );
  }
}

class BoyKiloDataSource extends DataTableSource {
  final List<String> tarihler;
  final List<double> boylar;
  final List<double> kilolar;

  BoyKiloDataSource(this.tarihler, this.boylar, this.kilolar);

  @override
  DataRow? getRow(int index) {
    if (index >= tarihler.length) return null;

    return DataRow(
      cells: [
        DataCell(Text(tarihler[index])),
        DataCell(Text("${boylar[index]} cm")),
        DataCell(Text("${kilolar[index]} kg")),
      ],
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => tarihler.length;

  @override
  int get selectedRowCount => 0;
}
