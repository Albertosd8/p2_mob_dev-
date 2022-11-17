part of 'homepage_bloc.dart';

abstract class HomepageRecognitionState{}

class HomePageRecognitionInitial extends HomepageRecognitionState{}

class HomePageRecording extends HomepageRecognitionState {}

class HomePageLoadingSong extends HomepageRecognitionState{}

class HomePageSongLoaded extends HomepageRecognitionState{
  final Map<dynamic, dynamic> songInfo;

  HomePageSongLoaded({required this.songInfo});
  List<Object> get props => [songInfo];
}

class HomepageError extends HomepageRecognitionState{}