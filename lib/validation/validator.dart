import 'package:flutter/material.dart';
import 'package:base_structure/validation/validation.dart';

class Validator {
  Validator._();

  static FormFieldValidator<T> apply<T>(
    BuildContext context,
    List<Validation<T>> validations,
  ) {
    return (T? value) {
      for (final validation in validations) {
        final error = validation.validate(context, value);
        if (error != null) {
          return error;
        }
      }
      return null; // No error, validation passed
    };
  }
}
