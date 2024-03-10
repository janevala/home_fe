import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:homefe/bloc/login_bloc.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  DashboardScreenState createState() => DashboardScreenState();
}

class DashboardScreenState extends State<DashboardScreen> {
  LoginBloc loginBloc = LoginBloc();

  String email = '';
  String password = '';

  bool openDefault = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        foregroundColor: Colors.white,
        title: const Text('Select news servie'),
      ),
      body: BlocProvider<LoginBloc>(
        create: (context) => loginBloc,
        child: BlocBuilder<LoginBloc, LoginState>(
          builder: (context, LoginState loginState) {
            return Padding(
              padding: const EdgeInsets.all(32),
              child: Column(children: [
                const SizedBox(height: 24.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Switch(
                      value: openDefault,
                      onChanged: (bool value) {
                        setState(() {
                          openDefault = value;
                        });
                      },
                    ),
                    const SizedBox(width: 8.0),
                    Text(openDefault ? 'Choose providers' : 'Choose aggregate'),
                  ],
                ),
              ]),
            );
          },
        ),
      ),
    );
  }
}
