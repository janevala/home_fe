import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:homefe/bloc/rss_bloc.dart';
import 'package:homefe/functions.dart';
import 'package:homefe/podo/rss/news_item.dart';
import 'package:homefe/podo/rss/rss_site.dart';
import 'package:homefe/ui/callback_shortcuts.dart';
import 'package:homefe/ui/list_tile.dart';
import 'package:homefe/ui/spinner.dart';
import 'package:rss_dart/domain/rss_item.dart';

class FeedScreen extends StatefulWidget {
  final RssSite rssSite;

  const FeedScreen({super.key, required this.rssSite});

  @override
  FeedScreenState createState() => FeedScreenState();
}

class FeedScreenState extends State<FeedScreen> {
  final controller = ScrollController();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
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
            context.go('/sites');
          },
        ),
      ),
      body: SafeArea(
        child: BlocProvider<RssFeedBloc>(
          create: (context) => RssFeedBloc(),
          child: BlocBuilder<RssFeedBloc, RssState>(
            builder: (context, state) {
              if (state is Loading) {
                return const Spinner();
              } else if (state is Initial) {
                context.read<RssFeedBloc>().add(
                  RssFeedEvent(Uri.parse(widget.rssSite.url)),
                );

                return const Spinner();
              } else if (state is RssFeedSuccess &&
                  state.rssFeed.items.isNotEmpty) {
                return CallbackShortcuts(
                  bindings: getCallbackShortcuts(controller),
                  child: Focus(
                    autofocus: true,
                    child: ListView.builder(
                      controller: controller,
                      itemCount: state.rssFeed.items.length,
                      itemBuilder: (BuildContext context, int index) {
                        RssItem item = state.rssFeed.items[index];

                        return RssFeedTile(
                          openItem: () => openItem(
                            context,
                            NewsItem(
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
                      },
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
