import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:homefe/assets/i18n/generated/app_localizations.dart';
import 'package:homefe/bloc/rss_bloc.dart';
import 'package:homefe/functions.dart';
import 'package:homefe/podo/rss/news_item.dart';
import 'package:homefe/callback_shortcuts.dart';
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
  bool _isSearchVisible = true;

  @override
  void initState() {
    super.initState();

    _scrollContoller.addListener(_onScroll);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<RssArchiveBloc>().add(ResetArchive());
      final locale = Localizations.localeOf(context);
      final language = locale.languageCode;
      context.read<RssArchiveBloc>().add(LoadMoreArchive(language: language));
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
    if (_scrollContoller.position.pixels >= (_scrollContoller.position.maxScrollExtent)) {
      final locale = Localizations.localeOf(context);
      final language = locale.languageCode;
      context.read<RssArchiveBloc>().add(LoadMoreArchive(language: language));
    }

    if (_scrollContoller.position.userScrollDirection == ScrollDirection.reverse) {
      if (_isSearchVisible) {
        setState(() {
          _isSearchVisible = !_isSearchVisible;
        });
      }
    } else if (_scrollContoller.position.userScrollDirection == ScrollDirection.forward) {
      if (!_isSearchVisible) {
        setState(() {
          _isSearchVisible = !_isSearchVisible;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.title),
        leading: BackButton(
          onPressed: () {
            context.pop();
          },
        ),
      ),
      body: SafeArea(
        child: BlocBuilder<RssArchiveBloc, RssState>(
          builder: (context, state) {
            return CallbackShortcuts(
              bindings: getCallbackShortcuts(_scrollContoller),
              child: Focus(
                autofocus: true,
                child: CustomScrollView(
                  controller: _scrollContoller,
                  slivers: [
                    SliverAnimatedOpacity(
                      opacity: _isSearchVisible ? 1.0 : 0.0,
                      duration: const Duration(milliseconds: 250),
                      sliver: SliverToBoxAdapter(
                        child: TextField(
                          controller: _searchController,
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.search),
                            suffixIcon: IconButton(
                              icon: Icon(Icons.clear),
                              onPressed: () {
                                _searchController.clear();
                                context.read<RssArchiveBloc>().add(ResetArchive());
                                final locale = Localizations.localeOf(context);
                                final language = locale.languageCode;
                                context.read<RssArchiveBloc>().add(LoadMoreArchive(language: language));
                              },
                            ),
                            hintText: AppLocalizations.of(context)!.searchArchive,
                            border: Theme.of(context).inputDecorationTheme.border,
                          ),
                          onChanged: (value) {
                            final locale = Localizations.localeOf(context);
                            final language = locale.languageCode;

                            if (value.isEmpty) {
                              context.read<RssArchiveBloc>().add(LoadMoreArchive(language: language));
                            } else {
                              context.read<RssArchiveBloc>().add(
                                SearchArchive(query: _searchController.text, language: language),
                              );
                            }
                          },
                        ),
                      ),
                    ),
                    if (state is Loading)
                      SliverFillRemaining(
                        child: Center(child: const Spinner()),
                      )
                    else if (state is ArchiveLoad)
                      _buildSliverList(context, state.items, isLoadingMore: false)
                    else if (state is ArchiveLoadMore)
                      _buildSliverList(context, state.items, isLoadingMore: true)
                    else if (state is SearchLoad)
                      _buildSearchSliverList(context, state.items)
                    else if (state is Failure)
                      SliverFillRemaining(
                        child: Center(
                          child: Text(
                            state.error,
                            style: const TextStyle(fontSize: 18),
                          ),
                        ),
                      )
                    else if (state is AnswerSuccess)
                      SliverFillRemaining(
                        child: Center(
                          child: Text(
                            state.answer,
                            style: const TextStyle(fontSize: 18),
                          ),
                        ),
                      )
                    else
                      SliverFillRemaining(
                        child: Center(
                          child: Text(
                            AppLocalizations.of(context)!.generalError,
                            style: const TextStyle(fontSize: 18),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  SliverList _buildSliverList(
    BuildContext context,
    List<NewsItem> items, {
    bool isLoadingMore = false,
  }) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, int index) {
          if (index >= items.length) {
            return Center(child: CircularProgressIndicator());
          }

          NewsItem item = items[index];
          Locale locale = Localizations.localeOf(context);
          if (locale.countryCode == "pt") {
            locale = Locale('pt_BR');
          }
          return JsonFeedTile(
            key: Key(item.link),
            onItemTap: () => openItem(context, item),
            item: item,
            locale: locale,
          );
        },
        childCount: items.length + (isLoadingMore ? 1 : 0),
      ),
    );
  }

  SliverList _buildSearchSliverList(BuildContext context, List<NewsItem> items) {
    Locale locale = Localizations.localeOf(context);
    if (locale.countryCode == "pt") {
      locale = Locale('pt_BR');
    }

    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, int index) {
          NewsItem item = items[index];
          return JsonFeedTile(
            key: Key(item.link),
            onItemTap: () => openItem(context, item),
            item: item,
            locale: locale,
          );
        },
        childCount: items.length,
      ),
    );
  }
}
