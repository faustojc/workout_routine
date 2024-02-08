import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:workout_routine/backend/powersync.dart';
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

        PowerSyncConnector connector = PowerSyncConnector(database);
        await database.connect(connector: connector);

        await _fetchData();

        if (mounted) {
          Navigator.of(context).pushReplacementNamed(RouteList.home.name);
        }
      }).onError((AuthException error, _) {
        showToast(context: context, message: error.message, type: ToastType.error, vsync: this);
      }).whenComplete(() => setState(() => _isLoading = false));

      return;
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
  Widget build(BuildContext context) => Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      color: ThemeColor.primary,
      child: Flex(
        direction: Axis.vertical,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Flexible(
            flex: 6,
            fit: FlexFit.tight,
            child: Container(
              padding: const EdgeInsets.all(20.0),
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/backgrounds/login_bg.png'),
                  fit: BoxFit.fill,
                ),
              ),
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        decoration: const BoxDecoration(
                          color: Colors.transparent,
                          border: Border(
                            bottom: BorderSide(width: 2, color: ThemeColor.tertiary),
                          ),
                        ),
                        child: TextButton(
                          onPressed: () {},
                          style: TextButton.styleFrom(backgroundColor: Colors.transparent, padding: const EdgeInsets.all(10)),
                          child: const Text(
                            'Login',
                            style: TextStyle(
                              color: ThemeColor.white,
                              fontSize: 17,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 20),
                      Container(
                        color: Colors.transparent,
                        child: TextButton(
                          onPressed: () => Routes.to(context, RouteList.register, 'right'),
                          style: TextButton.styleFrom(backgroundColor: Colors.transparent, padding: const EdgeInsets.all(10)),
                          child: const Text(
                            'Register',
                            style: TextStyle(
                              color: ThemeColor.white,
                              fontSize: 17,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Expanded(
                    child: Align(
                      child: Image.asset('assets/images/icons/logo-white.png', width: 290, height: 290),
                    ),
                  )
                ],
              ),
            ),
          ),
          Flexible(
            flex: 4,
            fit: FlexFit.tight,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 26.0, vertical: 10.0),
              child: Material(
                color: Colors.transparent,
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      InputFormField(
                        controller: _emailController,
                        type: FieldType.text,
                        decoration: FieldDecoration.filled,
                        label: 'Email',
                        labelStyle: const TextStyle(color: ThemeColor.tertiary),
                        validator: _validateEmail,
                        fillColor: Colors.transparent,
                      ),
                      InputFormField(
                        controller: _passwordController,
                        type: FieldType.password,
                        decoration: FieldDecoration.filled,
                        label: 'Password',
                        labelStyle: const TextStyle(color: ThemeColor.tertiary),
                        validator: _validatePassword,
                        fillColor: Colors.transparent,
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {},
                          child: const Text(
                            'Forgot Password?',
                            style: TextStyle(color: ThemeColor.tertiary, fontSize: 14),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () => _login(context),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: ThemeColor.secondary,
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(26),
                            ),
                          ),
                          child: _isLoading
                              ? const CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(ThemeColor.white)) //
                              : const Text('Login',
                                  style: TextStyle(
                                    color: ThemeColor.white,
                                    fontSize: 18,
                                  )),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          )
        ],
      ));
}
