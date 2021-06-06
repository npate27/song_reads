import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:song_reads/bloc/blocs.dart';
import 'package:song_reads/bloc/color_reveal/color_reveal_bloc.dart';
import 'package:song_reads/constants/literals.dart' as LiteralConstants;
import 'package:song_reads/models/models.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:song_reads/utils/color_utils.dart';

class NowPlayingCard extends StatelessWidget {
  final SongInfo songInfo;

  NowPlayingCard({this.songInfo});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150,
      child: Card(
        borderOnForeground: false,
        margin: EdgeInsets.all(0.0),
        color: Colors.transparent,
        elevation: 0,
        child:
            FutureBuilder(
                future: PaletteGenerator.fromImageProvider(NetworkImage(songInfo.artworkImage)),
                builder: (BuildContext context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done && snapshot.hasData && snapshot.data != null) {
                    BlocProvider.of<ColorRevealBloc>(context).add(UpdateRevealColor(colorPalettes: snapshot.data));
                    Color dominantColor = snapshot.data.dominantColor.color;
                    Color complementaryColor = lightAdjustedComplimentColor(dominantColor);
                    Color complementaryContrastColor = absoluteContrastColorFromLuminance(complementaryColor);

                    return Stack(
                      children: [
                        Container(
                          color: dominantColor,
                          child: Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                                //150x150 is the default (I think?) need a way to enforce via url
                                // TODO check API for acceptable sizes
                                child: Image.network(songInfo.artworkImage),
                              ),
                              Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Icon(Icons.music_note, color: complementaryColor),
                                        Text(songInfo.title, style: TextStyle(color: complementaryColor)),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Icon(Icons.person, color: complementaryColor),
                                        Text(songInfo.artist, style: TextStyle(color: complementaryColor)),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Icon(Icons.album, color: complementaryColor),
                                        Text(songInfo.album, style: TextStyle(color: complementaryColor)),
                                      ],
                                    ),
                                  ]
                              ),
                            ],
                          ),
                        ),

                        Align(
                          alignment: Alignment.topRight,
                          child: Container(
                            decoration: BoxDecoration(color: complementaryColor, borderRadius: BorderRadius.all(Radius.circular(50.0))),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                              child: Text(LiteralConstants.nowPlayingCardHeader, style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold, color: complementaryContrastColor)),
                            )
                          ),
                        ),
                      ]
                    );
                  }
                  //TODO: make this better
                  return Center(child: Text('Getting song info...', style: TextStyle(fontSize: 20),));
                }
            ),
      ),
    );
  }
}