import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:homefe/assets/i18n/generated/app_localizations.dart';
import 'package:homefe/bloc/rss_bloc.dart';
import 'package:homefe/functions.dart';
import 'package:homefe/podo/rss/news_item.dart';
import 'package:homefe/callback_shortcuts.dart';
import 'package:homefe/ui/spinner.dart';
import 'package:homefe/ui_landscape/list_tile.dart';

class ArchiveScreen extends StatefulWidget {
  const ArchiveScreen({super.key});

  @override
  ArchiveScreenState createState() => ArchiveScreenState();
}

class ArchiveScreenState extends State<ArchiveScreen> with TickerProviderStateMixin {
  final _scrollContoller = ScrollController();
  final _searchController = TextEditingController();

  bool _isSearchBarVisible = true;
  late AnimationController _animationController;
  late Animation<double> _slideAnimation;

  @override
  void initState() {
    super.initState();

    _scrollContoller.addListener(_onScroll);

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _slideAnimation =
        Tween<double>(
          begin: 0.0,
          end: -100.0,
        ).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: Curves.easeInOut,
          ),
        );

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
    _animationController.dispose();

    super.dispose();
  }

  void _onScroll() {
    if (_scrollContoller.position.pixels >= (_scrollContoller.position.maxScrollExtent)) {
      final locale = Localizations.localeOf(context);
      final language = locale.languageCode;
      context.read<RssArchiveBloc>().add(LoadMoreArchive(language: language));
    }

    if (_scrollContoller.position.userScrollDirection == ScrollDirection.reverse) {
      if (_isSearchBarVisible) {
        setState(() {
          _isSearchBarVisible = false;
        });
        _animationController.forward();
      }
    } else if (_scrollContoller.position.userScrollDirection == ScrollDirection.forward) {
      if (!_isSearchBarVisible) {
        setState(() {
          _isSearchBarVisible = true;
        });
        _animationController.reverse();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.title),
        leading: BackButton(
          onPressed: () {
            GoRouter.of(context).go('/dashboard');
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
                child: Center(
                  child: SizedBox(
                    width: width,
                    child: Stack(
                      children: [
                        CustomScrollView(
                          controller: _scrollContoller,
                          slivers: [
                            SliverToBoxAdapter(
                              child: SizedBox(height: 48),
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
                        Positioned(
                          top: 0,
                          left: 0,
                          right: 0,
                          child: AnimatedBuilder(
                            animation: _slideAnimation,
                            builder: (context, child) {
                              return Transform.translate(
                                offset: Offset(0, _slideAnimation.value),
                                child: Container(
                                  padding: Theme.of(context).inputDecorationTheme.contentPadding,
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).scaffoldBackgroundColor,
                                  ),
                                  child: TextField(
                                    controller: _searchController,
                                    decoration: InputDecoration(
                                      filled: true,
                                      fillColor: Theme.of(context).scaffoldBackgroundColor,
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
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
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
