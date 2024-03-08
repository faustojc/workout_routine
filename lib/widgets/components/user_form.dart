import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:workout_routine/data/client.dart';
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
  }

  Future<void> _submit(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      FocusManager.instance.primaryFocus?.unfocus();

      setState(() => _isLoading = true);

      await Future.delayed(const Duration(seconds: 2));

      _overlayController.show();

      return;

      await supabase.auth
          .signUp(
        password: _passwordController.text.trim(),
        email: _emailController.text.trim(),
        emailRedirectTo: 'io.supabase.strength-conditioning://verification/confirm',
      )
          .then((value) {
        user = value.user!;

        _overlayController.show();
      }).onError((AuthException error, _) {
        if (mounted) {
          showToast(context: context, message: error.message, type: ToastType.error, vsync: this, dismissible: true);
        }
      }).whenComplete(() => setState(() => _isLoading = false));
    }
  }

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Column(
                children: [
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.all(20),
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
                            labelStyle: const TextStyle(color: ThemeColor.primary),
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
                            labelStyle: const TextStyle(color: ThemeColor.primary),
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
                  backgroundColor: ThemeColor.primary,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(26),
                  ),
                ),
                child: _isLoading
                    ? const CircularProgressIndicator(color: ThemeColor.black) //
                    : const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          AutoSizeText("Next", style: TextStyle(color: ThemeColor.black, fontSize: 20)),
                          SizedBox(width: 15),
                          Icon(Icons.arrow_forward_ios, color: ThemeColor.black, size: 20),
                        ],
                      ),
              ),
              OverlayPortal(
                controller: _overlayController,
                overlayChildBuilder: (BuildContext context) => StatusAlertDialog(
                  statusIndicator: const Text('VERIFICATION', style: TextStyle(color: ThemeColor.primary, fontSize: 30, fontWeight: FontWeight.bold)),
                  statusMessage: "Check your email to verify your account",
                  actions: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          _overlayController.hide();
                          widget.onSuccess();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: ThemeColor.primary,
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(26)),
                        ),
                        child: const Text('Continue', style: TextStyle(color: ThemeColor.black, fontSize: 16)),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      );
}
