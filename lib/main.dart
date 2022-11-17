import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:p1_mob_dev/home/home_page.dart';
import 'package:p1_mob_dev/home/songs.dart';
import 'package:p1_mob_dev/home/song_screen.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:p1_mob_dev/home/bloc_homepage/homepage_bloc.dart';
import 'package:p1_mob_dev/home/bloc_songs/songs_bloc.dart';
// import 'package:p1_mob_dev/home/bloc_songscreen/';

void main() {
  runApp(const MyApp(),
  );
}



class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => HomePageBloc(),
        ),
        BlocProvider(
          create: (context) => FavsSongsBloc(),
        ),
      ],
    child:MaterialApp(
      darkTheme: ThemeData(
        brightness: Brightness.dark,
      ),
      themeMode: ThemeMode.dark, 
      theme: ThemeData(
        primarySwatch: Colors.purple,
      ),
      title: 'MusicFindApp',
      home: HomePage(),
    ));
  }
}