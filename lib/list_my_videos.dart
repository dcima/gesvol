import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:gesvol/my_drawer.dart';
import 'package:googleapis/youtube/v3.dart';

import 'helper.dart';

class ListMyVideos extends StatefulWidget {
  const ListMyVideos({super.key});

  @override
_ListMyVideosState createState() => _ListMyVideosState();
}

class _ListMyVideosState extends State<ListMyVideos> {
  @override
  void initState() {
    super.initState();
  }

  Future<void> getVideos() async {
    print('************** getVideos ******************');
    print(Helper.authClient);
    final youTubeApi = YouTubeApi(Helper.authClient);
    print('youTubeApi');
    final favorites = await youTubeApi.playlistItems.list(['snippet'], playlistId: 'LL');
    var  _favoriteVideos;

    setState(() {
      print('setState');
      _favoriteVideos = favorites.items!.map((e) => e.snippet!).toList();
      print('_favoriteVideos $_favoriteVideos');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.drawerListMyVideos),
      ),
      drawer: const MyDrawer(),
      body: Center(
        child: Container(
          height: 80,
          width: 150,
          child: TextButton(
            onPressed: () {
              getVideos();
            },
            child: const Text(
              'My Videos',
              style: TextStyle(color: Colors.red, fontSize: 25),
            ),
          ),
        ),
      ),
    );
  }
}