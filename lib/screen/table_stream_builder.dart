import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

typedef TableHeaderBuilder = Widget Function(String header);
typedef TableCellBuilder = Widget Function(String cell);
typedef TableCellValueBuilder<T> = String Function(String header, T value);
typedef HeaderClickHandler = void Function(String header);
typedef RowClickHandler<T> = void Function(T value);

class TableStreamBuilder<T> extends StatelessWidget {
  final List<T> initialData;
  final List<String> headerList;
  final TableHeaderBuilder headerBuilder;
  final TableCellBuilder cellBuilder;
  final Stream<List<T>> stream;
  final TableCellValueBuilder<T> cellValueBuilder;
  final HeaderClickHandler headerClickHandler;
  final RowClickHandler<T> rowClickHandler;

  TableStreamBuilder(
      {required this.initialData,
        required this.headerBuilder,
        required this.cellBuilder,
        required this.headerClickHandler,
        required this.rowClickHandler,
        required this.headerList,
        required this.stream,
        required this.cellValueBuilder});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: stream,
      builder: (context, snapshot) {
        if (snapshot?.hasData ?? false) return _buildTable(snapshot.data!);
        if (snapshot?.hasError ?? false) return const Text('Something went wrong!');
        return const CircularProgressIndicator();
      },
    );
  }

  Widget _buildTable(List<T> data) {
    return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: DataTable(
              columns: _getColumns(headerList),
              rows: _getRows(data),
            )));
  }

  List<DataColumn> _getColumns(List<String> data) {
    return data.map((key) => DataColumn(label: headerBuilder(key))).toList();
    return data
        .map((key) => DataColumn(label: _buildInternelColumnWidget(key)))
        .toList();
  }

  Widget _buildInternelColumnWidget(String column) {
    return Text(column,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold));
  }

  List<DataRow> _getRows(List<T> data) {
    return data
        .map((item) => DataRow(cells: _buildProvidedRowCells(item)))
        .toList();

    return data
        .map((item) => DataRow(cells: _buildInternelRowCells(item)))
        .toList();
  }

  List<DataCell> _buildProvidedRowCells(T data) {
    return headerList
        .map((header) => DataCell(
      cellBuilder(cellValueBuilder(header, data)),
    ))
        .toList();
  }

  List<DataCell> _buildInternelRowCells(T data) {
    return headerList
        .map((header) => DataCell(
      _buildInternelRowWidget(cellValueBuilder(header, data)),
    ))
        .toList();
  }

  Widget _buildInternelRowWidget(String row) {
    return Text(
      row,
      style: const TextStyle(fontSize: 16),
    );
  }
}