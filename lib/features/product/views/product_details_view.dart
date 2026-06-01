import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:loqmtk_food_delivery_app/features/product/data/product_model.dart';
import 'package:loqmtk_food_delivery_app/features/product/data/product_repo.dart';
import 'package:loqmtk_food_delivery_app/shared/price_action_section.dart';
import 'package:loqmtk_food_delivery_app/features/product/widgets/custom_section.dart';
import 'package:loqmtk_food_delivery_app/features/product/widgets/spicy_slider.dart';
import 'package:skeletonizer/skeletonizer.dart';

class ProductDetailsView extends StatefulWidget {
  final String productImage;
  const ProductDetailsView({super.key, required this.productImage});

  @override
  State<ProductDetailsView> createState() => _ProductDetailsViewState();
}

class _ProductDetailsViewState extends State<ProductDetailsView> {
  // ---- fetching toppings and side options data ----
  final ProductRepository productRepository = ProductRepository();

  bool isToppingsLoading = true;
  bool isSideOptionsLoading = true;

  final toppings = <ProductModel>[];
  final sideOptions = <ProductModel>[];

  Future<void> _fetchToppings() async {
    try {
      isToppingsLoading = true;
      List<ProductModel>? fetchedToppings = await productRepository
          .getToppings();

      if (mounted) {
        setState(() {
          if (fetchedToppings != null) {
            toppings.addAll(fetchedToppings);
          }
          isToppingsLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          isToppingsLoading = false;
          toppings.clear();
        });
      }
    }
  }

  Future<void> _fetchSideOptions() async {
    try {
      isSideOptionsLoading = true;
      List<ProductModel>? fetchedSideOptions = await productRepository
          .getSideOptions();

      if (mounted) {
        setState(() {
          if (fetchedSideOptions != null) {
            sideOptions.addAll(fetchedSideOptions);
          }
          isSideOptionsLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          sideOptions.clear();
          isSideOptionsLoading = false;
        });
      }
    }
  }
  // ---- end of fetching toppings and side options data ----

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
      enabled: isToppingsLoading || isSideOptionsLoading,
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
                  productImage: widget.productImage,
                  onChanged: _updateSpicyLevel,
                ),
                //  ------------------ Toppings Section ------------------
                CustomSection(
                  sectionTitle: 'Toppings',
                  productModel: toppings,
                  onAdd: () {},
                ),
                Gap(20),
                //  ------------------ Side options Section ------------------
                CustomSection(
                  sectionTitle: 'Side options',
                  productModel: sideOptions,
                  onAdd: () {},
                ),
                Gap(80),
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
