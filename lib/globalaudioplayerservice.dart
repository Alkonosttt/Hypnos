// for ChangeNotifier
import 'package:flutter/material.dart';
// for Timer
import 'dart:async';
// standard audio player package
import 'package:audioplayers/audioplayers.dart';
// for TimerPicker
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart';

class GlobalAudioService extends ChangeNotifier {
  static final GlobalAudioService _instance = GlobalAudioService._internal();
  factory GlobalAudioService() => _instance;
  GlobalAudioService._internal();

  final Map<String, AudioPlayer> _players = {};
  final Map<String, bool> _isPlaying = {};
  final Map<String, double> _volumes = {};

  Timer? _timer;
  Duration? _remainingTime;
  bool _timerPausedAutomatically = false;
  List<String> _previouslyPlaying = [];

  Duration? get remainingTime => _remainingTime;
  bool get isTimerRunning => _timer != null;
  bool get isTimerPaused => _timer == null && _remainingTime != null;

  bool isPlaying(String path) => _isPlaying[path] ?? false;
  double volume(String path) => _volumes[path] ?? 1.0;

  bool anyAudioPlaying() => _isPlaying.values.any((v) => v);

  Future<void> play(String audioPath, {double volume = 1.0}) async {
    _players[audioPath] ??= AudioPlayer();
    final player = _players[audioPath]!;

    await player.setReleaseMode(ReleaseMode.loop);
    await player.setVolume(volume);
    await player.setSource(AssetSource(audioPath.replaceFirst('assets/', '')));
    await player.resume();

    _isPlaying[audioPath] = true;
    _volumes[audioPath] = volume;

    // If timer is set and not running due to no audio, resume it
    if (_remainingTime != null && _timer == null && _timerPausedAutomatically) {
      _timerPausedAutomatically = false;
      _startCountdown();
    }

    notifyListeners();
  }

  Future<void> pause(String audioPath) async {
    final player = _players[audioPath];
    if (player != null) {
      await player.pause();
      _isPlaying[audioPath] = false;
    }

    // Auto-pause the timer if nothing is playing
    if (!anyAudioPlaying() && isTimerRunning) {
      pauseTimer(automatically: true);
    }

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

  Future<void> stopAll() async {
    for (var player in _players.values) {
      await player.stop();
    }
    _isPlaying.clear();
    _previouslyPlaying.clear();
    notifyListeners();
  }

  void startTimer(Duration duration) {
    _remainingTime = duration;
    _timer?.cancel();
    _timerPausedAutomatically = false;

    if (anyAudioPlaying()) {
      _startCountdown();
    }

    notifyListeners();
  }

  void _startCountdown() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingTime == null) {
        timer.cancel();
        return;
      }

      _remainingTime = _remainingTime! - const Duration(seconds: 1);

      if (_remainingTime!.inSeconds <= 0) {
        timer.cancel();
        stopAll();
        _remainingTime = null;
      }

      notifyListeners();
    });
  }

  void pauseTimer({bool automatically = false}) {
    if (_timer != null) {
      _timer?.cancel();
      _timer = null;

      // Save what was playing
      _previouslyPlaying =
          _isPlaying.entries
              .where((entry) => entry.value)
              .map((entry) => entry.key)
              .toList();

      // Pause all currently playing audio
      for (final path in _previouslyPlaying) {
        _players[path]?.pause();
        _isPlaying[path] = false;
      }

      _timerPausedAutomatically = automatically;
      notifyListeners();
    }
  }

  void resumeTimer() {
    if (_remainingTime != null && _timer == null) {
      // Resume previously playing audio
      for (final path in _previouslyPlaying) {
        play(path, volume: _volumes[path] ?? 1.0);
      }

      _timerPausedAutomatically = false;
      _startCountdown();
      notifyListeners();
    }
  }

  void cancelTimer() {
    _timer?.cancel();
    _timer = null;
    _remainingTime = null;
    _timerPausedAutomatically = false;
    _previouslyPlaying.clear();
    notifyListeners();
  }
}
