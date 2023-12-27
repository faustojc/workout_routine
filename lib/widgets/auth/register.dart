import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:workout_routine/models/athletes.dart';
import 'package:workout_routine/routes.dart';
import 'package:workout_routine/widgets/components/input_form_field.dart';

class RegisterForm extends StatefulWidget {
  const RegisterForm({super.key});

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  static final Map<String, dynamic> userInfo = {
    'email': '',
    'password': '',
    'firstName': '',
    'lastName': '',
    'gender': '',
    'age': '',
    'weight': '',
    'birthday': '',
    'country': '',
    'city': '',
    'address': '',
    'createdAt': DateTime.now(),
    'updatedAt': DateTime.now(),
  };

  final userAthleteFormKey = GlobalKey<_UserAthleteFormState>();
  final List<Widget> _statusIndicator = <Widget>[
    const CircularProgressIndicator(key: ValueKey(1)),
    const Icon(
      Icons.error_outline,
      key: ValueKey(2),
      color: Colors.red,
    ),
    const Icon(
      Icons.check_circle_outline,
      key: ValueKey(3),
      color: Colors.green,
    ),
  ];
  final List<String> _statusText = <String>[
    'Loading...',
    'Something went wrong! Try again later.',
    'Registration successful!',
  ];

  late Widget _currentStatusIndicator;
  late String _currentStatusText;
  bool _isLoading = false;
  bool _hasError = false;

  void _register(context) {
    final currentState = userAthleteFormKey.currentState?._formKey.currentState;

    if (currentState != null && currentState.validate()) {
      userInfo.map((key, value) {
        if (key == 'birthday' && value != null && value is String) {
          final formattedDate = value.toString().split(' ')[0].split('/');

          userInfo[key] = DateTime(int.parse(formattedDate[2]), int.parse(formattedDate[1]), int.parse(formattedDate[0]));
        }

        return MapEntry(key, value);
      });

      setState(() => _isLoading = true);

      if (_isLoading) {
        _currentStatusIndicator = _statusIndicator[0];
        _currentStatusText = _statusText[0];
      } else if (_hasError) {
        _currentStatusIndicator = _statusIndicator[1];
        _currentStatusText = _statusText[1];
      } else {
        _currentStatusIndicator = _statusIndicator[2];
        _currentStatusText = _statusText[2];
      }

      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AnimatedSwitcher(
                    duration: const Duration(milliseconds: 500),
                    transitionBuilder: (child, animation) => ScaleTransition(scale: animation, child: child),
                    switchOutCurve: Curves.easeOut,
                    child: _currentStatusIndicator),
                const SizedBox(width: 20),
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 500),
                  transitionBuilder: (child, animation) => ScaleTransition(scale: animation, child: child),
                  switchOutCurve: Curves.easeOut,
                  child: Text(_currentStatusText),
                ),
              ],
            ),
          );
        },
      );

      FirebaseAuth.instance
          .createUserWithEmailAndPassword(
        email: userInfo['email']!,
        password: userInfo['password']!,
      )
          .then((UserCredential userCredential) {
        userCredential.user?.updateDisplayName('${userInfo['firstName']} ${userInfo['lastName']}');

        Athlete.current = Athlete.fromJson(userInfo);
        Athlete.current?.id = userCredential.user?.uid;

        setState(() {
          _isLoading = false;
          _hasError = false;
        });
        Future.delayed(const Duration(seconds: 2), () {
          if (!_isLoading || _hasError) {
            Routes.back(context);
          }
        });
      }).catchError((err) {
        setState(() {
          _isLoading = false;
          _hasError = true;
        });

        Future.delayed(const Duration(seconds: 2), () {
          if (!_isLoading || _hasError) {
            Routes.back(context);
          }
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: ListView(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            const Text(
              'REGISTER',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
              'Create an account to get started.',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 20),
            UserAthleteForm(key: userAthleteFormKey),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                _register(context);
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.deepPurple,
              ),
              child: const Text('Register'),
            ),
            const SizedBox(height: 30),
            TextButton(
              onPressed: () => Routes.redirectTo(context, "/login"),
              child: const Text('Already have an account? Login'),
            ),
          ],
        ),
      ),
    );
  }
}

class UserAthleteForm extends StatefulWidget {
  const UserAthleteForm({super.key});

  @override
  State<UserAthleteForm> createState() => _UserAthleteFormState();
}

class _UserAthleteFormState extends State<UserAthleteForm> {
  final _formKey = GlobalKey<FormState>();
  final List<String> genderList = ['Male', 'Female', 'Others'];

  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _genderController;
  late TextEditingController _ageController;
  late TextEditingController _weightController;
  late TextEditingController _birthdayController;
  late TextEditingController _countryController;
  late TextEditingController _cityController;
  late TextEditingController _addressController;

  @override
  void initState() {
    super.initState();

    _emailController = TextEditingController(text: _RegisterFormState.userInfo['email']);
    _passwordController = TextEditingController(text: _RegisterFormState.userInfo['password']);
    _firstNameController = TextEditingController(text: _RegisterFormState.userInfo['firstName']);
    _lastNameController = TextEditingController(text: _RegisterFormState.userInfo['lastName']);
    _genderController = TextEditingController(text: _RegisterFormState.userInfo['gender']);
    _ageController = TextEditingController(text: _RegisterFormState.userInfo['age'].toString());
    _weightController = TextEditingController(text: _RegisterFormState.userInfo['weight'].toString());
    _birthdayController = TextEditingController(text: _RegisterFormState.userInfo['birthday']);
    _countryController = TextEditingController(text: _RegisterFormState.userInfo['country']);
    _cityController = TextEditingController(text: _RegisterFormState.userInfo['city']);
    _addressController = TextEditingController(text: _RegisterFormState.userInfo['address']);

    _emailController.addListener(() => _RegisterFormState.userInfo['email'] = _emailController.text);
    _passwordController.addListener(() => _RegisterFormState.userInfo['password'] = _passwordController.text);
    _firstNameController.addListener(() => _RegisterFormState.userInfo['firstName'] = _firstNameController.text);
    _lastNameController.addListener(() => _RegisterFormState.userInfo['lastName'] = _lastNameController.text);
    _genderController.addListener(() => _RegisterFormState.userInfo['gender'] = _genderController.text);
    _ageController.addListener(() {
      if (_ageController.text.isEmpty) {
        _RegisterFormState.userInfo['age'] = '';
      } else if (int.tryParse(_ageController.text) == null) {
        _RegisterFormState.userInfo['age'] = int.parse(_ageController.text);
      }
    });
    _weightController.addListener(() {
      if (_weightController.text.isEmpty) {
        _RegisterFormState.userInfo['weight'] = '';
      } else if (double.tryParse(_weightController.text) == null) {
        _RegisterFormState.userInfo['weight'] = double.parse(_weightController.text);
      }
    });
    _birthdayController.addListener(() => _RegisterFormState.userInfo['birthday'] = _birthdayController.text);
    _countryController.addListener(() => _RegisterFormState.userInfo['country'] = _countryController.text);
    _cityController.addListener(() => _RegisterFormState.userInfo['city'] = _cityController.text);
    _addressController.addListener(() => _RegisterFormState.userInfo['address'] = _addressController.text);
  }

  @override
  void dispose() {
    super.dispose();

    _emailController.dispose();
    _passwordController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _genderController.dispose();
    _ageController.dispose();
    _weightController.dispose();
    _birthdayController.dispose();
    _countryController.dispose();
    _cityController.dispose();
    _addressController.dispose();
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your email';
    }

    if (value.matchAsPrefix(RegExp(r'^[\w-]+@([\w-]+\.)+[\w-]{2,4}$').toString()) != null) {
      return 'Please enter a valid email';
    } else {
      final fireStore = FirebaseFirestore.instance;

      FirebaseFirestore.instance.collection('athletes').where('email', isEqualTo: value).get().then((QuerySnapshot querySnapshot) {
        if (querySnapshot.docs.isNotEmpty) {
          return 'Email already exists';
        }
      });
    }

    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your password';
    }

    return null;
  }

  String? _validateInfo(String? value, String field, {String? message}) {
    if (value == null || value.isEmpty) {
      return message ?? 'Please enter your $field';
    }

    return null;
  }

  void _setBirthday(DateTime date) {
    setState(() {
      final formattedDate = date.toString().split(' ')[0].split('-');
      _birthdayController.text = '${formattedDate[1]}/${formattedDate[2]}/${formattedDate[0]}';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
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
          const Divider(height: 50),
          InputFormField(
            type: FieldType.text,
            label: 'First Name',
            controller: _firstNameController,
            validator: (value) => _validateInfo(value, 'first name'),
            decoration: FieldDecoration.borderless,
          ),
          const SizedBox(height: 20),
          InputFormField(
            type: FieldType.text,
            label: 'Last Name',
            controller: _lastNameController,
            validator: (value) => _validateInfo(value, 'last name'),
            decoration: FieldDecoration.borderless,
          ),
          const SizedBox(height: 20),
          InputFormField(
            type: FieldType.int,
            label: 'Age',
            controller: _ageController,
            decoration: FieldDecoration.borderless,
            validator: (value) => _validateInfo(value, 'age'),
          ),
          const SizedBox(height: 20),
          InputFormField(
            type: FieldType.double,
            label: 'Weight',
            hint: 'Enter your weight in lbs',
            controller: _weightController,
            decoration: FieldDecoration.borderless,
            validator: (value) => _validateInfo(value, 'weight'),
          ),
          const SizedBox(height: 20),
          DropdownButtonFormField(
            hint: const Text('Select Gender'),
            validator: (value) => _validateInfo(value, 'gender', message: 'Please select your gender'),
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.circular(10),
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 10),
              filled: true,
              fillColor: Colors.purple.shade50,
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
          InputFormField(
            type: FieldType.text,
            label: 'Birthday',
            hint: 'Select your birthday',
            suffixIcon: Icons.calendar_month_outlined,
            readOnly: true,
            decoration: FieldDecoration.borderless,
            controller: _birthdayController,
            validator: (value) => _validateInfo(value, 'birthday'),
            onTap: () => showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime(1900),
              lastDate: DateTime.now(),
            ).then((DateTime? date) => _setBirthday(date!)).catchError((err) => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text("Something went wrong! Try again later."),
                ))),
          ),
          const SizedBox(height: 20),
          InputFormField(
            type: FieldType.text,
            label: 'Country',
            controller: _countryController,
            validator: (value) => _validateInfo(value, 'country'),
            decoration: FieldDecoration.borderless,
          ),
          const SizedBox(height: 20),
          InputFormField(
            type: FieldType.text,
            label: 'City',
            controller: _cityController,
            validator: (value) => _validateInfo(value, 'city'),
            decoration: FieldDecoration.borderless,
          ),
          const SizedBox(height: 20),
          InputFormField(
            type: FieldType.text,
            label: 'Address',
            controller: _addressController,
            validator: (value) => _validateInfo(value, 'address'),
            decoration: FieldDecoration.borderless,
          ),
        ],
      ),
    );
  }
}
