// for ChangeNotifier
import 'package:flutter/material.dart';
// for Timer
import 'dart:async';
// standard audio player package
import 'package:audioplayers/audioplayers.dart';
// for TimerPicker
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
  Duration? _lastSetDuration;
  bool _timerPausedAutomatically = false;
  List<String> _previouslyPlaying = [];

  Duration? get remainingTime => _remainingTime;
  Duration? get lastSetDuration => _lastSetDuration;
  bool get isTimerRunning => _timer != null;
  bool get isTimerPaused => _timer == null && _remainingTime != null;

  bool isPlaying(String path) => _isPlaying[path] ?? false;
  double volume(String path) => _volumes[path] ?? 1.0;

  bool anyAudioPlaying() => _isPlaying.values.any((v) => v);

  // play a specific audio track
  Future<void> play(String audioPath, {double volume = 1.0}) async {
    _players[audioPath] ??= AudioPlayer();
    final player = _players[audioPath]!;

    await player.setReleaseMode(ReleaseMode.loop);
    await player.setVolume(volume);
    await player.setSource(AssetSource(audioPath.replaceFirst('assets/', '')));
    await player.resume();

    _isPlaying[audioPath] = true;
    _volumes[audioPath] = volume;

    // resume the timer if it was auto-paused due to no audio
    if (_remainingTime != null && _timer == null && _timerPausedAutomatically) {
      _timerPausedAutomatically = false;
      _startCountdown();
    }

    notifyListeners();
  }

  // pause a specific audio track
  Future<void> pause(String audioPath) async {
    final player = _players[audioPath];
    if (player != null) {
      await player.pause();
      _isPlaying[audioPath] = false;
    }

    // automatically pause the timer if no audio is playing
    if (!anyAudioPlaying() && isTimerRunning) {
      pauseTimer(automatically: true);
    }

    notifyListeners();
  }

  // set volume for a track
  Future<void> setVolume(String audioPath, double volume) async {
    final player = _players[audioPath];
    if (player != null) {
      await player.setVolume(volume);
      _volumes[audioPath] = volume;
    }
    notifyListeners();
  }

  // stop everything
  Future<void> stopAll() async {
    for (var player in _players.values) {
      await player.stop();
    }
    _isPlaying.clear();
    _previouslyPlaying.clear();
    notifyListeners();
  }

  // Start the timer (but only countdown if audio is playing)
  void startTimer(Duration duration) {
    _lastSetDuration = duration;
    _remainingTime = duration;
    _timer?.cancel();
    _timerPausedAutomatically = false;

    if (anyAudioPlaying()) {
      _startCountdown();
    }

    notifyListeners();
  }

  // internal countdown logic
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

  // manual or auto pause
  void pauseTimer({bool automatically = false}) {
    if (_timer != null) {
      _timer?.cancel();
      _timer = null;

      _previouslyPlaying =
          _isPlaying.entries
              .where((entry) => entry.value)
              .map((entry) => entry.key)
              .toList();

      // pause all audio
      for (final path in _previouslyPlaying) {
        _players[path]?.pause();
        _isPlaying[path] = false;
      }

      _timerPausedAutomatically = automatically;
      notifyListeners();
    }
  }

  // resume timer (only works if audio is resumed)
  void resumeTimer() {
    if (_remainingTime != null && _timer == null) {
      // resume the previously playing audio
      for (final path in _previouslyPlaying) {
        play(path, volume: _volumes[path] ?? 1.0);
      }

      _timerPausedAutomatically = false;
      _startCountdown();
      notifyListeners();
    }
  }

  // cancel the timer
  void cancelTimer() {
    _timer?.cancel();
    _timer = null;
    _remainingTime = null;
    _timerPausedAutomatically = false;
    _previouslyPlaying.clear();
    notifyListeners();
  }
}
