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

  @override
  void initState() {
    super.initState();
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

  void _resetAndStop() {
    // _firstFadeController.reset();
  }

  @override
  void dispose() {
    _firstFadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (defaultTargetPlatform == TargetPlatform.iOS || defaultTargetPlatform == TargetPlatform.android) {
      return SizedBox(
        width: 200,
        height: 50,
        child: Center(
          child: _buildFlagBattery(),
        ),
      );
    } else {
      return SizedBox(
        width: 400,
        height: 150,
        child: Center(
          child: _buildFlagBattery(),
        ),
      );
    }
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
              style: Theme.of(context).textTheme.bodyLarge,
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
                      width: 80,
                      height: 80,
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
                      width: 80,
                      height: 80,
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
                      width: 80,
                      height: 80,
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
                      width: 80,
                      height: 80,
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
