import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:homefe/bloc/rss_bloc.dart';
import 'package:homefe/functions.dart';
import 'package:homefe/podo/rss/news_item.dart';
import 'package:homefe/ui/list_tile.dart';
import 'package:homefe/ui/spinner.dart';
// import 'package:two_dimensional_scrollables/two_dimensional_scrollables.dart';

class TreeScreen extends StatefulWidget {
  const TreeScreen({super.key});

  @override
  TreeScreenState createState() => TreeScreenState();
}

class TreeScreenState extends State<TreeScreen> {
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<RssArchiveBloc>().add(ResetArchive());
      context.read<RssArchiveBloc>().add(LoadMoreArchive());
    });
  }

  @override
  void dispose() {
    _searchController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
                  return _buildTree(context, state.items);
                } else if (state is ArchiveLoadMore) {
                  return _buildTree(context, state.items, isLoadingMore: true);
                } else if (state is SearchLoad) {
                  return _buildSearchTree(context, state.items);
                } else if (state is Failure) {
                  return Flexible(
                    child: Center(
                      child: Text(
                        state.error,
                        style: const TextStyle(fontSize: 18),
                      ),
                    ),
                  );
                } else if (state is AnswerSuccess) {
                  return Flexible(
                    child: Center(
                      child: Text(
                        state.answer,
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

  Widget _buildTree(
    BuildContext context,
    List<NewsItem> items, {
    bool isLoadingMore = false,
  }) {
    return Flexible(
      child: Focus(
        autofocus: true,
        child: ListView.builder(
          itemCount: items.length + (isLoadingMore ? 1 : 0),
          itemBuilder: (BuildContext context, int index) {
            if (index >= items.length) {
              return Center(child: CircularProgressIndicator());
            }

            NewsItem item = items[index];
            return JsonFeedTile(
              key: Key(item.link),
              onItemTap: () => openItem(context, item),
              onItemLongPress: () {
                context.read<RssArchiveBloc>().add(
                  QuestionEvent('translate to spanish: ${item.title}'),
                );
              },
              item: item,
            );
          },
        ),
      ),
    );
  }

  Widget _buildSearchTree(BuildContext context, List<NewsItem> items) {
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
