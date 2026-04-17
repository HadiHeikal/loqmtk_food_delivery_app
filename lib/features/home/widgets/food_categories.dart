import 'package:flutter/material.dart';

class FoodCategories extends StatefulWidget {
  const FoodCategories({
    super.key,
    required this.categories,
    required this.selectedCategoryIndex,
  });
  final int selectedCategoryIndex;
  final List categories;
  @override
  State<FoodCategories> createState() => _FoodCategoriesState();
}

class _FoodCategoriesState extends State<FoodCategories> {
  late int _selectedCategoryIndex;
  late List categories;

  @override
  void initState() {
    super.initState();
    _selectedCategoryIndex = widget.selectedCategoryIndex;
    categories = widget.categories;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 44,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemBuilder: (BuildContext context, int index) {
          final bool isSelected = _selectedCategoryIndex == index;
          return InkWell(
            borderRadius: BorderRadius.circular(22),
            onTap: () {
              setState(() {
                _selectedCategoryIndex = index;
              });
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
              decoration: BoxDecoration(
                color: isSelected ? const Color(0xFFFF5B2E) : Colors.white,
                borderRadius: BorderRadius.circular(22),
              ),
              child: Text(
                categories[index],
                style: TextStyle(
                  color: isSelected ? Colors.white : const Color(0xFF1C1C1E),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          );
        },
        separatorBuilder: (_, _) => const SizedBox(width: 10),
        itemCount: categories.length,
      ),
    );
  }
}
