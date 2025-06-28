// for ChangeNotifier
import 'package:flutter/material.dart';
// for Timer
import 'dart:async';
// standard audio player package
import 'package:audioplayers/audioplayers.dart';
// for TimerPicker
import 'package:shared_preferences/shared_preferences.dart';

class GlobalAudioService extends ChangeNotifier {
  static final GlobalAudioService _instance = GlobalAudioService._internal();
  factory GlobalAudioService() => _instance;
  GlobalAudioService._internal();

  final Map<String, AudioPlayer> _players = {};
  final Map<String, double> _volumes = {};
  final Map<String, bool> _isPlaying = {};

  Timer? _timer;
  Duration? _remainingTime;

  bool _isTimerPaused = false;
  Duration? _pausedRemainingTime;

  bool _disposed = false;

  bool anyAudioPlaying() {
    return _isPlaying.values.any((isPlaying) => isPlaying);
  }

  bool get isTimerRunning => _timer?.isActive ?? false;
  bool get isTimerPaused => _isTimerPaused;
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

    _safeNotifyListeners();
  }

  Future<void> pause(String audioPath) async {
    final player = _players[audioPath];
    if (player != null) {
      await player.pause();
      _isPlaying[audioPath] = false;
    }
    _safeNotifyListeners();
  }

  Future<void> stopAll() async {
    for (var player in _players.values) {
      await player.stop();
    }
    _isPlaying.clear();
    _safeNotifyListeners();
  }

  Future<void> setVolume(String audioPath, double volume) async {
    final player = _players[audioPath];
    if (player != null) {
      await player.setVolume(volume);
      _volumes[audioPath] = volume;
    }
    _safeNotifyListeners();
  }

  bool isPlaying(String audioPath) => _isPlaying[audioPath] ?? false;
  double volume(String audioPath) => _volumes[audioPath] ?? 1.0;

  Future<void> _saveTimerState() async {
    final prefs = await SharedPreferences.getInstance();
    if (_remainingTime != null) {
      await prefs.setInt(
        'timer_end_time',
        DateTime.now().add(_remainingTime!).millisecondsSinceEpoch,
      );
    } else {
      await prefs.remove('timer_end_time');
    }
  }

  Future<void> restoreTimerState() async {
    final prefs = await SharedPreferences.getInstance();
    final endTime = prefs.getInt('timer_end_time');

    if (endTime != null) {
      final now = DateTime.now();
      final targetTime = DateTime.fromMillisecondsSinceEpoch(endTime);

      if (targetTime.isAfter(now)) {
        final remaining = targetTime.difference(now);
        startTimer(remaining);
      } else {
        await prefs.remove('timer_end_time');
        stopAll();
      }
    }
  }

  void startTimer(Duration duration) {
    _remainingTime = duration;
    _isTimerPaused = false;
    _pausedRemainingTime = null;
    _timer?.cancel();
    _saveTimerState();

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
        _saveTimerState();
        _safeNotifyListeners();
        return;
      }

      _safeNotifyListeners();
    });

    _safeNotifyListeners();
  }

  // ✅ NEW: Pause timer
  void pauseTimer() {
    if (!isTimerRunning || _isTimerPaused) return;

    _timer?.cancel();
    _pausedRemainingTime = _remainingTime;
    _isTimerPaused = true;
    _saveTimerState();
    _safeNotifyListeners();
  }

  void resumeTimer() {
    if (!_isTimerPaused || _pausedRemainingTime == null) return;

    startTimer(_pausedRemainingTime!); // resets and restarts
    _isTimerPaused = false;
    _pausedRemainingTime = null;
    _safeNotifyListeners();
  }

  void cancelTimer() {
    _timer?.cancel();
    _remainingTime = null;
    _pausedRemainingTime = null;
    _isTimerPaused = false;
    _saveTimerState();
    _safeNotifyListeners();
  }

  void _safeNotifyListeners() {
    if (!_disposed) {
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _disposed = true;
    _timer?.cancel();
    for (var player in _players.values) {
      player.dispose();
    }
    super.dispose();
  }
}
