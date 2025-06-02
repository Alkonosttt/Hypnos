// for ChangeNotifier
import 'package:flutter/material.dart';
// for Timer
import 'dart:async';
// standard audio player package
import 'package:audioplayers/audioplayers.dart';

class GlobalAudioService extends ChangeNotifier {
  static final GlobalAudioService _instance = GlobalAudioService._internal();
  factory GlobalAudioService() => _instance;
  GlobalAudioService._internal();

  final Map<String, AudioPlayer> _players = {};
  final Map<String, double> _volumes = {};
  final Map<String, bool> _isPlaying = {};

  Timer? _timer;
  Duration? _remainingTime;

  bool anyAudioPlaying() {
    return _isPlaying.values.any((isPlaying) => isPlaying);
  }

  bool get isTimerRunning => _timer?.isActive ?? false;
  Duration? get remainingTime => _remainingTime;

  Future<void> play(String audioPath, {double volume = 1.0}) async {
    _players[audioPath] ??= AudioPlayer();
    final player = _players[audioPath]!;
    await player.setSource(AssetSource(audioPath.replaceFirst('assets/', '')));
    await player.setReleaseMode(ReleaseMode.loop);
    await player.setVolume(volume);
    await player.resume();
    _volumes[audioPath] = volume;
    _isPlaying[audioPath] = true;

    notifyListeners();
  }

  Future<void> pause(String audioPath) async {
    final player = _players[audioPath];
    if (player != null) {
      await player.pause();
      _isPlaying[audioPath] = false;
    }
    notifyListeners();
  }

  Future<void> stopAll() async {
    for (var player in _players.values) {
      await player.stop();
    }
    _isPlaying.clear();
    notifyListeners();
  }

  Future<void> setVolume(String audioPath, double volume) async {
    final player = _players[audioPath];
    if (player != null) {
      await player.setVolume(volume);
      _volumes[audioPath] = volume;
    }
    notifyListeners();
  }

  bool isPlaying(String audioPath) => _isPlaying[audioPath] ?? false;
  double volume(String audioPath) => _volumes[audioPath] ?? 1.0;

  void startTimer(Duration duration) {
    _remainingTime = duration;
    _timer?.cancel();
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_remainingTime == null) {
        timer.cancel();
        return;
      }
      _remainingTime = _remainingTime! - Duration(seconds: 1);
      if (_remainingTime!.inSeconds <= 0) {
        timer.cancel();
        stopAll();
        _remainingTime = null;
      }
      notifyListeners();
    });
  }

  void cancelTimer() {
    _timer?.cancel();
    _remainingTime = null;
    notifyListeners();
  }
}
