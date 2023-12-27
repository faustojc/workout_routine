import 'package:flutter/material.dart';
import 'package:workout_routine/routes.dart';
import 'package:workout_routine/widgets/components/input_form_field.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your email';
    }

    if (value.matchAsPrefix(RegExp(r'^[\w-]+@([\w-]+\.)+[\w-]{2,4}$').toString()) != null) {
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

  void _login() {
    if (_formKey.currentState!.validate()) {
      // Perform login action
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Text(
                  'HELLO AGAIN',
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 30),
                InputFormField(
                  type: FieldType.text,
                  label: 'Email',
                  controller: _emailController,
                  validator: _validateEmail,
                  icon: Icons.email_outlined,
                  decoration: FieldDecoration.borderless,
                ),
                const SizedBox(height: 20),
                InputFormField(
                  type: FieldType.password,
                  label: 'Password',
                  controller: _passwordController,
                  validator: _validatePassword,
                  icon: Icons.lock_outline,
                  decoration: FieldDecoration.borderless,
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: FilledButton.tonal(
                        onPressed: _login,
                        child: const Text('Login'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                TextButton(
                  onPressed: () {
                    Routes.redirectTo(context, "/register");
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Don\'t have an account?', style: TextStyle(color: Colors.grey.shade800)),
                      const SizedBox(width: 5),
                      const Text('Register'),
                    ],
                  ),
                ),
              ],
            ),
          )),
    );
  }
}
