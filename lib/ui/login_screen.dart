import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:homefe/bloc/login_bloc.dart';
import 'package:homefe/logger/logger.dart';
import 'package:homefe/podo/login/login_body.dart';
import 'package:homefe/podo/token/token.dart';
import 'package:homefe/ui/spinner.dart';
import 'package:flutter/foundation.dart';
import 'package:homefe/constants/app_version.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  String userName = '';

  @override
  void initState() {
    super.initState();

    if (kIsWasm) {
      logger.i("WASM build $appVersion");
    } else if (kIsWeb) {
      logger.i("WEB build $appVersion");
    } else {
      logger.i("NATIVE build $appVersion");
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        foregroundColor: Colors.white,
        title: Text('Tech-Heavy News'),
      ),
      body: SafeArea(
        child: BlocProvider<LoginBloc>(
          create: (context) => context.read<LoginBloc>(),
          child: BlocListener<LoginBloc, LoginState>(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Form(
                  key: _formKey,
                  child: SizedBox(
                    width: width * 0.6,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
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
                          onChanged: (String value) {
                            setState(() {
                              userName = value;
                            });
                          },
                          onFieldSubmitted: (String value) {
                            if (_formKey.currentState!.validate()) {
                              context.read<LoginBloc>().add(
                                LoginEvent(
                                  LoginBody(userName, '123', 'password'),
                                ),
                              );
                            }
                          },
                        ),
                        const SizedBox(height: 32),
                        ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              context.read<LoginBloc>().add(
                                LoginEvent(
                                  LoginBody(userName, '123', 'password'),
                                ),
                              );
                            }
                          },
                          child: const Text('Login'),
                        ),
                      ],
                    ),
                  ),
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
                if (mounted) {
                  Future.delayed(const Duration(seconds: 1), () {
                    // ignore: use_build_context_synchronously
                    GoRouter.of(context).go('/dashboard');
                  });
                }
              } else if (state is LoginFailure) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.error),
                    backgroundColor: Colors.red,
                    duration: const Duration(seconds: 2),
                  ),
                );
              } else if (state is LoginLoading) {
                const Spinner();
              }
            },
          ),
        ),
      ),
    );
  }
}
