import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:homefe/assets/i18n/generated/app_localizations.dart';
import 'package:homefe/bloc/locale_cubit.dart';
// import 'package:homefe/assets/i18n/generated/app_localizations.dart';

class FlagSelection extends StatefulWidget {
  const FlagSelection({super.key, required this.welcomeMessage});

  final String welcomeMessage;

  @override
  State<FlagSelection> createState() => _FlagSelectionState();
}

class _FlagSelectionState extends State<FlagSelection> with TickerProviderStateMixin {
  late final Animation<double> _firstFadeIn;
  late final AnimationController _firstFadeController;

  double _containerWidth = 400;
  double _containerHeight = 70;
  double _flagSize = 80;

  @override
  void initState() {
    super.initState();

    if (defaultTargetPlatform == TargetPlatform.iOS || defaultTargetPlatform == TargetPlatform.android) {
      _containerWidth = 200;
      _containerHeight = 50;
      _flagSize = 50;
    }

    _firstFadeController = AnimationController(vsync: this, duration: Duration(milliseconds: 1500));

    _firstFadeIn = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _firstFadeController,
        curve: Curves.easeIn,
      ),
    );

    _showFlags();
  }

  void _showFlags() {
    _firstFadeController.forward().then((_) {
      _resetAndStop();
    });
  }

  void _resetAndStop() {}

  @override
  void dispose() {
    _firstFadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: _containerWidth,
      height: _containerHeight,
      child: Center(
        child: _buildFlagBattery(),
      ),
    );
  }

  Widget _buildFlagBattery() {
    return Center(
      child: AnimatedBuilder(
        animation: _firstFadeIn,
        builder: (context, child) => Opacity(
          opacity: _firstFadeIn.value,
          child: child,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              widget.welcomeMessage,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Tooltip(
                  message: AppLocalizations.of(context)!.localeEnTranslated,
                  child: InkWell(
                    onTap: () {
                      context.read<LocaleCubit>().changeLocaleTo(Locale('en'));
                    },
                    child: SvgPicture.asset(
                      'assets/flags/flag-en.svg',
                      key: ValueKey('en'),
                      width: _flagSize,
                      height: _flagSize,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Tooltip(
                  message: AppLocalizations.of(context)!.localeThTranslated,
                  child: InkWell(
                    onTap: () {
                      context.read<LocaleCubit>().changeLocaleTo(Locale('th'));
                    },
                    child: SvgPicture.asset(
                      'assets/flags/flag-th.svg',
                      key: ValueKey('th'),
                      width: _flagSize,
                      height: _flagSize,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Tooltip(
                  message: AppLocalizations.of(context)!.localeFiTranslated,
                  child: InkWell(
                    onTap: () {
                      context.read<LocaleCubit>().changeLocaleTo(Locale('fi'));
                    },
                    child: SvgPicture.asset(
                      'assets/flags/flag-fi.svg',
                      key: ValueKey('fi'),
                      width: _flagSize,
                      height: _flagSize,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Tooltip(
                  message: AppLocalizations.of(context)!.localeDeTranslated,
                  child: InkWell(
                    onTap: () {
                      context.read<LocaleCubit>().changeLocaleTo(Locale('de'));
                    },
                    child: SvgPicture.asset(
                      'assets/flags/flag-de.svg',
                      key: ValueKey('de'),
                      width: _flagSize,
                      height: _flagSize,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
