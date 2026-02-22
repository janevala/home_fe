import 'package:flutter/material.dart';

class Spinner extends StatelessWidget {
  const Spinner({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.scrim.withValues(alpha: 0.5),
      width: double.infinity,
      height: double.infinity,
      child: Center(
        child: SizedBox(
          width: 60,
          height: 60,
          child: CircularProgressIndicator.adaptive(
            valueColor: AlwaysStoppedAnimation<Color>(
              Theme.of(context).colorScheme.primary,
            ),
            backgroundColor: Theme.of(context).colorScheme.primaryContainer,
          ),
        ),
      ),
    );
  }
}
