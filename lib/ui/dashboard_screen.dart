import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:homefe/assets/i18n/generated/app_localizations.dart';
import 'package:homefe/bloc/rss_bloc.dart';
import 'package:homefe/bloc/theme_cubit.dart';
import 'package:homefe/constants/app_version.dart';
import 'package:homefe/functions.dart';
import 'package:homefe/logger/logger.dart';
import 'package:homefe/persistence/persistent_storage.dart';
import 'package:homefe/ui/animated_first.dart';
import 'package:homefe/ui/animated_flags.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  DashboardScreenState createState() => DashboardScreenState();
}

class DashboardScreenState extends State<DashboardScreen> {
  late SharedPreferences storage;

  String? token;
  String? backVersion;
  String? frontVersion;
  DateTime? oldestItemDate;

  int totalItems = 0;
  bool firstTimeUser = true;
  bool showAnimation = true;

  bool slowLoadingDone = false;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<RssArchiveBloc>().add(ConfigEvent());
      context.read<RssArchiveBloc>().add(RefreshArchive());
    });

    _loadPersisted();

    super.initState();
  }

  Future<void> _loadPersisted() async {
    String token = await PersistentStorage.read('token') ?? '';
    String firstTimeUser = await PersistentStorage.read('first_time_user') ?? 'true';

    setState(() {
      this.token = token;
      this.firstTimeUser = firstTimeUser == 'true';
    });

    logger.d('Loaded persisted data: token=$token, first_time_user=$firstTimeUser');
  }

  Future<void> _persist(Map<String, dynamic> data) async {
    await PersistentStorage.delete(data.entries.first.key);
    await PersistentStorage.write(
      data.entries.first.key,
      data.entries.first.value.toString(),
    );
  }

  Future<void> _dePersist(Map<String, dynamic> data) async {
    await PersistentStorage.delete(data.entries.first.key);
  }

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
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Theme.of(context).colorScheme.primary.withValues(alpha: 0.6),
                    Theme.of(context).colorScheme.secondary.withValues(alpha: 0.1),
                  ],
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    child: const Icon(Icons.person),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    '${AppLocalizations.of(context)!.token}: ${token ?? 'No token'}',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    firstTimeUser ? AppLocalizations.of(context)!.welcome : AppLocalizations.of(context)!.welcomeBack,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),

            BlocBuilder<ThemeCubit, ThemeMode>(
              builder: (context, themeMode) {
                return ListTile(
                  leading: const Icon(Icons.dark_mode_outlined),
                  title: Text(
                    themeMode == ThemeMode.dark
                        ? AppLocalizations.of(context)!.darkMode
                        : AppLocalizations.of(context)!.lightMode,
                  ),
                  trailing: Switch(
                    value: themeMode == ThemeMode.dark,
                    onChanged: (value) {
                      context.read<ThemeCubit>().toggleTheme();
                    },
                  ),
                );
              },
            ),

            const Divider(),

            ListTile(
              leading: const Icon(Icons.storage),
              title: Text(
                AppLocalizations.of(context)!.newsItemCount(totalItems),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.calendar_today),
              title: Text(
                AppLocalizations.of(context)!.newsArchiveStart(
                  oldestItemDate != null
                      ? getLocalizedDate(context, oldestItemDate!)
                      : AppLocalizations.of(context)!.unknown,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.dns),
              title: Text(
                AppLocalizations.of(context)!.serverVersion(backVersion ?? 'Unknown'),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.phone_android),
              title: Text(
                AppLocalizations.of(context)!.appVersion(appVersion),
              ),
            ),

            const Divider(),
            Tooltip(
              message: AppLocalizations.of(context)!.contactTooltip,
              child: ListTile(
                leading: const Icon(Icons.email_outlined),
                title: Text(
                  AppLocalizations.of(context)!.contact,
                ),
              ),
            ),

            // Tooltip(
            //   message: AppLocalizations.of(context)!.contactTooltip,
            //   child: InkWell(
            //     onTap: () async {
            //       sendEmail(
            //         subject: AppLocalizations.of(context)!.contactSubject,
            //         body: '',
            //       );
            //     },
            //     child: ListTile(
            //       leading: Icon(
            //         Icons.email_outlined,
            //         color: Theme.of(context).colorScheme.onSurface,
            //       ),
            //       title: Text(
            //         AppLocalizations.of(context)!.contact,
            //         style: TextStyle(
            //           color: Theme.of(context).colorScheme.onSurface,
            //         ),
            //       ),
            //     ),
            //   ),
            // ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout),
              title: Text(
                AppLocalizations.of(context)!.logout,
              ),
              onTap: () {
                _dePersist({'token': dynamic});
                _persist({'first_time_user': false});
                Future.delayed(const Duration(milliseconds: 500), () {
                  // ignore: use_build_context_synchronously
                  context.pop();
                  // ignore: use_build_context_synchronously
                  GoRouter.of(context).pop();
                });
              },
            ),
          ],
        ),
      ),
      body: BlocListener<RssArchiveBloc, RssState>(
        listener: (context, state) {
          if (state is ArchiveRefreshDone) {
            slowLoadingDone = true;
            String message;

            oldestItemDate = parsePublishedParsed(state.stats.oldest);
            totalItems = state.stats.count;
            if (state.stats.status == 'Refreshed') {
              message = AppLocalizations.of(
                context,
              )!.newsUpdateWithItems(state.stats.count.toString());
            } else if (state.stats.status.startsWith('Not needed')) {
              message = AppLocalizations.of(
                context,
              )!.newsUpdatedWithNoItems(state.stats.count.toString());
            } else {
              message = AppLocalizations.of(context)!.newsNoItems;
            }

            setState(() {});

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  message,
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
              child: SizedBox(
                width: width * 0.7,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    showAnimation
                        ? AnimatedFirst(
                            onAnimationComplete: () {
                              setState(() {
                                showAnimation = false;
                              });
                            },
                          )
                        : AnimatedFlags(
                            welcomeMessage: firstTimeUser
                                ? AppLocalizations.of(context)!.welcome
                                : AppLocalizations.of(context)!.welcomeBack,
                          ),
                    const SizedBox(height: 64),
                    // if (!kIsWeb && !kIsWasm)
                    //   ElevatedButton(
                    //     onPressed: () {
                    //       GoRouter.of(context).push('/sites');
                    //     },
                    //     child: Text(AppLocalizations.of(context)!.newsSites),
                    //   ),
                    // if (!kIsWeb && !kIsWasm) const SizedBox(height: 32),
                    ElevatedButton(
                      onPressed: slowLoadingDone ? () => GoRouter.of(context).push('/archive') : null,
                      child: Text(AppLocalizations.of(context)!.newsArchive),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
