import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:workout_routine/routes.dart';
import 'package:workout_routine/themes/colors.dart';
import 'package:workout_routine/widgets/components/input_form_field.dart';
import 'package:workout_routine/widgets/components/toast.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _rememberMe = false;
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

  void onChanged(bool? value) {
    setState(() {
      _rememberMe = value!;
    });
  }

  void _login(context) {
    if (_formKey.currentState!.validate()) {
      // Perform login action
      setState(() => _isLoading = true);

      FirebaseAuth.instance.signInWithEmailAndPassword(email: _emailController.text, password: _passwordController.text).then((userCredential) {
        Routes.redirectTo(context, '/');
      }).onError((FirebaseAuthException error, _) {
        if (error.code.contains('invalid-credential')) {
          showToast(context: context, message: 'Incorrect email or password!', type: ToastType.error, vsync: this);
        } else if (error.code.contains('user-not-found')) {
          showToast(context: context, message: 'User not found!', type: ToastType.error, vsync: this);
        } else if (error.code.contains('wrong-password')) {
          showToast(context: context, message: 'Incorrect password!', type: ToastType.error, vsync: this);
        } else if (error.code.contains('network-request-failed')) {
          showToast(context: context, message: 'Network error!', type: ToastType.error, vsync: this);
        } else {
          showToast(context: context, message: 'Something went wrong!', type: ToastType.error, vsync: this);
        }
      }).whenComplete(() => setState(() => _isLoading = false));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(30),
        topRight: Radius.circular(30),
      ),
      child: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Text(
                'Login to Your Account',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: ThemeColor.primary,
                ),
              ),
              const Text(
                'Make sure that you already have an account',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.normal,
                  color: ThemeColor.primary,
                ),
              ),
              const SizedBox(height: 40),
              const Text(
                'Email',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: ThemeColor.primary,
                ),
              ),
              const SizedBox(height: 10),
              InputFormField(
                type: FieldType.text,
                hint: 'Enter your email',
                controller: _emailController,
                validator: _validateEmail,
                icon: Icons.email_outlined,
                decoration: FieldDecoration.outlined,
              ),
              const SizedBox(height: 20),
              const Text(
                'Password',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: ThemeColor.primary,
                ),
              ),
              const SizedBox(height: 10),
              InputFormField(
                type: FieldType.password,
                hint: 'Enter your password',
                controller: _passwordController,
                validator: _validatePassword,
                icon: Icons.lock_outline,
                decoration: FieldDecoration.outlined,
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Checkbox(
                        value: _rememberMe,
                        onChanged: onChanged,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                        side: const BorderSide(color: ThemeColor.primary),
                        activeColor: ThemeColor.primary,
                      ),
                      const Text(
                        'Remember me',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.normal,
                          color: ThemeColor.primary,
                        ),
                      ),
                    ],
                  ),
                  TextButton(
                    onPressed: () {},
                    style: TextButton.styleFrom(
                      minimumSize: const Size(0, 0),
                      textStyle: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.normal,
                        color: ThemeColor.primary,
                      ),
                    ),
                    child: const Text('Forgot password?'),
                  ),
                ],
              ),
              const SizedBox(height: 40),
              ConstrainedBox(
                constraints: const BoxConstraints.tightFor(width: double.infinity, height: 55),
                child: OutlinedButton(
                  onPressed: _isLoading ? null : () => _login(context),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: ThemeColor.white,
                    backgroundColor: ThemeColor.primary,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
                  ),
                  child: _isLoading ? const CircularProgressIndicator() : const Text('Login'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
