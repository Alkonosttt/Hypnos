import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
// for global audio service, to be able to access the disposeAll function
import 'globalaudioplayerservice.dart';
// for the spinning picker
import 'package:flutter/cupertino.dart';
// for Consumer
import 'package:provider/provider.dart';

class SleepTimerPicker extends StatefulWidget {
  @override
  _SleepTimerPickerState createState() => _SleepTimerPickerState();
}

class _SleepTimerPickerState extends State<SleepTimerPicker> {
  int selectedHours = 0;
  int selectedMinutes = 30;
  int selectedSeconds = 0;

  @override
  Widget build(BuildContext context) {
    Widget _buildTimeColumn(
      String label,
      int max,
      int selectedValue,
      void Function(int) onSelectedItemChanged,
    ) {
      return Expanded(
        child: Column(
          children: [
            Text(label, style: GoogleFonts.comfortaa(fontSize: 18)),
            Expanded(
              child: CupertinoPicker(
                scrollController: FixedExtentScrollController(
                  initialItem: selectedValue,
                ),
                itemExtent: 32.0,
                onSelectedItemChanged: onSelectedItemChanged,
                children: List<Widget>.generate(
                  max,
                  (index) =>
                      Center(child: Text(index.toString().padLeft(2, '0'))),
                ),
              ),
            ),
          ],
        ),
      );
    }

    return Consumer<GlobalAudioService>(
      builder: (context, audioService, child) {
        final remaining = audioService.remainingTime;
        final isRunning = audioService.isTimerRunning;
        final isPaused = audioService.isTimerPaused;

        String timeText;
        if (remaining != null) {
          final hours = remaining.inHours;
          final minutes = remaining.inMinutes % 60;
          final seconds = remaining.inSeconds % 60;
          timeText =
              '${hours.toString().padLeft(2, '0')}:'
              '${minutes.toString().padLeft(2, '0')}:'
              '${seconds.toString().padLeft(2, '0')}';
        } else {
          timeText = '00:00';
        }

        return Scaffold(
          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 70, 0, 20),
                child: Text(
                  'Sleep Timer',
                  style: GoogleFonts.caesarDressing(fontSize: 45),
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: Row(
                  children: [
                    _buildTimeColumn('hours', 24, selectedHours, (value) {
                      setState(() => selectedHours = value);
                    }),
                    _buildTimeColumn('minutes', 60, selectedMinutes, (value) {
                      setState(() => selectedMinutes = value);
                    }),
                    _buildTimeColumn('seconds', 60, selectedSeconds, (value) {
                      setState(() => selectedSeconds = value);
                    }),
                  ],
                ),
              ),
              Text(timeText, style: GoogleFonts.comfortaa(fontSize: 28)),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    if (isRunning)
                      ElevatedButton(
                        onPressed: () {
                          audioService.cancelTimer();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF942F67),
                          foregroundColor: Colors.white,
                          textStyle: GoogleFonts.comfortaa(),
                        ),
                        child: const Text('cancel'),
                      ),
                    if (isRunning)
                      ElevatedButton(
                        onPressed: () {
                          if (isPaused) {
                            audioService.resumeTimer();
                          } else {
                            audioService.pauseTimer();
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Color(0xFF942F67),
                          textStyle: GoogleFonts.comfortaa(),
                        ),
                        child: Text(isPaused ? 'resume' : 'pause'),
                      ),
                    if (!isRunning)
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Color(0xFF942F67),
                          textStyle: GoogleFonts.comfortaa(),
                        ),
                        onPressed: () {
                          final duration = Duration(
                            hours: selectedHours,
                            minutes: selectedMinutes,
                            seconds: selectedSeconds,
                          );
                          if (duration.inSeconds > 0) {
                            audioService.startTimer(duration);
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Please select a time greater than 0',
                                ),
                              ),
                            );
                          }
                        },
                        child: const Text('set'),
                      ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
