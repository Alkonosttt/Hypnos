// for the Timer
import 'dart:async';
// audio player itself
import 'package:audioplayers/audioplayers.dart';

// creates a global audio service and a timer that will play regardless of
// which screen is currently active
class AudioService {
  static final AudioService _instance = AudioService._internal();
  factory AudioService() => _instance;
  AudioService._internal();

  final AudioPlayer _player = AudioPlayer();
  Timer? _stopTimer;

  // pointing to which audio asset to play
  Future<void> play(String url) async {
    await _player.play(AssetSource(url));
  }

  // to stop with the timer
  void stop() {
    _player.stop();
    _stopTimer?.cancel();
  }

  void setTimer(Duration duration) {
    _stopTimer?.cancel();
    _stopTimer = Timer(duration, () {
      stop();
    });
  }

  bool get isPlaying => _player.state == PlayerState.playing;
}
