import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:smart_dispencer/data/models/api.dart';
import 'package:smart_dispencer/data/models/container.dart';
import 'package:smart_dispencer/data/models/device.dart';
import 'package:smart_dispencer/data/services/containerservice.dart';
import 'package:smart_dispencer/data/services/deviceservice.dart';
import 'package:smart_dispencer/presentation/home/controller/homecontroller.dart';

class Devicecontroller extends GetxController {
  late ProviderDevice providerDevice;
  late ProviderMedicineContainer providerMedicineContainer;
  Devices? device;
  RxInt currentValue = 0.obs;
  RxBool isLoading = false.obs;
  TextEditingController medicineNameController = TextEditingController();
  List<MedicineContainer> containers = [];
  CarouselSliderController carouselController = CarouselSliderController();
  final carouselKey = GlobalKey<CarouselSliderState>();

  final MobileScannerController scanController = MobileScannerController(
    formats: const [BarcodeFormat.qrCode],
  );

  @override
  void onInit() {
    initializeDevice();
    super.onInit();
  }

  Future<void> initializeDevice() async {
    Devices? tempdevice;
    isLoading.value = true;
    providerDevice = ProviderDevice();
    providerMedicineContainer = ProviderMedicineContainer();
    await providerDevice.open(tableDevices);
    await providerMedicineContainer.open(tableContainer);
    tempdevice = await providerDevice.getDevice();

    ApiResponse apiResponse = ApiResponse();
    apiResponse = await getDevice(Get.find<HomeController>().user!.id);

    if (apiResponse.error != null && apiResponse.error != 'Device not found') {
      Get.snackbar('Error', apiResponse.error!);
      // print('device found');
    } else {
      if (apiResponse.data != null &&
          (apiResponse.data as Devices).userId != tempdevice?.userId) {
        // print('device found');
        await providerDevice.insert(apiResponse.data as Devices);
        for (var container in (apiResponse.data as Devices).containers!) {
          await providerMedicineContainer.insert(container);
        }
        device = apiResponse.data as Devices;
        containers = device!.containers ?? [];
      } else if (apiResponse.data != null &&
          (apiResponse.data as Devices).userId == tempdevice?.userId) {
        // print('device found');
        List<MedicineContainer> tempcontainers = [];
        device = tempdevice;
        tempcontainers = await providerMedicineContainer.getAllContainers();
        if (tempcontainers.isNotEmpty) {
          containers = tempcontainers;
        } else {
          containers = device!.containers ?? [];
        }
      } else {
        device = null;
        containers = [];
      }
    }
    isLoading.value = false;
  }

  void spinRight() {
    carouselKey.currentState!.carouselController.nextPage();
    // carouselController.nextPage();
    if (currentValue.value < containers.length - 1) {
      currentValue.value += 1;
    } else {
      currentValue.value = 0;
    }
  }

  void spinLeft() {
    carouselController.previousPage();
    if (currentValue.value > 0) {
      currentValue.value -= 1;
    } else {
      currentValue.value = containers.length - 1;
    }
  }

  void onDetect(BarcodeCapture result) async {
    for (final barcode in result.barcodes) {
      final String? qrValue = barcode.displayValue;

      if (qrValue != null) {
        Get.back();
        try {
          final userId = Get.find<HomeController>().user!.id;
          ApiResponse apiResponse = ApiResponse();

          apiResponse = await registerDevice(qrValue, userId);

          if (apiResponse.error != null) {
            Get.snackbar('Error', apiResponse.error!);
          } else {
            Get.snackbar('Success', 'Device registered');
            await providerDevice.open(tableDevices);
            await providerMedicineContainer.open(tableContainer);
            await providerDevice.insert(apiResponse.data as Devices);
            for (var container in (apiResponse.data as Devices).containers!) {
              await providerMedicineContainer.insert(container);
            }
            device = apiResponse.data as Devices;
            containers = device!.containers ?? [];
            update();
          }
        } catch (e) {
          Get.snackbar('Error', e.toString());
        }
      }
    }
  }

  void updateContainerDetail(
      {required int containerId,
      required String medicine,
      required int quantity,
      required int index}) async {
    ApiResponse apiResponse = ApiResponse();
    apiResponse = await updateContainer(
      deviceId: device!.id!,
      containerId: containerId,
      medicine: medicine,
      quantity: quantity,
    );

    if (apiResponse.error != null) {
      Get.snackbar('Error', apiResponse.error!);
    } else {
      containers[index] = apiResponse.data as MedicineContainer;
      update();
    }
    Get.back();
  }

  void settingContainer(int index) {
    int initQuantity = containers[index].quantity ?? 0;
    medicineNameController.text = containers[index].medicine ?? '';
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(10),
        height: 300,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey,
              spreadRadius: 5,
              blurRadius: 7,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: ListView(
          children: [
            Center(
              child: Text(
                'Container ${index + 1}',
                style: const TextStyle(fontSize: 20),
              ),
            ),
            TextFormField(
              controller: medicineNameController,
              decoration: const InputDecoration(
                hintText: 'Medicine name',
                // labelText: 'Medicine name',
              ),
            ),
            StatefulBuilder(builder: (context, setState) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      IconButton(
                        onPressed: () {
                          initQuantity =
                              (initQuantity > 0) ? initQuantity - 1 : 0;
                          setState(() {});
                        },
                        icon: const Icon(Icons.remove),
                      ),
                      Text(initQuantity.toString()),
                      IconButton(
                        onPressed: () {
                          initQuantity = initQuantity + 1;
                          setState(() {});
                        },
                        icon: const Icon(Icons.add),
                      ),
                    ],
                  ),
                  TextButton(
                    onPressed: () {
                      medicineNameController.clear();
                      initQuantity = 0;
                      setState(() {});
                    },
                    child: const Text('Reset'),
                  ),
                ],
              );
            }),
            ElevatedButton(
              onPressed: () => updateContainerDetail(
                containerId: containers[index].id,
                medicine: medicineNameController.text,
                quantity: initQuantity,
                index: index,
              ),
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
