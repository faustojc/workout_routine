import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:powersync/sqlite3.dart';
import 'package:workout_routine/data/client.dart';
import 'package:workout_routine/models/athletes.dart';
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
  bool isAgreed = false;

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
    if (_formKey.currentState!.validate() && isAgreed) {
      await AthleteModel.create({
        "userId": user.id,
        "firstName": _firstNameController.text.trim(),
        "lastName": _lastNameController.text.trim(),
        "sex": _sex,
        "height": double.parse(_heightController.text.trim()),
        "weight": double.parse(_weightController.text.trim()),
        "birthday": _birthday,
        "age": int.parse(_ageController.text.trim()),
        "city": _cityController.text.trim(),
        "address": _addressController.text.trim(),
        "createdAt": DateTime.now(),
        "updatedAt": DateTime.now(),
      }).then((ResultSet? value) {
        widget.onSuccess();
      }).onError((error, _) {
        showToast(context: context, message: error.toString(), type: ToastType.error, vsync: this, dismissible: true);
      });
    }
  }

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
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
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  decoration: const BoxDecoration(
                    color: Colors.transparent,
                    border: Border(
                      bottom: BorderSide(
                        color: Colors.white,
                      ),
                    ),
                  ),
                  child: DropdownButtonFormField<String>(
                    isExpanded: true,
                    hint: const Text("Select your sex", style: TextStyle(color: ThemeColor.tertiary)),
                    dropdownColor: ThemeColor.secondary,
                    icon: const Icon(Icons.arrow_drop_down, color: ThemeColor.white),
                    decoration: const InputDecoration(
                      filled: true,
                      fillColor: Colors.transparent,
                      border: InputBorder.none,
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
                    validator: (value) => value!.isEmpty ? "Please select your sex" : null,
                  ),
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
                  value: isAgreed,
                  onChanged: (value) => setState(() => isAgreed = value!),
                  title: const Text(
                    "I agree to the terms and conditions by signing up.",
                    style: TextStyle(color: Colors.white),
                  ),
                  activeColor: Colors.greenAccent,
                  checkColor: ThemeColor.primary,
                  controlAffinity: ListTileControlAffinity.leading,
                ),
                (isAgreed
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
                  child: const Text('Register', style: TextStyle(fontSize: 18)),
                ),
                const SizedBox(height: 20)
              ],
            ),
          ),
        ),
      );
}
