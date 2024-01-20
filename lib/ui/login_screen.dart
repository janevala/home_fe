import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:homefe/bloc/login_bloc.dart';
import 'package:homefe/podo/login/login_body.dart';
import 'package:homefe/ui/spinner.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  LoginBloc loginBloc = LoginBloc();

  final _formKey = GlobalKey<FormState>();
  String email = '';
  String password = '';

  bool openDefault = true;

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
            child: const Text('Login')),
      ),
      body: BlocProvider<LoginBloc>(
        create: (context) => loginBloc,
        child: BlocBuilder<LoginBloc, LoginState>(
          builder: (context, LoginState loginState) {
            return BlocListener<LoginBloc, LoginState>(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        TextFormField(
                          decoration: const InputDecoration(labelText: 'Email'),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your account';
                            }
                            return null;
                          },
                          onChanged: (value) {
                            setState(() {
                              email = value;
                            });
                          },
                        ),
                        const SizedBox(height: 16.0),
                        TextFormField(
                          decoration:
                              const InputDecoration(labelText: 'Password'),
                          obscureText: true,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your password';
                            }
                            return null;
                          },
                          onChanged: (value) {
                            setState(() {
                              password = value;
                            });
                          },
                        ),
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
                            Text(openDefault
                                ? 'Choose providers'
                                : 'Choose aggregate'),
                          ],
                        ),
                        const SizedBox(height: 24.0),
                        ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              loginBloc.add(LoginEvent(
                                  LoginBody(email, password, 'password')));
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
                    GoRouter.of(context)
                        .goNamed(openDefault ? 'rss_sites' : 'rss_aggregate');
                  } else if (state is LoginFailure) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(state.error),
                        backgroundColor: Colors.red,
                        duration: const Duration(seconds: 15),
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
