import 'package:flutter/material.dart';

Widget notificationCard({
  required String message,
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
        message,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
        ),
        overflow: TextOverflow.clip,
      ),
      // subtitle: Text(subtitle),
      trailing: Text(time),
    ),
  );
}
