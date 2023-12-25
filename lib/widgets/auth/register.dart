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
    const EmailPassForm(key: ValueKey(1)),
    const AthleteForm(key: ValueKey(2)),
  ];

  int _currentIndex = 0;
  late Widget _currentForm = _forms[_currentIndex];

  void _setForm() {
    if (_currentIndex == 0) {
      setState(() {
        _currentIndex = (_currentIndex + 1) % _forms.length;
        _currentForm = KeyedSubtree(
          key: ValueKey(_currentIndex),
          child: _forms[_currentIndex],
        );
      });
    }
  }

  void _previousForm() {
    setState(() {
      _currentIndex = (_currentIndex - 1) % _forms.length;
      _currentForm = KeyedSubtree(
        key: ValueKey(_currentIndex),
        child: _forms[_currentIndex],
      );
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
            Text('Register', style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: 20),
            Flexible(
              flex: 0,
              fit: FlexFit.loose,
              child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 150),
                  transitionBuilder: (child, animation) => ScaleTransition(scale: animation, child: child),
                  switchInCurve: Curves.easeIn,
                  switchOutCurve: Curves.easeOut,
                  child: _currentForm),
            ),
            const SizedBox(height: 30),
            Flexible(
              fit: FlexFit.loose,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _currentIndex == 1 ? Expanded(child: ElevatedButton(onPressed: _previousForm, child: const Text('Back'))) : const SizedBox(),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _setForm,
                      style: ElevatedButton.styleFrom(
                        foregroundColor: _currentIndex == 0 ? Colors.deepPurple : Colors.white,
                        backgroundColor: _currentIndex == 0 ? Colors.white : Colors.deepPurple,
                      ),
                      child: Text(_currentIndex == 0 ? 'Next' : 'Register'),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            TextButton(
              onPressed: () => Routes.redirectTo(context, "/login"),
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
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
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
          ],
        ),
      ),
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
  final _genderController = TextEditingController();
  final _ageController = TextEditingController();
  final _weightController = TextEditingController();

  final List<String> genderList = ['Male', 'Female', 'Others'];

  late String _birthday = '';

  void _setBirthday(DateTime date) {
    setState(() {
      final formattedDate = date.toString().split(' ')[0].split('-');
      _birthday = '${formattedDate[1]}/${formattedDate[2]}/${formattedDate[0]}';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            InputFormField(
              type: FieldType.text,
              label: 'First Name',
              controller: _firstNameController,
              decoration: FieldDecoration.borderless,
            ),
            const SizedBox(height: 20),
            InputFormField(
              type: FieldType.text,
              label: 'Last Name',
              controller: _lastNameController,
              decoration: FieldDecoration.borderless,
            ),
            const SizedBox(height: 20),
            InputFormField(
              type: FieldType.int,
              label: 'Age',
              controller: _ageController,
              decoration: FieldDecoration.borderless,
            ),
            const SizedBox(height: 20),
            InputFormField(
              type: FieldType.double,
              label: 'Weight',
              hint: 'Enter your weight in lbs',
              controller: _weightController,
              decoration: FieldDecoration.borderless,
            ),
            const SizedBox(height: 20),
            DropdownButtonFormField(
              hint: const Text('Select Gender'),
              decoration: InputDecoration(
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                filled: true,
                fillColor: Colors.grey.shade200,
              ),
              items: genderList.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String? value) => setState(() => _genderController.text = value!),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Text("Birthday: ", style: TextStyle(fontSize: 16)),
                const SizedBox(width: 10),
                FilledButton.tonal(
                  onPressed: () => showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(1900),
                    lastDate: DateTime.now(),
                  )
                      .then((DateTime? date) => _setBirthday(date!))
                      .catchError((err) => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Something went wrong! Try again later.")))),
                  child: Text(_birthday == '' ? 'Select your birthday' : _birthday.toString(), style: const TextStyle(color: Colors.deepPurple)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
