import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:loqmtk_food_delivery_app/features/product/data/product_model.dart';
import 'package:loqmtk_food_delivery_app/features/product/data/product_repo.dart';
import 'package:loqmtk_food_delivery_app/shared/price_action_section.dart';
import 'package:loqmtk_food_delivery_app/features/product/widgets/custom_section.dart';
import 'package:loqmtk_food_delivery_app/features/product/widgets/spicy_slider.dart';
import 'package:skeletonizer/skeletonizer.dart';

class ProductDetailsView extends StatefulWidget {
  const ProductDetailsView({super.key});

  @override
  State<ProductDetailsView> createState() => _ProductDetailsViewState();
}

class _ProductDetailsViewState extends State<ProductDetailsView> {
  final ProductRepository productRepository = ProductRepository();
  final toppings = <ProductModel>[];
  // fetch toppings list from product repository and pass it to toppings variable
  Future<void> _fetchToppings() async {
    toppings.addAll(await productRepository.getToppings() ?? []);
  }

  // fetch side options list from product repository and pass it to sideOptions variable
  final sideOptions = <ProductModel>[];
  Future<void> _fetchSideOptions() async {
    sideOptions.addAll(await productRepository.getSideOptions() ?? []);
  }

  @override
  void initState() {
    super.initState();
    _fetchToppings();
    _fetchSideOptions();
  }

  double spicyLevel = 0.0;
  void _updateSpicyLevel(double value) {
    setState(() {
      spicyLevel = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      enabled: toppings.isEmpty && sideOptions.isEmpty,
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back_ios_new),
          ),
        ),

        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SpicySlider(
                  initialValue: spicyLevel,
                  onChanged: _updateSpicyLevel,
                ),
                //  ------------------ Toppings Section ------------------
                CustomSection(
                  sectionTitle: 'Toppings',
                  productModel: toppings,
                  onAdd: () {},
                ),
                //  ------------------ Side options Section ------------------
                CustomSection(
                  sectionTitle: 'Side options',
                  productModel: sideOptions,
                  onAdd: () {},
                ),
                Gap(30),
                //  ------------------ Add to Cart Section ------------------
                PriceActionSection(
                  price: '170.5',
                  onTap: () {},
                  buttonText: 'Add to Cart',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
