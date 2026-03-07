import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:homefe/assets/i18n/generated/app_localizations.dart';
import 'package:homefe/bloc/locale_cubit.dart';

class AnimatedFlags extends StatefulWidget {
  const AnimatedFlags({super.key, required this.welcomeMessage});

  final String welcomeMessage;

  @override
  State<AnimatedFlags> createState() => _AnimatedFlagsState();
}

class _AnimatedFlagsState extends State<AnimatedFlags> with TickerProviderStateMixin {
  late final Animation<double> _firstFadeIn;
  late final AnimationController _fadeController;

  @override
  void initState() {
    super.initState();

    _fadeController = AnimationController(vsync: this, duration: Duration(milliseconds: 1500));

    _firstFadeIn = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _fadeController,
        curve: Curves.easeIn,
      ),
    );

    _showFlags();
  }

  void _showFlags() {
    _fadeController.forward().then((_) {
      _resetAndStop();
    });
  }

  void _resetAndStop() {}

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (defaultTargetPlatform == TargetPlatform.iOS || defaultTargetPlatform == TargetPlatform.android) {
      return SizedBox(
        height: 100,
        child: Center(
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
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                const SizedBox(height: 32),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: () {
                        context.read<LocaleCubit>().changeLocaleTo(Locale('en'));
                      },
                      child: SvgPicture.asset(
                        'assets/flags/flag-en.svg',
                        key: ValueKey('en'),
                        width: 50,
                        height: 50,
                      ),
                    ),
                    const SizedBox(width: 16),
                    InkWell(
                      onTap: () {
                        context.read<LocaleCubit>().changeLocaleTo(Locale('th'));
                      },
                      child: SvgPicture.asset(
                        'assets/flags/flag-th.svg',
                        key: ValueKey('th'),
                        width: 50,
                        height: 50,
                      ),
                    ),
                    const SizedBox(width: 16),
                    InkWell(
                      onTap: () {
                        context.read<LocaleCubit>().changeLocaleTo(Locale('fi'));
                      },
                      child: SvgPicture.asset(
                        'assets/flags/flag-fi.svg',
                        key: ValueKey('fi'),
                        width: 50,
                        height: 50,
                      ),
                    ),
                    const SizedBox(width: 16),
                    InkWell(
                      onTap: () {
                        context.read<LocaleCubit>().changeLocaleTo(Locale('de'));
                      },
                      child: SvgPicture.asset(
                        'assets/flags/flag-de.svg',
                        key: ValueKey('de'),
                        width: 50,
                        height: 50,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    }

    return SizedBox(
      height: 170,
      child: Center(
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
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              const SizedBox(height: 32),
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
                        width: 100,
                        height: 100,
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
                        width: 100,
                        height: 100,
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
                        width: 100,
                        height: 100,
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
                        width: 100,
                        height: 100,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
