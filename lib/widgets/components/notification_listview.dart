import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:workout_routine/models/notifications.dart';
import 'package:workout_routine/themes/colors.dart';
import 'package:workout_routine/widgets/components/empty_content.dart';

class NotificationListView extends StatefulWidget {
  const NotificationListView({super.key});

  @override
  State<NotificationListView> createState() => _NotificationListViewState();
}

class _NotificationListViewState extends State<NotificationListView> {
  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(20.0),
        color: ThemeColor.primary,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'NOTIFICATIONS',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: ThemeColor.white,
              ),
            ),
            const SizedBox(height: 20),
            (NotificationModel.list.isEmpty)
                ? const Expanded(
                    child: EmptyContent(title: "No notifications as of the moment", icon: Icons.notifications_off),
                  )
                : Expanded(
                    child: ListView.builder(
                      itemCount: NotificationModel.list.length,
                      itemBuilder: (context, index) {
                        final notification = NotificationModel.list[index];

                        return ListTile(
                          leading: CircleAvatar(
                            backgroundColor: ThemeColor.white,
                            child: Text(
                              notification.message.characters.first,
                              style: const TextStyle(
                                color: ThemeColor.secondary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          subtitle: Text(
                            notification.message,
                            style: const TextStyle(
                              color: ThemeColor.white,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                          trailing: Text(
                            DateFormat.yMMMM().format(notification.createdAt),
                            style: const TextStyle(
                              color: ThemeColor.white,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
          ],
        ),
      );
}
