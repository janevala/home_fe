import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  DashboardScreenState createState() => DashboardScreenState();
}

class DashboardScreenState extends State<DashboardScreen> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        foregroundColor: Colors.white,
        title: const Text('News dashboard'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: SizedBox(
            width: width * 0.6,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (!kIsWeb && !kIsWasm)
                  ElevatedButton(
                    onPressed: () {
                      GoRouter.of(context).goNamed('sites');
                    },
                    child: const Text('Choose news site'),
                  ),
                if (!kIsWeb && !kIsWasm) const SizedBox(height: 32),
                ElevatedButton(
                  onPressed: () {
                    GoRouter.of(context).goNamed('archive');
                  },
                  child: const Text('Choose new archive'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
