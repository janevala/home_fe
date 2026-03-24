import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class AnimatedFirst extends StatefulWidget {
  const AnimatedFirst({super.key, this.onAnimationComplete});

  final VoidCallback? onAnimationComplete;

  @override
  State<AnimatedFirst> createState() => _AnimatedFirstState();
}

class _AnimatedFirstState extends State<AnimatedFirst> with TickerProviderStateMixin {
  late final Animation<double> _firstRotate;
  late final Animation<double> _firstFadeIn;
  late final Animation<double> _firstResizeOut;
  late final AnimationController _firstRotateController;
  late final AnimationController _firstFadeController;
  late final AnimationController _firstResizeController;

  late final Animation<double> _secondRotate;
  late final Animation<double> _secondFadeIn;
  late final Animation<double> _secondResizeOut;
  late final AnimationController _secondRotateController;
  late final AnimationController _secondFadeController;
  late final AnimationController _secondResizeController;

  late final Animation<double> _thirdRotate;
  late final Animation<double> _thirdFadeIn;
  late final Animation<double> _thirdResizeOut;
  late final AnimationController _thirdRotateController;
  late final AnimationController _thirdFadeController;
  late final AnimationController _thirdResizeController;

  late final AnimationController _waitController;

  final double _containerHeight = 180;
  final List<int> _logoSizes = [130, 140, 150, 160, 170];
  String _logoPath = 'assets/app-logo.svg';

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final isLight = Theme.of(context).brightness == Brightness.light;
    if (isLight) {
      _logoPath = 'assets/app-logo-light.svg';
    }
  }

  @override
  void initState() {
    super.initState();

    _firstFadeController = AnimationController(vsync: this, duration: Duration(milliseconds: 400));
    _firstRotateController = AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    _firstResizeController = AnimationController(vsync: this, duration: Duration(milliseconds: 600));

    // second is always slightly slower
    _secondFadeController = AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    _secondRotateController = AnimationController(vsync: this, duration: Duration(milliseconds: 600));
    _secondResizeController = AnimationController(vsync: this, duration: Duration(milliseconds: 700));

    // third is even slower
    _thirdFadeController = AnimationController(vsync: this, duration: Duration(milliseconds: 600));
    _thirdRotateController = AnimationController(vsync: this, duration: Duration(milliseconds: 700));
    _thirdResizeController = AnimationController(vsync: this, duration: Duration(milliseconds: 800));

    _waitController = AnimationController(vsync: this, duration: Duration(milliseconds: 500));

    _firstFadeIn = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _firstFadeController,
        curve: Curves.easeIn,
      ),
    );

    final firstDirection = Random().nextBool() ? 1.0 : -1.0;
    _firstRotate = Tween<double>(begin: pi * firstDirection, end: 0).animate(
      CurvedAnimation(
        parent: _firstRotateController,
        curve: Curves.linear,
      ),
    );

    _firstResizeOut = Tween<double>(begin: 1, end: 0).animate(
      CurvedAnimation(
        parent: _firstResizeController,
        curve: Curves.easeInOut,
      ),
    );

    _secondFadeIn = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _secondFadeController,
        curve: Curves.easeInOut,
      ),
    );

    final secondDirection = Random().nextBool() ? 1.0 : -1.0;
    _secondRotate = Tween<double>(begin: pi * secondDirection, end: 0).animate(
      CurvedAnimation(
        parent: _secondRotateController,
        curve: Curves.easeInOut,
      ),
    );

    _secondResizeOut = Tween<double>(begin: 1, end: 0).animate(
      CurvedAnimation(
        parent: _secondResizeController,
        curve: Curves.easeInOut,
      ),
    );

    _thirdFadeIn = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _thirdFadeController,
        curve: Curves.easeInOut,
      ),
    );

    final thirdDirection = Random().nextBool() ? 1.0 : -1.0;
    _thirdRotate = Tween<double>(begin: pi * thirdDirection, end: 0).animate(
      CurvedAnimation(
        parent: _thirdRotateController,
        curve: Curves.easeInOut,
      ),
    );

    _thirdResizeOut = Tween<double>(begin: 1, end: 0).animate(
      CurvedAnimation(
        parent: _thirdResizeController,
        curve: Curves.easeInOut,
      ),
    );

    _startAnimationLoop();
  }

  void _startAnimationLoop() {
    _firstFadeController
        .forward()
        .then((_) => _firstRotateController.forward())
        .then((_) => _firstResizeController.forward());

    _secondFadeController
        .forward()
        .then((_) => _secondRotateController.forward())
        .then((_) => _secondResizeController.forward());

    _thirdFadeController
        .forward()
        .then((_) => _thirdRotateController.forward())
        .then((_) => _thirdResizeController.forward())
        .then((_) => _waitController.forward())
        .then((_) {
          _resetAndStop();
          if (widget.onAnimationComplete != null) {
            widget.onAnimationComplete!();
          }
        });
  }

  void _resetAndStop() {
    _firstFadeController.reset();
    _firstRotateController.reset();
    _firstResizeController.reset();
    _secondFadeController.reset();
    _secondRotateController.reset();
    _secondResizeController.reset();
    _thirdFadeController.reset();
    _thirdRotateController.reset();
    _thirdResizeController.reset();
    _waitController.reset();
  }

  @override
  void dispose() {
    _firstRotateController.dispose();
    _firstFadeController.dispose();
    _firstResizeController.dispose();
    _secondRotateController.dispose();
    _secondFadeController.dispose();
    _secondResizeController.dispose();
    _thirdRotateController.dispose();
    _thirdFadeController.dispose();
    _thirdResizeController.dispose();
    _waitController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: _containerHeight,
      child: Center(child: _animatedLogo(context)),
    );
  }

  Widget _animatedLogo(BuildContext context) {
    return _buildTripleLogos();
  }

  Widget _buildTripleLogos() {
    final firstSize = _logoSizes[Random().nextInt(5)];
    final remainingSizes1 = _logoSizes.where((size) => size != firstSize).toList();
    final secondSize = remainingSizes1[Random().nextInt(4)];
    final remainingSizes2 = remainingSizes1.where((size) => size != secondSize).toList();
    final thirdSize = remainingSizes2[Random().nextInt(3)];

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildFirstAnimatedLogo(firstSize),
        const SizedBox(width: 15),
        _buildSecondAnimatedLogo(secondSize),
        const SizedBox(width: 15),
        _buildThirdAnimatedLogo(thirdSize),
      ],
    );
  }

  Widget _buildFirstAnimatedLogo(int size) {
    return Center(
      child: AnimatedBuilder(
        animation: Listenable.merge([_firstFadeIn, _firstRotate, _firstResizeOut]),
        builder: (context, child) => Transform.rotate(
          angle: _firstRotate.value,
          child: Opacity(
            opacity: _firstFadeIn.value * _firstResizeOut.value,
            child: Transform.scale(
              scale: _firstResizeOut.value,
              child: child,
            ),
          ),
        ),
        child: SvgPicture.asset(
          _logoPath,
          key: ValueKey('logo1'),
          width: size.toDouble(),
          height: size.toDouble(),
        ),
      ),
    );
  }

  Widget _buildSecondAnimatedLogo(int size) {
    return Center(
      child: AnimatedBuilder(
        animation: Listenable.merge([_secondFadeIn, _secondRotate, _secondResizeOut]),
        builder: (context, child) => Transform.rotate(
          angle: _secondRotate.value,
          child: Opacity(
            opacity: _secondFadeIn.value,
            child: Transform.scale(
              scale: _secondResizeOut.value,
              child: child,
            ),
          ),
        ),
        child: SvgPicture.asset(
          _logoPath,
          key: ValueKey('logo2'),
          width: size.toDouble(),
          height: size.toDouble(),
        ),
      ),
    );
  }

  Widget _buildThirdAnimatedLogo(int size) {
    return Center(
      child: AnimatedBuilder(
        animation: Listenable.merge([_thirdFadeIn, _thirdRotate, _thirdResizeOut]),
        builder: (context, child) => Transform.rotate(
          angle: _thirdRotate.value,
          child: Opacity(
            opacity: _thirdFadeIn.value,
            child: Transform.scale(
              scale: _thirdResizeOut.value,
              child: child,
            ),
          ),
        ),
        child: SvgPicture.asset(
          _logoPath,
          key: ValueKey('logo3'),
          width: size.toDouble(),
          height: size.toDouble(),
        ),
      ),
    );
  }
}
