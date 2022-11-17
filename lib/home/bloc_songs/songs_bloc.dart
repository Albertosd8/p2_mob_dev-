import 'dart:async';
import 'dart:developer';
import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

import 'package:collection/collection.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

part 'songs_event.dart';
part 'songs_state.dart';

class FavsSongsBloc extends Bloc<SongsEvent, FavsSongsState> {
  // static List<Map<String,String>> songs_list = [];
  FavsSongsBloc() : super(SongsInitial()) {
    on<LoadSongsFavs>(_loadFavsSongs);
    on<AddToSongsFavs>(_addToFavsSongs);
    on<RemoveFromSongsFavs>(_removeFromFavsSongs);
  }

  Future<FutureOr<void>> _loadFavsSongs(event, emit) async {
      emit(LoadingSongs());
      try{
        String? uId = await FirebaseAuth.instance.currentUser?.uid;
        CollectionReference favorites = await FirebaseFirestore.instance.collection("favorites");
        var document = await favorites.doc(uId).get();
        if(document["favorites"].length == 0){
          emit(NoSongs());
        }else{
          emit(LoadedSongs(songs: document["favorites"]));
        }
      }catch( error ) {
        emit(ErrorLoadingSongs());
      }
  }

  FutureOr<void> _addToFavsSongs(event, emit) async{
    String? uId = await FirebaseAuth.instance.currentUser?.uid;
    CollectionReference favorites = await FirebaseFirestore.instance.collection("favorites");
    var document = await favorites.doc(uId).get();

    if(await document.data() == null){
      try{
        favorites.doc(uId).set({
          "favorites": [
            {
              'image': event.newFavSong['image'],
              'song_name': event.newFavSong['song_name'],
              'author': event.newFavSong['author'],
            }
          ]
        });
        emit(SuccessfulAddedToSongs());
      } catch (error){
        emit(UnSuccessfulAddedToSongs());
      }
    }else{
      var list_songs = document.get('favorites');
      if(list_songs.any((element) => DeepCollectionEquality().equals(element, {
        'image': event.newFavSong['image'],
        'song_name': event.newFavSong['song_name'],
        'author': event.newFavSong['author'],
      }))) {
        emit(DuplicateSongs());
      }else{
        list_songs.add({
          'image': event.newFavSong['image'],
          'song_name': event.newFavSong['song_name'],
          'author': event.newFavSong['author'],
        });
        favorites.doc(uId).set({
          "favorites": list_songs,
        });
        emit(SuccessfulAddedToSongs());
      }
    }
    // Map<String,String> new_fav = { // por hacer
    //   "image": event.newFavSong['image'],
    //   "song_name": event.newFavSong['song_name'],
    //   "author": event.newFavSong['author']
    // };
    // if(songs_list.contains(new_fav)){
    //   print("ya estoy en la lista");
    //   emit(SuccessfulAddedToSongs());
    // }else{
    //   print("me añadi a la lista");
    //   songs_list.add(new_fav);
    //   emit(SuccessfulAddedToSongs());
    // }
  }

