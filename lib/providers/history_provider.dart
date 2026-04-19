import 'package:flutter/foundation.dart';
import '../models/calculation_history.dart';
import '../services/storage_service.dart';

class HistoryProvider extends ChangeNotifier {
  final StorageService _storage;
  List<CalculationHistory> _history = [];
  int _maxSize = 50;

  HistoryProvider(this._storage);

  List<CalculationHistory> get history => _history;
  List<CalculationHistory> get recentHistory =>
      _history.length > 3 ? _history.sublist(0, 3) : _history;

  Future<void> init() async {
    _history = await _storage.loadHistory();
    final settings = await _storage.loadSettings();
    _maxSize = settings.historySize;
    notifyListeners();
  }

  void setMaxSize(int size) {
    _maxSize = size;
    if (_history.length > _maxSize) {
      _history = _history.sublist(0, _maxSize);
      _storage.saveHistory(_history);
    }
    notifyListeners();
  }

  void addEntry(CalculationHistory entry) {
    _history.insert(0, entry);
    if (_history.length > _maxSize) {
      _history = _history.sublist(0, _maxSize);
    }
    _storage.saveHistory(_history);
    notifyListeners();
  }

  void clearHistory() {
    _history.clear();
    _storage.clearHistory();
    notifyListeners();
  }

  void removeEntry(int index) {
    if (index >= 0 && index < _history.length) {
      _history.removeAt(index);
      _storage.saveHistory(_history);
      notifyListeners();
    }
  }
}
