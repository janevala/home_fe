import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:homefe/bloc/login_bloc.dart';
import 'package:homefe/podo/login/login_body.dart';
import 'package:homefe/podo/token/token.dart';
import 'package:homefe/ui/spinner.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  LoginBloc loginBloc = LoginBloc();

  final _formKey = GlobalKey<FormState>();
  String userName = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        foregroundColor: Colors.white,
        title: InkWell(
            onTap: () {
              loginBloc.add(LoginEvent(LoginBody('', '', '')));
            },
            child: const Text('Enter token')),
      ),
      body: BlocProvider<LoginBloc>(
        create: (context) => loginBloc,
        child: BlocBuilder<LoginBloc, LoginState>(
          builder: (context, LoginState loginState) {
            return BlocListener<LoginBloc, LoginState>(
                child: Padding(
                  padding: const EdgeInsets.all(32),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        TextFormField(
                          decoration: const InputDecoration(labelText: 'Token'),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter token';
                            }
                            return null;
                          },
                          onChanged: (value) {
                            setState(() {
                              userName = value;
                            });
                          },
                        ),
                        const SizedBox(height: 24.0),
                        ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              loginBloc.add(LoginEvent(
                                  LoginBody(userName, '123', 'password')));
                            }
                          },
                          child: const Text('Login'),
                        ),
                      ],
                    ),
                  ),
                ),
                listener: (BuildContext context, LoginState state) {
                  if (state is LoginSuccess) {
                    Token token = state.token;
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Token: ${token.accessToken}'),
                        backgroundColor: Colors.green,
                        duration: const Duration(seconds: 2),
                      ),
                    );
                    Future.delayed(const Duration(seconds: 3), () {
                      GoRouter.of(context).goNamed('dashboard');
                    });
                  } else if (state is LoginFailure) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(state.error),
                        backgroundColor: Colors.red,
                        duration: const Duration(seconds: 10),
                      ),
                    );
                  } else if (state is LoginLoading) {
                    const Spinner();
                  }
                });
          },
        ),
      ),
    );
  }
}
