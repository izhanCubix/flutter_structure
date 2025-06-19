import 'package:flutter/material.dart';

abstract class Validation<T> {
  /// Validates the given value.
  ///
  const Validation();

  /// abstract method to validate the value.
  String? validate(BuildContext context, T? value);
}
