import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:homefe/bloc/rss_bloc.dart';
import 'package:homefe/functions.dart';
import 'package:homefe/podo/rss/news_item.dart';
import 'package:homefe/ui/list_tile.dart';
import 'package:homefe/ui/spinner.dart';

class ArchiveScreen extends StatefulWidget {
  const ArchiveScreen({super.key});

  @override
  ArchiveScreenState createState() => ArchiveScreenState();
}

class ArchiveScreenState extends State<ArchiveScreen> {
  final RssArchiveBloc rssAggregateBloc = RssArchiveBloc();

  @override
  void initState() {
    super.initState();

    rssAggregateBloc.add(RssArchiveEvent());
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.blueGrey,
          foregroundColor: Colors.white,
          iconTheme: const IconThemeData(color: Colors.white),
          title: const Text('Archive'),
          leading: BackButton(
            onPressed: () {
              context.goNamed('dashboard');
            },
          )),
      body: SafeArea(
        child: BlocProvider<RssArchiveBloc>(
          create: (context) => rssAggregateBloc,
          child: BlocBuilder<RssArchiveBloc, RssState>(
            builder: (context, feedState) {
              if (feedState is Loading) {
                return const Spinner();
              } else if (feedState is RssArchiveSuccess) {
                return Center(
                  child: SizedBox(
                    width: width * 0.9,
                    child: Padding(
                      padding: const EdgeInsets.all(32),
                      child: ListView.builder(
                          itemCount: feedState.rssArchiveFeed.items.length,
                          itemBuilder: (BuildContext context, int index) {
                            NewsItem item =
                                feedState.rssArchiveFeed.items[index];

                            return JsonFeedTile(
                              key: Key(item.link),
                              openItem: () => openItem(context, item),
                              explainItem: () => explainItem(context, item),
                              index: index,
                              item: item,
                            );
                          }),
                    ),
                  ),
                );
              } else if (feedState is Failure) {
                return Center(
                    child: Text(feedState.error,
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
