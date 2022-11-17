import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:http/http.dart' as http;
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:path_provider/path_provider.dart';
import 'package:p1_mob_dev/secrets.dart';
import 'package:record/record.dart';

part 'homepage_event.dart';
part 'homepage_state.dart';

class HomePageBloc
    extends Bloc<HomePageRecognitionEvent, HomepageRecognitionState> {
  HomePageBloc() : super(HomePageRecognitionInitial()) {
    on<RecordSong>(_recodSong);
  }
  FutureOr<void> _recodSong(event, emit) async {
    // print("hey");
    emit(HomePageRecording());
    final record = Record();
    bool canRecord = await record.hasPermission();
    if (canRecord) {
      Directory tempDir = await getTemporaryDirectory();
      await record.start(path: tempDir.path + "/temp_audio.m4a"); 
      // emit(HomePageRecording());
      await Future.delayed(
        const Duration(seconds: 10),
        () async {
          await record.stop();
        },
      );
      emit(HomePageLoadingSong());
      File recording = File(tempDir.path + "/temp_audio.m4a");
      Uint8List recodingBytes = await recording.readAsBytes();
      String base64recording = base64.encode(recodingBytes);
      var response = await http.post(
        Uri.parse('https://api.audd.io/'),
        body: jsonEncode(<String, String>{
          'api_token': AUDD_API_TOKEN,
          'audio': base64recording,
          'return': 'apple_music,spotify',
        }),
      );
      final Map response_parsed = json.decode(utf8.decode(response.bodyBytes));
      // print("hey parser"); print(response_parsed);
      if (response_parsed["status"] == "error" || response_parsed["result"] == null) {
        emit(HomepageError());
      } else {
        emit(HomePageSongLoaded(songInfo: response_parsed));
      }
      emit(HomePageRecognitionInitial());
    }
  }
}