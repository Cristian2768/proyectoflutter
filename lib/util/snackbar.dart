import 'package:flutter/material.dart';

class Snackbar {
  void ShowSnackbar(String mensaje, context) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(mensaje)));
  }
}
