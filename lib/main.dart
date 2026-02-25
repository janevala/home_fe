// import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:homefe/api/api_client.dart';
import 'package:homefe/api/api_repository.dart';
import 'package:homefe/assets/i18n/generated/app_localizations.dart';
import 'package:homefe/bloc/login_bloc.dart';
import 'package:homefe/bloc/rss_bloc.dart';
import 'package:homefe/constants/app_version.dart';
import 'package:homefe/podo/rss/rss_site.dart';
import 'package:homefe/ui/archive_screen.dart';
import 'package:homefe/ui/dashboard_screen.dart';
import 'package:homefe/ui/login_screen.dart';
import 'package:homefe/ui/feed_screen.dart';
import 'package:homefe/ui/sites_screen.dart';
import 'package:go_router/go_router.dart';
import 'package:homefe/theme/theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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
            )..add(LoadMoreArchive());
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

      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        theme: AppTheme.getThemeForPlatform(isDarkMode: false),
        darkTheme: AppTheme.getThemeForPlatform(isDarkMode: true),
        themeMode: ThemeMode.light,
        localizationsDelegates: [
          AppLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: [Locale('en'), Locale('th')],
        routerConfig: router,
      ),
    );
  }
}

final GoRouter router = GoRouter(
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      builder: (BuildContext context, GoRouterState state) {
        return const LoginScreen();
      },
      routes: <RouteBase>[
        GoRoute(
          path: 'dashboard',
          builder: (BuildContext context, GoRouterState state) {
            return const DashboardScreen();
          },
        ),
        GoRoute(
          path: 'sites',
          builder: (BuildContext context, GoRouterState state) {
            return const SitesScreen();
          },
        ),
        GoRoute(
          path: 'site',
          builder: (BuildContext context, GoRouterState state) {
            return FeedScreen(rssSite: state.extra as RssSite);
          },
        ),
        GoRoute(
          path: 'archive',
          builder: (BuildContext context, GoRouterState state) {
            return const ArchiveScreen();
          },
        ),
      ],
    ),
  ],
);
