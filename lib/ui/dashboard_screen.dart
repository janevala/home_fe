import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:homefe/bloc/login_bloc.dart';
import 'package:homefe/bloc/rss_bloc.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  DashboardScreenState createState() => DashboardScreenState();
}

class DashboardScreenState extends State<DashboardScreen> {
  LoginBloc loginBloc = LoginBloc();

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        foregroundColor: Colors.white,
        title: const Text('Logout'),
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
                  ElevatedButton(
                    onPressed: () {
                      GoRouter.of(context).goNamed('sites');
                    },
                    child: const Text('Choose provider'),
                  ),
                  const SizedBox(height: 32),
                  ElevatedButton(
                    onPressed: () {
                      GoRouter.of(context).goNamed('archive');
                    },
                    child: const Text('Choose archive'),
                  ),
                  const SizedBox(height: 32),
                  ElevatedButton(
                    onPressed: () {
                      final QuestionBloc bloc = QuestionBloc();
                      bloc.add(QuestionEvent(
                          'Tell me about differences in stateless and stateful widgets in Flutter'));
                    },
                    child: const Text('Ask AI'),
                  ),
                ]),
          ),
        ),
      ),
    );
  }
}
