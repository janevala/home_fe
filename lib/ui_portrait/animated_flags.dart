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

  bool _isCurrentLocale(String languageCode) {
    return context.read<LocaleCubit>().state.languageCode == languageCode;
  }

  Widget _buildFlag(String code, String asset, String tooltip, {bool isMobile = false}) {
    final isCurrent = _isCurrentLocale(code);
    final size = isMobile ? 50.0 : 100.0;

    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: () => context.read<LocaleCubit>().changeLocaleTo(Locale(code)),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isCurrent ? Theme.of(context).colorScheme.primary : Colors.transparent,
              width: 2,
            ),
            color: isCurrent ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.1) : Colors.transparent,
          ),
          child: Padding(
            padding: EdgeInsets.all(isCurrent ? 4 : 0),
            child: SvgPicture.asset(
              asset,
              key: ValueKey(code),
              width: size,
              height: size,
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final flags = [
      {'code': 'en', 'asset': 'assets/flags/flag-en.svg', 'tooltip': AppLocalizations.of(context)!.localeEnTranslated},
      {'code': 'th', 'asset': 'assets/flags/flag-th.svg', 'tooltip': AppLocalizations.of(context)!.localeThTranslated},
      {'code': 'fi', 'asset': 'assets/flags/flag-fi.svg', 'tooltip': AppLocalizations.of(context)!.localeFiTranslated},
      {'code': 'de', 'asset': 'assets/flags/flag-de.svg', 'tooltip': AppLocalizations.of(context)!.localeDeTranslated},
    ];

    return SizedBox(
      height: 120,
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
                children: flags.map((flag) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 16),
                    child: _buildFlag(
                      flag['code']!,
                      flag['asset']!,
                      flag['tooltip']!,
                      isMobile: true,
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
