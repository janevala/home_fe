import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:homefe/bloc/rss_bloc.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  DashboardScreenState createState() => DashboardScreenState();
}

class DashboardScreenState extends State<DashboardScreen> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<RssArchiveBloc>().add(RefreshArchive());
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        foregroundColor: Colors.white,
        title: const Text('News dashboard'),
      ),
      body: BlocListener<RssArchiveBloc, RssState>(
        listener: (context, state) {
          if (state is ArchiveRefreshDone) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.blueGrey,
                duration: const Duration(seconds: 2),
              ),
            );
          } else if (state is Failure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Error: ${state.error}'),
                backgroundColor: Colors.blueGrey,
                duration: const Duration(seconds: 2),
              ),
            );
          }
        },
        child: Center(
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
                        GoRouter.of(context).go('/sites');
                      },
                      child: const Text('Choose news site'),
                    ),
                  if (!kIsWeb && !kIsWasm) const SizedBox(height: 32),
                  ElevatedButton(
                    onPressed: () {
                      GoRouter.of(context).go('/archive');
                    },
                    child: const Text('Choose new archive'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
