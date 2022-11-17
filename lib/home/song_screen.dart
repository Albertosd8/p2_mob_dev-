import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:p1_mob_dev/home/bloc_songs/songs_bloc.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:async';
import 'package:flutter/material.dart';

class SongScreen extends StatefulWidget {
  final Map<dynamic, dynamic> songDetail;
  SongScreen({Key? key, required this.songDetail}) : super(key: key);

  @override
  State<SongScreen> createState()=> _SongScreenState();
}

class _SongScreenState extends State<SongScreen> {
  // String title_album = "Feel something";
  // String title_song = "Infinity";
  // String title_song_date = "2017-06-23";
  // @override
  // void initState(){
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text('Here you go'), 
        actions: [
          Container(
            padding: const EdgeInsets.fromLTRB(0, 0, 20, 0),
            child: IconButton(
              icon: Icon(Icons.favorite), 
              onPressed: (() {
                BlocProvider.of<FavsSongsBloc>(context).add(AddToSongsFavs(newFavSong: {
                  'image': widget.songDetail['spotify'] != null ? widget.songDetail['spotify']['album']['images'][1]['url'] 
                      : "https://akamai.sscdn.co/uploadfile/letras/albuns/1/6/a/6/608811511359601.jpg",
                  'song_name': widget.songDetail['title'],
                  'author': widget.songDetail['artist']
                }));
              })
            ),
          )
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              Container(
                height: MediaQuery.of(context).size.height * 0.50,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  image: DecorationImage(
                  fit: BoxFit.fill,
                  image: NetworkImage(widget.songDetail['spotify'] != null ? widget.songDetail['spotify']['album']['images'][1]['url'] 
                      : "https://akamai.sscdn.co/uploadfile/letras/albuns/1/6/a/6/608811511359601.jpg") ,
                ),
                )
              ),
              // Image.network('https://akamai.sscdn.co/uploadfile/letras/albuns/1/6/a/6/608811511359601.jpg'),
            ],
          ),
          Container(
            padding: EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                SizedBox(height: 15,),
                Column(
                  children: [
                    Text(
                      widget.songDetail['title'], style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      widget.songDetail['album'], style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      widget.songDetail['artist'], style: TextStyle(fontSize: 15, color: Colors.grey),
                    ),
                    Text(
                      widget.songDetail['release_date'], style: TextStyle(fontSize: 15, color: Colors.grey),
                    ),
                  ],
                ),
                SizedBox(height: 25,),
                Text(
                      "Abrir con:", style: TextStyle(fontSize: 15),
                    ),
                SizedBox(height: 25,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    IconButton(
                      icon: FaIcon(FontAwesomeIcons.spotify),
                      iconSize: 50,
                      onPressed: () async {
                        if (widget.songDetail["spotify"] == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text("Apple music link unavailable"),
                            ),
                          );
                        } else {
                          var _url = Uri.parse(widget.songDetail["spotify"]
                              ["external_urls"]["spotify"]);
                          if (!await launchUrl(_url)) {
                            throw 'Could not launch $_url';
                          }
                        }
                      },
                    ),
                    IconButton(
                      icon: FaIcon(FontAwesomeIcons.podcast),
                      iconSize: 50,
                      onPressed: () {
                      },
                    ),
                    IconButton(
                      icon: FaIcon(FontAwesomeIcons.apple),
                      iconSize: 50,
                      onPressed: () async {
                        if (widget.songDetail["apple_music"] == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text("Apple music link unavailable"),
                            ),
                          );
                        } else {
                          var _url = Uri.parse(widget.songDetail["apple_music"]
                              ["external_urls"]["spotify"]);
                          if (!await launchUrl(_url)) {
                            throw 'Could not launch $_url';
                          }
                        }
                      },
                    ),
                  ],
                )
              ],
            )
          )
          
        ],
      )
    );
  }
}

Future<void> _launchInBrowser(Uri url) async {
    if (!await launchUrl(
      url,
      mode: LaunchMode.externalApplication,
    )) {
      throw 'Could not launch $url';
    }
  }