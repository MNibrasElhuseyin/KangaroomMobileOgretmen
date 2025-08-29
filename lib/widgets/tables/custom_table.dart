// Amaç: Dinamik bir tablo bileşeni oluşturmak ve diğer bileşenleri bir araya getirmek.
// Kullanım: Sütun başlıkları, veri satırları, checkbox'lar ve sayfalama özelliklerini destekler.
// Ek: Checkbox sütunu taşması önlendi, "Tümünü Seç" için ellipsis ve dinamik genişlik eklendi.

import 'package:flutter/material.dart';
import 'package:kangaroom_mobile/widgets/tables/table_config.dart';
import 'package:kangaroom_mobile/widgets/tables/table_data_processor.dart';
import 'package:kangaroom_mobile/widgets/tables/table_error.dart';
import '../../screens/sinif_takip_pages/PaginationControls.dart';

class CustomTable extends StatefulWidget {
  final int columnCount;
  final List<String> columnHeaders;
  final List<List<String>> rowData;
  final bool hasCheckboxColumn;
  final List<bool> checkboxStates;
  final ValueChanged<bool?>? onSelectAll;
  final Function(int index, bool? value)? onCheckboxChanged;
  final bool hasPagination;
  final int currentPage;
  final int totalPages;
  final VoidCallback? onPrevious;
  final VoidCallback? onNext;
  final ValueChanged<int>? onRowTap; // 👈 YENİ

  const CustomTable({
    super.key,
    required this.columnCount,
    required this.columnHeaders,
    required this.rowData,
    this.hasCheckboxColumn = false,
    this.checkboxStates = const [],
    this.onSelectAll,
    this.onCheckboxChanged,
    this.hasPagination = false,
    this.currentPage = 0,
    this.totalPages = 1,
    this.onPrevious,
    this.onNext,
    this.onRowTap, // 👈 YENİ
  });

  @override
  _CustomTableState createState() => _CustomTableState();
}

class _CustomTableState extends State<CustomTable> {
  final ScrollController _verticalController = ScrollController();
  final ScrollController _horizontalController = ScrollController();
  late List<List<String>> _adjustedRowData;
  late List<bool> _adjustedCheckboxStates;

  @override
  void initState() {
    super.initState();
    _updateTableData();
  }

  @override
  void didUpdateWidget(CustomTable oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.rowData != widget.rowData ||
        oldWidget.columnHeaders != widget.columnHeaders ||
        oldWidget.checkboxStates != widget.checkboxStates) {
      _updateTableData();
    }
  }

  void _updateTableData() {
    if (widget.columnCount != widget.columnHeaders.length) {
      debugPrint(
        'Hata: columnCount (${widget.columnCount}) ile columnHeaders uzunluğu (${widget.columnHeaders.length}) uyuşmuyor',
      );
    }

    _adjustedRowData = TableDataProcessor.adjustRowData(
      widget.rowData,
      widget.columnHeaders.length,
    );
    _adjustedCheckboxStates = TableDataProcessor.adjustCheckboxStates(
      widget.checkboxStates,
      _adjustedRowData.length,
    );
  }

  @override
  void dispose() {
    _verticalController.dispose();
    _horizontalController.dispose();
    super.dispose();
  }

  // Yeni: Checkbox sütunu için genişlik hesapla
  double _calculateCheckboxColumnWidth(BuildContext context) {
    const text = 'Tümünü Seç';
    final textPainter = TextPainter(
      text: TextSpan(
        text: text,
        style: TableConfig.headerTextStyle.copyWith(fontSize: 13),
      ),
      maxLines: 1,
      textDirection: TextDirection.ltr,
    )..layout();
    // Checkbox (yaklaşık 40.0 genişlik) + SizedBox (4.0) + metin genişliği + padding
    return (40.0 + 4.0 + textPainter.width + TableConfig.cellPadding.horizontal)
        .clamp(
          TableConfig.checkboxColumnWidth,
          TableConfig.maxCQheckboxColumnWidth, //TableConfig.maxCheckboxColumnWidth, bunun yerine TableConfig.maxCQheckboxColumnWidth, bu olmalı
        );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.columnHeaders.isEmpty || widget.rowData.isEmpty) {
      return const TableError(message: 'API çağrısı başarısız / Veritabanında veri bulunamadı.');
    }

    if (widget.columnCount != widget.columnHeaders.length) {
      return const TableError(message: 'Sütun sayısı başlıklarla uyumsuz!');
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final double fixedColumnWidth = (constraints.maxWidth /
                widget.columnCount)
            .clamp(TableConfig.minColumnWidth, TableConfig.maxColumnWidth);
        final double checkboxWidth =
            widget.hasCheckboxColumn
                ? _calculateCheckboxColumnWidth(context)
                : 0;

        return Column(
          children: [
            Expanded(
              child: Scrollbar(
                controller: _verticalController,
                thumbVisibility: true,
                child: SingleChildScrollView(
                  controller: _verticalController,
                  scrollDirection: Axis.vertical,
                  child: Scrollbar(
                    controller: _horizontalController,
                    thumbVisibility: true,
                    child: SingleChildScrollView(
                      controller: _horizontalController,
                      scrollDirection: Axis.horizontal,
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          minWidth: constraints.maxWidth,
                        ),
                        child: Table(
                          border: TableBorder.all(color: Colors.deepPurple.shade300),
                          defaultVerticalAlignment:
                              TableCellVerticalAlignment.middle,
                          columnWidths: {
                            if (widget.hasCheckboxColumn)
                              0: FixedColumnWidth(checkboxWidth),
                            for (int i = 0; i < widget.columnCount; i++)
                              widget.hasCheckboxColumn
                                  ? i + 1
                                  : i: FixedColumnWidth(fixedColumnWidth),
                          },
                          children: [
                            TableRow(
                              decoration: BoxDecoration(color: Colors.deepPurple.shade300),
                              children: [
                                if (widget.hasCheckboxColumn)
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 8.0),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Checkbox(
                                            value: _adjustedCheckboxStates
                                                .every((e) => e),
                                            onChanged: (value) {
                                              setState(() {
                                                _adjustedCheckboxStates =
                                                    List.filled(
                                                      _adjustedCheckboxStates
                                                          .length,
                                                      value ?? false,
                                                    );
                                              });
                                              widget.onSelectAll?.call(value);
                                            },
                                            semanticLabel: 'Hepsini Seç',
                                          ),
                                          const SizedBox(width: 4),
                                          Flexible(
                                            child: Text(
                                              'Tümünü Seç',
                                              style: TableConfig.headerTextStyle
                                                  .copyWith(fontSize: 13),
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 1,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ...widget.columnHeaders.map(
                                  (header) => Padding(
                                    padding: TableConfig.cellPadding,
                                    child: Text(
                                      header,
                                      style: TableConfig.headerTextStyle,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            for (int i = 0; i < _adjustedRowData.length; i++)
                              TableRow(
                                children: [
                                  if (widget.hasCheckboxColumn)
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                          left: 8.0,
                                        ),
                                        child: Checkbox(
                                          value: _adjustedCheckboxStates[i],
                                          onChanged: (value) {
                                            setState(() {
                                              _adjustedCheckboxStates[i] =
                                                  value ?? false;
                                            });
                                            widget.onCheckboxChanged?.call(
                                              i,
                                              value,
                                            );
                                          },
                                          semanticLabel: 'Satır ${i + 1} Seç',
                                        ),
                                      ),
                                    ),
                                  ..._adjustedRowData[i].map((cell) {
                                    return InkWell(
                                      onTap: () => widget.onRowTap?.call(i),
                                      child: Padding(
                                          padding: TableConfig.cellPadding,
                                          child: Text(
                                            cell,
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style: TableConfig.cellTextStyle,
                                          ),
                                      ),
                                    );
                                  }),
                                ],
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            if (widget.hasPagination)
              PaginationControls(
                currentPage: widget.currentPage,
                totalPages: widget.totalPages,
                onPrevious: widget.onPrevious,
                onNext: widget.onNext,
              ),
          ],
        );
      },
    );
  }
}
