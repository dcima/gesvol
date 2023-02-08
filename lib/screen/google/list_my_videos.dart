import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:gesvol/screen/my_drawer.dart';
import 'package:googleapis/youtube/v3.dart';
import 'package:gesvol/models/channel_info.dart';

import '../../utils/helper.dart';

class ListMyVideos extends StatefulWidget {
  const ListMyVideos({super.key});

  @override
_ListMyVideosState createState() => _ListMyVideosState();
}

class _ListMyVideosState extends State<ListMyVideos> {
  late Future<List<ChannelInfo>> _playlist;

  @override
  void initState() {
    super.initState();
    _playlist = getVideos() as Future<List<MyVideo>>;
    print(_playlist);
  }

  Future<ChannelInfo> getVideos() async {
    final youTubeApi = YouTubeApi(Helper.authClient);

    Map<String,String> parameters = {
      'part' : ,
      'mine' : 'true'
    };
    youTubeApi.    .channels.list('id,snippet,contentDetails,statistics' as List<String>);

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.drawerListMyVideos),
      ),
      drawer: const MyDrawer(),
      body: FutureBuilder<MyVideo>(
        future: _playlist,
        builder: (context, snapshot) {
          if(snapshot.hasData) {

          }
        }
      )
    );
  }
}