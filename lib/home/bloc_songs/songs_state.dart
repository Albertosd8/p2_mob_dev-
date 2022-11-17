part of 'songs_bloc.dart';

abstract class FavsSongsState {}

class SongsInitial extends FavsSongsState {}

class LoadingSongs extends FavsSongsState {}

class LoadedSongs extends FavsSongsState {
  final List<Map<String,String>> songs;

  LoadedSongs({required this.songs});
  List<Object> get props => [songs];
}

class ErrorLoadingSongs extends FavsSongsState {}

class NoSongs extends FavsSongsState {}

class SuccessfulAddedToSongs extends FavsSongsState {}

class DuplicateSongs extends FavsSongsState {}

class UnSuccessfulAddedToSongs extends FavsSongsState {}

class SuccessfulRemovedFromSongs extends FavsSongsState {}

class UnSuccessfulRemovedFromSongs extends FavsSongsState {}