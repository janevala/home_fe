import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:homefe/bloc/rss_bloc.dart';
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
        backgroundColor: Colors.blueGrey,
        foregroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text('News sites'),
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
            } else if (state is RssSitesSuccess &&
                state.rssSites.sites.isNotEmpty) {
              return Center(
                child: SizedBox(
                  width: width * 0.8,
                  child: Padding(
                    padding: const EdgeInsets.all(32),
                    child: ListView.separated(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      itemCount: state.rssSites.sites.length,
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 12),
                      itemBuilder: (BuildContext context, int index) {
                        final site = state.rssSites.sites[index];

                        return Card(
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                            side: BorderSide(
                              color: Theme.of(
                                context,
                              ).colorScheme.outlineVariant,
                              width: 1,
                            ),
                          ),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(12),
                            onTap: () =>
                                GoRouter.of(context).go('/site', extra: site),
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    site.title,
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium
                                        ?.copyWith(fontWeight: FontWeight.w600),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    site.url,
                                    style: Theme.of(context).textTheme.bodySmall
                                        ?.copyWith(
                                          color: Theme.of(
                                            context,
                                          ).colorScheme.primary,
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
                child: Text(state.error, style: const TextStyle(fontSize: 18)),
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
    );
  }
}
