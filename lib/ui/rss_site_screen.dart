import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:homefe/bloc/rss_bloc.dart';
import 'package:homefe/functions.dart';
import 'package:homefe/podo/rss/rss_json_feed.dart';
import 'package:homefe/podo/rss/rss_site.dart';
import 'package:homefe/ui/list_tile.dart';
import 'package:homefe/ui/spinner.dart';
import 'package:intl/intl.dart';
import 'package:webfeed/webfeed.dart';

class RssSiteScreen extends StatefulWidget {
  final RssSite rssSite;

  const RssSiteScreen({Key? key, required this.rssSite}) : super(key: key);

  @override
  RssSiteScreenState createState() => RssSiteScreenState();
}

class RssSiteScreenState extends State<RssSiteScreen> {
  final RssFeedBloc rssFeedBloc = RssFeedBloc();

  String itemPubDate(DateTime dateTime) {
    return DateFormat('d.M. HH:mm').format(dateTime);
  }

  @override
  void initState() {
    super.initState();

    rssFeedBloc.add(RssFeedEvent(Uri.parse(widget.rssSite.url)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.blueGrey,
          foregroundColor: Colors.white,
          iconTheme: const IconThemeData(color: Colors.white),
          title: Text(widget.rssSite.title),
          leading: BackButton(
            onPressed: () {
              context.goNamed('rss_sites');
            },
          )),
      body: BlocProvider<RssFeedBloc>(
        create: (context) => rssFeedBloc,
        child: BlocBuilder<RssFeedBloc, RssState>(
          builder: (context, feedState) {
            if (feedState is RssLoading) {
              return const Spinner();
            } else if (feedState is RssFeedSuccess) {
              return SafeArea(
                child: ListView.builder(
                    itemCount: feedState.rssFeed.items!.length,
                    itemBuilder: (BuildContext context, int index) {
                      RssItem item = feedState.rssFeed.items![index];
                      return RssFeedTile(
                        openItem: () => openItem(
                          context,
                          RssJsonFeed(
                            item.title!,
                            item.description!,
                            item.link!,
                            item.pubDate.toString(),
                            item.pubDate.toString(),
                          ),
                        ),
                        index: index,
                        item: item,
                        site: widget.rssSite,
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
