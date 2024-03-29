import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:homefe/bloc/rss_bloc.dart';
import 'package:homefe/podo/rss/rss_site.dart';
import 'package:homefe/ui/spinner.dart';

class RssSitesScreen extends StatefulWidget {
  const RssSitesScreen({super.key});

  @override
  RssSitesScreenState createState() => RssSitesScreenState();
}

class RssSitesScreenState extends State<RssSitesScreen> {
  final RssSitesBloc rssBloc = RssSitesBloc();

  @override
  void initState() {
    super.initState();

    rssBloc.add(RssSitesEvent());
  }

  @override
  Widget build(BuildContext context) {
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
          create: (context) => rssBloc,
          child: BlocBuilder<RssSitesBloc, RssState>(
            builder: (context, state) {
              if (state is RssLoading) {
                return const Spinner();
              } else if (state is RssSitesSuccess &&
                  state.rssSites.sites.isNotEmpty) {
                return ListView.builder(
                    itemCount: state.rssSites.sites.length,
                    itemBuilder: (BuildContext context, int index) {
                      RssSite site = state.rssSites.sites[index];

                      return ListTile(
                        title: Text(site.title),
                        titleTextStyle:
                            const TextStyle(fontSize: 22, color: Colors.black),
                        subtitle: Align(
                          alignment: Alignment.centerRight,
                          child: Text(site.url),
                        ),
                        subtitleTextStyle:
                            const TextStyle(fontSize: 16, color: Colors.blue, decoration: TextDecoration.underline),
                        onTap: () async {
                          GoRouter.of(context).goNamed('rss_site', extra: site);
                        },
                      );
                    });
              } else if (state is RssFailure) {
                return Center(
                    child: Text(state.error,
                        style: const TextStyle(fontSize: 18)));
              } else {
                return const Center(
                    child: Text('Something went wrong',
                        style: TextStyle(fontSize: 18)));
              }
            },
          ),
        ),
      ),
    );
  }
}
