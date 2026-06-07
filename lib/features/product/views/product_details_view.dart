import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:loqmtk_food_delivery_app/core/services/api_error.dart';
import 'package:loqmtk_food_delivery_app/core/utils/pref_helper.dart';
import 'package:loqmtk_food_delivery_app/features/cart/data/add_to_cart_models/add_to_cart_model.dart';
import 'package:loqmtk_food_delivery_app/features/cart/data/add_to_cart_models/cart_model.dart';
import 'package:loqmtk_food_delivery_app/features/cart/data/cart_repo/cart_repo.dart';
import 'package:loqmtk_food_delivery_app/features/product/data/product_model.dart';
import 'package:loqmtk_food_delivery_app/features/product/data/product_repo.dart';
import 'package:loqmtk_food_delivery_app/shared/price_action_section.dart';
import 'package:loqmtk_food_delivery_app/features/product/widgets/custom_section.dart';
import 'package:loqmtk_food_delivery_app/features/product/widgets/spicy_slider.dart';
import 'package:skeletonizer/skeletonizer.dart';

class ProductDetailsView extends StatefulWidget {
  final String productImage;
  final int productId;
  const ProductDetailsView({
    super.key,
    required this.productImage,
    required this.productId,
  });

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

  // ---- Add to cart handing ----
  final bool isToppingSelected = false;
  final bool isOptionSelected = false;

  List<int> selectedToppingsIndicies = [];
  List<int> selectedOptionsIndicies = [];

  // ---- end of Add to cart handing ----

  // ---- Add to cart loading state ----
  bool isLoading = false;

  // toggle topping selection
  void toggleToppingIndicies(int index) {
    setState(() {
      if (selectedToppingsIndicies.contains(index)) {
        selectedToppingsIndicies.remove(index);
      } else {
        selectedToppingsIndicies.add(index);
      }
    });
  }

  // toggle side option selection
  void toggleOptionIndicies(int index) {
    setState(() {
      if (selectedOptionsIndicies.contains(index)) {
        selectedOptionsIndicies.remove(index);
      } else {
        selectedOptionsIndicies.add(index);
      }
    });
  }
  // ---- end of Add to cart loading state ----

  @override
  void initState() {
    super.initState();
    _fetchToppings();
    _fetchSideOptions();
  }

  double spicyLevel = 0.1;
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
                //  ----- Toppings Section configuration with selection handling -----
                CustomSection(
                  selectedIndices: selectedToppingsIndicies,
                  sectionTitle: 'Toppings',
                  productModel: toppings,
                  onAdd: toggleToppingIndicies,
                ),
                Gap(20),
                //  ------------------ Side options Section ------------------
                CustomSection(
                  selectedIndices: selectedOptionsIndicies,
                  sectionTitle: 'Side options',
                  productModel: sideOptions,
                  onAdd: toggleOptionIndicies,
                ),
                Gap(80),
                //  ------------------ Add to Cart Section ------------------
                PriceActionSection(
                  price: '170.5',
                  onTap: () async {
                    final token = await PrefHelper.getToken();
                    if (token == null || token.isEmpty) {
                      if (!context.mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Please log in to add items to cart'),
                        ),
                      );
                      return;
                    }

                    try {
                      final mappedToppings = selectedToppingsIndicies
                          .map((index) => toppings[index].id)
                          .toList();
                      final mappedSides = selectedOptionsIndicies
                          .map((index) => sideOptions[index].id)
                          .toList();

                      final cartItem = CartModel(
                        productId: widget.productId,
                        quantity: 1,
                        toppings: mappedToppings,
                        sideOptions: mappedSides,
                        spicy: spicyLevel,
                      );

                      await CartRepo().addToCart(
                        AddToCartModel(cartItems: [cartItem]),
                      );
                      if (!context.mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Item added to cart successfully'),
                        ),
                      );
                    } on ApiError catch (e) {
                      if (!context.mounted) return;
                      ScaffoldMessenger.of(
                        context,
                      ).showSnackBar(SnackBar(content: Text(e.message)));
                    } catch (e) {
                      if (!context.mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Failed to add item to cart: $e'),
                        ),
                      );
                    }
                  },
                  buttonText: isLoading ? 'Adding...' : 'Add to Cart',
                ),
                // ----------------------------------------------------------
              ],
            ),
          ),
        ),
      ),
    );
  }
}
