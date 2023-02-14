import '../my_drawer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:gesvol/models/nazione.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

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

  @override
  void initState() {
    super.initState();
  }

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
            return SfDataGrid(
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
                          'area',
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
                    columnName: 'iso3',
                    label: Container(
                        padding: const EdgeInsets.all(8.0),
                        alignment: Alignment.center,
                        child: const Text('iso3'))),
                GridColumn(
                    columnName: 'iso',
                    label: Container(
                        padding: const EdgeInsets.all(8.0),
                        alignment: Alignment.center,
                        child: const Text('iso'))),
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
                        child: const Text('population'))),
                GridColumn(
                    columnName: 'tld',
                    label: Container(
                        padding: const EdgeInsets.all(8.0),
                        alignment: Alignment.center,
                        child: const Text('tld'))),
              ],
              columnWidthMode: ColumnWidthMode.auto,
              gridLinesVisibility: GridLinesVisibility.both,
              headerGridLinesVisibility: GridLinesVisibility.both,
              isScrollbarAlwaysShown: true,
              source: _nazioneDataSource,
            );
          }
      },
      stream: _nazioniStream,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.drawerListNations),
      ),
      drawer: const MyDrawer(),
      body:  _buildDataGrid(context),
    );
  }
}