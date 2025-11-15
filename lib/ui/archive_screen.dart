import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:homefe/bloc/rss_bloc.dart';
import 'package:homefe/functions.dart';
import 'package:homefe/podo/rss/news_item.dart';
import 'package:homefe/ui/callback_shortcuts.dart';
import 'package:homefe/ui/list_tile.dart';
import 'package:homefe/ui/spinner.dart';

class ArchiveScreen extends StatefulWidget {
  const ArchiveScreen({super.key});

  @override
  ArchiveScreenState createState() => ArchiveScreenState();
}

class ArchiveScreenState extends State<ArchiveScreen> {
  final controller = ScrollController();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    void onScroll() {
      if (controller.position.pixels >= (controller.position.maxScrollExtent)) {
        context.read<RssArchiveBloc>().add(LoadMoreArchive());
      }
    }

    controller.addListener(onScroll);

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
              } else if (state is Initial) {
                context.read<RssArchiveBloc>().add(LoadMoreArchive());

                return const Spinner();
              } else if (state is RssArchiveLoadingMore) {
                return _buildList(
                  context,
                  state.items,
                  controller,
                  isLoadingMore: true,
                );
              } else if (state is RssArchiveSuccess) {
                return _buildList(context, state.rssArchiveFeed, controller);
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

  Widget _buildList(
    BuildContext context,
    List<NewsItem> items,
    ScrollController contoller, {
    bool isLoadingMore = false,
  }) {
    return CallbackShortcuts(
      bindings: getCallbackShortcuts(contoller),
      child: Focus(
        autofocus: true,
        child: ListView.builder(
          controller: contoller,
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
    );
  }
}
