import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/flashcard.dart';
import 'package:uuid/uuid.dart';

class FlashcardProvider with ChangeNotifier {
  List<Flashcard> _cards = [];
  late Box _box;

  List<Flashcard> get cards => _cards;

  Future<void> load(Box box) async {
    _box = box;
    _cards = box.values.map((e) => e as Flashcard).toList();
    notifyListeners();
  }

  void addCard(Flashcard card) {
    _box.add(card);
    _cards.add(card);
    notifyListeners();
  }

  // ⭐ EASY = difficulty = 0
  // ⭐ HARD = difficulty >= 1

  // ------------------------------
  // NORMAL STUDY DECK
  // Hard + Not attempted
  // ------------------------------
  List<Flashcard> getStudyDeck() {
    return _cards.where((c) => c.difficulty >= 0).toList();
  }

  // ------------------------------
  // HARD CARDS ONLY (REVISION)
  // ------------------------------
  List<Flashcard> getHardCardsDeck() {
    return _cards.where((c) => c.difficulty >= 1).toList();
  }

  // ------------------------------
  // MOST DIFFICULT (difficulty ≥ 2)
  // ------------------------------
  List<Flashcard> getMostDifficultCards() {
    return _cards.where((c) => c.difficulty >= 2).toList();
  }

  // ------------------------------
  // UPDATE difficulty
  // ------------------------------
  void markEasy(Flashcard card) {
    card.difficulty = 0;
    card.save();
    notifyListeners();
  }

  void markHard(Flashcard card) {
    card.difficulty += 1;
    card.save();
    notifyListeners();
  }

void createEmptySubject(String subjectName) {
  final id = const Uuid().v4(); // generate unique ID

  addCard(
    Flashcard(
      id: id,
      subject: subjectName,
      topic: "General",
      question: "This is an empty subject.",
      answer: "Add cards to this subject.",
      difficulty: 0,
    ),
  );
}

}
