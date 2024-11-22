import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_dispencer/data/dummy/container.dart';
import 'package:smart_dispencer/data/models/reminder.dart';

class CalendarController extends GetxController {
  List<MedicineReminder> events = [];

  void openDialog() {
    // create for loop to create bool list for medicine
    RxList<bool> medicineList =
        RxList<bool>.filled(dummyContainer.length, false);

    // RxList<int> dosageList = RxList<int>.filled(medicineDummy.length, 0);

    RxMap<String, Map<String, int>> timeMedicineMap =
        RxMap<String, Map<String, int>>();

    // RxMap<String, int> dosageMap = RxMap<String, int>();

    DateTime? startDate;
    DateTime? endDate;

    Get.bottomSheet(
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
                        for (var i = 0; i < dummyContainer.length; i++)
                          ListTile(
                            title: Text(
                              dummyContainer.values.elementAt(i)['medicine'],
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
                                String selectedTime =
                                    value.format(Get.context!);
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
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10.0),
                                child: Text(
                                  time,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              for (var i = 0; i < dummyContainer.length; i++)
                                if (medicineList[i])
                                  ListTile(
                                    title: Text(
                                      dummyContainer.values
                                          .elementAt(i)['medicine'],
                                      style: const TextStyle(
                                          overflow: TextOverflow.ellipsis),
                                    ),
                                    onTap: () {
                                      // Toggle medicine selection for this time
                                      String medicine = dummyContainer.values
                                          .elementAt(i)['medicine'];
                                      if (timeMedicineMap[time]!
                                          .containsKey(medicine)) {
                                        timeMedicineMap[time]!.remove(medicine);
                                      } else {
                                        timeMedicineMap[time]![medicine] = 0;
                                      }
                                    },
                                    trailing: Obx(() {
                                      String medicine = dummyContainer.values
                                          .elementAt(i)['medicine'];
                                      // Ensure the map exists
                                      timeMedicineMap[time] ??= {};
                                      // Ensure the medicine entry exists
                                      timeMedicineMap[time]![medicine] ??= 0;

                                      return Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          IconButton(
                                            onPressed: () {
                                              if (timeMedicineMap[time]![
                                                      medicine]! >
                                                  0) {
                                                timeMedicineMap[time]![
                                                    medicine] = timeMedicineMap[
                                                        time]![medicine]! -
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
                                              timeMedicineMap[time]![medicine] =
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
              return Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  IconButton(
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
                      icon: const Icon(Icons.calendar_month)),
                  const SizedBox(width: 10),
                  Text(
                    startDate == null
                        ? 'Start Date'
                        : 'Start Date: ${startDate.toString().split(' ')[0]}',
                  ),
                ],
              );
            }),
            StatefulBuilder(builder: (context, setState) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  IconButton(
                      onPressed: () {
                        int day = 365 * 5;
                        showDatePicker(
                          context: Get.context!,
                          initialDate: startDate ?? DateTime.now(),
                          firstDate: DateTime.now(),
                          lastDate: DateTime.now().add(Duration(days: day)),
                        ).then((value) {
                          if (value!.isBefore(startDate!)) {
                            Get.snackbar('Error',
                                'End date cannot be before start date');
                            return;
                          } else {
                            endDate = value;
                            setState(() {
                              // update();
                            });
                          }
                        });
                      },
                      icon: const Icon(Icons.calendar_month)),
                  const SizedBox(width: 10),
                  Text(
                    endDate == null
                        ? 'End Date'
                        : 'End Date: ${startDate.toString().split(' ')[0]}',
                  ),
                ],
              );
            }),
            ElevatedButton(
              onPressed: () {
                print('Medicine List: $medicineList');
                print('Time Medicine Map: $timeMedicineMap');
                print('Start Date: $startDate');
                print('End Date: $endDate');
                // Get.back();
              },
              child: const Text('Save Reminder'),
            ),
          ],
        ),
      ),
    );
  }
}
