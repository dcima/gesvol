import '../../utils/helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:gesvol/screen/my_drawer.dart';
import 'package:googleapis/youtube/v3.dart';

class ListMyVideos extends StatefulWidget {
  const ListMyVideos({super.key});

  @override
  ListMyVideosState createState() => ListMyVideosState();
}

class ListMyVideosState extends State<ListMyVideos> {
  //late Future<ChannelListResponse> _playlist;
  late Future<PlaylistListResponse> _playlist;

  @override
  void initState() {
    super.initState();
    _playlist = getVideos();
  }

  Future<PlaylistListResponse> getVideos() async {
    final youTubeApi = YouTubeApi(Helper.authClient);
    final response = await youTubeApi.playlists.list(
      ["snippet"],
      mine: true,
      maxResults: 25,
    );
    //print(_playlist.items?.first.snippet?.channelTitle);
    return response;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.drawerListMyVideos),
      ),
      drawer: const MyDrawer(),
      body: FutureBuilder<PlaylistListResponse>(
        future: getVideos(),
        builder: (context, AsyncSnapshot<PlaylistListResponse> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              return const Text('Error');
            } else if (snapshot.hasData) {
              print(snapshot.data?.toJson());

              var t = snapshot.data?.items?.first.snippet?.channelTitle;
              return Text(
                  t ?? 'empty channel',
                  style: const TextStyle(color: Colors.cyan, fontSize: 36)
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