import 'package:audioplayers/audioplayers.dart';

class GlobalAudioService {
  static final GlobalAudioService _instance = GlobalAudioService._internal();
  factory GlobalAudioService() => _instance;
  GlobalAudioService._internal();

  final Map<String, AudioPlayer> _players = {};
  final Map<String, double> _volumes = {};
  final Map<String, bool> _isPlaying = {};

  Future<void> play(String audioPath, {double volume = 1.0}) async {
    _players[audioPath] ??= AudioPlayer();
    final player = _players[audioPath]!;
    await player.setSource(AssetSource(audioPath.replaceFirst('assets/', '')));
    await player.setReleaseMode(ReleaseMode.loop);
    await player.setVolume(volume);
    await player.resume();
    _volumes[audioPath] = volume;
    _isPlaying[audioPath] = true;
  }

  Future<void> pause(String audioPath) async {
    final player = _players[audioPath];
    if (player != null) {
      await player.pause();
      _isPlaying[audioPath] = false;
    }
  }

  Future<void> setVolume(String audioPath, double volume) async {
    final player = _players[audioPath];
    if (player != null) {
      await player.setVolume(volume);
      _volumes[audioPath] = volume;
    }
  }

  bool isPlaying(String audioPath) => _isPlaying[audioPath] ?? false;
  double volume(String audioPath) => _volumes[audioPath] ?? 1.0;

  Future<void> disposeAll() async {
    for (var player in _players.values) {
      await player.dispose();
    }
    _players.clear();
    _volumes.clear();
    _isPlaying.clear();
  }
}
