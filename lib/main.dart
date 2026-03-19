import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:homefe/api/api_client.dart';
import 'package:homefe/api/api_repository.dart';
import 'package:homefe/assets/i18n/generated/app_localizations.dart';
import 'package:homefe/bloc/locale_cubit.dart';
import 'package:homefe/bloc/login_bloc.dart';
import 'package:homefe/bloc/rss_bloc.dart';
import 'package:homefe/bloc/theme_cubit.dart';
import 'package:homefe/constants/app_version.dart';
import 'package:homefe/constants/supported_locals.dart';
import 'package:homefe/podo/rss/rss_site.dart';
import 'package:homefe/ui_portrait/login_screen.dart' as portrait;
import 'package:homefe/ui_landscape/login_screen.dart' as landscape;
import 'package:homefe/ui_portrait/dashboard_screen.dart' as portrait;
import 'package:homefe/ui_landscape/dashboard_screen.dart' as landscape;
import 'package:homefe/ui_portrait/sites_screen.dart' as portrait;
import 'package:homefe/ui_landscape/sites_screen.dart' as landscape;
import 'package:homefe/ui_portrait/feed_screen.dart' as portrait;
import 'package:homefe/ui_landscape/feed_screen.dart' as landscape;
import 'package:homefe/ui_portrait/archive_screen.dart' as portrait;
import 'package:homefe/ui_landscape/archive_screen.dart' as landscape;
import 'package:go_router/go_router.dart';
import 'package:homefe/theme/theme.dart';
import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart';

import 'package:flutter/foundation.dart' show defaultTargetPlatform, TargetPlatform;

bool get _usePortraitUi =>
    defaultTargetPlatform == TargetPlatform.iOS || defaultTargetPlatform == TargetPlatform.android;

void main() {
  setLocaleMessages('de', DeMessages());
  setLocaleMessages('de_short', DeShortMessages());
  setLocaleMessages('fi', FiMessages());
  setLocaleMessages('fi_short', FiShortMessages());
  setLocaleMessages('th', ThMessages());
  setLocaleMessages('th_short', ThShortMessages());
  setLocaleMessages('pt_BR', PtBrMessages());
  setLocaleMessages('pt_BR_short', PtBrShortMessages());

  runApp(const ThemedApp());
}

class ThemedApp extends StatelessWidget {
  const ThemedApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ThemeCubit>(create: (context) => ThemeCubit()),
        BlocProvider<LocaleCubit>(create: (context) => LocaleCubit()),
      ],
      child: const App(),
    );
  }
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<LoginBloc>(
          create: (context) {
            return LoginBloc(
              repo: ApiRepository(client: ApiClient(appApi.trim())),
            );
          },
        ),
        BlocProvider<RssArchiveBloc>(
          create: (context) {
            return RssArchiveBloc(
              repo: ApiRepository(client: ApiClient(appApi.trim())),
            );
          },
        ),
        BlocProvider<RssSitesBloc>(
          create: (context) {
            return RssSitesBloc(
              repo: ApiRepository(client: ApiClient(appApi.trim())),
            )..add(RssSitesEvent());
          },
        ),
      ],

      child: BlocBuilder<ThemeCubit, ThemeMode>(
        builder: (context, themeMode) {
          return BlocBuilder<LocaleCubit, Locale>(
            builder: (context, locale) {
              return MaterialApp.router(
                debugShowCheckedModeBanner: false,
                theme: AppTheme.getThemeForPlatform(isDarkMode: false),
                darkTheme: AppTheme.getThemeForPlatform(isDarkMode: true),
                themeMode: themeMode,
                locale: locale,
                localizationsDelegates: [
                  AppLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                  GlobalMaterialLocalizations.delegate,
                  GlobalCupertinoLocalizations.delegate,
                ],
                supportedLocales: supportedLocales,
                localeListResolutionCallback: (locales, supportedLocales) {
                  String usedLanguage = locale.languageCode;

                  if (context.read<LocaleCubit>().wasLocaleChanged()) {
                    Intl.defaultLocale = usedLanguage;
                    return locale;
                  } else {
                    List<Locale> systemLocales = View.of(context).platformDispatcher.locales;
                    if (supportedLocales.map((s) => s.languageCode).contains(systemLocales.first.languageCode)) {
                      usedLanguage = systemLocales.first.languageCode;
                      context.read<LocaleCubit>().changeLocaleTo(Locale(usedLanguage));
                    }

                    Intl.defaultLocale = usedLanguage;

                    return Locale(usedLanguage);
                  }
                },
                routerConfig: router,
              );
            },
          );
        },
      ),
    );
  }
}

final GoRouter router = GoRouter(
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      builder: (BuildContext context, GoRouterState state) {
        return _usePortraitUi ? const portrait.LoginScreen() : const landscape.LoginScreen();
      },
      routes: <RouteBase>[
        GoRoute(
          path: 'dashboard',
          builder: (BuildContext context, GoRouterState state) {
            return _usePortraitUi ? const portrait.DashboardScreen() : const landscape.DashboardScreen();
          },
        ),
        GoRoute(
          path: 'archive',
          builder: (BuildContext context, GoRouterState state) {
            return _usePortraitUi ? const portrait.ArchiveScreen() : const landscape.ArchiveScreen();
          },
        ),
        GoRoute(
          path: 'sites',
          builder: (BuildContext context, GoRouterState state) {
            return _usePortraitUi ? const portrait.SitesScreen() : const landscape.SitesScreen();
          },
        ),
        GoRoute(
          path: 'site',
          builder: (BuildContext context, GoRouterState state) {
            return _usePortraitUi
                ? portrait.FeedScreen(rssSite: state.extra as RssSite)
                : landscape.FeedScreen(rssSite: state.extra as RssSite);
          },
        ),
      ],
    ),
  ],
);
