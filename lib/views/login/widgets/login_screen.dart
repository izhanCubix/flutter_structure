import 'package:base_structure/localization/l10n/app_localizations.dart';
import 'package:base_structure/routing/routes.dart';
import 'package:base_structure/validation/validation_impl.dart';
import 'package:base_structure/validation/validator.dart';
import 'package:base_structure/views/login/view_models/login_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({super.key, required this.viewModel});

  final LoginViewModel viewModel;

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  final _emailController = TextEditingController(text: 'eve.holt@reqres.in');

  final _passwordController = TextEditingController(text: 'cityslicka');

  void onSubmit(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      print(
        'Form is valid email : ${_emailController.value.text} and password: ${_passwordController.value.text}',
      );
      final email = _emailController.value.text;
      final password = _passwordController.value.text;
      // context.widget.viewModel.login.exe
      widget.viewModel.login.execute((email, password));
    } else {
      print('Form is invalid');
    }

    // context.go(Routes.home);
  }

  void _onResult() {
    if (widget.viewModel.login.completed) {
      widget.viewModel.login.clearResult();
      context.go(Routes.home);
    }

    if (widget.viewModel.login.error) {
      widget.viewModel.login.clearResult();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.errorMsgLogin),
          action: SnackBarAction(
            label: AppLocalizations.of(context)!.tryAgain,
            onPressed: () => widget.viewModel.login.execute((
              _emailController.value.text,
              _passwordController.value.text,
            )),
          ),
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    widget.viewModel.login.addListener(_onResult);
  }

  @override
  void didUpdateWidget(covariant LoginScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    oldWidget.viewModel.login.removeListener(_onResult);
    widget.viewModel.login.addListener(_onResult);
  }

  @override
  void dispose() {
    widget.viewModel.login.removeListener(_onResult);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Container(
          padding: EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextFormField(
                  decoration: InputDecoration(labelText: 'Email'),
                  controller: _emailController,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: Validator.apply(context, [
                    RequiredValidation(),
                    EmailValidation(),
                  ]),
                ),
                SizedBox(height: 16.0),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Password'),
                  controller: _passwordController,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  obscureText: true,
                  validator: Validator.apply(context, [
                    RequiredValidation(),
                    // PasswordValidation(),
                  ]),
                ),

                ListenableBuilder(
                  listenable: widget.viewModel.login,
                  builder: (context, _) => ElevatedButton(
                    onPressed: () => widget.viewModel.login.running
                        ? null
                        : onSubmit(context),

                    child: widget.viewModel.login.running
                        ? SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : Text('Submit'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
