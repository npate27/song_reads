import 'package:flutter/material.dart';
import 'package:song_reads/constants/literals.dart' as LiteralConstants;


class NowPlayingCard extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(10,10,10,0),
      height: 100,
      width: double.maxFinite,
      child: Card(
        elevation: 5,
        child: Column(
            children: [
              Text(
                LiteralConstants.nowPlayingCardHeader,
                style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold)
              ),
              Row(
                children: [
                  //TODO: Temp Icon, replace with album art/image
                  Icon(Icons.album, size: 50),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Temp Song Title'),
                      Text('Temp Artist'),
                      Text('Temp Album'),
                    ],
                  )
                ]
              )
            ]
        ),
      ),
    );
  }
}