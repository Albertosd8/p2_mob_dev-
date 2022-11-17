part of 'songs_bloc.dart';

abstract class SongsEvent {}

class AddToSongsFavs extends SongsEvent {
  final Map<String, String> newFavSong;

  AddToSongsFavs({required this.newFavSong});
}

class RemoveFromSongsFavs extends SongsEvent {
  final Map<String, String> songToRemove;

  RemoveFromSongsFavs({required this.songToRemove});
}