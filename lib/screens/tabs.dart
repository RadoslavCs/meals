import 'package:flutter/material.dart';
import 'package:meals/data/dummy_data.dart';
import 'package:meals/models/filter.dart';
import 'package:meals/models/meal.dart';
import 'package:meals/screens/categories.dart';
import 'package:meals/screens/filters.dart';
import 'package:meals/screens/meals.dart';
import 'package:meals/services/preferences_service.dart';
import 'package:meals/widgets/main_drawer.dart';

// východiskové filtre
const kInitialFilters = {
  Filter.glutenFree: false,
  Filter.lactoseFree: false,
  Filter.vegetarian: false,
  Filter.vegan: false,
};

class TabsScreen extends StatefulWidget {
  const TabsScreen({super.key});

  @override
  State<TabsScreen> createState() => _TabsScreenState();
}

class _TabsScreenState extends State<TabsScreen> {
  int _selectedPageIndex = 0;

  // Zoznam sa nikdy nenahrádza novým objektom, len sa mení (add/remove),
  // vďaka čomu ho vidia aj obrazovky otvorené cez Navigator.push().
  final List<Meal> _favoriteMeals = [];

  // Aktuálne zvolené filtre
  Map<Filter, bool> _selectedFilters = kInitialFilters;

  @override
  void initState() {
    super.initState();
    _loadSavedData();
  }

  // Načítanie uložených obľúbených jedál a filtrov (bonus)
  Future<void> _loadSavedData() async {
    final favoriteIds = await PreferencesService.loadFavoriteIds();
    final filters = await PreferencesService.loadFilters();

    if (!mounted) return;

    final mealsById = {for (final meal in dummyMeals) meal.id: meal};

    setState(() {
      _favoriteMeals
        ..clear()
        ..addAll(
          favoriteIds.where(mealsById.containsKey).map((id) => mealsById[id]!),
        );
      _selectedFilters = filters;
    });
  }

  void _saveFavorites() {
    PreferencesService.saveFavoriteIds(
      _favoriteMeals.map((meal) => meal.id).toList(),
    );
  }

  // Filtrovanie jedál podľa aktívnych filtrov
  List<Meal> get _availableMeals {
    return dummyMeals.where((meal) {
      if (_selectedFilters[Filter.glutenFree]! && !meal.isGlutenFree) {
        return false;
      }
      if (_selectedFilters[Filter.lactoseFree]! && !meal.isLactoseFree) {
        return false;
      }
      if (_selectedFilters[Filter.vegetarian]! && !meal.isVegetarian) {
        return false;
      }
      if (_selectedFilters[Filter.vegan]! && !meal.isVegan) {
        return false;
      }
      return true;
    }).toList();
  }

  // Otvorenie FiltersScreen z Draweru
  void _setScreen(String identifier) async {
    Navigator.of(context).pop(); // zatvorí Drawer

    if (identifier == 'filters') {
      final result = await Navigator.of(context).push<Map<Filter, bool>>(
        MaterialPageRoute(
          builder: (ctx) => FiltersScreen(
            currentFilters: _selectedFilters, // odosielame aktuálne filtre
          ),
        ),
      );

      if (!mounted) return;

      setState(() {
        _selectedFilters = result ?? kInitialFilters; // aktualizácia filtrov
      });
      PreferencesService.saveFilters(_selectedFilters); // uloženie (bonus)
    }
  }

  void _toggleMealFavoriteStatus(Meal meal) {
    final isExisting = _favoriteMeals.contains(meal);

    setState(() {
      if (isExisting) {
        _favoriteMeals.remove(meal);
        _showInfoMessage('Meal removed from favorites.');
      } else {
        _favoriteMeals.add(meal);
        _showInfoMessage('Meal added to favorites!');
      }
    });
    _saveFavorites(); // uloženie (bonus)
  }

  void _selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  void _showInfoMessage(String message) {
    ScaffoldMessenger.of(context)
      ..clearSnackBars() // zruší predchádzajúce hlásenie
      ..showSnackBar(
        SnackBar(content: Text(message), duration: const Duration(seconds: 3)),
      );
  }

  @override
  Widget build(BuildContext context) {
    Widget activePage = CategoriesScreen(
      onToggleFavorite: _toggleMealFavoriteStatus,
      availableMeals: _availableMeals, // posielame prefiltrované jedlá
      favoriteMeals: _favoriteMeals,
    );
    String activePageTitle = 'Categories';

    if (_selectedPageIndex == 1) {
      activePage = MealsScreen(
        meals: _favoriteMeals, // odovzdanie obľúbených jedál
        favoriteMeals: _favoriteMeals,
        onToggleFavorite: _toggleMealFavoriteStatus, // funkcia z TabsScreen
      );
      activePageTitle = 'Your Favorites';
    }

    return Scaffold(
      appBar: AppBar(title: Text(activePageTitle)),
      body: activePage,
      drawer: MainDrawer(onSelectScreen: _setScreen),
      bottomNavigationBar: BottomNavigationBar(
        onTap: _selectPage,
        currentIndex: _selectedPageIndex,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.set_meal),
            label: 'Categories',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.star), label: 'Favorites'),
        ],
      ),
    );
  }
}
