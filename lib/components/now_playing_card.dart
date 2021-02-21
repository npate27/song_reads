import 'package:flutter/material.dart';
import 'package:song_reads/constants/literals.dart' as LiteralConstants;
import 'package:song_reads/models/models.dart';
import 'package:palette_generator/palette_generator.dart';


class NowPlayingCard extends StatelessWidget {
  final SongInfo songInfo;

  NowPlayingCard({this.songInfo});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(10,10,10,0),
      height: 100,
      width: double.maxFinite,
      child: Card(
        elevation: 5,
        child: Stack(
          children: [
            FutureBuilder(
                future: PaletteGenerator.fromImageProvider(NetworkImage(songInfo.artworkImage)),
                builder: (BuildContext context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done && snapshot.hasData && snapshot.data != null) {
                    return Container(
                      color: snapshot.data.dominantColor.color,
                      child: Row(
                        children: [
                          Image.network(songInfo.artworkImage, height: 100),
                          Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Icon(Icons.music_note),
                                      Text(songInfo.title),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Icon(Icons.person),
                                      Text(songInfo.artist),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Icon(Icons.album),
                                      Text(songInfo.album),
                                    ],
                                  ),
                                ]
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                  //TODO: make this better
                  return Align(alignment: Alignment.center, child: CircularProgressIndicator());
                }
            ),
            Align(
              alignment: Alignment.topRight,
              child:
              Container(
                  decoration: BoxDecoration(color: Colors.grey, borderRadius: BorderRadius.only(bottomLeft: Radius.circular(50.0))),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                    child: Text(LiteralConstants.nowPlayingCardHeader, style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold)),
                  )
              ),
            ),
          ],
        ),
      ),
    );
  }
}