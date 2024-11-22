import 'package:flutter/material.dart';
import 'package:flutter_fortune_wheel/flutter_fortune_wheel.dart';
import 'package:get/get.dart';
import 'package:smart_dispencer/data/dummy/container.dart';
import 'package:smart_dispencer/presentation/colorpalette.dart';
import 'package:smart_dispencer/presentation/device/controllers/devicecontroller.dart';

class Device extends GetView<Devicecontroller> {
  const Device({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: const Text('Device'),
      // ),
      body: Container(
        // padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          // color: BrightnessMode.primary,
          gradient: LinearGradient(
            colors: [
              BrightnessMode.secondary,
              BrightnessMode.primary,
              // BrightnessMode.tertiary1,
              BrightnessMode.tertiary3,
              // BrightnessMode.tertiary2,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: ListView(
          children: [
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                'Device',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 30,
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            SizedBox(
              // height: 400,
              child: FortuneBar(
                // styleStrategy: UniformStyleStrategy(
                //   borderColor: Colors.black,
                //   borderWidth: 2,
                //   color: Colors.accents[10],
                // ),
                styleStrategy: const UniformStyleStrategy(
                  // borderColor: Colors.black,
                  borderWidth: 1,
                  color: BrightnessMode.tertiary1,
                ),
                animateFirst: false,
                curve: Curves.easeIn,
                rotationCount: 1,
                duration: const Duration(milliseconds: 150),
                selected: controller.spinWheelController.stream,
                physics: CircularPanPhysics(
                  duration: const Duration(milliseconds: 1000),
                  curve: Curves.easeIn,
                  allowOppositeRotationFlung: false,
                ),
                items: [
                  for (var i = 0; i < dummyContainer.length; i++)
                    FortuneItem(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Container ${i + 1}'),
                        ],
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: Obx(() => Text(
                    'Container ${controller.currentValue.value + 1}',
                    style: const TextStyle(
                      // color: Colors.black,
                      fontSize: 20,
                    ),
                  )),
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // rotate the wheel 1 step clockwise
                IconButton(
                  onPressed: controller.spinRight,
                  icon: const Icon(Icons.arrow_back),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: BrightnessMode.tertiary1,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),

                // configure
                IconButton(
                  onPressed: () => controller
                      .settingContainer(controller.currentValue.value),
                  icon: const Icon(Icons.settings),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: BrightnessMode.tertiary1,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),

                // rotate the wheel 1 step counter-clockwise
                IconButton(
                  onPressed: controller.spinLeft,
                  icon: const Icon(Icons.arrow_forward),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: BrightnessMode.tertiary1,
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
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      // color: Colors.black,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: Colors.blueAccent,
                        // color: BrightnessMode.tertiary3,
                      ),
                    ),
                    child: const Text('Containers'),
                  ),
                  // IconButton(
                  //   onPressed: controller.openDialog,
                  //   icon: const Icon(Icons.add),
                  // ),
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            GetBuilder<Devicecontroller>(
              builder: (_) {
                return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: dummyContainer.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(
                          'Container ${dummyContainer.keys.elementAt(index) + 1}',
                          style: const TextStyle(
                            color: Colors.black,
                          ),
                        ),
                        subtitle: Text(
                            dummyContainer.values.elementAt(index)['medicine'],
                            style: const TextStyle(
                              color: Colors.black,
                            )),
                        trailing: Text(
                          dummyContainer.values
                              .elementAt(index)['quantity']
                              .toString(),
                          style: const TextStyle(
                            color: Colors.black,
                          ),
                        ),
                      );
                    });
              },
            ),
            SizedBox(
              height: Get.height * 0.07,
            )
          ],
        ),
      ),
    );
  }
}
