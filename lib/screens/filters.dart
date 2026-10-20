import 'package:flutter/material.dart';
import 'package:meals/models/filter.dart';

class FiltersScreen extends StatefulWidget {
  const FiltersScreen({super.key, required this.currentFilters});

  final Map<Filter, bool> currentFilters;

  @override
  State<FiltersScreen> createState() => _FiltersScreenState();
}

class _FiltersScreenState extends State<FiltersScreen> {
  var _glutenFreeFilterSet = false;
  var _lactoseFreeFilterSet = false;
  var _vegetarianFilterSet = false;
  var _veganFilterSet = false;

  @override
  void initState() {
    super.initState();
    _glutenFreeFilterSet = widget.currentFilters[Filter.glutenFree]!;
    _lactoseFreeFilterSet = widget.currentFilters[Filter.lactoseFree]!;
    _vegetarianFilterSet = widget.currentFilters[Filter.vegetarian]!;
    _veganFilterSet = widget.currentFilters[Filter.vegan]!;
  }

  Widget _buildSwitch(
    String title,
    String subtitle,
    bool value,
    void Function(bool) onChanged,
  ) {
    return SwitchListTile(
      value: value,
      onChanged: onChanged,
      title: Text(
        title,
        style: Theme.of(context).textTheme.titleLarge!.copyWith(
          color: Theme.of(context).colorScheme.onSurface,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: Theme.of(context).textTheme.labelMedium!.copyWith(
          color: Theme.of(context).colorScheme.onSurface,
        ),
      ),
      activeThumbColor: Theme.of(context).colorScheme.tertiary,
      contentPadding: const EdgeInsets.only(left: 34, right: 22),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;

        // pri návrate (Back) pošleme nastavené filtre späť do TabsScreen
        Navigator.of(context).pop({
          Filter.glutenFree: _glutenFreeFilterSet,
          Filter.lactoseFree: _lactoseFreeFilterSet,
          Filter.vegetarian: _vegetarianFilterSet,
          Filter.vegan: _veganFilterSet,
        });
      },
      child: Scaffold(
        appBar: AppBar(title: const Text('Your Filters')),
        body: Column(
          children: [
            _buildSwitch(
              'Gluten-free',
              'Only include gluten-free meals.',
              _glutenFreeFilterSet,
              (isChecked) => setState(() => _glutenFreeFilterSet = isChecked),
            ),
            _buildSwitch(
              'Lactose-free',
              'Only include lactose-free meals.',
              _lactoseFreeFilterSet,
              (isChecked) => setState(() => _lactoseFreeFilterSet = isChecked),
            ),
            _buildSwitch(
              'Vegetarian',
              'Only include vegetarian meals.',
              _vegetarianFilterSet,
              (isChecked) => setState(() => _vegetarianFilterSet = isChecked),
            ),
            _buildSwitch(
              'Vegan',
              'Only include vegan meals.',
              _veganFilterSet,
              (isChecked) => setState(() => _veganFilterSet = isChecked),
            ),
          ],
        ),
      ),
    );
  }
}
