import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:homefe/bloc/rss_bloc.dart';
import 'package:homefe/functions.dart';
import 'package:homefe/podo/rss/news_item.dart';
import 'package:homefe/podo/rss/rss_site.dart';
import 'package:homefe/ui/list_tile.dart';
import 'package:homefe/ui/spinner.dart';
import 'package:webfeed/webfeed.dart';

class FeedScreen extends StatefulWidget {
  final RssSite rssSite;

  const FeedScreen({super.key, required this.rssSite});

  @override
  FeedScreenState createState() => FeedScreenState();
}

class FeedScreenState extends State<FeedScreen> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<RssFeedBloc>().add(
          RssFeedEvent(Uri.parse(widget.rssSite.url)),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        foregroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(widget.rssSite.title),
        leading: BackButton(
          onPressed: () {
            context.goNamed('sites');
          },
        ),
      ),
      body: SafeArea(
        child: BlocProvider<RssFeedBloc>(
          create: (context) => context.read<RssFeedBloc>(),
          child: BlocBuilder<RssFeedBloc, RssState>(
            builder: (context, state) {
              if (state is Loading || state is Initial) {
                return const Spinner();
              } else if (state is RssFeedSuccess) {
                return Center(
                  child: SizedBox(
                    width: width * 0.9,
                    child: Padding(
                      padding: const EdgeInsets.all(32),
                      child: ListView.builder(
                        itemCount: state.rssFeed.items!.length,
                        itemBuilder: (BuildContext context, int index) {
                          RssItem item = state.rssFeed.items![index];

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
