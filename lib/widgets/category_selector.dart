import 'package:flutter/material.dart';
import '../constants.dart';

class CategorySelector extends StatelessWidget {
  final String selectedCategory;
  final Function(String) onCategorySelected;

  const CategorySelector({
    Key? key,
    required this.selectedCategory,
    required this.onCategorySelected,
  }) : super(key: key);

  static const List<String> categories = [
    'All',
    'Fantasy',
    'Romance',
    'Science',
    'Business',
    'Technology',
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: categories.length,
        padding:
            const EdgeInsets.symmetric(horizontal: AppConstants.paddingMedium),
        itemBuilder: (context, index) {
          final category = categories[index];
          final isSelected = selectedCategory == category;

          return Padding(
            padding: const EdgeInsets.only(right: 10),
            child: ChoiceChip(
              label: Text(
                category,
                style: TextStyle(
                  color: isSelected
                      ? Colors.white
                      : Theme.of(context)
                          .colorScheme
                          .onBackground
                          .withOpacity(0.8),
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
              selected: isSelected,
              onSelected: (_) => onCategorySelected(category),
              selectedColor: AppConstants.primaryColor,
              backgroundColor: Theme.of(context).cardTheme.color,
              checkmarkColor: Colors.white,
              elevation: isSelected ? 3 : 0,
              pressElevation: 1,
              shadowColor: AppConstants.primaryColor.withOpacity(0.2),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: BorderSide(
                  color: isSelected
                      ? Colors.transparent
                      : Theme.of(context)
                          .colorScheme
                          .onBackground
                          .withOpacity(0.1),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
