import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:homefe/assets/i18n/generated/app_localizations.dart';
import 'package:homefe/bloc/rss_bloc.dart';
import 'package:homefe/theme/theme.dart';
import 'package:homefe/ui/spinner.dart';

class SitesScreen extends StatefulWidget {
  const SitesScreen({super.key});

  @override
  SitesScreenState createState() => SitesScreenState();
}

class SitesScreenState extends State<SitesScreen> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

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
        child: BlocBuilder<RssSitesBloc, RssState>(
          builder: (context, state) {
            if (state is Loading) {
              return const Spinner();
            } else if (state is RssSitesSuccess && state.rssSites.sites.isNotEmpty) {
              return Center(
                child: SizedBox(
                  width: width * 0.8,
                  child: Padding(
                    padding: const EdgeInsets.all(32),
                    child: ListView.separated(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      itemCount: state.rssSites.sites.length,
                      separatorBuilder: (context, index) => const SizedBox(height: 12),
                      itemBuilder: (BuildContext context, int index) {
                        final site = state.rssSites.sites[index];

                        return Card(
                          child: InkWell(
                            borderRadius: BorderRadius.circular(Radi.medium),
                            onTap: () => GoRouter.of(context).go('/site', extra: site),
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    site.title,
                                    style: Theme.of(
                                      context,
                                    ).textTheme.titleLarge,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    site.url,
                                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                      decoration: TextDecoration.underline,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              );
            } else if (state is Failure) {
              return Center(
                child: Text(
                  state.error,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              );
            } else {
              return Center(
                child: Text(
                  AppLocalizations.of(context)!.generalError,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
