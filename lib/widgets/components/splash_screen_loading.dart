import 'package:flutter/cupertino.dart';
import 'package:workout_routine/backend/powersync.dart';
import 'package:workout_routine/data/client.dart';
import 'package:workout_routine/models/athletes.dart';
import 'package:workout_routine/models/personal_records.dart';
import 'package:workout_routine/models/personal_records_history.dart';
import 'package:workout_routine/models/subscriptions.dart';
import 'package:workout_routine/models/user_workouts.dart';
import 'package:workout_routine/routes.dart';
import 'package:workout_routine/widgets/components/loading.dart';

class SplashScreenLoading extends StatefulWidget {
  const SplashScreenLoading({super.key});

  @override
  State<SplashScreenLoading> createState() => _SplashScreenLoadingState();
}

class _SplashScreenLoadingState extends State<SplashScreenLoading> {
  @override
  void initState() {
    super.initState();

    _checkAuthAndFetch();
  }

  Future<void> _checkAuthAndFetch() async {
    if (isLoggedIn()) {
      await _fetchData();

      if (mounted) {
        Navigator.of(context).pushReplacementNamed(RouteList.home.name);
      }

      return;
    } else if (mounted) {
      Navigator.of(context).pushReplacementNamed(RouteList.login.name);
    }

    return;
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
    SubscriptionModel.current = await SubscriptionModel.getSingleByUserId(user.id);

    PersonalRecordModel.list = await PersonalRecordModel.getAllByUserId(user.id);
    PRHistoryModel.list = await PRHistoryModel.getAllByUserId(user.id);
    UserWorkoutModel.list = await UserWorkoutModel.getAllByUserId(user.id);
  }

  @override
  Widget build(BuildContext context) {
    return const Loading();
  }
}
