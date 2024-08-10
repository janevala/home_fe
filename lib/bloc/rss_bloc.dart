import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:homefe/api/api_repository.dart';
import 'package:homefe/podo/rss/rss_json_feed.dart';
import 'package:homefe/podo/rss/rss_sites.dart';
import 'package:webfeed/webfeed.dart';

abstract class RssState {}

class RssSitesEvent extends RssState {}

class RssFeedEvent extends RssState {
  final Uri url;

  RssFeedEvent(this.url);
}

class RssArchiveEvent extends RssState {}

class RssInitial extends RssState {}

class RssLoading extends RssState {}

class RssSitesSuccess extends RssState {
  final RssSites rssSites;

  RssSitesSuccess(this.rssSites);
}

class RssFeedSuccess extends RssState {
  final RssFeed rssFeed;

  RssFeedSuccess(this.rssFeed);
}

class RssArchiveSuccess extends RssState {
  final List<RssJsonFeed> rssArchiveFeed;

  RssArchiveSuccess(this.rssArchiveFeed);
}

class RssFailure extends RssState {
  final String error;

  RssFailure(this.error);
}

class RssSitesBloc extends Bloc<RssSitesEvent, RssState> {
  final ApiRepository repo = ApiRepository();

  RssSitesBloc() : super(RssInitial()) {
    on<RssSitesEvent>((event, emit) async {
      emit(RssLoading());

      RssSites rssSite = await repo.getSites();
      if (rssSite.error.isNotEmpty) {
        emit(RssFailure(rssSite.error));
      } else {
        emit(RssSitesSuccess(rssSite));
      }
    });
  }
}

class RssArchiveBloc extends Bloc<RssArchiveEvent, RssState> {
  final ApiRepository repo = ApiRepository();

  RssArchiveBloc() : super(RssInitial()) {
    on<RssArchiveEvent>((event, emit) async {
      emit(RssLoading());

      List<RssJsonFeed> archiveFeed = await repo.getArchive();
      if (archiveFeed.isEmpty) {
        emit(RssFailure('Cannot get RSS archive feed'));
      } else {
        emit(RssArchiveSuccess(archiveFeed));
      }
    });
  }
}

class RssFeedBloc extends Bloc<RssFeedEvent, RssState> {
  final ApiRepository repo = ApiRepository();

  RssFeedBloc() : super(RssInitial()) {
    on<RssFeedEvent>((event, emit) async {
      emit(RssLoading());

      RssFeed? rssFeed = await repo.getRss(event.url);
      if (rssFeed == null) {
        emit(RssFailure('Cannot get RSS feed'));
      } else {
        emit(RssFeedSuccess(rssFeed));
      }
    });
  }
}
