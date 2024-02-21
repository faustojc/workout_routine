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
import 'package:workout_routine/widgets/components/diagonal_container.dart';
import 'package:workout_routine/widgets/components/input_form_field.dart';
import 'package:workout_routine/widgets/components/toast.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> with TickerProviderStateMixin {
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
      setState(() => _isLoading = true);

      supabase.auth
          .signInWithPassword(
              email: _emailController.text.trim(),
              password: _passwordController.text.trim())
          .then((AuthResponse response) async {
        session = response.session!;
        user = response.user!;

        PowerSyncConnector connector = PowerSyncConnector(database);
        await database.connect(connector: connector);

        await _fetchData();

        if (mounted) {
          Routes.redirectTo(context, RouteList.home);
        }
      }).onError((AuthException error, _) {
        showToast(
          context: context,
          message: error.message,
          type: ToastType.error,
          vsync: this,
        );
      }).whenComplete(() => setState(() => _isLoading = false));

      return;
    }
  }

  Future<void> _fetchData() async {
    // Use only for virtual device testing
    // AthleteModel.current = AthleteModel.fromJson(await supabase.from("athletes").select().eq("userId", user.id).single());
    // SubscriptionModel.current = SubscriptionModel.fromJson(await supabase.from("subscriptions").select().eq("userId", user.id).single());
    // PersonalRecordModel.list = PersonalRecordModel.fromList(await supabase.from("personal_records").select().eq("userId", user.id));
    // PRHistoryModel.list = PRHistoryModel.fromList(await supabase.from("personal_records_history").select().eq("userId", user.id));
    // UserWorkoutModel.list = UserWorkoutModel.fromList(await supabase.from("user_workouts").select().eq("userId", user.id));

    // Use for physical device testing
    AthleteModel.current = await AthleteModel.getByUserId(user.id);
    SubscriptionModel.current =
        await SubscriptionModel.getSingleByUserId(user.id);

    PersonalRecordModel.list =
        await PersonalRecordModel.getAllByUserId(user.id);
    PRHistoryModel.list = await PRHistoryModel.getAllByUserId(user.id);
    UserWorkoutModel.list = await UserWorkoutModel.getAllByUserId(user.id);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        resizeToAvoidBottomInset: true,
        body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          color: ThemeColor.primary,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Has Image Background with Login and Register navigation
              Flexible(
                  flex: 6,
                  child: DiagonalContainer(
                    color: ThemeColor.secondary,
                    child: Container(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(
                                top: MediaQuery.of(context).padding.top),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  decoration: const BoxDecoration(
                                    color: Colors.transparent,
                                    border: Border(
                                      bottom: BorderSide(
                                          width: 2, color: ThemeColor.tertiary),
                                    ),
                                  ),
                                  child: TextButton(
                                    onPressed: () {},
                                    style: TextButton.styleFrom(
                                        backgroundColor: Colors.transparent,
                                        padding: const EdgeInsets.all(10)),
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
                                    onPressed: () => Routes.to(
                                        context, RouteList.register, "right"),
                                    style: TextButton.styleFrom(
                                        backgroundColor: Colors.transparent,
                                        padding: const EdgeInsets.all(10)),
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
                          ),
                          Expanded(
                            child: Align(
                              child: Image.asset(
                                  'assets/images/icons/logo-white.png',
                                  width: 290,
                                  height: 290),
                            ),
                          )
                        ],
                      ),
                    ),
                  )),
              // Input Form Fields
              Flexible(
                flex: 4,
                child: Container(
                  color: Colors.transparent,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 26.0, vertical: 10.0),
                  child: SingleChildScrollView(
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          InputFormField(
                            controller: _emailController,
                            type: FieldType.text,
                            decoration: FieldDecoration.filled,
                            label: 'Email',
                            labelStyle:
                                const TextStyle(color: ThemeColor.tertiary),
                            icon: Icons.email,
                            validator: _validateEmail,
                            fillColor: Colors.transparent,
                          ),
                          const SizedBox(height: 10),
                          InputFormField(
                            controller: _passwordController,
                            type: FieldType.password,
                            decoration: FieldDecoration.filled,
                            label: 'Password',
                            labelStyle:
                                const TextStyle(color: ThemeColor.tertiary),
                            icon: Icons.lock,
                            validator: _validatePassword,
                            fillColor: Colors.transparent,
                          ),
                          const SizedBox(height: 10),
                          Align(
                            alignment: Alignment.topRight,
                            child: TextButton(
                              onPressed: () {},
                              child: const Text(
                                'Forgot Password?',
                                style: TextStyle(
                                    color: ThemeColor.tertiary, fontSize: 14),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: () => _login(context),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: ThemeColor.secondary,
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(26),
                              ),
                            ),
                            child: _isLoading
                                ? const CircularProgressIndicator(
                                    color: ThemeColor.white) //
                                : const Text('Login',
                                    style: TextStyle(
                                      color: ThemeColor.white,
                                      fontSize: 18,
                                    )),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      );
}
