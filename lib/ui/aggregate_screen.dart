import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:homefe/bloc/rss_bloc.dart';
import 'package:homefe/functions.dart';
import 'package:homefe/podo/rss/rss_json_feed.dart';
import 'package:homefe/ui/list_tile.dart';
import 'package:homefe/ui/spinner.dart';

class AggregateScreen extends StatefulWidget {
  const AggregateScreen({super.key});

  @override
  AggregateScreenState createState() => AggregateScreenState();
}

class AggregateScreenState extends State<AggregateScreen> {
  final RssAggregateBloc rssAggregateBloc = RssAggregateBloc();

  @override
  void initState() {
    super.initState();

    rssAggregateBloc.add(RssAggregateEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.blueGrey,
          foregroundColor: Colors.white,
          iconTheme: const IconThemeData(color: Colors.white),
          title: const Text('Aggregate'),
          leading: BackButton(
            onPressed: () {
              context.goNamed('dashboard');
            },
          )),
      body: SafeArea(
        child: BlocProvider<RssAggregateBloc>(
          create: (context) => rssAggregateBloc,
          child: BlocBuilder<RssAggregateBloc, RssState>(
            builder: (context, feedState) {
              if (feedState is RssLoading) {
                return const Spinner();
              } else if (feedState is RssAggregateSuccess) {
                return ListView.builder(
                    itemCount: feedState.rssAggregateFeed.length,
                    itemBuilder: (BuildContext context, int index) {
                      RssJsonFeed item = feedState.rssAggregateFeed[index];

                      return JsonFeedTile(
                        openItem: () => openItem(context, item),
                        index: index,
                        item: item,
                      );
                    });
              } else if (feedState is RssFailure) {
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
