import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SavedDropsNotifier extends StateNotifier<Set<int>> {
  static const _storageKey = 'saved_drops';

  SavedDropsNotifier() : super({}) {
    _loadSavedDrops();
  }

  Future<void> _loadSavedDrops() async {
    final prefs = await SharedPreferences.getInstance();
    final savedList = prefs.getStringList(_storageKey) ?? [];
    state = savedList
        .map((e) => int.tryParse(e))
        .whereType<int>() // Filter out nulls
        .toSet();
  }

  Future<void> toggleSave(int dropId) async {
    // 1. Optimistic update (instant UI change)
    if (state.contains(dropId)) {
      state = {...state}..remove(dropId);
    } else {
      state = {...state}..add(dropId);
    }

    // 2. Persist to storage
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(
        _storageKey, state.map((e) => e.toString()).toList());
  }

  bool isSaved(int dropId) => state.contains(dropId);
}

final savedDropsProvider =
    StateNotifierProvider<SavedDropsNotifier, Set<int>>((ref) {
  return SavedDropsNotifier();
});
