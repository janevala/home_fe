import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

Map<ShortcutActivator, VoidCallback> getCallbackShortcuts(
  ScrollController scrollController,
) => {
  const SingleActivator(LogicalKeyboardKey.arrowDown): () {
    scrollController.animateTo(
      scrollController.position.pixels + 50,
      duration: const Duration(milliseconds: 10),
      curve: Curves.easeInOut,
    );
  },
  const SingleActivator(LogicalKeyboardKey.home): () {
    scrollController.animateTo(
      scrollController.position.pixels - scrollController.position.pixels,
      duration: const Duration(milliseconds: 10),
      curve: Curves.easeInOut,
    );
  },

  const SingleActivator(LogicalKeyboardKey.pageUp): () {
    scrollController.animateTo(
      scrollController.position.pixels - 500,
      duration: const Duration(milliseconds: 50),
      curve: Curves.easeInOut,
    );
  },
  const SingleActivator(LogicalKeyboardKey.pageDown): () {
    scrollController.animateTo(
      scrollController.position.pixels + 500,
      duration: const Duration(milliseconds: 50),
      curve: Curves.easeInOut,
    );
  },
  const SingleActivator(LogicalKeyboardKey.arrowUp): () {
    scrollController.animateTo(
      scrollController.position.pixels - 50,
      duration: const Duration(milliseconds: 100),
      curve: Curves.easeInOut,
    );
  },
  const SingleActivator(LogicalKeyboardKey.end): () {
    scrollController.animateTo(
      scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 100),
      curve: Curves.easeInOut,
    );
  },
};
