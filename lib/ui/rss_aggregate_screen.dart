import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:homefe/bloc/rss_bloc.dart';
import 'package:homefe/functions.dart';
import 'package:homefe/podo/rss/rss_json_feed.dart';
import 'package:homefe/ui/list_tile.dart';
import 'package:homefe/ui/spinner.dart';

class RssAggregateScreen extends StatefulWidget {
  const RssAggregateScreen({Key? key}) : super(key: key);

  @override
  RssAggregateScreenState createState() => RssAggregateScreenState();
}

class RssAggregateScreenState extends State<RssAggregateScreen> {
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
              context.goNamed('login');
            },
          )),
      body: BlocProvider<RssAggregateBloc>(
        create: (context) => rssAggregateBloc,
        child: BlocBuilder<RssAggregateBloc, RssState>(
          builder: (context, feedState) {
            if (feedState is RssLoading) {
              return const Spinner();
            } else if (feedState is RssAggregateSuccess) {
              return SafeArea(
                child: ListView.builder(
                    itemCount: feedState.rssAggregateFeed.length,
                    itemBuilder: (BuildContext context, int index) {
                      RssJsonFeed item = feedState.rssAggregateFeed[index];
                      return JsonFeedTile(
                        openItem: () => openItem(context, item),
                        index: index,
                        item: item,
                      );
                    }),
              );
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
    );
  }
}
