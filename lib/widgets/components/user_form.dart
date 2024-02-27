import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:workout_routine/data/client.dart';
import 'package:workout_routine/services/auth_state_provider.dart';
import 'package:workout_routine/themes/colors.dart';
import 'package:workout_routine/widgets/components/status_alert_dialog.dart';
import 'package:workout_routine/widgets/components/toast.dart';

import 'input_form_field.dart';

class UserForm extends StatefulWidget {
  final Function onSuccess;

  const UserForm({required this.onSuccess, super.key});

  @override
  State<UserForm> createState() => _UserFormState();
}

class _UserFormState extends State<UserForm> with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  final OverlayPortalController _overlayController = OverlayPortalController();

  late Widget _statusIndicator = const CircularProgressIndicator(color: ThemeColor.white);
  late String _status = '';
  bool _isLoading = false;

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your email';
    }

    if (!RegExp(r'^[\w-]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
      return 'Please enter a valid email';
    }

    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your password';
    }

    return null;
  }

  @override
  void dispose() {
    super.dispose();

    _emailController.dispose();
    _passwordController.dispose();

    Provider.of<AuthStateProvider>(context, listen: false).removeListener(_verificationListener);
  }

  Future<void> _submit(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      await supabase.auth
          .signUp(
        password: _passwordController.text.trim(),
        email: _emailController.text.trim(),
        emailRedirectTo: 'io.supabase.strength-conditioning://verification/confirm',
      )
          .then((value) {
        user = value.user!;

        // Display the overlay to show the status of the email verification
        _overlayController.show();
        Provider.of<AuthStateProvider>(context, listen: false).addListener(_verificationListener);
      }).onError((AuthException error, _) {
        showToast(context: context, message: error.message, type: ToastType.error, vsync: this, dismissible: true);
      }).whenComplete(() => setState(() => _isLoading = false));
    }
  }

  Future<void> _verificationListener() async {
    final currSession = Provider.of<AuthStateProvider>(context, listen: false).authSession;
    final errorMessage = Provider.of<AuthStateProvider>(context, listen: false).errorMessage;

    if (errorMessage != null) {
      setState(() {
        _status = errorMessage;
        _statusIndicator = const Icon(Icons.error, color: Colors.redAccent);
      });
    } else if (currSession != null) {
      session = currSession;

      setState(() {
        _status = 'Verification complete';
        _statusIndicator = const Icon(Icons.check, color: Colors.green);
      });
    }

    await Future.delayed(const Duration(seconds: 2));
    _overlayController.hide();
  }

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Column(
                children: [
                  const SizedBox(height: 20),
                  const Column(
                    children: [
                      Row(
                        children: [
                          AutoSizeText(
                            "WELCOME",
                            style: TextStyle(
                              color: ThemeColor.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(width: 5),
                          AutoSizeText(
                            "ATHLETES",
                            style: TextStyle(
                              color: ThemeColor.white,
                              fontSize: 24,
                            ),
                          )
                        ],
                      ),
                      SizedBox(height: 5),
                      AutoSizeText(
                        "CREATE AN ACCOUNT TO START YOUR WORKOUT JOURNEY",
                        style: TextStyle(
                          color: ThemeColor.white,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: ThemeColor.secondary.withOpacity(0.7),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          InputFormField(
                            controller: _emailController,
                            type: FieldType.text,
                            decoration: FieldDecoration.filled,
                            label: 'Email',
                            labelStyle: const TextStyle(color: ThemeColor.tertiary),
                            icon: Icons.email,
                            validator: _validateEmail,
                            fillColor: Colors.transparent,
                          ),
                          const SizedBox(height: 20),
                          InputFormField(
                            controller: _passwordController,
                            type: FieldType.password,
                            decoration: FieldDecoration.filled,
                            label: 'Password',
                            labelStyle: const TextStyle(color: ThemeColor.tertiary),
                            icon: Icons.lock,
                            validator: _validatePassword,
                            fillColor: Colors.transparent,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: () => _submit(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: ThemeColor.accent,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(26),
                  ),
                ),
                child: _isLoading
                    ? const CircularProgressIndicator(color: ThemeColor.primary) //
                    : const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          AutoSizeText("Next", style: TextStyle(color: ThemeColor.primary, fontSize: 20)),
                          SizedBox(width: 5),
                          Icon(Icons.arrow_forward_ios, color: ThemeColor.primary, size: 20),
                        ],
                      ),
              ),
              OverlayPortal(
                controller: _overlayController,
                overlayChildBuilder: (BuildContext context) => StatusAlertDialog(
                  title: const AutoSizeText('Verification', style: TextStyle(color: ThemeColor.white, fontWeight: FontWeight.bold)),
                  currentStatusIndicator: _statusIndicator,
                  currentStatusText: _status,
                ),
              ),
            ],
          ),
        ),
      );
}
