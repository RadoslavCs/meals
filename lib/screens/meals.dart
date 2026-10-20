import 'package:flutter/material.dart';
import 'package:meals/models/meal.dart';
import 'package:meals/screens/meal_details.dart';
import 'package:meals/widgets/meal_item.dart';

class MealsScreen extends StatelessWidget {
  final String? title;
  final List<Meal> meals;
  final List<Meal> favoriteMeals;
  final void Function(Meal meal) onToggleFavorite;

  const MealsScreen({
    super.key,
    this.title,
    required this.meals,
    required this.favoriteMeals,
    required this.onToggleFavorite,
  });

  void _selectMeal(BuildContext context, Meal meal) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) => MealDetailsScreen(
          meal: meal,
          isFavorite: favoriteMeals.contains(meal),
          onToggleFavorite: onToggleFavorite, // odovzdanie funkcie ďalej
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // obsah obrazovky – buď zoznam jedál alebo prázdna správa
    Widget content = ListView.builder(
      itemCount: meals.length,
      itemBuilder: (ctx, index) {
        return MealItem(
          meal: meals[index],
          onSelectMeal: (meal) {
            _selectMeal(ctx, meal);
          },
        );
      },
    );

    if (meals.isEmpty) {
      content = Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Uh oh... nothing here!',
              style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Try selecting a different category!',
              style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
          ],
        ),
      );
    }

    // ak nie je nastavený title (napr. pri Favorites v TabsScreen),
    // zobraz len obsah bez Scaffoldu a AppBaru.
    if (title == null) {
      return content;
    }

    // inak zobraz obrazovku so Scaffoldom a AppBarom
    return Scaffold(
      appBar: AppBar(title: Text(title!)),
      body: content,
    );
  }
}
