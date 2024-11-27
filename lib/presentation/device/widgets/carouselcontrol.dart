import 'package:flutter/material.dart';
import 'package:smart_dispencer/presentation/device/controllers/devicecontroller.dart';

class CarouselControl extends StatelessWidget {
  const CarouselControl({
    super.key,
    required this.controller,
  });

  final Devicecontroller controller;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        // rotate the wheel 1 step clockwise
        IconButton(
          onPressed: controller.spinLeft,
          icon: const Icon(Icons.arrow_back),
          style: ElevatedButton.styleFrom(
            // backgroundColor: BrightnessMode.tertiary1,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
        IconButton(
          onPressed: () =>
              controller.settingContainer(controller.currentValue.value),
          icon: const Icon(Icons.settings),
          style: ElevatedButton.styleFrom(
            // backgroundColor: BrightnessMode.tertiary1,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
        IconButton(
          onPressed: controller.spinRight,
          icon: const Icon(Icons.arrow_forward),
          style: ElevatedButton.styleFrom(
            // backgroundColor: BrightnessMode.tertiary1,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
      ],
    );
  }
}
