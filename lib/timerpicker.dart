import 'package:flutter/material.dart';
//import 'package:google_fonts/google_fonts.dart';
// for global audio service, to be able to access the disposeAll function
import 'globalaudioplayerservice.dart';
// for the spinning picker
import 'package:flutter/cupertino.dart';
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
    return Consumer<GlobalAudioService>(
      builder: (context, audioService, child) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Sleep Timer'),
            backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          ),
          body: Column(
            children: [
              Expanded(
                child: Row(
                  children: [
                    _buildTimeColumn('Hours', 24, selectedHours, (value) {
                      setState(() => selectedHours = value);
                    }),
                    _buildTimeColumn('Minutes', 60, selectedMinutes, (value) {
                      setState(() => selectedMinutes = value);
                    }),
                    _buildTimeColumn('Seconds', 60, selectedSeconds, (value) {
                      setState(() => selectedSeconds = value);
                    }),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    if (audioService.isTimerRunning)
                      ElevatedButton(
                        onPressed: () {
                          audioService.cancelTimer();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                        ),
                        child: const Text('Cancel Timer'),
                      ),
                    ElevatedButton(
                      onPressed: () {
                        final duration = Duration(
                          hours: selectedHours,
                          minutes: selectedMinutes,
                          seconds: selectedSeconds,
                        );
                        if (duration.inSeconds > 0) {
                          audioService.startTimer(duration);
                          //Navigator.pop(context);
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
                      child: const Text('Start Timer'),
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

  Widget _buildTimeColumn(
    String label,
    int count,
    int initialValue,
    void Function(int) onChanged,
  ) {
    return Expanded(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(label, style: Theme.of(context).textTheme.titleMedium),
          ),
          Expanded(
            child: CupertinoPicker(
              itemExtent: 60,
              scrollController: FixedExtentScrollController(
                initialItem: initialValue,
              ),
              onSelectedItemChanged: onChanged,
              children: List.generate(count, (index) {
                return Center(
                  child: Text(
                    index.toString().padLeft(2, '0'),
                    style: const TextStyle(fontSize: 24),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}
