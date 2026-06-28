import 'package:hive/hive.dart';

part 'journal.g.dart';

@HiveType(typeId: 0)
class Journal extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String title;

  @HiveField(2)
  String location;

  @HiveField(3)
  DateTime travelDate;

  @HiveField(4)
  String story;

  @HiveField(5)
  String? imagePath;

  @HiveField(6)
  DateTime createdAt;

  Journal({
    required this.id,
    required this.title,
    required this.location,
    required this.travelDate,
    required this.story,
    this.imagePath,
    required this.createdAt,
  });
}
