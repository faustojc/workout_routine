import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:powersync/sqlite3.dart';
import 'package:workout_routine/data/client.dart';
import 'package:workout_routine/models/athletes.dart';
import 'package:workout_routine/models/roles.dart';
import 'package:workout_routine/models/subscriptions.dart';
import 'package:workout_routine/themes/colors.dart';
import 'package:workout_routine/widgets/components/toast.dart';

import 'input_form_field.dart';

class AthleteForm extends StatefulWidget {
  final Function onBack;
  final Function onSuccess;

  const AthleteForm({required this.onBack, required this.onSuccess, super.key});

  @override
  State<AthleteForm> createState() => _AthleteFormState();
}

class _AthleteFormState extends State<AthleteForm> with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _birthdayController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  String? _sex = "";
  DateTime? _birthday;
  bool _isAgreed = false;
  bool _submitted = false;

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _ageController.dispose();
    _birthdayController.dispose();
    _weightController.dispose();
    _heightController.dispose();
    _cityController.dispose();
    _addressController.dispose();

    super.dispose();
  }

  String? _validateBirthday(DateTime? value) {
    if (value == null) {
      return "Please enter your birthday";
    }

    setState(() {
      _birthday = value;
      _birthdayController.text = DateFormat.yMMMMd().format(value);
    });

    return null;
  }

  void _onBirthdaySelected() {
    showDatePicker(context: context, firstDate: DateTime(1900), lastDate: DateTime.now(), initialDate: _birthday ?? DateTime.now()) //
        .then((value) => _validateBirthday(value))
        .catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Something went wrong. Please try again."),
      ));

      return null;
    });
  }

  Future<void> _register(BuildContext context) async {
    setState(() => _submitted = true);

    if (_formKey.currentState!.validate() && _isAgreed) {
      AthleteModel athleteData = AthleteModel.fromJson({
        'userId': user.id,
        'firstName': _firstNameController.text.trim(),
        'lastName': _lastNameController.text.trim(),
        'sex': _sex!.trim(),
        'city': _cityController.text.trim(),
        'address': _addressController.text.trim(),
        'age': int.parse(_ageController.text.trim()),
        'weight': double.parse(_weightController.text.trim()),
        'height': double.parse(_heightController.text.trim()),
        'birthday': _birthday!,
      });

      RoleModel roleData = RoleModel.fromJson({
        'userId': user.id,
        'name': 'user',
      });

      SubscriptionModel subscriptionData = SubscriptionModel.fromJson({
        'userId': user.id,
        'isSubscribed': false,
      });

      await athleteData.create(athleteData.toJson()).then((ResultSet? value) async {
        AthleteModel.current = AthleteModel.fromJson(value!.first);
        RoleModel.current = await roleData.create(roleData.toJson()).then((ResultSet? value) => RoleModel.fromJson(value!.first));
        SubscriptionModel.current = await subscriptionData.create(subscriptionData.toJson()).then((ResultSet? value) => SubscriptionModel.fromJson(value!.first));

        widget.onSuccess();
      }).onError((error, _) {
        showToast(context: context, message: error.toString(), type: ToastType.error, vsync: this, dismissible: true);
      });
    }
  }

  @override
  Widget build(BuildContext context) => Container(
        color: ThemeColor.black,
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: CircleAvatar(
                    backgroundColor: ThemeColor.primary,
                    child: IconButton(
                      color: ThemeColor.black,
                      onPressed: () => widget.onBack(),
                      icon: const Icon(Icons.arrow_back, color: ThemeColor.black),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                const AutoSizeText(
                  "ATHLETE INFORMATION",
                  style: TextStyle(
                    color: Colors.white,
                    letterSpacing: 1.2,
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                const AutoSizeText(
                  'Please fill in the following information to complete your registration.',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 30),
                InputFormField(
                  type: FieldType.text,
                  controller: _firstNameController,
                  label: "First Name",
                  labelStyle: const TextStyle(color: ThemeColor.tertiary),
                  decoration: FieldDecoration.filled,
                  fillColor: Colors.transparent,
                  validator: (value) => value!.isEmpty ? "First name is required" : null,
                ),
                const SizedBox(height: 20),
                InputFormField(
                  type: FieldType.text,
                  controller: _lastNameController,
                  label: "Last Name",
                  labelStyle: const TextStyle(color: ThemeColor.tertiary),
                  decoration: FieldDecoration.filled,
                  fillColor: Colors.transparent,
                  validator: (value) => value!.isEmpty ? "Last name is required" : null,
                ),
                const SizedBox(height: 20),
                DropdownButtonFormField<String>(
                  isExpanded: true,
                  hint: const Text("Select your sex", style: TextStyle(color: ThemeColor.tertiary)),
                  dropdownColor: ThemeColor.secondary,
                  icon: const Icon(Icons.arrow_drop_down, color: ThemeColor.white),
                  decoration: const InputDecoration(
                    filled: true,
                    fillColor: Colors.transparent,
                    border: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                  ),
                  items: const [
                    DropdownMenuItem(
                      value: 'Male',
                      child: Text('Male', style: TextStyle(color: ThemeColor.white)),
                    ),
                    DropdownMenuItem(
                      value: 'Female',
                      child: Text('Female', style: TextStyle(color: ThemeColor.white)),
                    ),
                  ],
                  onChanged: (String? value) {
                    if (value != null) {
                      setState(() => _sex = value);
                    }
                  },
                  validator: (value) => value == null ? "Please select your sex" : null,
                ),
                const SizedBox(height: 20),
                InputFormField(
                  type: FieldType.text,
                  controller: _birthdayController,
                  label: "Birthday",
                  labelStyle: const TextStyle(color: ThemeColor.tertiary),
                  decoration: FieldDecoration.filled,
                  fillColor: Colors.transparent,
                  suffixIcon: Icons.calendar_month,
                  readOnly: true,
                  validator: (value) => _validateBirthday(_birthday),
                  onTap: _onBirthdaySelected,
                ),
                const SizedBox(height: 20),
                InputFormField(
                  type: FieldType.int,
                  controller: _ageController,
                  label: "Age",
                  labelStyle: const TextStyle(color: ThemeColor.tertiary),
                  decoration: FieldDecoration.filled,
                  fillColor: Colors.transparent,
                  validator: (value) => value!.isEmpty ? "Age is required" : null,
                ),
                const SizedBox(height: 20),
                InputFormField(
                  type: FieldType.int,
                  controller: _ageController,
                  label: "Age",
                  labelStyle: const TextStyle(color: ThemeColor.tertiary),
                  decoration: FieldDecoration.filled,
                  fillColor: Colors.transparent,
                  validator: (value) => value!.isEmpty ? "Age is required" : null,
                ),
                const SizedBox(height: 20),
                InputFormField(
                  type: FieldType.double,
                  controller: _weightController,
                  label: "Weight (kg)",
                  labelStyle: const TextStyle(color: ThemeColor.tertiary),
                  decoration: FieldDecoration.filled,
                  fillColor: Colors.transparent,
                  validator: (value) => value!.isEmpty ? "Weight is required" : null,
                ),
                const SizedBox(height: 20),
                InputFormField(
                  type: FieldType.double,
                  controller: _heightController,
                  label: "Height (inches)",
                  labelStyle: const TextStyle(color: ThemeColor.tertiary),
                  decoration: FieldDecoration.filled,
                  fillColor: Colors.transparent,
                  validator: (value) => value!.isEmpty ? "Height is required" : null,
                ),
                const SizedBox(height: 20),
                InputFormField(
                  type: FieldType.text,
                  controller: _cityController,
                  label: "City",
                  labelStyle: const TextStyle(color: ThemeColor.tertiary),
                  decoration: FieldDecoration.filled,
                  fillColor: Colors.transparent,
                  validator: (value) => value!.isEmpty ? "City is required" : null,
                ),
                const SizedBox(height: 20),
                InputFormField(
                  type: FieldType.text,
                  controller: _addressController,
                  label: "Address",
                  labelStyle: const TextStyle(color: ThemeColor.tertiary),
                  decoration: FieldDecoration.filled,
                  fillColor: Colors.transparent,
                  validator: (value) => value!.isEmpty ? "Address is required" : null,
                ),
                const SizedBox(height: 20),
                CheckboxListTile(
                  value: _isAgreed,
                  onChanged: (value) => setState(() => _isAgreed = value!),
                  title: const Text(
                    "I agree to the terms and conditions by signing up.",
                    style: TextStyle(color: Colors.white),
                  ),
                  activeColor: Colors.greenAccent,
                  checkColor: ThemeColor.primary,
                  controlAffinity: ListTileControlAffinity.leading,
                ),
                (_isAgreed || !_submitted
                    ? const SizedBox.shrink()
                    : const Padding(
                        padding: EdgeInsets.only(top: 10),
                        child: AutoSizeText(
                          "You must agree to the terms and conditions to continue.",
                          style: TextStyle(color: Colors.red, fontSize: 12),
                        ),
                      )),
                const SizedBox(height: 40),
                FilledButton(
                  onPressed: () => _register(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ThemeColor.primary,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(26),
                    ),
                  ),
                  child: const Text('Register', style: TextStyle(color: ThemeColor.black, fontSize: 20)),
                ),
                const SizedBox(height: 20)
              ],
            ),
          ),
        ),
      );
}
