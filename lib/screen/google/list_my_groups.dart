import '../../models/gruppo.dart';
import '../../utils/helper.dart';
import 'package:flutter/material.dart';
import 'package:googleapis/admin/directory_v1.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class ListMyGroups extends StatefulWidget {
  const ListMyGroups({super.key});

  @override
  ListMyGroupsState createState() => ListMyGroupsState();
}

class ListMyGroupsState extends State<ListMyGroups> {
  final CustomColumnSizer _columnSizer = CustomColumnSizer();
  final GlobalKey<SfDataGridState> keySfDataGrid = GlobalKey<SfDataGridState>();
  GruppoDataSource _gruppoDataSource = GruppoDataSource([]);
  late List<Group>? _gruppi;

  @override
  void initState()  {
    super.initState();
    print('getList - initState');
    getList();
  }

  getList() async {
    print('getList');
    _gruppi = await getGroups();
    print(_gruppi);
    _gruppoDataSource = GruppoDataSource(_gruppi!);
    print(_gruppoDataSource.toString());
  }

  Future<List<Group>?> getGroups() async {
    final directoryApi = DirectoryApi(Helper.httpClient);
    final response = await directoryApi.groups.list(
      domain: 'gevbologna.org',
      maxResults: 500,
      userKey: Helper.userGoogle?.id
    );
    return response.groups;
  }

/*  @override
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
                  return getList(snapshot.data!.groups);
                } else {
                  return const Text('Empty data');
                }
              } else {
                return Text('State: ${snapshot.connectionState}');
              }
            }
        )
    );
  }*/

  Widget _buildDataGrid(context) {
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
                    columnName: 'adminCreated',
                    label: Container(
                        padding: const EdgeInsets.all(16.0),
                        alignment: Alignment.centerLeft,
                        child: const Text(
                          'adminCreated',
                        ))),
                GridColumn(
                    columnName: 'description',
                    label: Container(
                        padding: const EdgeInsets.all(8.0),
                        alignment: Alignment.center,
                        child: const Text('description'))),
                GridColumn(
                    columnName: 'directMembersCount',
                    label: Container(
                        padding: const EdgeInsets.all(8.0),
                        alignment: Alignment.center,
                        child: const Text(
                          'directMembersCount',
                          overflow: TextOverflow.ellipsis,
                        ))),
                GridColumn(
                    columnName: 'email',
                    label: Container(
                        padding: const EdgeInsets.all(8.0),
                        alignment: Alignment.center,
                        child: const Text('email'))),
                GridColumn(
                    columnName: 'etag',
                    label: Container(
                        padding: const EdgeInsets.all(8.0),
                        alignment: Alignment.center,
                        child: const Text('etag'))),
                GridColumn(
                    columnName: 'id',
                    label: Container(
                        padding: const EdgeInsets.all(8.0),
                        alignment: Alignment.center,
                        child: const Text('id'))),
                GridColumn(
                    columnName: 'kind',
                    label: Container(
                        padding: const EdgeInsets.all(8.0),
                        alignment: Alignment.center,
                        child: const Text('kind'))),
                GridColumn(
                    columnName: 'name',
                    label: Container(
                        padding: const EdgeInsets.all(8.0),
                        alignment: Alignment.center,
                        child: const Text('name'))),
              ],
              columnSizer: _columnSizer,
              columnWidthMode: ColumnWidthMode.auto,
              gridLinesVisibility: GridLinesVisibility.both,
              headerGridLinesVisibility: GridLinesVisibility.both,
              isScrollbarAlwaysShown: true,
              key: keySfDataGrid,
              onQueryRowHeight: (details) {
                return details.rowIndex == 0 ? 70.0 : 49.0;
              },
              source: _gruppoDataSource,
            ),
          );
  }

  Widget getBody(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children:  <Widget> [
        Helper.getRibbon(context, keySfDataGrid),
        Expanded(
          child: _buildDataGrid(context),
        ),
      ],
    );
  }

  @override Widget build(BuildContext context) {
    return Helper.doBuild(context, "Dashboard", getBody(context));
  }

}