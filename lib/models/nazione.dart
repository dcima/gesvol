import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class Nazione {
  final String area;
  final String capital;
  final String continent;
  final String country;
  final String currencyCode;
  final String currencyName;
  final String fips;
  final String iso3;
  final String iso;
  final String isoNumeric;
  final String phone;
  final String population;
  final String tld;

  const Nazione({
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
}

class NazioneDataSource extends DataGridSource {
  NazioneDataSource(this.nazioni) {
    _buildDataRow();
  }

  List<DataGridRow> dataGridRows = [];
  List<Nazione> nazioni;

  void _buildDataRow() {
    dataGridRows = nazioni
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
  DataGridRowAdapter buildRow(
      DataGridRow row,
      ) {
    return DataGridRowAdapter(
        cells: row.getCells().map<Widget>((e) {
          return Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.all(8.0),
            child: Text(e.value.toString()),
          );
        }).toList());
  }

  void updateDataGridSource() {
    notifyListeners();
  }
}
