import 'package:intl/intl.dart';

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
  Future<PlaylistListResponse> getVideos() async {
    final youTubeApi = YouTubeApi(Helper.authClient);
    final response = await youTubeApi.playlists.list(
      ["snippet"],
      mine: true,
      maxResults: 25,
    );
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
              List<Playlist> playList = snapshot.data!.items!;
              return ListView(
                children: playList.map((e){
                  return Column(
                    children: [
                      Text(e.etag!),
                      Text(e.id!),
                      Text(e.kind!),
                      Text(e.snippet!.title!),
                      Text(e.snippet!.channelTitle!),
                      Text(e.snippet!.channelId!),
                      Text(e.snippet!.defaultLanguage!),
                      Text(e.snippet!.description!),
                      Text(DateFormat('dd/MM/YYYY hh:mm:ss').format(e.snippet!.publishedAt!)),
                      Text(e.snippet!.tags! as String),
                      Text(e.snippet!.thumbnails!.default_! as String),
                      Text(e.snippet!.thumbnailVideoId!),
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