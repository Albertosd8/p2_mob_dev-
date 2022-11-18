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

  Future<FutureOr<void>> _loadFavsSongs(event, emit) async {  //error going on firebase to load
      emit(LoadingSongs());
      try{
        String? uId = await FirebaseAuth.instance.currentUser?.uid;
        CollectionReference favorites = await FirebaseFirestore.instance.collection('favorites');
        // print(favorites.doc(uId).get());
        // var document = await favorites.doc(uId).get();
        var document = await favorites.doc('favorites').get();
        // print(document['hG5KIQM2pyjzlP9Stftw']); //
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

    // var document = await favorites.doc('uId').get(); // .doc(uId) para el login pero no implementado//old line
    var document = await favorites.doc("favorites").get(); //modified line

    // print(document.data()); //documento en colección

    if(await document.data() == null){
      try{
        favorites.doc("favorites").set({
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
      // print("songs list on document");print(list_songs); //songs in document favorites
      if(list_songs.any((element) => DeepCollectionEquality().equals(element, {
        'image': event.newFavSong['image'],
        'song_name': event.newFavSong['song_name'],
        'author': event.newFavSong['author'],
      }))) {
        // print("duplicated song");
        emit(DuplicateSongs());
      }else{
        list_songs.add({
          'image': event.newFavSong['image'],
          'song_name': event.newFavSong['song_name'],
          'author': event.newFavSong['author'],
        });
        favorites.doc('favorites').set({
          "favorites": list_songs,
        });
        emit(SuccessfulAddedToSongs());
      }
    }
  }

  FutureOr<void> _removeFromFavsSongs(event, emit) async {
    String? uId = await FirebaseAuth.instance.currentUser?.uid;
    CollectionReference favorites = FirebaseFirestore.instance.collection('favorites');
    var document = await favorites.doc('favorites').get();
    var list_songs = await document.get('favorites');
    final index = list_songs.indexWhere((element) =>
      element["song_name"] == event.songToRemove["song_name"] &&
      element["song_artist"] == event.songToRemove["song_artist"]);
    list_songs.removeAt(index);
    favorites.doc('favorites').set({
      "favorites": list_songs,
    });
    emit(SuccessfulRemovedFromSongs());
  }
}
