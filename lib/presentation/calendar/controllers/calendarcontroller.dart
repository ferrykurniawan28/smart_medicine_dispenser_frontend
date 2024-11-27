import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:smart_dispencer/data/dummy/container.dart';
import 'package:smart_dispencer/data/models/container.dart';
import 'package:smart_dispencer/data/models/reminder.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarController extends GetxController {
  Rx<DateTime> focusedDay = DateTime.now().obs;
  Rx<CalendarFormat> calendarFormat = Rx<CalendarFormat>(CalendarFormat.month);
  Rx<DateTime?> selectedDay = Rx<DateTime?>(null);
  late ValueNotifier<List<MedicineReminder>> selectedEvents;
  RxMap<DateTime, List<MedicineReminder>> events = RxMap();
  List<MedicineContainer> containers = [];
  RxBool isEditing = false.obs;
  ProviderMedicineReminder providerMedicineReminder =
      ProviderMedicineReminder();

  List<MedicineReminder> reminders = [];

  @override
  void onInit() {
    containers = dummyContainer;
    selectedEvents = ValueNotifier<List<MedicineReminder>>([]);
    _loadEvents();
    super.onInit();
  }

  void onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    this.selectedDay.value = selectedDay;
    this.focusedDay.value = focusedDay;

    // Update selected events for the selected day
    selectedEvents.value = events[selectedDay] ?? [];
  }

  void onFormatChanged(CalendarFormat format) {
    calendarFormat.value = format;
  }

  void _loadEvents() {
    events.clear();
    for (var reminder in reminders) {
      DateTime current = reminder.medicineStartDate;
      while (current.isBefore(reminder.medicineEndDate) ||
          current.isAtSameMomentAs(reminder.medicineEndDate)) {
        if (!events.containsKey(current)) {
          events[current] = [];
        }
        events[current]?.add(reminder);
        current = current.add(const Duration(days: 1));
      }
    }
    if (selectedDay.value != null) {
      selectedEvents.value = events[selectedDay.value!] ?? [];
    }
  }

  List<MedicineReminder> getEventsForDay(DateTime day) {
    List<MedicineReminder> dayEvents = events[day] ?? [];

    dayEvents.sort((a, b) {
      TimeOfDay timeA = _parseTime(a.medicineTime);
      TimeOfDay timeB = _parseTime(b.medicineTime);
      return _compareTimeOfDay(timeA, timeB);
    });

    return dayEvents;
  }

  // Parse time from string
  TimeOfDay _parseTime(String time) {
    List<String> parts = time.split(':');
    int hour = int.parse(parts[0]);
    int minute = int.parse(parts[1].substring(0, 2));
    return TimeOfDay(hour: hour, minute: minute);
  }

  int _compareTimeOfDay(TimeOfDay a, TimeOfDay b) {
    if (a.hour == b.hour) {
      return a.minute.compareTo(b.minute);
    }
    return a.hour.compareTo(b.hour);
  }

  List<MedicineReminder> getNextReminders(int count) {
    DateTime now = DateTime.now();
    List<MedicineReminder> allReminders = reminders;

    // Sort reminders by time
    allReminders.sort((a, b) {
      TimeOfDay timeA = _parseTime(a.medicineTime);
      TimeOfDay timeB = _parseTime(b.medicineTime);
      return _compareTimeOfDay(timeA, timeB);
    });

    List<MedicineReminder> nextReminders = [];

    for (var reminder in allReminders) {
      DateTime current = reminder.medicineStartDate;
      while (current.isBefore(reminder.medicineEndDate) ||
          current.isAtSameMomentAs(reminder.medicineEndDate)) {
        // Combine date and time
        TimeOfDay reminderTime = _parseTime(reminder.medicineTime);
        DateTime reminderDateTime = DateTime(
          current.year,
          current.month,
          current.day,
          reminderTime.hour,
          reminderTime.minute,
        );

        // Check if the reminder is valid for the next period
        if (reminderDateTime.isAfter(now) ||
            now.isBefore(reminderDateTime.add(const Duration(minutes: 15)))) {
          nextReminders.add(reminder);

          // Break once we've collected enough reminders
          if (nextReminders.length == count) {
            return nextReminders;
          }
        }

        current = current.add(const Duration(days: 1));
      }
    }

    return nextReminders;
  }

  void openDialog() {
    RxList<bool> medicineList = RxList<bool>.filled(containers.length, false);

    RxMap<String, Map<String, int>> timeMedicineMap =
        RxMap<String, Map<String, int>>();

    DateTime startDate = selectedDay.value ?? focusedDay.value;
    DateTime? endDate;

    void addReminder() {
      if (endDate == null) {
        Get.snackbar('Error', 'Please select an end date',
            snackPosition: SnackPosition.BOTTOM);
        return;
      } else if (timeMedicineMap.isEmpty) {
        Get.snackbar('Error', 'Please add a time for the medicine',
            snackPosition: SnackPosition.BOTTOM);
        return;
      } else if (medicineList.every((element) => element == false)) {
        Get.snackbar('Error', 'Please select a medicine',
            snackPosition: SnackPosition.BOTTOM);
        return;
      }

      for (var time in timeMedicineMap.keys) {
        MedicineReminder newReminder = MedicineReminder(
          medicineTime: time,
          medicineDosage: timeMedicineMap[time]!,
          medicineStartDate: startDate,
          medicineEndDate: endDate!,
        );
        providerMedicineReminder.insert(newReminder);
        reminders.add(newReminder);
      }
      selectedEvents.value = reminders;

      _loadEvents();
      // update();
      Get.back();
    }

    Get.bottomSheet(
      Stack(
        // fit: StackFit.loose,
        clipBehavior: Clip.none,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
              ),
            ),
            child: ListView(
              children: [
                ExpansionTile(
                  title: const Text(
                    'Medicine List',
                  ),
                  children: [
                    Obx(() => Column(
                          children: [
                            for (var i = 0; i < containers.length; i++)
                              ListTile(
                                title: Text(
                                  containers[i].medicine,
                                  style: const TextStyle(
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                onTap: () {
                                  // change value of medicineList
                                  medicineList[i] = !medicineList[i];
                                  update();
                                },
                                trailing: Checkbox(
                                  value: medicineList[i],
                                  onChanged: (bool? value) {
                                    // change value of medicineList
                                    medicineList[i] = value!;
                                    update();
                                  },
                                ),
                              ),
                          ],
                        )),
                  ],
                ),
                ExpansionTile(
                  title: const Text('Dosage & Time'),
                  children: [
                    Obx(() => Column(
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                // Add a new time
                                showTimePicker(
                                  context: Get.context!,
                                  initialTime: TimeOfDay.now(),
                                ).then((value) {
                                  if (value != null) {
                                    // String selectedTime =
                                    //     value.format(Get.context!);
                                    // timeMedicineMap[selectedTime] = {};
                                    String selectedTime =
                                        "${value.hour.toString().padLeft(2, '0')}:${value.minute.toString().padLeft(2, '0')}";
                                    timeMedicineMap[selectedTime] = {};
                                    update();
                                  }
                                });
                              },
                              child: const Text('Add Time'),
                            ),
                            for (var time in timeMedicineMap.keys)
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10.0),
                                    child: Row(
                                      children: [
                                        Text(
                                          time,
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const Spacer(),
                                        IconButton(
                                          onPressed: () {
                                            timeMedicineMap.remove(time);
                                            timeMedicineMap.refresh();
                                          },
                                          icon: const Icon(Icons.delete),
                                        ),
                                      ],
                                    ),
                                  ),
                                  for (var i = 0; i < containers.length; i++)
                                    if (medicineList[i])
                                      ListTile(
                                        title: Text(
                                          containers[i].medicine,
                                          style: const TextStyle(
                                              overflow: TextOverflow.ellipsis),
                                        ),
                                        onTap: () {
                                          // Toggle medicine selection for this time
                                          String medicine =
                                              containers[i].medicine;
                                          if (timeMedicineMap[time]!
                                              .containsKey(medicine)) {
                                            timeMedicineMap[time]!
                                                .remove(medicine);
                                          } else {
                                            timeMedicineMap[time]![medicine] =
                                                0;
                                          }
                                        },
                                        trailing: Obx(() {
                                          String medicine =
                                              containers[i].medicine;
                                          // Ensure the map exists
                                          timeMedicineMap[time] ??= {};
                                          // Ensure the medicine entry exists
                                          timeMedicineMap[time]![medicine] ??=
                                              0;

                                          return Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              IconButton(
                                                onPressed: () {
                                                  if (timeMedicineMap[time]![
                                                          medicine]! >
                                                      0) {
                                                    timeMedicineMap[time]![
                                                            medicine] =
                                                        timeMedicineMap[time]![
                                                                medicine]! -
                                                            1;
                                                  }
                                                  timeMedicineMap.refresh();
                                                },
                                                icon: const Icon(Icons.remove),
                                              ),
                                              const SizedBox(width: 10),
                                              Text(
                                                timeMedicineMap[time]![medicine]
                                                    .toString(),
                                              ),
                                              const SizedBox(width: 10),
                                              IconButton(
                                                onPressed: () {
                                                  timeMedicineMap[time]![
                                                          medicine] =
                                                      timeMedicineMap[time]![
                                                              medicine]! +
                                                          1;
                                                  timeMedicineMap.refresh();
                                                },
                                                icon: const Icon(Icons.add),
                                              ),
                                            ],
                                          );
                                        }),
                                      ),
                                ],
                              ),
                          ],
                        )),
                  ],
                ),
                StatefulBuilder(builder: (context, setState) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const Icon(Icons.calendar_month),
                        const SizedBox(width: 10),
                        const Text(
                          'Start Date: ',
                        ),
                        TextButton(
                          onPressed: () {
                            int day = 365 * 5;
                            showDatePicker(
                              context: Get.context!,
                              initialDate: DateTime.now(),
                              firstDate: DateTime.now(),
                              lastDate: DateTime.now().add(Duration(days: day)),
                            ).then((value) {
                              if (value != null) {
                                startDate = value;
                                setState(() {
                                  // update();
                                });
                              }
                            });
                          },
                          child: Text(
                            DateFormat.yMMMMEEEEd('en_US').format(startDate),
                          ),
                        )
                      ],
                    ),
                  );
                }),
                StatefulBuilder(builder: (context, setState) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const Icon(Icons.calendar_month),
                        const SizedBox(width: 10),
                        const Text(
                          'End Date: ',
                        ),
                        TextButton(
                          onPressed: () {
                            int day = 365 * 5;
                            showDatePicker(
                              context: Get.context!,
                              initialDate: startDate,
                              firstDate: DateTime.now(),
                              lastDate: DateTime.now().add(Duration(days: day)),
                            ).then((value) {
                              if (value!.isBefore(startDate)) {
                                Get.snackbar('Error',
                                    'End date cannot be before start date');
                                return;
                              } else {
                                endDate = DateTime(value.year, value.month,
                                    value.day, 23, 59, 59);
                                setState(() {});
                              }
                            });
                          },
                          child: Text(
                            endDate == null
                                ? 'Select End Date'
                                : DateFormat.yMMMMEEEEd('en_US')
                                    .format(endDate!),
                          ),
                        )
                      ],
                    ),
                  );
                }),
                ElevatedButton(
                  onPressed: addReminder,
                  child: const Text('Save Reminder'),
                ),
              ],
            ),
          ),
          Positioned(
            top: -30,
            right: 10,
            child: IconButton.filled(
              onPressed: () {},
              iconSize: 30,
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all(Colors.red),
              ),
              icon: const Icon(Icons.close),
            ),
          ),
          const Positioned(
            top: -30,
            left: 10,
            child: Text(
              'Add Reminder',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void editDialog(MedicineReminder reminder) {
    DateTime startDate = reminder.medicineStartDate;
    DateTime endDate = reminder.medicineEndDate;

    String medicineTime = reminder.medicineTime;
    Map<String, int> medicineDosage = reminder.medicineDosage;

    RxList<bool> medicineList = RxList<bool>.filled(containers.length, false);

    if (medicineDosage.isNotEmpty) {
      for (var medicine in medicineDosage.keys) {
        for (var i = 0; i < containers.length; i++) {
          if (containers[i].medicine == medicine) {
            medicineList[i] = true;
          }
        }
      }
    }
    Get.bottomSheet(
      Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
              ),
            ),
            child: ListView(
              children: [
                ExpansionTile(
                  title: const Text(
                    'Medicine List',
                  ),
                  children: [
                    Obx(() => Column(
                          children: [
                            for (var i = 0; i < containers.length; i++)
                              ListTile(
                                title: Text(
                                  containers[i].medicine,
                                  style: const TextStyle(
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                onTap: () {
                                  // change value of medicineList
                                  medicineList[i] = !medicineList[i];
                                  update();
                                },
                                trailing: Checkbox(
                                  value: medicineList[i],
                                  onChanged: (bool? value) {
                                    // change value of medicineList
                                    medicineList[i] = value!;
                                    update();
                                  },
                                ),
                              ),
                          ],
                        )),
                  ],
                ),
                ExpansionTile(
                  title: const Text('Dosage & Time'), // edit time and dosage
                  children: [
                    StatefulBuilder(builder: (context, setState) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const Icon(Icons.access_time),
                            // IconButton(

                            //     icon: ),
                            const SizedBox(width: 10),
                            Text(
                              'Time: $medicineTime',
                            ),
                            const Spacer(),
                            TextButton(
                              onPressed: () {
                                showTimePicker(
                                  context: Get.context!,
                                  initialTime: _parseTime(medicineTime),
                                ).then((value) {
                                  if (value != null) {
                                    medicineTime =
                                        "${value.hour.toString().padLeft(2, '0')}:${value.minute.toString().padLeft(2, '0')}";
                                    setState(() {});
                                  }
                                });
                              },
                              child: const Text('Edit Time'),
                            ),
                          ],
                        ),
                      );
                    }),
                    for (String medicine in medicineDosage.keys)
                      ListTile(
                        title: Text(
                          medicine,
                          style: const TextStyle(
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              onPressed: () {
                                if (medicineDosage[medicine]! > 0) {
                                  medicineDosage[medicine] =
                                      medicineDosage[medicine]! - 1;
                                }
                                update();
                              },
                              icon: const Icon(Icons.remove),
                            ),
                            const SizedBox(width: 10),
                            Text(
                              medicineDosage[medicine]!.toString(),
                            ),
                            const SizedBox(width: 10),
                            IconButton(
                              onPressed: () {
                                medicineDosage[medicine] =
                                    medicineDosage[medicine]! + 1;
                                update();
                              },
                              icon: const Icon(Icons.add),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
                StatefulBuilder(builder: (context, setState) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const Icon(Icons.calendar_month),
                        const SizedBox(width: 10),
                        const Text('Start Date: '),
                        TextButton(
                          onPressed: () {
                            int day = 365 * 5;
                            showDatePicker(
                              context: Get.context!,
                              initialDate: startDate,
                              firstDate: DateTime.now(),
                              lastDate: DateTime.now().add(Duration(days: day)),
                            ).then((value) {
                              if (value != null) {
                                startDate = value;
                                setState(() {});
                              }
                            });
                          },
                          child: Text(
                              DateFormat.yMMMMEEEEd('en_US').format(startDate)),
                        ),
                      ],
                    ),
                  );
                }),
                StatefulBuilder(builder: (context, setState) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const Icon(Icons.calendar_month),
                        const SizedBox(width: 10),
                        const Text('End Date: '),
                        TextButton(
                          onPressed: () {
                            int day = 365 * 5;
                            showDatePicker(
                              context: Get.context!,
                              initialDate: endDate,
                              firstDate: DateTime.now(),
                              lastDate: DateTime.now().add(Duration(days: day)),
                            ).then((value) {
                              if (value!.isBefore(startDate)) {
                                Get.snackbar('Error',
                                    'End date cannot be before start date');
                                return;
                              } else {
                                endDate = DateTime(value.year, value.month,
                                    value.day, 23, 59, 59);
                                setState(() {});
                              }
                            });
                          },
                          child: Text(
                            DateFormat.yMMMMEEEEd('en_US').format(endDate),
                          ),
                        ),
                      ],
                    ),
                  );
                }),
                ElevatedButton(
                  onPressed: () {
                    if (medicineDosage.isEmpty) {
                      Get.snackbar(
                          'Error', 'Please add a time for the medicine',
                          snackPosition: SnackPosition.BOTTOM);
                      return;
                    } else if (medicineList
                        .every((element) => element == false)) {
                      Get.snackbar('Error', 'Please select a medicine',
                          snackPosition: SnackPosition.BOTTOM);
                      return;
                    }

                    reminder.medicineTime = medicineTime;
                    reminder.medicineDosage = medicineDosage;
                    reminder.medicineStartDate = startDate;
                    reminder.medicineEndDate = endDate;

                    selectedEvents.value = reminders;

                    _loadEvents();
                    Get.back();
                  },
                  child: const Text('Save Reminder'),
                ),
              ],
            ),
          ),
          Positioned(
            top: -30,
            right: 10,
            child: IconButton.filled(
              onPressed: () {},
              iconSize: 30,
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all(Colors.red),
              ),
              icon: const Icon(Icons.close),
            ),
          ),
          const Positioned(
            top: -30,
            left: 10,
            child: Text(
              'Edit Reminder',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: TextButton(
              onPressed: () {
                // open delete dialog
                Get.defaultDialog(
                  title: 'Delete Reminder',
                  middleText: 'Are you sure you want to delete this reminder?',
                  textConfirm: 'Delete',
                  textCancel: 'Cancel',
                  onConfirm: () {
                    reminders.remove(reminder);
                    selectedEvents.value = reminders;
                    _loadEvents();
                    Get.back();
                  },
                );
              },
              child: const Text("Delete Reminder"),
            ),
          ),
        ],
      ),
    );
  }

  void reminderDetail(MedicineReminder reminder) {
    Get.defaultDialog(
      title: 'Reminder Details',
      actions: [
        TextButton(
          onPressed: () {
            Get.back();
          },
          child: const Text('Close'),
        ),
      ],
      content: Column(
        children: [
          ListTile(
            title: Text('Medicine Time: ${reminder.medicineTime}'),
          ),
          ListTile(
            title: Text(
                'Start Date: ${DateFormat.yMMMMEEEEd('en_US').format(reminder.medicineStartDate)}'),
          ),
          ListTile(
            title: Text(
                'End Date: ${DateFormat.yMMMMEEEEd('en_US').format(reminder.medicineEndDate)}'),
          ),
          ListTile(
            title: const Text('Medicine Dosage:'),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (var medicine in reminder.medicineDosage.keys)
                  Text(
                    '$medicine: ${reminder.medicineDosage[medicine]}',
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
