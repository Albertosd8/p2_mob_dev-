import 'dart:async';
import 'dart:developer';
import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

import 'package:collection/collection.dart';

part 'songs_event.dart';
part 'songs_state.dart';

class FavsSongsBloc extends Bloc<SongsEvent, FavsSongsState> {
  static List<Map<String,String>> songs_list = [];
  FavsSongsBloc() : super(SongsInitial()) {
    on<AddToSongsFavs>(_addToFavsSongs);
    on<RemoveFromSongsFavs>(_removeFromFavsSongs);
  }


  void _addToFavsSongs(event, emit) {
    Map<String,String> new_fav = {
      "image": event.newFavSong['image'],
      "song_name": event.newFavSong['song_name'],
      "author": event.newFavSong['author']
    };
    if(songs_list.contains(new_fav)){
      print("ya estoy en la lista");
      emit(SuccessfulAddedToSongs());
    }else{
      print("me añadi a la lista");
      songs_list.add(new_fav);
      emit(SuccessfulAddedToSongs());
    }
  }

  void _removeFromFavsSongs(event, emit) {
    Map<String,String> fav_to_remove = {
      "image": event.songToRemove['image'],
      "song_name": event.songToRemove['song_name'],
      "author": event.songToRemove['author']
    };
    if(songs_list.contains(fav_to_remove)){
      songs_list.remove(fav_to_remove);
    }emit(UnSuccessfulRemovedFromSongs());
  }
}