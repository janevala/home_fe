import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

Map<ShortcutActivator, VoidCallback> getCallbackShortcuts(
  ScrollController controller,
) => {
  const SingleActivator(LogicalKeyboardKey.arrowDown): () {
    controller.animateTo(
      controller.position.pixels + 50,
      duration: const Duration(milliseconds: 10),
      curve: Curves.easeInOut,
    );
  },
  const SingleActivator(LogicalKeyboardKey.home): () {
    controller.animateTo(
      controller.position.pixels - controller.position.pixels,
      duration: const Duration(milliseconds: 10),
      curve: Curves.easeInOut,
    );
  },

  const SingleActivator(LogicalKeyboardKey.pageUp): () {
    controller.animateTo(
      controller.position.pixels - 500,
      duration: const Duration(milliseconds: 50),
      curve: Curves.easeInOut,
    );
  },
  const SingleActivator(LogicalKeyboardKey.pageDown): () {
    controller.animateTo(
      controller.position.pixels + 500,
      duration: const Duration(milliseconds: 50),
      curve: Curves.easeInOut,
    );
  },
  const SingleActivator(LogicalKeyboardKey.arrowUp): () {
    controller.animateTo(
      controller.position.pixels - 50,
      duration: const Duration(milliseconds: 100),
      curve: Curves.easeInOut,
    );
  },
  const SingleActivator(LogicalKeyboardKey.end): () {
    controller.animateTo(
      controller.position.maxScrollExtent,
      duration: const Duration(milliseconds: 100),
      curve: Curves.easeInOut,
    );
  },
};
