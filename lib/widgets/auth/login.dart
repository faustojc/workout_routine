import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:workout_routine/data/client.dart';
import 'package:workout_routine/models/athletes.dart';
import 'package:workout_routine/models/personal_records.dart';
import 'package:workout_routine/models/personal_records_history.dart';
import 'package:workout_routine/models/subscriptions.dart';
import 'package:workout_routine/models/user_workouts.dart';
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

  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();

    super.dispose();
  }

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

  Future<void> _login(context) async {
    if (_formKey.currentState!.validate()) {
      // Perform login action
      setState(() => _isLoading = true);

      supabase.auth.signInWithPassword(email: _emailController.text.trim(), password: _passwordController.text.trim()).then((AuthResponse response) async {
        session = response.session!;
        user = response.user!;

        // PowerSyncConnector connector = PowerSyncConnector(database);
        // await database.connect(connector: connector);

        await _fetchData();

        if (mounted) {
          Navigator.of(context).pushReplacementNamed(RouteList.home.name);
        }
      }).onError((AuthException error, _) {
        showToast(context: context, message: error.message, type: ToastType.error, vsync: this);
      }).whenComplete(() => setState(() => _isLoading = false));
    }
  }

  Future<void> _fetchData() async {
    AthleteModel.current = await AthleteModel.getByUserId(user.id);
    SubscriptionModel.current = await SubscriptionModel.getSingleByUserId(user.id);

    PersonalRecordModel.list = await PersonalRecordModel.getAllByUserId(user.id);
    PRHistoryModel.list = await PRHistoryModel.getAllByUserId(user.id);
    UserWorkoutModel.list = await UserWorkoutModel.getAllByUserId(user.id);
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
              ),
              const SizedBox(height: 20),
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
