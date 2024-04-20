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

class RssAggregateEvent extends RssState {}

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

class RssAggregateSuccess extends RssState {
  final List<RssJsonFeed> rssAggregateFeed;

  RssAggregateSuccess(this.rssAggregateFeed);
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

      RssSites rssSite = await repo.getRssSites();
      if (rssSite.error.isNotEmpty) {
        emit(RssFailure(rssSite.error));
      } else {
        emit(RssSitesSuccess(rssSite));
      }
    });
  }
}

class RssAggregateBloc extends Bloc<RssAggregateEvent, RssState> {
  final ApiRepository repo = ApiRepository();

  RssAggregateBloc() : super(RssInitial()) {
    on<RssAggregateEvent>((event, emit) async {
      emit(RssLoading());

      List<RssJsonFeed> aggregateFeed = await repo.getRssAggregateFeed();
      if (aggregateFeed.isEmpty) {
        emit(RssFailure('Cannot get RSS aggregate feed'));
      } else {
        emit(RssAggregateSuccess(aggregateFeed));
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
