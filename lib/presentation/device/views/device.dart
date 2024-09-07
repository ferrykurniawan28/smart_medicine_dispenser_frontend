import 'package:flutter/material.dart';
import 'package:flutter_fortune_wheel/flutter_fortune_wheel.dart';
import 'package:get/get.dart';
import 'package:smart_dispencer/presentation/colorpalette.dart';
import 'package:smart_dispencer/presentation/device/controllers/devicecontroller.dart';

class Device extends GetView<Devicecontroller> {
  const Device({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Device'),
      ),
      body: Container(
        decoration: const BoxDecoration(
            // color: BrightnessMode.primary,
            // gradient: LinearGradient(
            //   colors: [
            //     BrightnessMode.primary,
            //     BrightnessMode.tertiary1,
            //     BrightnessMode.tertiary3,
            //     BrightnessMode.secondary,
            //     BrightnessMode.tertiary2,
            //   ],
            //   begin: Alignment.topLeft,
            //   end: Alignment.bottomRight,
            // ),
            ),
        child: ListView(
          children: [
            SizedBox(
              height: 400,
              child: FortuneWheel(
                styleStrategy: UniformStyleStrategy(
                  borderColor: Colors.black,
                  borderWidth: 2,
                  color: Colors.accents[10],
                ),
                animateFirst: false,
                curve: Curves.easeIn,
                rotationCount: 1,
                duration: const Duration(milliseconds: 200),
                selected: controller.spinWheelController.stream,
                physics: CircularPanPhysics(
                  duration: const Duration(milliseconds: 1000),
                  curve: Curves.easeIn,
                  allowOppositeRotationFlung: false,
                ),
                items: [
                  for (var i = 0; i < 8; i++)
                    FortuneItem(
                      child: RotatedBox(
                        quarterTurns: 1,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                color: (i % 2 != 0) ? Colors.green : Colors.red,
                                borderRadius: BorderRadius.circular(50),
                              ),
                            ),
                            Text('Name $i'),
                            Text('Dose $i'),
                            Text('${i + 1}'),
                          ],
                        ),
                      ),
                      // style: const FortuneItemStyle(
                      //   color: BrightnessMode.secondary,
                      //   borderColor: Colors.black,
                      //   borderWidth: 2,
                      //   textStyle: TextStyle(fontSize: 20, color: Colors.black),
                      //   textAlign: TextAlign.center,
                      // ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // rotate the wheel 1 step clockwise
                IconButton(
                  onPressed: controller.spinLeft,
                  icon: const Icon(Icons.rotate_left),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: BrightnessMode.tertiary2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),

                // configure
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.settings),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: BrightnessMode.tertiary2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),

                // rotate the wheel 1 step counter-clockwise
                IconButton(
                  onPressed: controller.spinRight,
                  icon: const Icon(Icons.rotate_right),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: BrightnessMode.tertiary2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Reminders'),
                  IconButton(
                    onPressed: () {},
                    icon: Icon(Icons.add),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: 5,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text('Reminder $index'),
                    subtitle: Text('Time: 8:00 AM'),
                    trailing: IconButton(
                      onPressed: () {},
                      icon: Icon(Icons.delete),
                    ),
                  );
                }),
          ],
        ),
      ),
    );
  }
}
