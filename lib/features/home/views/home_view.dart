import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:loqmtk_food_delivery_app/features/home/models/food_item_model.dart';
import 'package:loqmtk_food_delivery_app/features/home/widgets/category_item.dart';
import 'package:loqmtk_food_delivery_app/features/home/widgets/food_categories.dart';
import 'package:loqmtk_food_delivery_app/features/home/widgets/home_header.dart';
import 'package:loqmtk_food_delivery_app/features/home/widgets/promo_code.dart';
import 'package:loqmtk_food_delivery_app/features/home/widgets/search_field.dart';
import 'package:loqmtk_food_delivery_app/features/home/widgets/section_title.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  // list of categories
  final List<String> _categories = <String>[
    'All',
    'Combos',
    'Sliders',
    'Classic',
  ];

  final int _selectedCategoryIndex = 0;
  // list of popular items
  final List<FoodItem> _popularItems = <FoodItem>[
    const FoodItem(
      title: 'Classic Burger',
      subtitle: 'Cheese, onion, special sauce',
      price: 12.50,
      imageUrl:
          'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?w=1200',
      rating: 4.8,
    ),
    const FoodItem(
      title: 'Pepperoni Pizza',
      subtitle: 'Mozzarella, tomato sauce',
      price: 15.00,
      imageUrl:
          'https://images.unsplash.com/photo-1513104890138-7c749659a591?w=1200',
      rating: 4.7,
    ),
    const FoodItem(
      title: 'Salmon Sushi',
      subtitle: 'Fresh salmon and rice roll',
      price: 18.90,
      imageUrl:
          'https://images.unsplash.com/photo-1579871494447-9811cf80d66c?w=1200',
      rating: 4.9,
    ),
    const FoodItem(
      title: 'Classic Burger',
      subtitle: 'Cheese, onion, special sauce',
      price: 12.50,
      imageUrl:
          'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?w=1200',
      rating: 4.8,
    ),
    const FoodItem(
      title: 'Pepperoni Pizza',
      subtitle: 'Mozzarella, tomato sauce',
      price: 15.00,
      imageUrl:
          'https://images.unsplash.com/photo-1513104890138-7c749659a591?w=1200',
      rating: 4.7,
    ),
    const FoodItem(
      title: 'Salmon Sushi',
      subtitle: 'Fresh salmon and rice roll',
      price: 18.90,
      imageUrl:
          'https://images.unsplash.com/photo-1579871494447-9811cf80d66c?w=1200',
      rating: 4.9,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FB),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SafeArea(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
            children: [
              Gap(15),
              buildHomeHeader(),
              Gap(22),
              buildSearchField(),
              Gap(22),
              buildPromoCard(),
              Gap(22),
              buildSectionTitle('Categories', onSeeAllTap: () {}),
              Gap(12),
              FoodCategories(
                categories: _categories,
                selectedCategoryIndex: _selectedCategoryIndex,
              ),
              Gap(22),
              ..._popularItems.map((FoodItem item) => CategoryItem(item: item)),
            ],
          ),
        ),
      ),
    );
  }
}
