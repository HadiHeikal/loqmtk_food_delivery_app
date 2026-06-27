import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:loqmtk_food_delivery_app/core/services/api_error.dart';
import 'package:loqmtk_food_delivery_app/core/utils/pref_helper.dart';
import 'package:loqmtk_food_delivery_app/features/cart/data/models/add_to_cart_models/add_to_cart_model.dart';
import 'package:loqmtk_food_delivery_app/features/cart/data/models/add_to_cart_models/cart_model.dart';
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
  final String productPrice;
  const ProductDetailsView({
    super.key,
    required this.productImage,
    required this.productId,
    required this.productPrice,
  });

  @override
  State<ProductDetailsView> createState() => _ProductDetailsViewState();
}

class _ProductDetailsViewState extends State<ProductDetailsView> {
  // ---- fetching toppings and side options data ----
  final ProductRepository productRepository = ProductRepository();
  final CartRepo _cartRepo = CartRepo();

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

  Future<void> _addToCart() async {
    final token = await PrefHelper.getToken();
    if (token == null || token.isEmpty || token == 'Guest') {
      _showSnackBar('Please log in to add items to cart');
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      final mappedToppings = selectedToppingsIndicies
          .where((index) => index >= 0 && index < toppings.length)
          .map((index) => toppings[index].id)
          .toList();
      final mappedSides = selectedOptionsIndicies
          .where((index) => index >= 0 && index < sideOptions.length)
          .map((index) => sideOptions[index].id)
          .toList();

      final cartResponse = await _cartRepo.getCartItems();
      final cartItems = cartResponse?.data.items ?? [];
      final existingItems = cartItems
          .where((item) => item.productId == widget.productId)
          .toList();
      final existingItem = existingItems.isNotEmpty
          ? existingItems.first
          : null;

      if (existingItem != null) {
        for (final item in existingItems.where((item) => item.itemId > 0)) {
          await _cartRepo.removeFromCart(item.itemId);
        }

        final currentQuantity = existingItems.fold<int>(
          0,
          (sum, item) => sum + item.quantity,
        );
        final newQuantity = currentQuantity + 1;

        await _cartRepo.addToCart(
          AddToCartModel(
            cartItems: [
              CartModel(
                productId: existingItem.productId,
                quantity: newQuantity,
                toppings: existingItem.toppings
                    .map((option) => option.id)
                    .toList(),
                sideOptions: existingItem.sideOptions
                    .map((option) => option.id)
                    .toList(),
                spicy: _parseSpicyLevel(existingItem.spicy),
              ),
            ],
          ),
        );
        await _cartRepo.saveCachedCartQuantity(
          existingItem.productId,
          newQuantity,
        );
      } else {
        await _cartRepo.addToCart(
          AddToCartModel(
            cartItems: [
              CartModel(
                productId: widget.productId,
                quantity: 1,
                toppings: mappedToppings,
                sideOptions: mappedSides,
                spicy: spicyLevel,
              ),
            ],
          ),
        );
        await _cartRepo.saveCachedCartQuantity(widget.productId, 1);
      }

      _showSnackBar(
        existingItem != null
            ? 'Item quantity updated successfully'
            : 'Item added to cart successfully',
      );
    } on ApiError catch (e) {
      _showSnackBar(e.message);
    } catch (e) {
      _showSnackBar('Failed to add item to cart: $e');
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  double _parseSpicyLevel(dynamic value) {
    if (value is num) return value.toDouble();

    return double.tryParse(value?.toString() ?? '') ?? 0.1;
  }

  void _showSnackBar(String message) {
    if (!mounted) return;

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
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
                  price: widget.productPrice,
                  onTap: isLoading ? () {} : _addToCart,
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
