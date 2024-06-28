import 'dart:async';
import 'package:flutter/material.dart';
import 'package:wear/wear.dart';

void main() {
  runApp(const MyApp());
}

//////  Cronometro
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cronómetro',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.compact,
      ),
      home: const WatchScreen(),
    );
  }
}

class WatchScreen extends StatelessWidget {
  const WatchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return WatchShape(
      builder: (context, shape, child) {
        return AmbientMode(
          builder: (context, mode, child) {
            return TimerScreen(mode);
          },
        );
      },
    );
  }
}

class TimerScreen extends StatefulWidget {
  // const TimerScreen({super.key});

  final WearMode mode;

  const TimerScreen(this.mode, {super.key});

  @override
  State<TimerScreen> createState() => _TimerScreenState();
}

class _TimerScreenState extends State<TimerScreen> {
  late Timer _timer;
  late int _count;
  late String _strCount;
  late String _status;

  @override
  void initState() {
    _count = 0;
    _strCount = "00:00:00";
    _status = "Start";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          widget.mode == WearMode.active ? Colors.white : Colors.grey[700],
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // add tittle to the screen
            widget.mode == WearMode.active
                ? const Center(
                    child: Text(
                      "Cronómetro",
                      style: TextStyle(
                          color: Colors.blueAccent,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                  )
                : const Center(
                    child: Text(
                      "Cronómetro",
                      style: TextStyle(
                          color: Colors.green,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
            const SizedBox(height: 6.0),
            widget.mode == WearMode.active
                ? const Center(
                    child: Icon(
                    Icons.timer,
                    size: 20,
                    color: Colors.blueAccent,
                  ))
                : const Center(
                    child: Icon(
                    Icons.timer,
                    size: 20,
                    color: Colors.green,
                  )),
            Center(
              child: Text(
                _strCount,
                style: TextStyle(
                    color: widget.mode == WearMode.active
                        ? Colors.blueAccent
                        : Colors.green,
                    fontSize: 40),
              ),
            ),
            _buildWidgetButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildWidgetButton() {
    if (widget.mode == WearMode.active) {
      //? WearMode.active
      return Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Column(
            children: [
              ElevatedButton(

                  // textColor: Colors.white,
                  onPressed: () {
                    if (_status == "Start") {
                      _startTimer();
                    } else if (_status == "Stop") {
                      _timer.cancel();
                      setState(() {
                        _status = "Continue";
                      });
                    } else if (_status == "Continue") {
                      _startTimer();
                    }
                  },
                  child: Icon(
                    _status == "Start"
                        ? Icons.play_arrow
                        : _status == "Stop"
                            ? Icons.stop
                            : Icons.play_arrow,
                    color: Colors.blueAccent,
                  )),
              _status == "Continue"
                  ? ElevatedButton(
                      // color: Colors.blue,
                      // textColor: Colors.white,
                      onPressed: () {
                        // ignore: unnecessary_null_comparison
                        if (_timer != null) {
                          _timer.cancel();
                          setState(() {
                            _count = 0;
                            _strCount = "00:00:00";
                            _status = "Start";
                          });
                        }
                      },
                      child: const Icon(
                        Icons.refresh,
                        color: Colors.blueAccent,
                      ),
                    )
                  : const SizedBox(width: 0, height: 0),
            ],
          ),
        ],
      );
    } else {
      //? WearMode.ambient
      return Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Column(
            children: [
              ElevatedButton(
                  // color: Colors.blue,
                  // textColor: Colors.white,
                  onPressed: () {
                    if (_status == "Start") {
                      _startTimer();
                    } else if (_status == "Stop") {
                      _timer.cancel();
                      setState(() {
                        _status = "Continue";
                      });
                    } else if (_status == "Continue") {
                      _startTimer();
                    }
                  },
                  child: Icon(
                    _status == "Start"
                        ? Icons.play_arrow
                        : _status == "Stop"
                            ? Icons.stop
                            : Icons.play_arrow,
                    color: Colors.green,
                  )),
              _status == "Continue"
                  ? ElevatedButton(
                      // color: Colors.blue,
                      // textColor: Colors.white,
                      onPressed: () {
                        // ignore: unnecessary_null_comparison
                        if (_timer != null) {
                          _timer.cancel();
                          setState(() {
                            _count = 0;
                            _strCount = "00:00:00";
                            _status = "Start";
                          });
                        }
                      },
                      child: const Icon(
                        Icons.refresh,
                        color: Colors.green,
                      ),
                    )
                  : const SizedBox(width: 0, height: 0),
            ],
          ),
        ],
      );
    }
  }

  void _startTimer() {
    _status = "Stop";
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _count += 1;
        int hour = _count ~/ 3600;
        int minute = (_count % 3600) ~/ 60;
        int second = (_count % 3600) % 60;
        _strCount = hour < 10 ? "0$hour" : "$hour";
        _strCount += ":";
        _strCount += minute < 10 ? "0$minute" : "$minute";
        _strCount += ":";
        _strCount += second < 10 ? "0$second" : "$second";
      });
    });
  }
}
