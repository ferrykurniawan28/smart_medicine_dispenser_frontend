import 'package:flutter/material.dart';
import 'package:smart_dispencer/presentation/bottomapp_bar/controllers/bottomappbar_controller.dart';

Widget buildIconButton({
  required IconData icon,
  required int index,
  required BottomappbarController controller,
  int badgeCount = 0,
}) {
  return Stack(
    children: [
      IconButton(
        icon: Icon(icon),
        iconSize: controller.currentIndex.value == index ? 40 : 25,
        onPressed: () {
          controller.changeIndex(index);
        },
        color: controller.currentIndex.value == index
            ? Colors.blueAccent
            : Colors.grey[00],
        splashColor: Colors.blueAccent,
      ),
      if (badgeCount > 0)
        Positioned(
          right: 0,
          child: Container(
            padding: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius.circular(12),
            ),
            constraints: const BoxConstraints(
              minWidth: 20,
              minHeight: 20,
            ),
            child: Text(
              '$badgeCount',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
    ],
  );
}
