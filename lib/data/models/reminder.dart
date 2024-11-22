import 'package:sqflite/sqflite.dart';

const String tableReminder = 'medicineReminder';
const String medicineReminderId = 'id';
const String medicineReminderName = 'medicineName';
const String medicineReminderDosageandTime = 'medicineDosageandTime';
const String medicineReminderStartDate = 'medicineStartDate';
const String medicineReminderEndDate = 'medicineEndDate';

class MedicineReminder {
  int id;
  final List<String> medicineName;
  final Map<String, List<String>> medicineDosageandTime;
  final DateTime medicineStartDate;
  final DateTime medicineEndDate;

  MedicineReminder({
    required this.id,
    required this.medicineName,
    required this.medicineDosageandTime,
    required this.medicineStartDate,
    required this.medicineEndDate,
  });

  Map<String, Object?> toMap() {
    return {
      medicineReminderId: id,
      medicineReminderName: medicineName,
      medicineReminderDosageandTime: medicineDosageandTime,
      medicineReminderStartDate: medicineStartDate,
      medicineReminderEndDate: medicineEndDate,
    };
  }

  factory MedicineReminder.fromMap(Map<String, Object?> map) {
    return MedicineReminder(
      id: map[medicineReminderId] as int,
      medicineName: map[medicineReminderName] as List<String>,
      medicineDosageandTime:
          map[medicineReminderDosageandTime] as Map<String, List<String>>,
      medicineStartDate: map[medicineReminderStartDate] as DateTime,
      medicineEndDate: map[medicineReminderEndDate] as DateTime,
    );
  }

  factory MedicineReminder.fromJson(Map<String, dynamic> json) {
    return MedicineReminder(
      id: json['id'],
      medicineName: json['medicineName'],
      medicineDosageandTime: json['medicineDosage'],
      medicineStartDate: json['medicineStartDate'],
      medicineEndDate: json['medicineEndDate'],
    );
  }
}

class ProviderMedicineReminder {
  late Database localdb;

  Future open(String path) async {
    localdb = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
      await db.execute('''
          create table $tableReminder ( 
            $medicineReminderId integer primary key autoincrement, 
            $medicineReminderName text not null,
            $medicineReminderDosageandTime text not null,
            $medicineReminderStartDate text not null,
            $medicineReminderEndDate text not null)
          ''');
    });
  }

  Future<MedicineReminder> insert(MedicineReminder reminder) async {
    reminder.id = await localdb.insert(tableReminder, reminder.toMap());
    return reminder;
  }

  Future<MedicineReminder> getReminder(int id) async {
    List<Map<String, Object?>> maps = await localdb.query(tableReminder,
        columns: [
          medicineReminderId,
          medicineReminderName,
          medicineReminderDosageandTime,
          medicineReminderStartDate,
          medicineReminderEndDate
        ],
        where: '$medicineReminderId = ?',
        whereArgs: [id]);
    if (maps.isNotEmpty) {
      return MedicineReminder.fromMap(maps.first);
    } else {
      throw Exception('ID $id not found');
    }
  }

  Future<int> delete(int id) async {
    return await localdb.delete(tableReminder,
        where: '$medicineReminderId = ?', whereArgs: [id]);
  }

  Future<int> update(MedicineReminder reminder) async {
    return await localdb.update(tableReminder, reminder.toMap(),
        where: '$medicineReminderId = ?', whereArgs: [reminder.id]);
  }

  Future<List<MedicineReminder>> getAllReminders() async {
    List<Map<String, Object?>> maps = await localdb.query(tableReminder);
    return List.generate(maps.length, (i) {
      return MedicineReminder(
        id: maps[i][medicineReminderId] as int,
        medicineName: maps[i][medicineReminderName] as List<String>,
        medicineDosageandTime:
            maps[i][medicineReminderDosageandTime] as Map<String, List<String>>,
        medicineStartDate: maps[i][medicineReminderStartDate] as DateTime,
        medicineEndDate: maps[i][medicineReminderEndDate] as DateTime,
      );
    });
  }
}
