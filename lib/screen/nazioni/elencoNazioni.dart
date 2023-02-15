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
