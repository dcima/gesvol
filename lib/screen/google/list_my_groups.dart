import '../../utils/helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:gesvol/screen/my_drawer.dart';
import 'package:googleapis/admin/directory_v1.dart';

class ListMyGroups extends StatefulWidget {
  const ListMyGroups({super.key});

  @override
  ListMyGroupsState createState() => ListMyGroupsState();
}

class ListMyGroupsState extends State<ListMyGroups> {
  Future<Groups> getGroups() async {
    final groupsApi = GroupsResource(Helper.authClient);
    final response = await groupsApi.list(
      domain: 'gevbologna.org',
      maxResults: 500,
      userKey: Helper.userGoogle?.uid
    );
    print('Future<Groups> getGroups() async');
    print(response);

    return response;
  }

  @override
  Widget build(BuildContext context) {
    print('ListMyGroupsState build');
    return Scaffold(
        appBar: AppBar(
          title: Text(AppLocalizations.of(context)!.drawerListMyGroups),
        ),
        drawer: const MyDrawer(),
        body: FutureBuilder<Groups>(
            future: getGroups(),
            builder: (context, AsyncSnapshot<Groups> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              } else if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasError) {
                  return const Text('Error');
                } else if (snapshot.hasData) {
                  List<Groups> groupList = snapshot.data! as List<Groups>;
                  return ListView(
                    children: groupList.map((e){
                      return Column(
                        children: [
                          Text(e.etag!),
                          Text(e.groups?.length as String),
                        ],
                      );
                    }).toList(),
                  );
                } else {
                  return const Text('Empty data');
                }
              } else {
                return Text('State: ${snapshot.connectionState}');
              }
            }
        )
    );
  }
}