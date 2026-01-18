import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:homefe/api/api_client.dart';
import 'package:homefe/api/api_repository.dart';
import 'package:homefe/bloc/login_bloc.dart';
import 'package:homefe/bloc/rss_bloc.dart';
import 'package:homefe/functions.dart';
import 'package:homefe/podo/rss/rss_site.dart';
import 'package:homefe/ui/archive_screen.dart';
import 'package:homefe/ui/dashboard_screen.dart';
import 'package:homefe/ui/login_screen.dart';
import 'package:homefe/ui/feed_screen.dart';
import 'package:homefe/ui/sites_screen.dart';
import 'package:go_router/go_router.dart';
import 'package:homefe/ui/spinner.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String?>(
      future: readBaseUrl(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: Spinner());
        }

        final baseUrl = snapshot.data ?? 'http://localhost:8000';

        return MultiBlocProvider(
          providers: [
            BlocProvider<LoginBloc>(
              create: (context) {
                return LoginBloc(
                  repo: ApiRepository(client: ApiClient(baseUrl)),
                );
              },
            ),
            BlocProvider<RssArchiveBloc>(
              create: (context) {
                return RssArchiveBloc(
                  repo: ApiRepository(client: ApiClient(baseUrl)),
                )..add(LoadMoreArchive());
              },
            ),
            BlocProvider<RssSitesBloc>(
              create: (context) {
                return RssSitesBloc(
                  repo: ApiRepository(client: ApiClient(baseUrl)),
                )..add(RssSitesEvent());
              },
            ),
            // BlocProvider<RssFeedBloc>(
            //   create: (context) {
            //     return RssFeedBloc();
            //   },
            // ),
          ],

          child: MaterialApp.router(routerConfig: router),
        );
      },
    );
  }
}

final GoRouter router = GoRouter(
  routes: <RouteBase>[
    GoRoute(
      name: 'login',
      path: '/',
      builder: (BuildContext context, GoRouterState state) {
        return const LoginScreen();
      },
      routes: <RouteBase>[
        GoRoute(
          name: 'dashboard',
          path: 'dashboard',
          builder: (BuildContext context, GoRouterState state) {
            return const DashboardScreen();
          },
        ),
        GoRoute(
          name: 'sites',
          path: 'sites',
          builder: (BuildContext context, GoRouterState state) {
            return const SitesScreen();
          },
        ),
        GoRoute(
          name: 'site',
          path: 'site',
          builder: (BuildContext context, GoRouterState state) {
            return FeedScreen(rssSite: state.extra as RssSite);
          },
        ),
        GoRoute(
          name: 'archive',
          path: 'archive',
          builder: (BuildContext context, GoRouterState state) {
            return const ArchiveScreen();
          },
        ),
      ],
    ),
  ],
);
