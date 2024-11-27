import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_dispencer/presentation/calendar/controllers/calendarcontroller.dart';

class ReminderList extends StatelessWidget {
  const ReminderList({
    super.key,
    required this.controller,
  });

  final CalendarController controller;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: controller.selectedEvents,
      builder: (context, value, child) {
        return Column(
          children: controller.selectedEvents.value
              .map(
                (event) => ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.grey[200],
                      // border: Border.all(color: Colors.grey, width: 2),
                    ),
                    child: const Icon(Icons.medication),
                  ),
                  title: Text(event.medicineTime),
                  subtitle: Text(
                    event.medicineDosage.keys
                        .map((key) => '$key: ${event.medicineDosage[key]}')
                        .join(', '),
                    style: const TextStyle(
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  onTap: () => controller.reminderDetail(event),
                  trailing: Obx(() {
                    if (controller.isEditing.value) {
                      return IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () {
                          controller.editDialog(event);
                        },
                      );
                    } else {
                      return const SizedBox.shrink();
                    }
                  }),
                ),
              )
              .toList(),
        );
      },
    );
  }
}
