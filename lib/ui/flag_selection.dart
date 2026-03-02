import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
// import 'package:homefe/assets/i18n/generated/app_localizations.dart';

class FlagSelection extends StatefulWidget {
  const FlagSelection({super.key, this.onSelectedCountryCode, required this.welcomeMessage});

  final Function? onSelectedCountryCode;
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
      if (widget.onSelectedCountryCode != null) {
        widget.onSelectedCountryCode!();
      }
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
        child: Text(
          widget.welcomeMessage,
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ),
    );
  }
}
