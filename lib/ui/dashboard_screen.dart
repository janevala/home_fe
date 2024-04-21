import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:homefe/bloc/login_bloc.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  DashboardScreenState createState() => DashboardScreenState();
}

class DashboardScreenState extends State<DashboardScreen> {
  LoginBloc loginBloc = LoginBloc();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        foregroundColor: Colors.white,
        title: const Text('Select news service'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
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
                  GoRouter.of(context).goNamed('aggregate');
                },
                child: const Text('Choose aggregate'),
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: () {
                  GoRouter.of(context).goNamed('archive');
                },
                child: const Text('Choose archive'),
              ),
            ]),
      ),
    );
  }
}
