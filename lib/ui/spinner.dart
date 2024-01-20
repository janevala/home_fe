import 'dart:io';

import 'package:flutter/material.dart';

class Spinner extends StatelessWidget {
  const Spinner({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black.withOpacity(0.2),
      width: double.infinity,
      height: double.infinity,
      child: Center(
        child: _buildMaterialSpinner(context),
      ),
    );
  }
}

Widget _buildMaterialSpinner(BuildContext context) {
  return Container(
    width: 100,
    height: 100,
    decoration: const BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.all(
        Radius.circular(8.0),
      ),
    ),
    child: const Center(
      child: SizedBox(
        height: 60,
        width: 60,
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
          backgroundColor: Colors.lightBlue,
        ),
      ),
    ),
  );
}
