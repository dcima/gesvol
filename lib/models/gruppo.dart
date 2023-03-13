import 'package:flutter/material.dart';
import 'package:googleapis/admin/directory_v1.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class GruppoDataSource extends DataGridSource {
  GruppoDataSource(this._gruppi) { buildDataRow(); }

  List<DataGridRow> dataGridRows = [];
  final List<Group> _gruppi;

  void buildDataRow() {
    dataGridRows = _gruppi
        .map<DataGridRow>((e) => DataGridRow(cells: [
      DataGridCell<bool>  (columnName: 'adminCreated',        value: e.adminCreated),
      DataGridCell<String>(columnName: 'description',         value: e.description),
      DataGridCell<String>(columnName: 'directMembersCount',  value: e.directMembersCount),
      DataGridCell<String>(columnName: 'email',               value: e.email),
      DataGridCell<String>(columnName: 'etag',                value: e.etag),
      DataGridCell<String>(columnName: 'id',                  value: e.id),
      DataGridCell<String>(columnName: 'kind',                value: e.kind),
      DataGridCell<String>(columnName: 'name',                value: e.name),
    ]))
        .toList();
  }

  @override
  List<DataGridRow> get rows => dataGridRows;

  @override
  DataGridRowAdapter? buildRow( DataGridRow row ) {
    var aDestra = [];
    Color getBackgroundColor() {
      int index = effectiveRows.indexOf(row);
      if (index % 2 == 0) {
        return Colors.grey.shade200;
      } else {
        return Colors.white;
      }
    }
    return DataGridRowAdapter(
        color: getBackgroundColor(),
        cells: row.getCells().map<Widget>((e) {
          var numerics = [];
          var n = 0;
          try {
            n = int.parse(e.value.toString());
          } catch(e) {
            n = 0;
          }
          var formatter = NumberFormat.decimalPattern('it_IT');
          return Container(
            alignment: aDestra.contains(e.columnName) ? Alignment.centerRight : Alignment.centerLeft,
            padding: const EdgeInsets.all(8.0),
            child: numerics.contains(e.columnName) ?
            Text(formatter.format(n))
                :
            Text(e.value.toString()),
          );
        }).toList());
  }

  void updateDataGridSource() {
    notifyListeners();
  }
}

class CustomColumnSizer extends ColumnSizer {
  @override
  double computeCellWidth(GridColumn column, DataGridRow row, Object? cellValue, TextStyle textStyle) {
    var numerics = [];
    var n = 0;
    try {
      n = int.parse(cellValue.toString());
    } catch(e) {
      n = 0;
    }
    if (numerics.contains(column.columnName)) {
      var formatter = NumberFormat.decimalPattern('it_IT');
      cellValue = formatter.format(n);
    }

    return super.computeCellWidth(column, row, cellValue, textStyle);
  }
}