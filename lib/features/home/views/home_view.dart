import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:loqmtk_food_delivery_app/features/home/data/home_repo.dart';
import 'package:loqmtk_food_delivery_app/features/home/data/item_model.dart';
import 'package:loqmtk_food_delivery_app/features/home/widgets/category_item.dart';
import 'package:loqmtk_food_delivery_app/features/home/widgets/food_categories.dart';
import 'package:loqmtk_food_delivery_app/features/home/widgets/home_header.dart';
import 'package:loqmtk_food_delivery_app/features/home/widgets/promo_code.dart';
import 'package:loqmtk_food_delivery_app/features/home/widgets/search_field.dart';
import 'package:loqmtk_food_delivery_app/features/home/widgets/section_title.dart';
import 'package:loqmtk_food_delivery_app/features/product/views/product_details_view.dart';

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

  List<ItemModel> _popularItems = [];
  final HomeRepo _homeRepo = HomeRepo();
  Future<void> _getPopularItems() async {
    try {
      List<ItemModel> items = await _homeRepo.getProducts();
      setState(() {
        _popularItems = items;
      });
    } catch (e) {
      if (mounted) {
        setState(() {
          _popularItems = [];
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _getPopularItems();
  }

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
              ..._popularItems.map(
                (ItemModel item) => GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return ProductDetailsView(productImage: item.image);
                        },
                      ),
                    );
                  },
                  child: CategoryItem(item: item),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
