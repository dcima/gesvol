// ignore_for_file: prefer_interpolation_to_compose_strings

import '../../utils/helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:gesvol/screen/my_drawer.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/people/v1.dart';

class ListMyContacts extends StatefulWidget {
  const ListMyContacts({super.key});

  @override
  ListMyContactsState createState() => ListMyContactsState();
}

class ListMyContactsState extends State<ListMyContacts> {
  GoogleSignInAccount? _currentUser;
  String _contactText = '';

  @override
  void initState() {
    super.initState();
    _currentUser = Helper.userGoogle;
    _handleGetContact();
  }

  Future<void> _handleGetContact() async {
    setState(() {
      _contactText = 'Loading contact info...';
    });

    assert(Helper.httpClient != null, 'Authenticated client missing!');

    // Prepare a People Service authenticated client.
    final PeopleServiceApi peopleApi = PeopleServiceApi(Helper.httpClient !);
    // Retrieve a list of the `names` of my `connections`
    final ListConnectionsResponse response =
    await peopleApi.people.connections.list(
      'people/me',
      personFields: 'names',
    );

    String  s = '';
    response.connections!.forEach((e) {
      if( e.emailAddresses != null ) {
        s += e.emailAddresses![0].displayName! + '<>';
      }
      if( e.names != null ){
        s += e.names![0].displayName! + '<br>';
      }
      print(s);
    });

    setState(() {
      if (s != null) {
        _contactText = s;
      } else {
        _contactText = 'No contacts to display.';
      }
    });
  }

  Widget _buildBody() {
    final GoogleSignInAccount? user = _currentUser;
      return Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          ListTile(
            title: Text(user?.displayName ?? 'displayName'),
            subtitle: Text(user?.email ?? 'email'),
          ),
          const Text('Signed in successfully.'),
          Text(_contactText),
          ElevatedButton(
            onPressed: _handleGetContact,
            child: const Text('REFRESH'),
          ),
        ],
      );
    }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.drawerListMyContacts),
      ),
      drawer: const MyDrawer(),
      body:ConstrainedBox(
        constraints: const BoxConstraints.expand(),
        child: _buildBody(),
      ),
    );
  }

}
