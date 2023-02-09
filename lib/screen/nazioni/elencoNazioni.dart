import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:gesvol/models/nazione.dart';
import 'package:gesvol/screen/my_drawer.dart';
import 'package:gesvol/screen/table_stream_builder.dart';

class ElencoNazioni extends StatefulWidget {
  const ElencoNazioni({Key? key}) : super(key: key);

  @override
  _ElencoNazioniState createState() => _ElencoNazioniState();
}

class _ElencoNazioniState extends State<ElencoNazioni> {
  final Stream<QuerySnapshot> _nazioniStream =   FirebaseFirestore.instance.collection('nazioni').snapshots();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('bella ciao')
      ),
      drawer: const MyDrawer(),
     /* body: TableStreamBuilder<Nazione>(
        stream: FirebaseFirestore.instance.collection('nazioni').snapshots()
        headerList: ['Iso', 'Country'],
        cellValueBuilder: (header, model) {
          switch (header) {
            case 'Iso':
              return model.iso;
            case 'Country':
              return '${model.country}';
          }
          return '';
        },
      ));*/
      body: StreamBuilder<QuerySnapshot>(
        stream: _nazioniStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Text("Loading");
          }

          return ListView(
            children: snapshot.data!.docs.map((DocumentSnapshot document) {
              Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
              return ListTile(
                    title: Text(data['iso']),
                    subtitle: Text(data['country']),
                  );
                })
                .toList()
                .cast(),
          );
        },
      ),
    );
  }
}