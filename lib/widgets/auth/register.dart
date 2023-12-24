import 'package:flutter/material.dart';
import 'package:workout_routine/routes.dart';
import 'package:workout_routine/widgets/components/input_form_field.dart';

class RegisterForm extends StatefulWidget {
  const RegisterForm({super.key});

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final List<Widget> _forms = <Widget>[
    const EmailPassForm(key: ValueKey('email_pass_form')),
    const AthleteForm(key: ValueKey('athlete_form')),
  ];

  int _currentIndex = 0;
  late Widget _currentForm = _forms[_currentIndex];

  void _setForm() {
    setState(() {
      _currentIndex = (_currentIndex + 1) % _forms.length;
      _currentForm = _forms[_currentIndex];
    });
  }

  void _previousForm() {
    setState(() {
      _currentIndex = (_currentIndex - 1) % _forms.length;
      _currentForm = _forms[_currentIndex];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              alignment: Alignment.centerLeft,
              child: IconButton(
                onPressed: _previousForm,
                icon: const Icon(Icons.arrow_back),
              ),
            ),
            AnimatedSwitcher(
                duration: const Duration(milliseconds: 150), transitionBuilder: (child, animation) => ScaleTransition(scale: animation, child: child), switchInCurve: Curves.easeIn, switchOutCurve: Curves.easeOut, child: _currentForm),
            const SizedBox(height: 10),
            ElevatedButton(
                onPressed: _setForm,
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.deepPurple,
                  maximumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child: Text(_currentIndex == 0 ? 'Next' : 'Register')),
            const SizedBox(height: 30),
            TextButton(
              onPressed: () => Routes.to(context, '/login'),
              child: const Text('Already have an account? Login'),
            )
          ],
        ),
      ),
    );
  }
}

class EmailPassForm extends StatefulWidget {
  const EmailPassForm({super.key});

  @override
  State<EmailPassForm> createState() => _EmailPassFormState();
}

class _EmailPassFormState extends State<EmailPassForm> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your email';
    }

    if (value.matchAsPrefix(RegExp(r'^[\w-]+@([\w-]+\.)+[\w-]{2,4}$') as String) != null) {
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
  Widget build(BuildContext context) {
    return Material(
      elevation: 5,
      surfaceTintColor: Colors.deepPurple,
      borderRadius: BorderRadius.circular(10),
      child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                InputFormField(
                  type: InputFormFieldType.text,
                  label: 'Email',
                  controller: _emailController,
                  validator: _validateEmail,
                ),
                const SizedBox(height: 20),
                InputFormField(
                  type: InputFormFieldType.password,
                  label: 'Password',
                  controller: _passwordController,
                  validator: _validatePassword,
                ),
              ],
            ),
          )),
    );
  }
}

class AthleteForm extends StatefulWidget {
  const AthleteForm({super.key});

  @override
  State<AthleteForm> createState() => _AthleteFormState();
}

class _AthleteFormState extends State<AthleteForm> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(10),
      surfaceTintColor: Colors.deepPurple,
      child: Form(
        key: _formKey,
        child: Padding(
            padding: const EdgeInsets.all(20),
            child: GridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              children: [
                InputFormField(
                  type: InputFormFieldType.text,
                  label: 'First Name',
                  controller: _firstNameController,
                ),
                InputFormField(
                  type: InputFormFieldType.text,
                  label: 'Last Name',
                  controller: _lastNameController,
                ),
              ],
            )),
      ),
    );
  }
}
