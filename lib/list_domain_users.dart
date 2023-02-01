import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:googleapis/storage/v1.dart' show StorageApi;
import 'package:googleapis_auth/auth_io.dart';


class ListDomainUsers extends StatefulWidget {
  const ListDomainUsers({super.key});

  @override
  _ListDomainUsersState createState() => _ListDomainUsersState();
}

class _ListDomainUsersState extends State<ListDomainUsers> {
  /*Future<String> listDomainUsers() async {
    final httpClient = await clientViaApplicationDefaultCredentials(scopes: [
      StorageApi.devstorageReadOnlyScope,
    ]);
    try {
      final storage = StorageApi(httpClient);

      final buckets = await storage.buckets.list('dart-on-cloud');
      final items = buckets.items!;
      print('Received ${items.length} bucket names:');
      for (var file in items) {
        print(file.name);
      }
    } finally {
      httpClient.close();
    }

    return 'fatto';
  }*/

  Future<String> listDomainUsers() async {
    return 'abc';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
          child: FutureBuilder(
            future: listDomainUsers(),
            builder: (BuildContext context, AsyncSnapshot<String> text) {
              return Text(text.data!);
            },
          ),
        ),
    );
  }
}



