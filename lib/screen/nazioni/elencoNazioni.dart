import '../my_drawer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:gesvol/models/nazione.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class ElencoNazioni extends StatefulWidget {
  ElencoNazioni({Key? key}) : super(key: key);
  late NazioneDataSource _nazioneDataSource;
  List<Nazione> _nazioni = <Nazione>[];

  final getDataFromFireStore =
  FirebaseFirestore.instance.collection('nazioni').snapshots();

  @override
  _ElencoNazioniState createState() => _ElencoNazioniState();
}

class _ElencoNazioniState extends State<ElencoNazioni> {
  late NazioneDataSource nazioneDataSource;
  List<Nazione> nazioneData = [];
  
  getDataFromDatabase() async {
    var value = FirebaseDatabase.instance.reference();
    var getValue = await value.child('DataGridNazioneCollection').once();
    return getValue;
  }

  Widget _buildDataGrid() {
    return FutureBuilder(
      future: getDataFromDatabase(),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.hasData) {
          var showData = snapshot.data;
          Map<dynamic, dynamic> values = showData.value;
          List<dynamic> key = values.keys.toList();

          for (int i = 0; i < key.length; i++) {
            final data = values[key[i]];
            nazioneData.add(Nazione(
              area: data['area'],
              capital: data['capital'],
              continent: data['continent'],
              country: data['country'],
              currencyCode: data['currencyCode'],
              currencyName: data['currencyName'],
              fips: data['fips'],
              iso3: data['iso3'],
              iso: data['iso'],
              isoNumeric: data['isoNumeric'],
              phone: data['phone'],
              population: data['population'],
              tld: data['tld'],
            ));
          }

          nazioneDataSource = NazioneDataSource(nazioneData);
          return SfDataGrid(
            source: nazioneDataSource,
            columns: <GridColumn>[
              GridColumn(
                  columnName: 'area',
                  label: Container(
                      padding: EdgeInsets.all(16.0),
                      alignment: Alignment.center,
                      child: Text(
                        'area',
                      ))),
              GridColumn(
                  columnName: 'capital',
                  label: Container(
                      padding: EdgeInsets.all(8.0),
                      alignment: Alignment.center,
                      child: Text('capital'))),
              GridColumn(
                  columnName: 'continent',
                  label: Container(
                      padding: EdgeInsets.all(8.0),
                      alignment: Alignment.center,
                      child: Text(
                        'continent',
                        overflow: TextOverflow.ellipsis,
                      ))),
              GridColumn(
                  columnName: 'country',
                  label: Container(
                      padding: EdgeInsets.all(8.0),
                      alignment: Alignment.center,
                      child: Text('country'))),
              GridColumn(
                  columnName: 'currencyCode',
                  label: Container(
                      padding: EdgeInsets.all(8.0),
                      alignment: Alignment.center,
                      child: Text('currencyCode'))),
              GridColumn(
                  columnName: 'currencyName',
                  label: Container(
                      padding: EdgeInsets.all(8.0),
                      alignment: Alignment.center,
                      child: Text('currencyName'))),
              GridColumn(
                  columnName: 'fips',
                  label: Container(
                      padding: EdgeInsets.all(8.0),
                      alignment: Alignment.center,
                      child: Text('fips'))),
              GridColumn(
                  columnName: 'iso3',
                  label: Container(
                      padding: EdgeInsets.all(8.0),
                      alignment: Alignment.center,
                      child: Text('iso3'))),
              GridColumn(
                  columnName: 'iso',
                  label: Container(
                      padding: EdgeInsets.all(8.0),
                      alignment: Alignment.center,
                      child: Text('iso'))),
              GridColumn(
                  columnName: 'isoNumeric',
                  label: Container(
                      padding: EdgeInsets.all(8.0),
                      alignment: Alignment.center,
                      child: Text('isoNumeric'))),
              GridColumn(
                  columnName: 'phone',
                  label: Container(
                      padding: EdgeInsets.all(8.0),
                      alignment: Alignment.center,
                      child: Text('phone'))),
              GridColumn(
                  columnName: 'population',
                  label: Container(
                      padding: EdgeInsets.all(8.0),
                      alignment: Alignment.center,
                      child: Text('population'))),
              GridColumn(
                  columnName: 'tld',
                  label: Container(
                      padding: EdgeInsets.all(8.0),
                      alignment: Alignment.center,
                      child: Text('tld'))),
            ],
          );
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('bella ciao')
      ),
      drawer: const MyDrawer(),
      body:  _buildDataGrid(),
    );
  }
}