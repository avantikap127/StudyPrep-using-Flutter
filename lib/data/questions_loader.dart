import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:uuid/uuid.dart';
import '../models/flashcard.dart';

class QuestionsLoader {
  // loads bundled assets/questions.json and converts to list<Flashcard>
  static Future<List<Flashcard>> loadFromAsset() async {
    final text = await rootBundle.loadString('assets/questions.json');
    final Map<String, dynamic> data = json.decode(text);
    final uu = Uuid();
    final List<Flashcard> out = [];
    data.forEach((subject, items) {
      for (var it in items) {
        out.add(Flashcard(
          id: uu.v4(),
          subject: subject,
          topic: it['topic'] ?? '',
          question: it['question'] ?? '',
          answer: it['answer'] ?? '',
        ));
      }
    });
    return out;
  }
}
