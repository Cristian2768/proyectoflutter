import 'package:flutter/material.dart';

class MensajeUtil {
  void ShowSnackbar(String mensaje, context, int duracion) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(mensaje),
      duration: Duration(seconds: duracion),
    ));
  }
}
