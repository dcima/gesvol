import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class Nazione {
  final String area;
  final String capital;
  final String continent;
  final String country;
  final String currencyCode;
  final String currencyName;
  final String fips;
  final String iso;
  final String iso3;
  final String isoNumeric;
  final String phone;
  final String population;
  final String tld;

  Nazione(Object? data, {
    required this.area,
    required this.capital,
    required this.continent,
    required this.country,
    required this.currencyCode,
    required this.currencyName,
    required this.fips,
    required this.iso,
    required this.iso3,
    required this.isoNumeric,
    required this.phone,
    required this.population,
    required this.tld,
  });

  Nazione.fromJson(Map<String, dynamic> json)
      : area          = json['area'],
        capital       = json['capital'],
        continent     = json['continent'],
        country       = json['country'],
        currencyCode  = json['currencyCode'],
        currencyName  = json['currencyName'],
        fips          = json['fips'],
        iso           = json['iso'],
        iso3          = json['iso3'],
        isoNumeric    = json['isoNumeric'],
        phone         = json['phone'],
        population    = json['population'],
        tld           = json['tld'];

  Map<String, dynamic> toJson() => {
    'area'          : area,
    'capital'       : capital,
    'continent'     : continent,
    'country'       : country,
    'currencyCode'  : currencyCode,
    'currencyName'  : currencyName,
    'fips'          : fips,
    'iso'           : iso,
    'iso3'          : iso3,
    'isoNumeric'    : isoNumeric,
    'phone'         : phone,
    'population'    : population,
    'tld'           : tld,
  };
}

class NazioneDataSource extends DataGridSource {
  NazioneDataSource(this._nazioni) { buildDataRow(); }

  List<DataGridRow> dataGridRows = [];
  final List<Nazione> _nazioni;

  void buildDataRow() {
    dataGridRows = _nazioni
        .map<DataGridRow>((e) => DataGridRow(cells: [
      DataGridCell<String>(columnName: 'area',          value: e.area),
      DataGridCell<String>(columnName: 'capital',       value: e.capital),
      DataGridCell<String>(columnName: 'continent',     value: e.continent),
      DataGridCell<String>(columnName: 'country',       value: e.country),
      DataGridCell<String>(columnName: 'currencyCode',  value: e.currencyCode),
      DataGridCell<String>(columnName: 'currencyName',  value: e.currencyName),
      DataGridCell<String>(columnName: 'fips',          value: e.fips),
      DataGridCell<String>(columnName: 'iso',           value: e.iso),
      DataGridCell<String>(columnName: 'iso3',          value: e.iso3),
      DataGridCell<String>(columnName: 'isoNumeric',    value: e.isoNumeric),
      DataGridCell<String>(columnName: 'phone',         value: e.phone),
      DataGridCell<String>(columnName: 'population',    value: e.population),
      DataGridCell<String>(columnName: 'tld',           value: e.tld),
    ]))
        .toList();
  }

  @override
  List<DataGridRow> get rows => dataGridRows;

  @override
  DataGridRowAdapter? buildRow( DataGridRow row ) {
    var aDestra = ["area","isoNumeric", "phone", "population"];
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
          var numerics = ["area","isoNumeric", "population"];
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
    var numerics = ["area","isoNumeric", "population"];
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