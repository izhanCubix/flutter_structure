import 'package:flutter/src/widgets/framework.dart';
import 'package:base_structure/validation/validation.dart';

final Map<String, RegExp> regexPatterns = {
  'email': RegExp(
    r'^(([^<>()\[\]\\.,;:\s@"]+(\.[^<>()\[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$',
  ),
  'password': RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[\W_]).{8,}$'),
};

class RequiredValidation<T> extends Validation<T> {
  const RequiredValidation();
  @override
  String? validate(BuildContext context, T? value) {
    if (value == null || (value is String && value.isEmpty)) {
      return 'This field is required';
    } else {
      return null; // No error, validation passed
    }
  }
}

class EmailValidation extends Validation<String> {
  const EmailValidation();

  @override
  String? validate(BuildContext context, String? value) {
    // if (value == null) return null;

    if (value == null || regexPatterns['email']!.hasMatch(value)) {
      return null;
    }

    return 'Please enter a valid email address';
  }
}

class PasswordValidation extends Validation<String> {
  const PasswordValidation();

  @override
  String? validate(BuildContext context, String? value) {
    if (value == null || regexPatterns['password']!.hasMatch(value)) {
      return null;
    }

    return 'Password must be at least 8 characters,\ninclude upper & lower case letters,\na number, and a special character';
  }
}
