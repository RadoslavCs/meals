import 'package:shared_preferences/shared_preferences.dart';
import 'package:meals/models/filter.dart';

/// Ukladanie obľúbených jedál a filtrov do pamäte zariadenia
/// (bonus – SharedPreferences).
class PreferencesService {
  static const _favoritesKey = 'favorite_meal_ids';

  static const _filterKeys = <Filter, String>{
    Filter.glutenFree: 'filter_gluten_free',
    Filter.lactoseFree: 'filter_lactose_free',
    Filter.vegetarian: 'filter_vegetarian',
    Filter.vegan: 'filter_vegan',
  };

  // ---------- Obľúbené jedlá (ukladáme len ich id) ----------

  static Future<List<String>> loadFavoriteIds() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_favoritesKey) ?? [];
  }

  static Future<void> saveFavoriteIds(List<String> ids) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_favoritesKey, ids);
  }

  // ---------- Filtre ----------

  static Future<Map<Filter, bool>> loadFilters() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      for (final entry in _filterKeys.entries)
        entry.key: prefs.getBool(entry.value) ?? false,
    };
  }

  static Future<void> saveFilters(Map<Filter, bool> filters) async {
    final prefs = await SharedPreferences.getInstance();
    for (final entry in _filterKeys.entries) {
      await prefs.setBool(entry.value, filters[entry.key] ?? false);
    }
  }
}
