/**
import '../my_drawer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:gesvol/models/nazione.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:syncfusion_flutter_datagrid_export/export.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart' hide Column;

class ElencoNazioni extends StatefulWidget {
  ElencoNazioni({Key? key}) : super(key: key);

  @override
  _ElencoNazioniState createState() => _ElencoNazioniState();
}

class _ElencoNazioniState extends State<ElencoNazioni> {
  late NazioneDataSource _nazioneDataSource;
  late List<Nazione> _nazioni = [];

  bool isLandscapeInMobileView = false;
  late bool isWebOrDesktop;

  FirebaseFirestore db = FirebaseFirestore.instance;
  final Stream<QuerySnapshot> _nazioniStream = FirebaseFirestore.instance.collection('nazioni').snapshots();
  final CustomColumnSizer _columnSizer = CustomColumnSizer();

  @override
  void initState() {
    super.initState();
  }

  late Map<String, double> columnWidths =  {
    'area'          : double.nan,
    'capital'       : double.nan,
    'continent'     : double.nan,
    'country'       : double.nan,
    'currencyCode'  : double.nan,
    'currencyName'  : double.nan,
    'fips'          : double.nan,
    'iso'           : double.nan,
    'iso3'          : double.nan,
    'isoNumeric'    : double.nan,
    'phone'         : double.nan,
    'population'    : double.nan,
    'tld'           : double.nan,
  };

  Widget _buildDataGrid(BuildContext context) {
    return StreamBuilder(
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return const LinearProgressIndicator();
          } else {
            _nazioni.clear();
            for (var doc in snapshot.data!.docs) {
              Nazione currentNation = Nazione.fromJson(doc.data() as Map<String, dynamic>);
              _nazioni.add(currentNation);
            }
            _nazioneDataSource = NazioneDataSource(_nazioni);
            return SfDataGridTheme(
              data: SfDataGridThemeData(
                  headerColor: Colors.greenAccent,
                  headerHoverColor: Colors.yellow
              ),
              child: SfDataGrid(
/*              allowColumnsResizing: true,
                onColumnResizeStart: (ColumnResizeStartDetails details) {
                  return true;
                },
                onColumnResizeUpdate: (ColumnResizeUpdateDetails details) {
                  setState(() {
                    columnWidths[details.column.columnName] = details.width;
                  });
                  return true;
                },*/
                allowMultiColumnSorting: true,
                allowSorting: true,
                allowTriStateSorting: true,
                columns: <GridColumn>[
                  GridColumn(
                      columnName: 'area',
                      label: Container(
                          padding: const EdgeInsets.all(16.0),
                          alignment: Alignment.centerLeft,
                          child: const Text(
                            'area\r\n(kmq)',
                          ))),
                  GridColumn(
                      columnName: 'capital',
                      label: Container(
                          padding: const EdgeInsets.all(8.0),
                          alignment: Alignment.center,
                          child: const Text('capital'))),
                  GridColumn(
                      columnName: 'continent',
                      label: Container(
                          padding: const EdgeInsets.all(8.0),
                          alignment: Alignment.center,
                          child: const Text(
                            'continent',
                            overflow: TextOverflow.ellipsis,
                          ))),
                  GridColumn(
                      columnName: 'country',
                      label: Container(
                          padding: const EdgeInsets.all(8.0),
                          alignment: Alignment.center,
                          child: const Text('country'))),
                  GridColumn(
                      columnName: 'currencyCode',
                      label: Container(
                          padding: const EdgeInsets.all(8.0),
                          alignment: Alignment.center,
                          child: const Text('currencyCode'))),
                  GridColumn(
                      columnName: 'currencyName',
                      label: Container(
                          padding: const EdgeInsets.all(8.0),
                          alignment: Alignment.center,
                          child: const Text('currencyName'))),
                  GridColumn(
                      columnName: 'fips',
                      label: Container(
                          padding: const EdgeInsets.all(8.0),
                          alignment: Alignment.center,
                          child: const Text('fips'))),
                  GridColumn(
                      columnName: 'iso',
                      label: Container(
                          padding: const EdgeInsets.all(8.0),
                          alignment: Alignment.center,
                          child: const Text('iso'))),
                  GridColumn(
                      columnName: 'iso3',
                      label: Container(
                          padding: const EdgeInsets.all(8.0),
                          alignment: Alignment.center,
                          child: const Text('iso3'))),
                  GridColumn(
                      columnName: 'isoNumeric',
                      label: Container(
                          padding: const EdgeInsets.all(8.0),
                          alignment: Alignment.center,
                          child: const Text('isoNumeric'))),
                  GridColumn(
                      columnName: 'phone',
                      label: Container(
                          padding: const EdgeInsets.all(8.0),
                          alignment: Alignment.center,
                          child: const Text('phone'))),
                  GridColumn(
                      columnName: 'population',
                      label: Container(
                          padding: const EdgeInsets.all(8.0),
                          alignment: Alignment.center,
                          child: const Text('population (milioni)'))),
                  GridColumn(
                      columnName: 'tld',
                      label: Container(
                          padding: const EdgeInsets.all(8.0),
                          alignment: Alignment.center,
                          child: const Text('tld'))),
                ],
                columnSizer: _columnSizer,
                columnWidthMode: ColumnWidthMode.auto,
                gridLinesVisibility: GridLinesVisibility.both,
                headerGridLinesVisibility: GridLinesVisibility.both,
                isScrollbarAlwaysShown: true,
                onQueryRowHeight: (details) {
                  // Set the row height as 70.0 to the column header row.
                  return details.rowIndex == 0 ? 70.0 : 49.0;
                },
                source: _nazioneDataSource,
              ),
            );
          }
      },
      stream: _nazioniStream,
    );
  }
  final GlobalKey<SfDataGridState> key = GlobalKey<SfDataGridState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.drawerListNations),
      ),
      drawer: const MyDrawer(),
      //body:  _buildDataGrid(context),
      body:  Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            height: 50.0,
            width: 150.0,
            padding: const EdgeInsets.all(10.0),
            child: MaterialButton(
                color: Colors.blue,
                child: const Center(
                    child: Text(
                      'Export to Excel',
                      style: TextStyle(color: Colors.white),
                    )),
                onPressed: () async {
                  final Workbook workbook =
                  key.currentState!.exportToExcelWorkbook();
                  final List<int> bytes = workbook.saveAsStream();
                  workbook.dispose();
                  //await helper.saveAndLaunchFile(bytes, 'DataGrid.xlsx');
                }),
          ),
          Expanded(
              child: _buildDataGrid(context),
          ),
        ],
      )
    );
  }
}

/// custom column sizer class
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
**/
import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

import '../my_drawer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:syncfusion_flutter_datagrid_export/export.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart' hide Column;
// Local import
import 'package:gesvol/helper/save_file_mobile.dart'
  if (dart.library.html) 'package:gesvol/helper//save_file_web.dart' as helper;

/**
class _ElencoNazioniState extends State<ElencoNazioni> {
  final CollectionReference _refNazioni = FirebaseFirestore.instance.collection('nazioni');
  final GlobalKey<SfDataGridState> keySfDataGrid = GlobalKey<SfDataGridState>();
  late Stream<QuerySnapshot> _streamNazioni;

  initState() {
    super.initState();
    _streamNazioni = _refNazioni.snapshots();
  }

  Future<void> _exportDataGridToExcel() async {
    final Workbook workbook = _key.currentState!.exportToExcelWorkbook();

    final List<int> bytes = workbook.saveAsStream();
    workbook.dispose();

    await helper.saveAndLaunchFile(bytes, 'DataGrid.xlsx');
  }

  Future<void> _exportDataGridToPdf() async {
    final PdfDocument document =
    keySfDataGrid.currentState!.exportToPdfDocument(fitAllColumnsInOnePage: true);

    final List<int> bytes = document.saveSync();
    await helper.saveAndLaunchFile(bytes, 'DataGrid.pdf');
    document.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(AppLocalizations.of(context)!.drawerListNations),
          actions: [
            IconButton(
                onPressed: () async {
                  await GoogleSignIn().signOut();
                  FirebaseAuth.instance.signOut();
                },
                icon: Icon(Icons.power_settings_new))
          ],
        ),
        drawer: const MyDrawer(),
        body:  Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              height: 50.0,
              width: 150.0,
              padding: const EdgeInsets.all(10.0),
              child: MaterialButton(
                  color: Colors.blue,
                  child: const Center(
                      child: Text(
                        'Export to Excel',
                        style: TextStyle(color: Colors.white),
                      )),
                  onPressed: () async {
                    final Workbook workbook =
                    keySfDataGrid.currentState!.exportToExcelWorkbook();
                    final List<int> bytes = workbook.saveAsStream();
                    workbook.dispose();
                    await helper.saveAndLaunchFile(bytes, 'DataGrid.xlsx');
                  }),
            ),
            Expanded(
              child: _buildDataGrid(context),
            ),
          ],
        )
    );

}
    **/

class ElencoNazioni extends StatefulWidget {
  ElencoNazioni({Key? key}) : super(key: key);

  @override
  _ElencoNazioniState createState() => _ElencoNazioniState();
}

class _ElencoNazioniState extends State<ElencoNazioni> {
  final CollectionReference _refNazioni = FirebaseFirestore.instance.collection('nazioni');
  final CustomColumnSizer _columnSizer = CustomColumnSizer();
  final GlobalKey<SfDataGridState> keySfDataGrid = GlobalKey<SfDataGridState>();
  late List<Nazione> _nazioni = [];
  late List<QueryDocumentSnapshot> listQueryDocumentSnapshot;
  late NazioneDataSource _nazioneDataSource;
  late QuerySnapshot querySnapshot;
  late Stream<QuerySnapshot> _streamNazioni;

  initState() {
    super.initState();
    _streamNazioni = _refNazioni.snapshots();
  }

  Future<void> _exportDataGridToExcel() async {
    final Workbook workbook = keySfDataGrid.currentState!
        .exportToExcelWorkbook();
    final List<int> bytes = workbook.saveAsStream();
    workbook.dispose();
    await helper.saveAndLaunchFile(bytes, 'DataGrid.xlsx');
  }

  Future<void> _exportDataGridToPdf() async {
    final PdfDocument document =
    keySfDataGrid.currentState!.exportToPdfDocument(
        fitAllColumnsInOnePage: true);

    final List<int> bytes = document.saveSync();
    await helper.saveAndLaunchFile(bytes, 'DataGrid.pdf');
    document.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.drawerListNations),
        actions: [
          IconButton(
              onPressed: () async {
                await GoogleSignIn().signOut();
                FirebaseAuth.instance.signOut();
              },
              icon: Icon(Icons.power_settings_new))
        ],
      ),
      drawer: const MyDrawer(),
      body: StreamBuilder<QuerySnapshot>(
        stream: _streamNazioni,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text(snapshot.error.toString()));
          }
          if (snapshot.connectionState == ConnectionState.active) {
            querySnapshot = snapshot.data;
            listQueryDocumentSnapshot = querySnapshot.docs;
            listQueryDocumentSnapshot.forEach((e) {
              var n = Nazione.fromJson(e.data().toString());
              //print(jsonDecode(jsonData));
              print(jsonData);
            });
            _nazioneDataSource = NazioneDataSource(_nazioni);

/*            return ListView.builder(
                itemCount: listQueryDocumentSnapshot.length,
                itemBuilder: (context, index) {
                  QueryDocumentSnapshot document = listQueryDocumentSnapshot[index];
                  return NazioniListItem(document: document);
                });*/
              return SfDataGridTheme(
                data: SfDataGridThemeData(
                    headerColor: Colors.greenAccent,
                    headerHoverColor: Colors.yellow
                ),
                child: SfDataGrid(
                  allowMultiColumnSorting: true,
                  allowSorting: true,
                  allowTriStateSorting: true,
                  columns: <GridColumn>[
                    GridColumn(
                        columnName: 'area',
                        label: Container(
                            padding: const EdgeInsets.all(16.0),
                            alignment: Alignment.centerLeft,
                            child: const Text(
                              'area\r\n(kmq)',
                            ))),
                    GridColumn(
                        columnName: 'capital',
                        label: Container(
                            padding: const EdgeInsets.all(8.0),
                            alignment: Alignment.center,
                            child: const Text('capital'))),
                    GridColumn(
                        columnName: 'continent',
                        label: Container(
                            padding: const EdgeInsets.all(8.0),
                            alignment: Alignment.center,
                            child: const Text(
                              'continent',
                              overflow: TextOverflow.ellipsis,
                            ))),
                    GridColumn(
                        columnName: 'country',
                        label: Container(
                            padding: const EdgeInsets.all(8.0),
                            alignment: Alignment.center,
                            child: const Text('country'))),
                    GridColumn(
                        columnName: 'currencyCode',
                        label: Container(
                            padding: const EdgeInsets.all(8.0),
                            alignment: Alignment.center,
                            child: const Text('currencyCode'))),
                    GridColumn(
                        columnName: 'currencyName',
                        label: Container(
                            padding: const EdgeInsets.all(8.0),
                            alignment: Alignment.center,
                            child: const Text('currencyName'))),
                    GridColumn(
                        columnName: 'fips',
                        label: Container(
                            padding: const EdgeInsets.all(8.0),
                            alignment: Alignment.center,
                            child: const Text('fips'))),
                    GridColumn(
                        columnName: 'iso',
                        label: Container(
                            padding: const EdgeInsets.all(8.0),
                            alignment: Alignment.center,
                            child: const Text('iso'))),
                    GridColumn(
                        columnName: 'iso3',
                        label: Container(
                            padding: const EdgeInsets.all(8.0),
                            alignment: Alignment.center,
                            child: const Text('iso3'))),
                    GridColumn(
                        columnName: 'isoNumeric',
                        label: Container(
                            padding: const EdgeInsets.all(8.0),
                            alignment: Alignment.center,
                            child: const Text('isoNumeric'))),
                    GridColumn(
                        columnName: 'phone',
                        label: Container(
                            padding: const EdgeInsets.all(8.0),
                            alignment: Alignment.center,
                            child: const Text('phone'))),
                    GridColumn(
                        columnName: 'population',
                        label: Container(
                            padding: const EdgeInsets.all(8.0),
                            alignment: Alignment.center,
                            child: const Text('population (milioni)'))),
                    GridColumn(
                        columnName: 'tld',
                        label: Container(
                            padding: const EdgeInsets.all(8.0),
                            alignment: Alignment.center,
                            child: const Text('tld'))),
                  ],
                  columnSizer: _columnSizer,
                  columnWidthMode: ColumnWidthMode.auto,
                  gridLinesVisibility: GridLinesVisibility.both,
                  headerGridLinesVisibility: GridLinesVisibility.both,
                  isScrollbarAlwaysShown: true,
                  onQueryRowHeight: (details) {
                    // Set the row height as 70.0 to the column header row.
                    return details.rowIndex == 0 ? 70.0 : 49.0;
                  },
                  source: _nazioneDataSource,
                ),
              );
          }

          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
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
/*

class NazioniListItem extends StatefulWidget {
  const NazioniListItem({
    Key? key,
    required this.document,
  }) : super(key: key);

  final QueryDocumentSnapshot<Object?> document;

  @override
  State<NazioniListItem> createState() => _NazioniListItemState();
}

class _NazioniListItemState extends State<NazioniListItem> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => Text('ciao')));
      },
      title: Text(widget.document['country']),
      subtitle: Text(widget.document['iso']),
      trailing: Checkbox(
        onChanged: (value) {
        },
        value: true,
      ),
    );
  }
}
*/

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