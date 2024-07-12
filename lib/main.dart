import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:async';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => StopwatchProvider(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          brightness: Brightness.light,
          primaryColor: const Color.fromARGB(255, 217, 0, 255), // Color primario más femenino
          hintColor: const Color.fromARGB(255, 146, 0, 49), // Color de acento brillante
        ),
        home: const StopwatchScreen(),
      ),
    );
  }
}

class StopwatchScreen extends StatelessWidget {
  const StopwatchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final stopwatchProvider = Provider.of<StopwatchProvider>(context);
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: stopwatchProvider.isAmbientMode
                ? [Colors.black, const Color.fromARGB(255, 43, 43, 43)]
                : [const Color.fromARGB(255, 217, 0, 255), const Color.fromARGB(255, 113, 0, 40)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: GestureDetector(
            onTap: stopwatchProvider.toggleAmbientMode,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'Cronómetro',
                  style: TextStyle(
                    fontSize: 15.0,
                    fontWeight: FontWeight.bold,
                    color: stopwatchProvider.isAmbientMode ? Colors.white : Colors.white,
                  ),
                ),
                const SizedBox(height: 5),
                Icon(
                  Icons.watch_later,
                  size: 20,
                  color: stopwatchProvider.isAmbientMode ? Colors.white : Colors.white,
                ),
                const SizedBox(height: 5),
                Text(
                  stopwatchProvider.timeFormatted,
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                    color: stopwatchProvider.isAmbientMode ? Colors.white : Colors.white,
                  ),
                ),
                const SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    _buildButton(
                      icon: Icons.play_arrow,
                      onPressed: () {
                        stopwatchProvider.start();
                        stopwatchProvider.setAmbientMode(true);
                      },
                      color: stopwatchProvider.isAmbientMode ? Colors.grey : Colors.green,
                    ),
                    const SizedBox(width: 5),
                    _buildButton(
                      icon: Icons.pause,
                      onPressed: () {
                        stopwatchProvider.pause();
                        stopwatchProvider.setAmbientMode(false);
                      },
                      color: stopwatchProvider.isAmbientMode ? Colors.grey : Colors.yellow[700]!,
                    ),
                    const SizedBox(width: 5),
                    _buildButton(
                      icon: Icons.stop,
                      onPressed: () {
                        stopwatchProvider.reset();
                        stopwatchProvider.setAmbientMode(false);
                      },
                      color: stopwatchProvider.isAmbientMode ? Colors.grey : Colors.red,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildButton({
    required IconData icon,
    required VoidCallback onPressed,
    required Color color,
  }) {
    return SizedBox(
      width: 35,
      height: 35,
      child: FloatingActionButton(
        onPressed: onPressed,
        backgroundColor: color,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
          side: const BorderSide(color: Colors.white, width: 2),
        ),
        elevation: 10,
        child: Icon(icon, size: 18, color: Colors.white),
      ),
    );
  }
}

class StopwatchProvider with ChangeNotifier {
  final Stopwatch _stopwatch = Stopwatch();
  late Timer _timer;
  bool _isAmbientMode = false;

  String get timeFormatted {
    final duration = _stopwatch.elapsed;
    return '${(duration.inMinutes % 60).toString().padLeft(2, '0')}:'
           '${(duration.inSeconds % 60).toString().padLeft(2, '0')}:'
           '${(duration.inMilliseconds % 1000 ~/ 10).toString().padLeft(2, '0')}';
  }

  bool get isAmbientMode => _isAmbientMode;

  void start() {
    if (!_stopwatch.isRunning) {
      _stopwatch.start();
      _timer = Timer.periodic(const Duration(milliseconds: 30), (timer) {
        notifyListeners();
      });
      setAmbientMode(true);
    }
  }

  void pause() {
    if (_stopwatch.isRunning) {
      _stopwatch.stop();
      _timer.cancel();
      setAmbientMode(false);
    }
  }

  void reset() {
    _stopwatch.reset();
    notifyListeners();
    setAmbientMode(false);
  }

  void toggleAmbientMode() {
    _isAmbientMode = !_isAmbientMode;
    notifyListeners();
  }

  void setAmbientMode(bool isAmbient) {
    _isAmbientMode = isAmbient;
    notifyListeners();
  }
}
