import 'package:smart_dispencer/data/models/container.dart';
import 'package:sqflite/sqflite.dart';

const String tableDevices = 'device';
const String columnId = 'id';
const String columnUid = 'uid';
const String columnCurrentState = 'currentState';
const String columnStatus = 'status';

class Devices {
  int? id;
  final String uid;
  int currentState = 0;
  String? status;
  List<MedicineContainer>? containers;

  Devices({
    this.id,
    required this.uid,
    this.currentState = 0,
    this.status,
    this.containers,
  });

  factory Devices.fromJson(Map<String, dynamic> json) {
    return Devices(
      id: json['id'],
      uid: json['uid'],
      currentState: json['current_state'],
      status: json['status'],
      containers: MedicineContainer.fromJsonList(json['device_content']),
    );
  }

  Map<String, Object?> toMap() {
    return {
      columnId: id,
      columnUid: uid,
      columnCurrentState: currentState,
      columnStatus: status,
    };
  }

  factory Devices.fromMap(Map<String, Object?> map) {
    return Devices(
      id: map[columnId] as int?,
      uid: map[columnUid] as String,
      currentState: map[columnCurrentState] as int,
      status: map[columnStatus] as String?,
    );
  }
}

class ProviderDevice {
  late Database localdb;

  Future<void> open(String path) async {
    localdb = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
      await db.execute('''
          CREATE TABLE $tableDevices (
            $columnId TEXT PRIMARY KEY,
            $columnUid TEXT NOT NULL,
            $columnCurrentState INTEGER,
            $columnStatus TEXT,
          )
          ''');
    });
  }

  // insert or replace
  Future<Devices> insert(Devices device) async {
    await localdb.delete(tableDevices);

    device.id = await localdb!.insert(tableDevices, device.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
    return device;
  }

  Future<Devices> getDevice(String uid) async {
    List<Map<String, Object?>> maps = await localdb!.query(tableDevices,
        columns: [
          columnId,
          columnUid,
          columnCurrentState,
          columnStatus,
        ],
        where: '$columnUid = ?',
        limit: 1,
        whereArgs: [uid]);
    if (maps.isNotEmpty) {
      return Devices.fromMap(maps.first);
    } else {
      throw Exception('Device not found');
    }
  }

  Future<int> delete(String uid) async {
    return await localdb!
        .delete(tableDevices, where: '$columnUid = ?', whereArgs: [uid]);
  }

  Future<int> update(Devices device) async {
    return await localdb!.update(tableDevices, device.toMap(),
        where: '$columnId = ?', whereArgs: [device.id]);
  }

  Future close() async => localdb!.close();

  Future<void> reset() async {
    await localdb!.delete(tableDevices);
  }
}
