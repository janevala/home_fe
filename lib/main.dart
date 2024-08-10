import 'package:flutter/material.dart';
import 'package:homefe/podo/rss/rss_site.dart';
import 'package:homefe/ui/archive_screen.dart';
import 'package:homefe/ui/dashboard_screen.dart';
import 'package:homefe/ui/login_screen.dart';
import 'package:homefe/ui/site_screen.dart';
import 'package:homefe/ui/sites_screen.dart';
import 'package:go_router/go_router.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: router,
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
            return SiteScreen(
              rssSite: state.extra as RssSite,
            );
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
