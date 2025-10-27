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
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    final scrollController = ScrollController();

    // Load more items when user scrolls to the bottom
    void onScroll() {
      if (scrollController.position.pixels >=
          (scrollController.position.maxScrollExtent)) {
        context.read<RssArchiveBloc>().add(LoadMoreArchive());
      }
    }

    // Add scroll listener
    scrollController.addListener(onScroll);

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
        ),
      ),
      body: SafeArea(
        child: BlocProvider<RssArchiveBloc>(
          create: (context) => context.read<RssArchiveBloc>(),
          child: BlocBuilder<RssArchiveBloc, RssState>(
            builder: (context, state) {
              if (state is Loading) {
                return const Spinner();
              } else if (state is RssInitial) {
                context.read<RssArchiveBloc>().add(LoadMoreArchive());

                return const Spinner();
              } else if (state is RssArchiveLoadingMore) {
                return _buildArchiveList(
                  context,
                  state.items,
                  width,
                  scrollController,
                  isLoadingMore: true,
                );
              } else if (state is RssArchiveSuccess) {
                return _buildArchiveList(
                  context,
                  state.rssArchiveFeed,
                  width,
                  scrollController,
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

  Widget _buildArchiveList(
    BuildContext context,
    List<NewsItem> items,
    double width,
    ScrollController? scrollController, {
    bool isLoadingMore = false,
  }) {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            controller: scrollController,
            itemCount: items.length + (isLoadingMore ? 1 : 0),
            itemBuilder: (BuildContext context, int index) {
              if (index >= items.length) {
                return const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Center(child: CircularProgressIndicator()),
                );
              }

              NewsItem item = items[index];
              return JsonFeedTile(
                key: Key(item.link),
                onItemTap: () => openItem(context, item),
                // onItemLongPress: () => explainItem(context, item),
                item: item,
              );
            },
          ),
        ),
      ],
    );
  }
}
