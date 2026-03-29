import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:homefe/bloc/rss_bloc.dart';
import 'package:homefe/logger/logger.dart';
import 'package:homefe/callback_shortcuts.dart';
import 'package:homefe/ui_landscape/list_tile.dart';

class ArticleScreen extends StatefulWidget {
  final int id;

  const ArticleScreen({super.key, required this.id});

  @override
  ArticleScreenState createState() => ArticleScreenState();
}

class ArticleScreenState extends State<ArticleScreen> with TickerProviderStateMixin {
  final _scrollContoller = ScrollController();

  @override
  void initState() {
    super.initState();

    _scrollContoller.addListener(_onScroll);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final locale = Localizations.localeOf(context);
      final language = locale.languageCode;
      context.read<RssArchiveBloc>().add(ArticleEvent(id: widget.id, language: language));
    });
  }

  @override
  void dispose() {
    _scrollContoller.removeListener(_onScroll);
    _scrollContoller.dispose();

    super.dispose();
  }

  void _onScroll() {
    if (_scrollContoller.position.pixels >= (_scrollContoller.position.maxScrollExtent)) {
      logger.d('Reached end of scroll');
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return BlocBuilder<RssArchiveBloc, RssState>(
      builder: (context, state) {
        if (state is ArchiveLoad) {
          final item = state.items.firstWhere((item) => item.id == widget.id);
          return Scaffold(
            appBar: AppBar(
              title: Text(item.source ?? item.title),
              leading: BackButton(
                onPressed: () {
                  GoRouter.of(context).go('/articles');
                },
              ),
            ),
            body: SafeArea(
              child: CallbackShortcuts(
                bindings: getCallbackShortcuts(_scrollContoller),
                child: Center(
                  child: SizedBox(
                    width: width * 0.6,
                    child: SingleChildScrollView(
                      controller: _scrollContoller,
                      child: JsonFeedTile(
                        key: Key(item.link),
                        onItemTap: () {},
                        item: item,
                        locale: Localizations.localeOf(context),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        } else if (state is ArchiveLoad) {
          return Scaffold(
            body: Center(
              child: Text('Loading...'),
            ),
          );
        } else {
          return Scaffold(
            body: Center(
              child: Text('Not found'),
            ),
          );
        }
      },
    );
  }
}
