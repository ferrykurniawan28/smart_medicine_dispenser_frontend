import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_dispencer/data/models/api.dart';
import 'package:smart_dispencer/data/models/container.dart';
import 'package:smart_dispencer/data/models/device.dart';
import 'package:smart_dispencer/data/models/user.dart';
import 'package:smart_dispencer/data/services/authservice.dart';
import 'package:smart_dispencer/presentation/colorpalette.dart';
import 'package:smart_dispencer/presentation/home/controller/homecontroller.dart';
import 'package:smart_dispencer/routes/pages_name.dart';

class Profile extends StatelessWidget {
  const Profile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: BrightnessMode.secondary,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Center(
              child: Text('Profile'),
            ),
            ElevatedButton(
              onPressed: () async {
                final ProviderDevice providerDevice = ProviderDevice();
                final ProviderMedicineContainer providerMedicineContainer =
                    ProviderMedicineContainer();
                await providerDevice.open(tableDevices);
                await providerMedicineContainer.open(tableContainer);
                await providerDevice.reset();
                await providerMedicineContainer.reset();
                await providerDevice.close();
                await providerMedicineContainer.close();
              },
              child: const Text("Reset database"),
            ),
            ElevatedButton(
              onPressed: () async {
                // Get.find<HomeController>().user;
                ApiResponse apiResponse = ApiResponse();
                apiResponse = await logout(Get.find<HomeController>().user!);

                if (apiResponse.error == null) {
                  final providerUser = ProviderUser();
                  final deviceProvider = ProviderDevice();
                  final containerProvider = ProviderMedicineContainer();
                  await providerUser.open(tableUser);
                  await deviceProvider.open(tableDevices);
                  await containerProvider.open(tableContainer);
                  await providerUser.delete();
                  await deviceProvider.reset();
                  await containerProvider.reset();
                  await deviceProvider.close();
                  await containerProvider.close();
                  Get.offAllNamed(PagesName.auth);
                } else {
                  Get.snackbar('Error', apiResponse.error.toString());
                }
              },
              child: const Text('Logout'),
            )
          ],
        ),
      ),
    );
  }
}
