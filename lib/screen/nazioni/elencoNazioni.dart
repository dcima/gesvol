import '../../models/nazione.dart';
import '../../utils/helper.dart';
import '../my_drawer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:syncfusion_flutter_datagrid_export/export.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart' hide Column;



class ElencoNazioni extends StatefulWidget {
  const ElencoNazioni({Key? key}) : super(key: key);

  @override
  _ElencoNazioniState createState() => _ElencoNazioniState();
}

class _ElencoNazioniState extends State<ElencoNazioni> {
  final CollectionReference _refNazioni = FirebaseFirestore.instance.collection('nazioni');
  final CustomColumnSizer _columnSizer = CustomColumnSizer();
  final GlobalKey<SfDataGridState> keySfDataGrid = GlobalKey<SfDataGridState>();
  late final List<Nazione> _nazioni = [];
  late List<QueryDocumentSnapshot> listQueryDocumentSnapshot;
  late NazioneDataSource _nazioneDataSource;
  late QuerySnapshot querySnapshot;
  late Stream<QuerySnapshot> _streamNazioni;

  @override
  initState() {
    super.initState();
    _streamNazioni = _refNazioni.snapshots();
  }

/*
  Future<void> _exportDataGridToExcel() async {
    final Workbook workbook = keySfDataGrid.currentState!.exportToExcelWorkbook();
    final List<int> bytes = workbook.saveAsStream();
    workbook.dispose();
    await helper.saveAndLaunchFile(bytes, 'DataGrid.xlsx');
  }

  Future<void> _exportDataGridToPdf() async {
    final PdfDocument document = keySfDataGrid.currentState!.exportToPdfDocument(fitAllColumnsInOnePage: true);
    final List<int> bytes = document.saveSync();
    await helper.saveAndLaunchFile(bytes, 'DataGrid.pdf');
    document.dispose();
  }
*/

  Widget _buildDataGrid(context) {
    return  StreamBuilder<QuerySnapshot>(
      stream: _streamNazioni,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text(snapshot.error.toString()));
        }
        if (snapshot.connectionState == ConnectionState.active) {
          querySnapshot = snapshot.data;
          listQueryDocumentSnapshot = querySnapshot.docs;
          Nazione current;
          for( int i = 0; i < listQueryDocumentSnapshot.length; i++) {
            Object? o1 = listQueryDocumentSnapshot[i].data();
            current = Nazione.fromJson(o1 as Map<String, dynamic>);
            _nazioni.add(current);
          }
          _nazioneDataSource = NazioneDataSource(_nazioni);
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
              key: keySfDataGrid,
              onQueryRowHeight: (details) {
                // Set the row height as 70.0 to the column header row.
                return details.rowIndex == 0 ? 70.0 : 49.0;
              },
              source: _nazioneDataSource,
            ),
          );
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.drawerListNations),
        actions: [
          IconButton(
              onPressed: ()  {
                Helper.logoff(context);
              },
              icon: const Icon(Icons.power_settings_new))
        ],
      ),
      drawer: const MyDrawer(),
      body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children:  <Widget> [
            Helper.getRibbon(context, keySfDataGrid),
            Expanded(
                child: _buildDataGrid(context),
            ),
          ],
      ),
    );
  }
}
