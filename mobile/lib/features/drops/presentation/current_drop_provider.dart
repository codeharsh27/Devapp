import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../domain/drop.dart';

class CurrentDropNotifier extends StateNotifier<Drop?> {
  CurrentDropNotifier() : super(null) {
    _loadState();
  }

  Future<void> _loadState() async {
    final prefs = await SharedPreferences.getInstance();
    final String? dropJson = prefs.getString('active_drop');
    if (dropJson != null) {
      try {
        state = Drop.fromJson(jsonDecode(dropJson));
      } catch (e) {
        prefs.remove('active_drop');
      }
    }
  }

  Future<void> setDrop(Drop drop) async {
    state = drop;
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('active_drop', jsonEncode(drop.toJson()));
  }

  Future<void> clearDrop() async {
    state = null;
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('active_drop');
  }
}

final currentDropProvider =
    StateNotifierProvider<CurrentDropNotifier, Drop?>((ref) {
  return CurrentDropNotifier();
});
