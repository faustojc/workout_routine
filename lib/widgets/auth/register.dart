import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:workout_routine/data/client.dart';
import 'package:workout_routine/models/athletes.dart';
import 'package:workout_routine/routes.dart';
import 'package:workout_routine/themes/colors.dart';
import 'package:workout_routine/widgets/components/input_form_field.dart';
import 'package:workout_routine/widgets/components/status_alert_dialog.dart';

class RegisterForm extends StatefulWidget {
  const RegisterForm({super.key});

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final userAthleteFormKey = GlobalKey<_UserAthleteFormState>();
  final List<Widget> _statusIndicator = <Widget>[
    const CircularProgressIndicator(key: ValueKey(1)),
    const Icon(
      Icons.error_outline,
      key: ValueKey(2),
      color: Colors.red,
      size: 55,
    ),
    const Icon(
      Icons.check_circle_outline,
      key: ValueKey(3),
      color: Colors.green,
      size: 55,
    ),
  ];
  final List<String> _statusText = <String>[
    'Registering...',
    'Something went wrong! Try again later.',
    'Registration successful!',
  ];
  final OverlayPortalController _overlayPortalController = OverlayPortalController();

  late Widget _currentStatusIndicator;
  late String _currentStatusText;
  bool _hasError = false;

  void _register(context) {
    final currentState = userAthleteFormKey.currentState?._formKey.currentState;

    if (currentState != null && currentState.validate()) {
      athleteInfo.map((key, value) {
        if (key == 'birthday' && value != null && value is String) {
          final formattedDate = value.toString().split(' ')[0].split('/');

          athleteInfo[key] = DateTime(int.parse(formattedDate[2]), int.parse(formattedDate[1]), int.parse(formattedDate[0])).microsecondsSinceEpoch;
        }

        return MapEntry(key, value);
      });

      setState(() {
        _currentStatusIndicator = _statusIndicator[0];
        _currentStatusText = _statusText[0];
      });

      _overlayPortalController.show();

      supabase.auth.signUp(email: userInfo['email']!, password: userInfo['password']!).then((AuthResponse response) async {
        session = response.session!;
        user = response.user!;

        await AthleteModel.create({
          'userId': user.id,
          'firstName': athleteInfo['firstName'],
          'lastName': athleteInfo['lastName'],
          'sex': athleteInfo['sex'],
          'age': athleteInfo['age'],
          'weight': athleteInfo['weight'],
          'height': athleteInfo['height'],
          'birthday': athleteInfo['birthday'],
          'city': athleteInfo['city'],
          'address': athleteInfo['address'],
        });

        setState(() {
          _currentStatusText = 'Registration successful! Email confirmation was sent to ${userInfo['email']} to verify your account.';
          _currentStatusIndicator = _statusIndicator[2];
          _hasError = false;
        });
      }).onError((error, stackTrace) {
        setState(() {
          _currentStatusIndicator = _statusIndicator[1];
          _hasError = true;
          _currentStatusText = _statusText[1];
        });
      }).whenComplete(() => Future.delayed(const Duration(seconds: 3), () {
            if (mounted) {
              _overlayPortalController.hide();

              if (!_hasError) {
                Routes.redirectTo(context, RouteList.home);
              }
            }
          }));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(30),
        topRight: Radius.circular(30),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Create Your Account',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: ThemeColor.primary,
              ),
            ),
            const Text(
              'Make sure your account is secure',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.normal,
                color: ThemeColor.primary,
              ),
            ),
            const SizedBox(height: 40),
            UserAthleteForm(key: userAthleteFormKey),
            const SizedBox(height: 40),
            ConstrainedBox(
              constraints: const BoxConstraints.tightFor(width: double.infinity, height: 55),
              child: OutlinedButton(
                onPressed: () {
                  _register(context);
                },
                style: OutlinedButton.styleFrom(
                  foregroundColor: ThemeColor.white,
                  backgroundColor: ThemeColor.primary,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
                ),
                child: const Text('Register'),
              ),
            ),
            OverlayPortal(
              controller: _overlayPortalController,
              overlayChildBuilder: (BuildContext context) => StatusAlertDialog(
                currentStatusIndicator: _currentStatusIndicator,
                currentStatusText: _currentStatusText,
              ),
            )
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
  late TextEditingController _heightController;
  late TextEditingController _birthdayController;
  late TextEditingController _cityController;
  late TextEditingController _addressController;

  @override
  void initState() {
    super.initState();

    _emailController = TextEditingController(text: userInfo['email']);
    _passwordController = TextEditingController(text: userInfo['password']);
    _firstNameController = TextEditingController(text: athleteInfo['firstName']);
    _lastNameController = TextEditingController(text: athleteInfo['lastName']);
    _genderController = TextEditingController(text: athleteInfo['gender']);
    _ageController = TextEditingController(text: athleteInfo['age']);
    _weightController = TextEditingController(text: athleteInfo['weight']);
    _heightController = TextEditingController(text: athleteInfo['height']);
    _birthdayController = TextEditingController(text: _formatDate(athleteInfo['birthday']));
    _cityController = TextEditingController(text: athleteInfo['city']);
    _addressController = TextEditingController(text: athleteInfo['address']);

    _emailController.addListener(() => userInfo['email'] = _emailController.text);
    _passwordController.addListener(() => userInfo['password'] = _passwordController.text);
    _firstNameController.addListener(() => athleteInfo['firstName'] = _firstNameController.text);
    _lastNameController.addListener(() => athleteInfo['lastName'] = _lastNameController.text);
    _genderController.addListener(() => athleteInfo['gender'] = _genderController.text);
    _ageController.addListener(() {
      if (athleteInfo['age'] is String && _ageController.text.isNotEmpty) {
        athleteInfo['age'] = int.parse(_ageController.text);
      } else if (athleteInfo['age'] is int) {
        _ageController.text = athleteInfo['age'].toString();
      }
    });
    _weightController.addListener(() {
      if (athleteInfo['weight'] is String && _weightController.text.isNotEmpty) {
        athleteInfo['weight'] = double.parse(_weightController.text);
      } else if (athleteInfo['weight'] is double) {
        _weightController.text = athleteInfo['weight'].toString();
      }
    });
    _heightController.addListener(() {
      if (athleteInfo['height'] is String && _heightController.text.isNotEmpty) {
        athleteInfo['height'] = double.parse(_heightController.text);
      } else if (athleteInfo['height'] is double) {
        _heightController.text = athleteInfo['height'].toString();
      }
    });
    _birthdayController.addListener(() {
      if (athleteInfo['birthday'] is String && _birthdayController.text.isNotEmpty) {
        final formattedDate = _birthdayController.text.split('/');

        athleteInfo['birthday'] = DateTime(int.parse(formattedDate[2]), int.parse(formattedDate[1]), int.parse(formattedDate[0]));
      } else if (athleteInfo['birthday'] is DateTime) {
        final formattedDate = athleteInfo['birthday'].toString().split(' ')[0].split('-');

        _birthdayController.text = '${formattedDate[1]}/${formattedDate[2]}/${formattedDate[0]}';
      }
    });
    _cityController.addListener(() => athleteInfo['city'] = _cityController.text);
    _addressController.addListener(() => athleteInfo['address'] = _addressController.text);
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
    _heightController.dispose();
    _birthdayController.dispose();
    _cityController.dispose();
    _addressController.dispose();
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your email';
    }

    if (!RegExp(r'^[\w-]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
      return 'Please enter a valid email';
    }

    supabase.from('athletes').select().eq('email', value).then((response) {
      return response.map((data) => data.map((key, value) => MapEntry(key, value))).toList().isNotEmpty ? 'Email already exists' : null;
    });

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

  String _formatDate(Object date) {
    if (date is DateTime) {
      final formattedDate = date.toString().split(' ')[0].split('-');

      return '${formattedDate[1]}/${formattedDate[2]}/${formattedDate[0]}';
    }

    return date.toString();
  }

  void _setBirthday(DateTime? date) {
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
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
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
            hint: 'Enter your valid email',
            controller: _emailController,
            validator: _validateEmail,
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
            decoration: FieldDecoration.outlined,
          ),
          const Divider(height: 50),
          const Text(
            'First Name',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: ThemeColor.primary,
            ),
          ),
          const SizedBox(height: 10),
          InputFormField(
            type: FieldType.text,
            hint: 'Enter your first name',
            controller: _firstNameController,
            validator: (value) => _validateInfo(value, 'first name'),
            decoration: FieldDecoration.outlined,
          ),
          const SizedBox(height: 20),
          const Text(
            'Last Name',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: ThemeColor.primary,
            ),
          ),
          const SizedBox(height: 10),
          InputFormField(
            type: FieldType.text,
            hint: 'Enter your last name',
            controller: _lastNameController,
            validator: (value) => _validateInfo(value, 'last name'),
            decoration: FieldDecoration.outlined,
          ),
          const SizedBox(height: 20),
          const Text(
            'Age',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: ThemeColor.primary,
            ),
          ),
          const SizedBox(height: 10),
          InputFormField(
            type: FieldType.int,
            hint: 'Enter your age',
            controller: _ageController,
            decoration: FieldDecoration.outlined,
            validator: (value) => _validateInfo(value, 'age'),
          ),
          const SizedBox(height: 20),
          const Text(
            'Weight',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: ThemeColor.primary,
            ),
          ),
          const SizedBox(height: 10),
          InputFormField(
            type: FieldType.double,
            hint: 'in lbs (pounds)',
            controller: _weightController,
            decoration: FieldDecoration.outlined,
            validator: (value) => _validateInfo(value, 'weight'),
          ),
          const SizedBox(height: 20),
          const Text(
            'Height',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: ThemeColor.primary,
            ),
          ),
          const SizedBox(height: 10),
          InputFormField(
            type: FieldType.double,
            hint: 'in inches',
            controller: _heightController,
            decoration: FieldDecoration.outlined,
            validator: (value) => _validateInfo(value, 'height'),
          ),
          const SizedBox(height: 20),
          const Text(
            'Gender',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: ThemeColor.primary,
            ),
          ),
          const SizedBox(height: 10),
          DropdownButtonFormField(
            hint: const Text('Select Gender'),
            validator: (value) => _validateInfo(value, 'gender', message: 'Please select your gender'),
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(28),
              ),
              contentPadding: const EdgeInsets.all(20),
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
          const Text(
            'Birthday',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: ThemeColor.primary,
            ),
          ),
          const SizedBox(height: 10),
          InputFormField(
            type: FieldType.text,
            hint: 'mm/dd/yyyy',
            suffixIcon: Icons.calendar_month_outlined,
            readOnly: true,
            decoration: FieldDecoration.outlined,
            controller: _birthdayController,
            validator: (value) => _validateInfo(value, 'birthday'),
            onTap: () => showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime(1900),
              lastDate: DateTime.now(),
            ).then((DateTime? date) {
              if (date != null) {
                _setBirthday(date);
              }
            }).catchError((err) {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content: Text("Something went wrong! Try again later."),
              ));
              return null;
            }),
          ),
          const SizedBox(height: 20),
          const Text(
            'City',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: ThemeColor.primary,
            ),
          ),
          const SizedBox(height: 10),
          InputFormField(
            type: FieldType.text,
            hint: 'Enter the city you live in',
            controller: _cityController,
            validator: (value) => _validateInfo(value, 'city'),
            decoration: FieldDecoration.outlined,
          ),
          const SizedBox(height: 20),
          const Text(
            'Address',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: ThemeColor.primary,
            ),
          ),
          const SizedBox(height: 10),
          InputFormField(
            type: FieldType.text,
            hint: 'Enter the address you live in',
            controller: _addressController,
            validator: (value) => _validateInfo(value, 'address'),
            decoration: FieldDecoration.outlined,
          ),
        ],
      ),
    );
  }
}
