import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:workout_routine/data/user.dart';
import 'package:workout_routine/models/athletes.dart';
import 'package:workout_routine/models/users.dart';
import 'package:workout_routine/routes.dart';
import 'package:workout_routine/themes/colors.dart';
import 'package:workout_routine/widgets/components/input_form_field.dart';
import 'package:workout_routine/widgets/components/status_alert_dialog.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  static const String routeName = '/edit_profile';

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final _formKey = GlobalKey<FormState>();
  final List<String> genderList = ['Male', 'Female', 'Others'];

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

  late TextEditingController _emailController;
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

    _emailController = TextEditingController(text: UserModel.current!.email);
    _firstNameController = TextEditingController(text: AthleteModel.current!.firstName);
    _lastNameController = TextEditingController(text: AthleteModel.current!.lastName);
    _genderController = TextEditingController(text: AthleteModel.current!.gender);
    _ageController = TextEditingController(text: AthleteModel.current!.age.toString());
    _weightController = TextEditingController(text: AthleteModel.current?.weight.toString());
    _heightController = TextEditingController(text: AthleteModel.current?.height.toString());
    _birthdayController = TextEditingController(text: _formatDate(AthleteModel.current!.birthday));
    _cityController = TextEditingController(text: AthleteModel.current!.city);
    _addressController = TextEditingController(text: AthleteModel.current!.address);

    _emailController.addListener(() => userInfo['email'] = _emailController.text);
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

  Future<void> _register(context) async {
    if (_formKey.currentState!.validate()) {
      athleteInfo.map((key, value) {
        if (key == 'birthday' && value != null && value is String) {
          final formattedDate = value.toString().split(' ')[0].split('/');

          athleteInfo[key] = DateTime(int.parse(formattedDate[2]), int.parse(formattedDate[1]), int.parse(formattedDate[0])).millisecondsSinceEpoch;
        }

        return MapEntry(key, value);
      });

      athleteInfo.addAll({'updatedAt': DateTime.now().millisecondsSinceEpoch});

      setState(() {
        _currentStatusIndicator = _statusIndicator[0];
        _currentStatusText = _statusText[0];
      });

      _overlayPortalController.show();

      if (athleteInfo['email'].toString().isNotEmpty) {
        UserAttributes attributes = UserAttributes(email: athleteInfo['email'].toString());

        await supabase.auth.updateUser(attributes);
        await supabase.from('users').update({
          'email': athleteInfo['email'],
          'updatedAt': DateTime.now().microsecondsSinceEpoch,
        }).eq('id', UserModel.current!.id);
      }

      supabase.from('athletes').update(athleteInfo).eq('id', AthleteModel.current!.id).then((value) {
        AthleteModel.current = AthleteModel.fromJson(value);

        setState(() {
          _currentStatusText = 'Update successful!';
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
                Routes.back(context);
              }
            }
          }));
    }
  }

  String _formatDate(DateTime date) {
    final formattedDate = date.toString().split(' ')[0].split('-');

    return '${formattedDate[1]}/${formattedDate[2]}/${formattedDate[0]}';
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

  String? _validateInfo(String? value, String field, {String? message}) {
    if (value == null || value.isEmpty) {
      return message ?? 'Please enter your $field';
    }

    return null;
  }

  void _setBirthday(DateTime? date) {
    setState(() {
      final formattedDate = date.toString().split(' ')[0].split('-');
      _birthdayController.text = '${formattedDate[1]}/${formattedDate[2]}/${formattedDate[0]}';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile', style: TextStyle(color: ThemeColor.white)),
        backgroundColor: ThemeColor.primary,
        leading: IconButton(
          color: ThemeColor.secondary,
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Navigator.of(context).pop(),
        ),
        centerTitle: true,
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [ThemeColor.primary, ThemeColor.secondary],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: CustomScrollView(
          slivers: [
            SliverFillRemaining(
              hasScrollBody: false,
              child: Column(
                children: [
                  OverlayPortal(
                    controller: _overlayPortalController,
                    overlayChildBuilder: (BuildContext context) => StatusAlertDialog(
                      currentStatusIndicator: _currentStatusIndicator,
                      currentStatusText: _currentStatusText,
                    ),
                  ),
                  CircleAvatar(
                    backgroundColor: ThemeColor.white,
                    radius: 40,
                    child: Text(
                      AthleteModel.current!.firstName.characters.first + AthleteModel.current!.lastName.characters.first,
                      style: const TextStyle(
                        color: ThemeColor.secondary,
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Material(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                      ),
                      child: Form(
                        key: _formKey,
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Column(
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
                              const SizedBox(height: 30),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  ElevatedButton(
                                    onPressed: () => _register(context),
                                    child: const Text('Save',
                                        style: TextStyle(
                                          color: ThemeColor.white,
                                          backgroundColor: ThemeColor.primary,
                                        )),
                                  ),
                                  const SizedBox(width: 10),
                                  OutlinedButton(onPressed: () => Routes.back(context), child: const Text('Cancel')),
                                ],
                              )
                            ],
                          ),
                        ),
                      ))
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
