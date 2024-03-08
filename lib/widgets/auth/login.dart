import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:workout_routine/data/client.dart';
import 'package:workout_routine/models/athletes.dart';
import 'package:workout_routine/models/personal_records.dart';
import 'package:workout_routine/models/personal_records_history.dart';
import 'package:workout_routine/models/roles.dart';
import 'package:workout_routine/models/subscriptions.dart';
import 'package:workout_routine/models/user_workouts.dart';
import 'package:workout_routine/routes.dart';
import 'package:workout_routine/themes/colors.dart';
import 'package:workout_routine/widgets/components/input_form_field.dart';
import 'package:workout_routine/widgets/components/status_alert_dialog.dart';
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

  final OverlayPortalController _overlayController = OverlayPortalController();

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

      supabase.auth.signInWithPassword(email: _emailController.text.trim(), password: _passwordController.text.trim()).then((AuthResponse response) async {
        session = response.session!;
        user = response.user!;

        if (user.emailConfirmedAt == null) {
          _overlayController.show();
        } else {
          await _fetchData();

          if (mounted) {
            Routes.redirectTo(context, RouteList.home);
          }
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
    AthleteModel.current = AthleteModel.fromJson(await supabase.from("athletes").select().eq("userId", user.id).single());
    RoleModel.current = RoleModel.fromJson(await supabase.from("roles").select().eq("userId", user.id).single());
    SubscriptionModel.current = SubscriptionModel.fromJson(await supabase.from("subscriptions").select().eq("userId", user.id).single());

    PersonalRecordModel.list = PersonalRecordModel.fromList(await supabase.from("personal_records").select().eq("userId", user.id));
    PRHistoryModel.list = PRHistoryModel.fromList(await supabase.from("personal_records_history").select().eq("userId", user.id));
    UserWorkoutModel.list = UserWorkoutModel.fromList(await supabase.from("user_workouts").select().eq("userId", user.id));

    // Use for physical device testing
    // AthleteModel.current = await AthleteModel.getByUserId(user.id);
    // RoleModel.current = await RoleModel.getUserRole(user.id);
    // SubscriptionModel.current = await SubscriptionModel.getSingleByUserId(user.id);
    //
    // PersonalRecordModel.list = await PersonalRecordModel.getAllByUserId(user.id);
    // PRHistoryModel.list = await PRHistoryModel.getAllByUserId(user.id);
    // UserWorkoutModel.list = await UserWorkoutModel.getAllByUserId(user.id);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        resizeToAvoidBottomInset: true,
        body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          color: ThemeColor.black,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: EdgeInsets.only(
                  top: MediaQuery.of(context).padding.top,
                  left: 20,
                  right: 20,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      decoration: const BoxDecoration(
                        color: Colors.transparent,
                        border: Border(
                          bottom: BorderSide(width: 2, color: ThemeColor.primary),
                        ),
                      ),
                      child: TextButton(
                          onPressed: () {},
                          style: TextButton.styleFrom(backgroundColor: Colors.transparent, padding: const EdgeInsets.all(10)),
                          child: const Text('Login', style: TextStyle(color: ThemeColor.white, fontSize: 17))),
                    ),
                    const SizedBox(width: 20),
                    Container(
                      color: Colors.transparent,
                      child: TextButton(
                        onPressed: () => Routes.redirectTo(context, RouteList.register),
                        style: TextButton.styleFrom(backgroundColor: Colors.transparent, padding: const EdgeInsets.all(10)),
                        child: const Text('Register', style: TextStyle(color: ThemeColor.white, fontSize: 17)),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: CustomScrollView(
                  slivers: [
                    SliverFillRemaining(
                      hasScrollBody: false,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width,
                            height: 300,
                            decoration: const BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage('assets/images/icons/logo-white.png'),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Container(
                            color: Colors.transparent,
                            padding: const EdgeInsets.symmetric(horizontal: 26.0, vertical: 10.0),
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
                                    labelStyle: const TextStyle(color: ThemeColor.tertiary),
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
                                    labelStyle: const TextStyle(color: ThemeColor.tertiary),
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
                                        style: TextStyle(color: ThemeColor.tertiary, fontSize: 14),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  ElevatedButton(
                                    onPressed: () => _login(context),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: ThemeColor.primary,
                                      padding: const EdgeInsets.symmetric(vertical: 10),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(26),
                                      ),
                                    ),
                                    child: _isLoading
                                        ? const CircularProgressIndicator(color: ThemeColor.white) //
                                        : const Text('Login',
                                            style: TextStyle(
                                              color: ThemeColor.black,
                                              fontSize: 18,
                                            )),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              OverlayPortal(
                controller: _overlayController,
                overlayChildBuilder: (context) => StatusAlertDialog(
                  title: const Text("Email Not Verified", style: TextStyle(color: ThemeColor.primary)),
                  statusIndicator: const Icon(Icons.do_not_disturb, color: Colors.redAccent, size: 50),
                  statusMessage: "You have not verified your email yet. Please check your email and verify to continue",
                  actions: [
                    ElevatedButton(
                      onPressed: () => _overlayController.hide(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ThemeColor.primary,
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(26),
                        ),
                      ),
                      child: const Text('Ok', style: TextStyle(color: ThemeColor.white, fontSize: 16)),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      );
}
