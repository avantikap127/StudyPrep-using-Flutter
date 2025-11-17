import 'package:hive/hive.dart';
part 'flashcard.g.dart';

@HiveType(typeId: 0)
class Flashcard extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String subject;

  @HiveField(2)
  String topic;

  @HiveField(3)
  String question;

  @HiveField(4)
  String answer;

  @HiveField(5)
  int difficulty;

  Flashcard({
    required this.id,
    required this.subject,
    required this.topic,
    required this.question,
    required this.answer,
    this.difficulty = 0,
  });

  void markEasy() {
    if (difficulty > 0) difficulty -= 1;
  }

  void markHard() {
    difficulty += 1;
  }
}
