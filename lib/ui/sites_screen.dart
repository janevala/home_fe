import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:homefe/bloc/rss_bloc.dart';
import 'package:homefe/podo/rss/rss_site.dart';
import 'package:homefe/ui/spinner.dart';

class SitesScreen extends StatefulWidget {
  const SitesScreen({super.key});

  @override
  SitesScreenState createState() => SitesScreenState();
}

class SitesScreenState extends State<SitesScreen> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        foregroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text('Providers'),
        leading: BackButton(
          onPressed: () {
            context.goNamed('dashboard');
          },
        ),
      ),
      body: SafeArea(
        child: BlocProvider<RssSitesBloc>(
          create: (context) => context.read<RssSitesBloc>(),
          child: BlocBuilder<RssSitesBloc, RssState>(
            builder: (context, state) {
              if (state is Loading) {
                return const Spinner();
              } else if (state is RssInitial) {
                context.read<RssSitesBloc>().add(RssSitesEvent());

                return const Spinner();
              } else if (state is RssSitesSuccess &&
                  state.rssSites.sites.isNotEmpty) {
                return Center(
                  child: SizedBox(
                    width: width * 0.8,
                    child: Padding(
                      padding: const EdgeInsets.all(32),
                      child: ListView.builder(
                        itemCount: state.rssSites.sites.length,
                        itemBuilder: (BuildContext context, int index) {
                          RssSite site = state.rssSites.sites[index];

                          return ListTile(
                            title: Text(site.title),
                            titleTextStyle: const TextStyle(
                              fontSize: 22,
                              color: Colors.black,
                            ),
                            subtitle: Align(
                              alignment: Alignment.centerRight,
                              child: Text(site.url),
                            ),
                            subtitleTextStyle: const TextStyle(
                              fontSize: 16,
                              color: Colors.blue,
                              decoration: TextDecoration.underline,
                            ),
                            onTap: () async {
                              GoRouter.of(context).goNamed('site', extra: site);
                            },
                          );
                        },
                      ),
                    ),
                  ),
                );
              } else if (state is Failure) {
                return Center(
                  child: Text(
                    state.error,
                    style: const TextStyle(fontSize: 18),
                  ),
                );
              } else {
                return const Center(
                  child: Text(
                    'Something went wrong',
                    style: TextStyle(fontSize: 18),
                  ),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
