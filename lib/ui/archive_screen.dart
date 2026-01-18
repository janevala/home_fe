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
  final scrollContoller = ScrollController();
  final searchController = TextEditingController();

  @override
  void dispose() {
    scrollContoller.dispose();
    searchController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    void onScroll() {
      if (scrollContoller.position.pixels >=
          (scrollContoller.position.maxScrollExtent)) {
        context.read<RssArchiveBloc>().add(LoadMoreArchive());
      }
    }

    scrollContoller.addListener(onScroll);

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
          child: Column(
            children: [
              TextField(
                controller: searchController,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.search),
                  suffixIcon: IconButton(
                    icon: Icon(Icons.clear),
                    onPressed: () {
                      searchController.clear();
                      context.read<RssArchiveBloc>().add(LoadMoreArchive());
                    },
                  ),
                  hintText: 'Search archive...',
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey, width: 2),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                onChanged: (value) {
                  if (value.length < 3) {
                    return;
                  }

                  context.read<RssArchiveBloc>().add(
                    SearchArchive(query: value.trim()),
                  );
                },
              ),
              BlocBuilder<RssArchiveBloc, RssState>(
                builder: (context, state) {
                  if (state is Loading) {
                    return Flexible(child: Center(child: const Spinner()));
                  } else if (state is Initial) {
                    context.read<RssArchiveBloc>().add(LoadMoreArchive());

                    return Flexible(child: Center(child: const Spinner()));
                  } else if (state is ArchiveLoad) {
                    return _buildList(context, state.items, scrollContoller);
                  } else if (state is ArchiveLoadMore) {
                    return _buildList(
                      context,
                      state.items,
                      scrollContoller,
                      isLoadingMore: true,
                    );
                  } else if (state is SearchLoad) {
                    return _buildList(
                      context,
                      state.items,
                      scrollContoller,
                      animate: true,
                    );
                  } else if (state is Failure) {
                    return Flexible(
                      child: Center(
                        child: Text(
                          state.error,
                          style: const TextStyle(fontSize: 18),
                        ),
                      ),
                    );
                  } else {
                    return Flexible(
                      child: const Center(
                        child: Text(
                          'Something went wrong',
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildList(
    BuildContext context,
    List<NewsItem> items,
    ScrollController scroll, {
    bool isLoadingMore = false,
    bool animate = false,
  }) {
    return animate
        ? Flexible(
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 5000),
              opacity: 1.0,
              child: CallbackShortcuts(
                bindings: getCallbackShortcuts(scroll),
                child: Focus(
                  autofocus: true,
                  child: ListView.builder(
                    controller: scroll,
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
                        item: item,
                      );
                    },
                  ),
                ),
              ),
            ),
          )
        : Flexible(
            child: CallbackShortcuts(
              bindings: getCallbackShortcuts(scroll),
              child: Focus(
                autofocus: true,
                child: ListView.builder(
                  controller: scroll,
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
                      item: item,
                    );
                  },
                ),
              ),
            ),
          );
  }
}
