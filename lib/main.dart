import 'package:flutter/material.dart';
import 'package:homefe/podo/rss/rss_site.dart';
import 'package:homefe/ui/dashboard_screen.dart';
import 'package:homefe/ui/login_screen.dart';
import 'package:homefe/ui/rss_aggregate_screen.dart';
import 'package:homefe/ui/rss_site_screen.dart';
import 'package:homefe/ui/rss_sites_screen.dart';
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
          name: 'rss_sites',
          path: 'rss_sites',
          builder: (BuildContext context, GoRouterState state) {
            return const RssSitesScreen();
          },
        ),
        GoRoute(
          name: 'rss_site',
          path: 'rss_site',
          builder: (BuildContext context, GoRouterState state) {
            return RssSiteScreen(
              rssSite: state.extra as RssSite,
            );
          },
        ),
        GoRoute(
          name: 'rss_aggregate',
          path: 'rss_aggregate',
          builder: (BuildContext context, GoRouterState state) {
            return const RssAggregateScreen();
          },
        ),
      ],
    ),
  ],
);
