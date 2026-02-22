import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:homefe/bloc/rss_bloc.dart';
import 'package:homefe/constants/app_version.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  DashboardScreenState createState() => DashboardScreenState();
}

class DashboardScreenState extends State<DashboardScreen> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<RssArchiveBloc>().add(ConfigEvent());
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<RssArchiveBloc>().add(RefreshArchive());
    });

    super.initState();
  }

  String backVersion = '';
  String frontVersion = '';

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(title: Text('Tech-Heavy News')),
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
            backVersion = state.config.version;
            frontVersion = appVersion;
            if (appVersion.contains('dev') ||
                appVersion.contains('dirty') ||
                appVersion.contains('vscode')) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Back: $backVersion, Front: $frontVersion',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                  duration: const Duration(seconds: 2),
                  backgroundColor: Theme.of(context).colorScheme.surface,
                ),
              );
            }
          } else if (state is Failure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'Error: ${state.error}',
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
                      Center(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Back: $backVersion',
                              style: const TextStyle(fontSize: 16),
                            ),
                            Text(
                              'Front: $frontVersion',
                              style: const TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 32),
                      if (!kIsWeb && !kIsWasm)
                        ElevatedButton(
                          onPressed: () {
                            GoRouter.of(context).push('/sites');
                          },
                          child: const Text('Choose news site'),
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
                        child: const Text('Choose news archive'),
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
