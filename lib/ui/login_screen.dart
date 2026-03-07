import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:homefe/assets/i18n/generated/app_localizations.dart';
import 'package:homefe/bloc/login_bloc.dart';
import 'package:homefe/bloc/theme_cubit.dart';
import 'package:homefe/logger/logger.dart';
import 'package:homefe/persistence/persistent_storage.dart';
import 'package:homefe/podo/login/login_body.dart';
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
      logger.i("WASM $appVersion");
    } else if (kIsWeb) {
      logger.i("WEB $appVersion");
    } else {
      logger.i("NATIVE $appVersion");
    }
  }

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    if (await _hasTheme()) {
      await _setTheme();
    } else {
      await _setSystemTheme();
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context)!.titleShort)),
      body: SafeArea(
        child: BlocProvider<LoginBloc>(
          create: (context) => context.read<LoginBloc>(),
          child: BlocListener<LoginBloc, LoginState>(
            child: Center(
              child: Form(
                key: _formKey,
                child: SizedBox(
                  width: width * 0.7,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: AppLocalizations.of(context)!.token,
                          border: Theme.of(context).inputDecorationTheme.border,
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return AppLocalizations.of(
                              context,
                            )!.pleaseEnterToken;
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
                        child: Text(AppLocalizations.of(context)!.login),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            listener: (BuildContext context, LoginState state) async {
              if (state is LoginSuccess) {
                Future.delayed(const Duration(milliseconds: 250), () {
                  if (mounted) {
                    _persist({'token': state.token.accessToken});
                    // ignore: use_build_context_synchronously
                    GoRouter.of(context).go('/dashboard');
                  }
                });
              } else if (state is LoginFailure) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      state.error,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onError,
                      ),
                    ),
                    duration: const Duration(seconds: 2),
                    backgroundColor: Theme.of(context).colorScheme.error,
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

  Future<bool> _hasTheme() async {
    final theme = await PersistentStorage.read('theme_mode');
    return theme != null;
  }

  Future<void> _setTheme() async {
    final theme = await PersistentStorage.read('theme_mode');
    if (theme != null) {
      if (mounted) {
        context.read<ThemeCubit>().setTheme(ThemeMode.values.firstWhere((e) => e.name == theme));
      }
    }
  }

  Future<void> _setSystemTheme() async {
    final mode = context.read<ThemeCubit>().mode;
    if (mode == ThemeMode.system) {
      _persist({'first_time_user': true});
      final brightness = MediaQuery.of(context).platformBrightness;
      if (brightness == Brightness.dark) {
        context.read<ThemeCubit>().setTheme(ThemeMode.dark);
      } else {
        context.read<ThemeCubit>().setTheme(ThemeMode.light);
      }
    }
  }
}

Future<void> _persist(Map<String, dynamic> data) async {
  await PersistentStorage.delete(data.entries.first.key);
  await PersistentStorage.write(
    data.entries.first.key,
    data.entries.first.value.toString(),
  );
}
