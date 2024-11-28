import 'package:sqflite/sqflite.dart';

const String tableContainer = 'medicineContainer';
const String medicineContainerId = 'id';
const String medicineContainerMedicine = 'medicine';
const String medicineContainerQuantity = 'quantity';

class MedicineContainer {
  int id;
  String? medicine;
  int? quantity;

  MedicineContainer({
    required this.id,
    this.medicine,
    this.quantity,
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
      id: json['container_id'] as int,
      medicine: json['medicine_name'] as String?,
      quantity: json['quantity'] as int?,
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
    localdb = await openDatabase(
      path,
      version: 2,
      onCreate: (Database db, int version) async {
        await db.execute('''
          create table $tableContainer ( 
            $medicineContainerId integer primary key autoincrement, 
            $medicineContainerMedicine text,
            $medicineContainerQuantity integer)
          ''');
      },
      onUpgrade: (Database db, int oldVersion, int newVersion) async {
        if (oldVersion < newVersion) {
          await db.execute('DROP TABLE IF EXISTS $tableContainer');
          await db.execute('''
            create table $tableContainer ( 
              $medicineContainerId integer primary key autoincrement, 
              $medicineContainerMedicine text,
              $medicineContainerQuantity integer)
            ''');
        }
      },
    );
  }

  Future<MedicineContainer> insert(MedicineContainer container) async {
    container.id = await localdb.insert(tableContainer, container.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);

    return container;
  }

  Future<void> insertAll(List<Map<String, Object?>> containers) async {
    Batch batch = localdb.batch();
    for (var container in containers) {
      batch.insert(tableContainer, container,
          conflictAlgorithm: ConflictAlgorithm.replace);
    }
    await batch.commit();
  }

  Future<MedicineContainer?> getContainer() async {
    List<Map<String, Object?>> maps = await localdb.query(
      tableContainer,
      columns: [
        medicineContainerId,
        medicineContainerMedicine,
        medicineContainerQuantity
      ],
    );
    if (maps.isNotEmpty) {
      return MedicineContainer.fromMap(maps.first);
    } else {
      return null;
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
        medicine: maps[i][medicineContainerMedicine] as String?,
        quantity: maps[i][medicineContainerQuantity] as int?,
      );
    });
  }

  Future<void> close() async => localdb.close();

  Future<void> reset() async {
    await localdb.delete(tableContainer);
  }
}
