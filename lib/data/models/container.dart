import 'package:sqflite/sqflite.dart';

const String tableContainer = 'medicineContainer';
const String medicineContainerId = 'id';
const String medicineContainerMedicine = 'medicine';
const String medicineContainerQuantity = 'quantity';

class MedicineContainer {
  int id;
  String medicine;
  int quantity;

  MedicineContainer({
    required this.id,
    required this.medicine,
    required this.quantity,
  });

  Map<String, Object?> toMap() {
    return {
      medicineContainerId: id,
      medicineContainerMedicine: medicine,
      medicineContainerQuantity: quantity,
    };
  }

  factory MedicineContainer.fromMap(Map<String, Object?> map) {
    return MedicineContainer(
      id: map[medicineContainerId] as int,
      medicine: map[medicineContainerMedicine] as String,
      quantity: map[medicineContainerQuantity] as int,
    );
  }

  factory MedicineContainer.fromJson(Map<String, dynamic> json) {
    return MedicineContainer(
      id: json['container_id'],
      medicine: json['medicine_name'],
      quantity: json['quantity'],
    );
  }

  static List<MedicineContainer> fromJsonList(List<dynamic> json) {
    List<MedicineContainer> containers = [];
    for (var container in json) {
      containers.add(MedicineContainer.fromJson(container));
    }
    return containers;
  }

  static List<Map<String, Object?>> toMapList(
      List<MedicineContainer> containers) {
    List<Map<String, Object?>> containerList = [];
    for (var container in containers) {
      containerList.add(container.toMap());
    }
    return containerList;
  }

  static toJsonList(List<MedicineContainer>? containers) {
    List<Map<String, Object?>> containerList = [];
    if (containers != null) {
      for (var container in containers) {
        containerList.add(container.toMap());
      }
    }
    return containerList;
  }

  static fromMapList(List map) {
    List<MedicineContainer> containers = [];
    for (var container in map) {
      containers.add(MedicineContainer.fromMap(container));
    }
    return containers;
  }
}

class ProviderMedicineContainer {
  late Database localdb;

  Future open(String path) async {
    localdb = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
      await db.execute('''
          create table $tableContainer ( 
            $medicineContainerId integer primary key autoincrement, 
            $medicineContainerMedicine text not null,
            $medicineContainerQuantity integer not null)
          ''');
    });
  }

  Future<MedicineContainer> insert(MedicineContainer container) async {
    container.id = await localdb.insert(tableContainer, container.toMap());
    return container;
  }

  Future<MedicineContainer> getContainer(int id) async {
    List<Map<String, Object?>> maps = await localdb.query(
      tableContainer,
      columns: [
        medicineContainerId,
        medicineContainerMedicine,
        medicineContainerQuantity
      ],
      where: '$medicineContainerId = ?',
      whereArgs: [id],
    );
    if (maps.isNotEmpty) {
      return MedicineContainer.fromMap(maps.first);
    } else {
      throw Exception('ID $id not found');
    }
  }

  Future<int> update(MedicineContainer container) async {
    return await localdb.update(
      tableContainer,
      container.toMap(),
      where: '$medicineContainerId = ?',
      whereArgs: [container.id],
    );
  }

  Future<int> delete(int id) async {
    return await localdb.delete(
      tableContainer,
      where: '$medicineContainerId = ?',
      whereArgs: [id],
    );
  }

  Future<List<MedicineContainer>> getAllContainers() async {
    List<Map<String, Object?>> maps = await localdb.query(tableContainer);
    return List.generate(maps.length, (i) {
      return MedicineContainer(
        id: maps[i][medicineContainerId] as int,
        medicine: maps[i][medicineContainerMedicine] as String,
        quantity: maps[i][medicineContainerQuantity] as int,
      );
    });
  }
}
