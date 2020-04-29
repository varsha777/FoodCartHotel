import 'package:flutter/material.dart';

class ErrorMessages {
  static SnackBar showErrorMessage(String message) {
    return SnackBar(content: Text(message), duration: Duration(seconds: 5));
  }
}
