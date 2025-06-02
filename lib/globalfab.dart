import 'package:flutter/material.dart';
import 'globalaudioplayerservice.dart';

class GlobalFAB extends StatelessWidget {
  final VoidCallback? onPressed;
  const GlobalFAB({this.onPressed, super.key});

  @override
  Widget build(BuildContext context) {
    final timer = GlobalAudioService();
    return Visibility(
      visible: timer.isTimerRunning,
      child: FloatingActionButton.extended(
        onPressed: onPressed,
        label: Text("⏱ ${timer.remainingTime?.inMinutes ?? 0}m"),
        icon: Icon(Icons.timer),
      ),
    );
  }
}
