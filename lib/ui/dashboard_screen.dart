import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:homefe/assets/i18n/generated/app_localizations.dart';
import 'package:homefe/bloc/rss_bloc.dart';
import 'package:homefe/constants/app_version.dart';
import 'package:homefe/persistence/persistent_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  DashboardScreenState createState() => DashboardScreenState();
}

class DashboardScreenState extends State<DashboardScreen> {
  late SharedPreferences storage;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<RssArchiveBloc>().add(ConfigEvent());
      context.read<RssArchiveBloc>().add(RefreshArchive());
    });

    _loadSharedPreferences();

    super.initState();
  }

  Future<void> _loadSharedPreferences() async {
    storage = await PersistentStorage.instance;
    setState(() {
      token = storage.getString('token') ?? '';
    });
  }

  String token = '';
  String backVersion = '';
  String frontVersion = '';

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context)!.title)),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
              ),
              child: Center(child: Text('Token: $token')), //TODO
            ),
            ListTile(
              title: Text(
                'Back: $backVersion', //TODO
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
            ),
            ListTile(
              title: Text(
                'Front: $frontVersion', //TODO
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
            ),
            ListTile(
              title: Text(AppLocalizations.of(context)!.logout),
              onTap: () {
                storage.clear();
                context.pop();
                GoRouter.of(context).pop();
              },
            ),
          ],
        ),
      ),
      body: BlocListener<RssArchiveBloc, RssState>(
        listener: (context, state) {
          if (state is ArchiveRefreshDone) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  state.message,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                duration: const Duration(seconds: 4),
                backgroundColor: Theme.of(context).colorScheme.surface,
              ),
            );
          } else if (state is ConfigSuccess) {
            setState(() {
              backVersion = state.config.version;
              frontVersion = appVersion;
            });
          } else if (state is Failure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  AppLocalizations.of(context)!.backendError(state.error),
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onError,
                  ),
                ),
                duration: const Duration(seconds: 2),
                backgroundColor: Theme.of(context).colorScheme.error,
              ),
            );
          }
        },
        child: BlocBuilder<RssArchiveBloc, RssState>(
          builder: (context, state) {
            return Center(
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
                            GoRouter.of(context).push('/sites');
                          },
                          child: Text(AppLocalizations.of(context)!.newsSites),
                        ),
                      if (!kIsWeb && !kIsWasm) const SizedBox(height: 32),
                      ElevatedButton(
                        style: state is SlowLoading
                            ? ButtonStyle(
                                backgroundColor: WidgetStateProperty.all(
                                  Theme.of(context).colorScheme.surface,
                                ),
                                foregroundColor: WidgetStateProperty.all(
                                  Theme.of(context).colorScheme.onSurface,
                                ),
                              )
                            : null,
                        onPressed: state is SlowLoading
                            ? null
                            : () => GoRouter.of(context).push('/archive'),
                        child: Text(AppLocalizations.of(context)!.newsArchive),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
