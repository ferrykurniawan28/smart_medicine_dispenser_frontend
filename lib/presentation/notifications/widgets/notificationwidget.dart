import 'package:flutter/material.dart';

Widget notificationCard({
  required String title,
  required String subtitle,
  required String time,
}) {
  return Card(
    elevation: 0,
    child: ListTile(
      leading: const Icon(
        Icons.notifications,
        size: 40,
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
      subtitle: Text(subtitle),
      trailing: Text(time),
    ),
  );
}
