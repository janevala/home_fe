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
  final _scrollContoller = ScrollController();
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();

    _scrollContoller.addListener(_onScroll);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<RssArchiveBloc>().add(ResetArchive());
      context.read<RssArchiveBloc>().add(LoadMoreArchive());
    });
  }

  @override
  void dispose() {
    _scrollContoller.removeListener(_onScroll);
    _scrollContoller.dispose();
    _searchController.dispose();

    super.dispose();
  }

  void _onScroll() {
    if (_scrollContoller.position.pixels >=
        (_scrollContoller.position.maxScrollExtent)) {
      context.read<RssArchiveBloc>().add(LoadMoreArchive());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        foregroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text('News archive'),
        leading: BackButton(
          onPressed: () {
            context.pop();
          },
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.search),
                suffixIcon: IconButton(
                  icon: Icon(Icons.clear),
                  onPressed: () {
                    _searchController.clear();
                    context.read<RssArchiveBloc>().add(ResetArchive());
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
                if (value.isEmpty) {
                  context.read<RssArchiveBloc>().add(LoadMoreArchive());
                } else {
                  context.read<RssArchiveBloc>().add(
                    SearchArchive(query: _searchController.text),
                  );
                }
              },
            ),
            BlocBuilder<RssArchiveBloc, RssState>(
              builder: (context, state) {
                if (state is Loading) {
                  return Flexible(child: Center(child: const Spinner()));
                } else if (state is ArchiveLoad) {
                  return _buildArchiveList(
                    context,
                    state.items,
                    _scrollContoller,
                  );
                } else if (state is ArchiveLoadMore) {
                  return _buildArchiveList(
                    context,
                    state.items,
                    _scrollContoller,
                    isLoadingMore: true,
                  );
                } else if (state is SearchLoad) {
                  return _buildSearchList(context, state.items);
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
    );
  }

  Widget _buildArchiveList(
    BuildContext context,
    List<NewsItem> items,
    ScrollController scroll, {
    bool isLoadingMore = false,
  }) {
    return Flexible(
      child: CallbackShortcuts(
        bindings: getCallbackShortcuts(scroll),
        child: Focus(
          autofocus: true,
          child: ListView.builder(
            controller: scroll,
            itemCount: items.length + (isLoadingMore ? 1 : 0),
            itemBuilder: (BuildContext context, int index) {
              if (index >= items.length) {
                return Center(child: CircularProgressIndicator());
              }

              NewsItem item = items[index];
              return JsonFeedTile(
                key: Key(item.link),
                onItemTap: () {
                  String question =
                      'Translate the following text to English:\n\n${item.title}\n\n${parseDescription(item, false)}';
                  context.read<RssFeedBloc>().add(QuestionEvent(question));
                },
                // onItemTap: () => openItem(context, item),
                onItemLongPress: () {},
                item: item,
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildSearchList(BuildContext context, List<NewsItem> items) {
    return Flexible(
      child: Focus(
        autofocus: true,
        child: ListView.builder(
          itemCount: items.length,
          itemBuilder: (BuildContext context, int index) {
            NewsItem item = items[index];
            return JsonFeedTile(
              key: Key(item.link),
              onItemTap: () => openItem(context, item),
              item: item,
            );
          },
        ),
      ),
    );
  }
}
