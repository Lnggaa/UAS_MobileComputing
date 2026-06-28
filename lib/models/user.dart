import 'package:hive/hive.dart';

part 'user.g.dart';

@HiveType(typeId: 1)
class User extends HiveObject {
  @HiveField(0)
  String name;

  @HiveField(1)
  String password;

  @HiveField(2)
  String? photoPath;

  @HiveField(3)
  bool hasSeenOnboarding;

  User({
    required this.name,
    required this.password,
    this.photoPath,
    this.hasSeenOnboarding = false,
  });
}
