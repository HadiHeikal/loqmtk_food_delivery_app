import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:loqmtk_food_delivery_app/core/constants/app_colors.dart';
import 'package:loqmtk_food_delivery_app/core/services/api_error.dart';
import 'package:loqmtk_food_delivery_app/core/utils/pref_helper.dart';
import 'package:loqmtk_food_delivery_app/features/cart/data/cart_repo/cart_repo.dart';
import 'package:loqmtk_food_delivery_app/features/cart/data/models/add_to_cart_models/add_to_cart_model.dart';
import 'package:loqmtk_food_delivery_app/features/cart/data/models/add_to_cart_models/cart_model.dart';
import 'package:loqmtk_food_delivery_app/features/cart/data/models/get_cart_models/cart_item_model.dart';
import 'package:loqmtk_food_delivery_app/features/cart/data/models/get_cart_models/get_cart_model.dart';
import 'package:loqmtk_food_delivery_app/features/cart/widgets/cart_item.dart';
import 'package:loqmtk_food_delivery_app/features/checkout/views/checkout_view.dart';
import 'package:loqmtk_food_delivery_app/shared/custom_text.dart';
import 'package:loqmtk_food_delivery_app/shared/price_action_section.dart';
import 'package:skeletonizer/skeletonizer.dart';

class CartView extends StatefulWidget {
  const CartView({super.key});
  @override
  State<CartView> createState() => _CartViewState();
}

class _CartViewState extends State<CartView> {
  // State variables to manage cart items and their quantities
  Map<int, int> _quantityByProductId = {};
  final Set<int> _dismissedProductIds = {};
  final Set<int> _removingProductIds = {};
  bool _isUpdatingCart = false;

  // Functions to handle quantity changes ------------
  // Increment item quantity
  Future<void> _incrementQuantity(int index) async {
    final item = _itemAt(index);
    if (item == null) return;

    await _updateCartItemQuantity(item, _quantityAt(index, item) + 1);
  }

  // Decrement item quantity
  Future<void> _decrementQuantity(int index) async {
    final item = _itemAt(index);
    if (item == null) return;

    final newQuantity = _quantityAt(index, item) - 1;
    if (newQuantity < 1) return;

    await _updateCartItemQuantity(item, newQuantity);
  }
  // -------------------------------------------------

  // Functions to handle item removal ------------
  // Remove item from cart
  Future<void> _removeItem(int index) async {
    final item = _itemAt(index);
    if (item == null || _isUpdatingCart) return;

    await _removeCartItem(item);
  }

  // Remove cart item with optional animation
  Future<void> _removeCartItem(
    CartItemModel item, {
    bool animateBeforeRemove = true,
  }) async {
    try {
      setState(() {
        _isUpdatingCart = true;
        if (animateBeforeRemove) {
          _removingProductIds.add(item.productId);
        }
      });

      if (animateBeforeRemove) {
        await Future<void>.delayed(const Duration(milliseconds: 250));
      }

      setState(() {
        _dismissedProductIds.add(item.productId);
        _removingProductIds.remove(item.productId);
        _quantityByProductId.remove(item.productId);
      });
      await _cartRepo.removeCachedCartQuantity(item.productId);
      await _removeRawItemsForProduct(item.productId);
      await _getCartItemsData(showLoading: false);
    } on ApiError catch (error) {
      _showSnackBar(error.message);
    } catch (error) {
      _showSnackBar('Failed to remove item from cart');
    } finally {
      if (mounted) {
        setState(() {
          _dismissedProductIds.remove(item.productId);
          _removingProductIds.remove(item.productId);
          _isUpdatingCart = false;
        });
      }
    }
  }
  // -------------------------------------------------

  // Helper functions --------------------------------
  CartItemModel? _itemAt(int index) {
    final items = _cartDisplayItems;
    if (index < 0 || index >= items.length) return null;

    return items[index];
  }

  int _quantityAt(int index, CartItemModel item) {
    return _quantityByProductId[item.productId] ?? item.quantity;
  }
  // -------------------------------------------------

  // Update cart item quantity --------------------------------
  Future<void> _updateCartItemQuantity(
    CartItemModel item,
    int newQuantity,
  ) async {
    final oldQuantity = _quantityByProductId[item.productId] ?? item.quantity;

    setState(() {
      _quantityByProductId[item.productId] = newQuantity;
    });
    await _cartRepo.saveCachedCartQuantity(item.productId, newQuantity);

    try {
      await _removeRawItemsForProduct(item.productId);
      await _cartRepo.addToCart(
        AddToCartModel(
          cartItems: [
            CartModel(
              productId: item.productId,
              quantity: newQuantity,
              toppings: item.toppings.map((option) => option.id).toList(),
              sideOptions: item.sideOptions.map((option) => option.id).toList(),
              spicy: _parseSpicyLevel(item.spicy),
            ),
          ],
        ),
      );
      await _getCartItemsData(showLoading: false);
    } on ApiError catch (error) {
      await _cartRepo.saveCachedCartQuantity(item.productId, oldQuantity);
      if (mounted) {
        setState(() {
          _quantityByProductId[item.productId] = oldQuantity;
        });
      }
      _showSnackBar(error.message);
    } catch (error) {
      await _cartRepo.saveCachedCartQuantity(item.productId, oldQuantity);
      if (mounted) {
        setState(() {
          _quantityByProductId[item.productId] = oldQuantity;
        });
      }
      _showSnackBar('Failed to update cart item');
    }
  }
  // -------------------------------------------------

  // Helper function to remove raw items for a specific product from the cart
  Future<void> _removeRawItemsForProduct(int productId) async {
    final matchingItems = (_cartItems?.data.items ?? [])
        .where((item) => item.productId == productId && item.itemId > 0)
        .toList();

    for (final item in matchingItems) {
      await _cartRepo.removeFromCart(item.itemId);
    }
  }
  // -------------------------------------------------

  // Helper function to parse the spicy level from dynamic value
  double _parseSpicyLevel(dynamic value) {
    if (value is num) return value.toDouble();

    return double.tryParse(value?.toString() ?? '') ?? 0.1;
  }
  // -------------------------------------------------

  // get cart items ----------------------------------
  final CartRepo _cartRepo = CartRepo();
  GetCartModel? _cartItems;
  bool _isLoading = true;
  String? _errorMessage;

  Future<void> _getCartItemsData({bool showLoading = true}) async {
    try {
      if (showLoading) {
        setState(() {
          _isLoading = true;
          _errorMessage = null;
        });
      } else {
        setState(() {
          _errorMessage = null;
        });
      }

      final token = await PrefHelper.getToken();
      if (token == null || token.isEmpty || token == 'Guest') {
        if (!mounted) return;
        setState(() {
          _cartItems = null;
          _quantityByProductId = {};
          _dismissedProductIds.clear();
          _removingProductIds.clear();
          _errorMessage = 'Please log in to view your cart';
          _isLoading = false;
        });
        return;
      }

      final response = await _cartRepo.getCartItems();
      final cachedQuantities = await _cartRepo.getCachedCartQuantities();
      if (!mounted) return;

      setState(() {
        _cartItems = response;
        _dismissedProductIds.clear();
        _removingProductIds.clear();
        _quantityByProductId = cachedQuantities;
        _isLoading = false;
      });
    } on ApiError catch (error) {
      if (!mounted) return;
      setState(() {
        _cartItems = null;
        _quantityByProductId = {};
        _dismissedProductIds.clear();
        _removingProductIds.clear();
        _errorMessage = error.message;
        _isLoading = false;
      });
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _cartItems = null;
        _quantityByProductId = {};
        _dismissedProductIds.clear();
        _removingProductIds.clear();
        _errorMessage = 'Failed to load cart items';
        _isLoading = false;
      });
    }
  }

  String get _totalPrice {
    final items = _cartDisplayItems;
    if (items.isEmpty) return '0';

    final total = items.asMap().entries.fold<double>(0, (sum, entry) {
      final price = double.tryParse(entry.value.price) ?? 0;
      final quantity = _quantityAt(entry.key, entry.value);
      return sum + (price * quantity);
    });

    return total.toStringAsFixed(total.truncateToDouble() == total ? 0 : 2);
  }

  List<CartItemModel> get _cartDisplayItems {
    final rawItems = _cartItems?.data.items ?? [];
    final uniqueItems = <int, CartItemModel>{};

    for (final item in rawItems) {
      if (_dismissedProductIds.contains(item.productId)) continue;

      final existingItem = uniqueItems[item.productId];
      if (existingItem == null) {
        uniqueItems[item.productId] = item.copyWith(
          quantity: _quantityByProductId[item.productId] ?? item.quantity,
        );
      } else {
        final mergedQuantity =
            _quantityByProductId[item.productId] ??
            existingItem.quantity + item.quantity;
        uniqueItems[item.productId] = existingItem.copyWith(
          quantity: mergedQuantity,
        );
      }
    }

    return uniqueItems.values.toList();
  }

  void _showSnackBar(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  // --------------------------------------------------
  @override
  void initState() {
    super.initState();

    _getCartItemsData();
  }

  @override
  Widget build(BuildContext context) {
    final items = _cartDisplayItems;
    final hasItems = items.isNotEmpty;

    return SafeArea(
      child: Skeletonizer(
        enabled: _isLoading,
        child: Scaffold(
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 20),
            child: Column(
              children: [
                Expanded(child: _buildCartContent(items)),
                Gap(3),
                PriceActionSection(
                  price: _totalPrice,
                  onTap: () {
                    if (!hasItems) {
                      _showSnackBar('Your cart is empty');
                      return;
                    }
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            CheckoutView(totalPrice: _totalPrice.toString()),
                      ),
                    );
                  },
                  buttonText: 'Check Out',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Build the cart content based on the current state
  Widget _buildCartContent(List<CartItemModel> items) {
    if (_isLoading) {
      return SingleChildScrollView(
        child: Column(
          children: List.generate(
            6,
            (index) => Padding(
              padding: const EdgeInsets.only(bottom: 20.0),
              child: CartItem(
                itemName: 'Veggie Burger',
                itemDescription: 'Loading item',
                itemImage: 'https://example.com/veggie_burger.jpg',
                onPlus: () {},
                onMinus: () {},
                onRemoveItem: () {},
                itemQuantity: 1,
              ),
            ),
          ),
        ),
      );
    }

    if (_errorMessage != null) {
      return _CartMessage(
        title: 'Could not load cart',
        subtitle: _errorMessage!,
        actionText: 'Try again',
        onAction: _getCartItemsData,
      );
    }

    if (items.isEmpty) {
      return const _CartMessage(
        title: 'Your cart is empty',
        subtitle: 'Add something delicious and it will appear here.',
      );
    }

    return ListView.separated(
      itemCount: items.length,
      separatorBuilder: (context, index) => const Gap(20),
      itemBuilder: (context, index) {
        final item = items[index];
        final isRemoving = _removingProductIds.contains(item.productId);
        return Dismissible(
          key: ValueKey(item.productId),
          direction: DismissDirection.endToStart,
          background: Container(
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
              color: AppColors.redColor,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.delete, color: Colors.white),
          ),
          confirmDismiss: (_) => _confirmRemoveItem(),
          onDismissed: (_) => _removeCartItem(item, animateBeforeRemove: false),
          child: AnimatedSlide(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeInOut,
            offset: isRemoving ? const Offset(-1, 0) : Offset.zero,
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 250),
              opacity: isRemoving ? 0 : 1,
              child: CartItem(
                itemName: item.name,
                itemDescription: 'Quantity: ${item.quantity}',
                itemImage: item.image,
                onPlus: () => _incrementQuantity(index),
                onMinus: () => _decrementQuantity(index),
                onRemoveItem: () => _removeItemWithConfirmation(index),
                itemQuantity: _quantityAt(index, item),
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> _removeItemWithConfirmation(int index) async {
    final shouldRemove = await _confirmRemoveItem();
    if (shouldRemove != true) return;

    await _removeItem(index);
  }

  Future<bool?> _confirmRemoveItem() {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Remove Item'),
        content: const Text('Do you want to remove this item from your cart?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('No'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Yes'),
          ),
        ],
      ),
    );
  }
}

// Widget to display messages in the cart view
class _CartMessage extends StatelessWidget {
  const _CartMessage({
    required this.title,
    required this.subtitle,
    this.actionText,
    this.onAction,
  });

  final String title;
  final String subtitle;
  final String? actionText;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomText(
            text: title,
            color: AppColors.blackColor,
            fontSize: 22,
            fontWeight: FontWeight.w700,
          ),
          const Gap(8),
          CustomText(
            text: subtitle,
            color: AppColors.blackColor,
            fontSize: 16,
            fontWeight: FontWeight.w400,
          ),
          if (actionText != null && onAction != null) ...[
            const Gap(16),
            ElevatedButton(onPressed: onAction, child: Text(actionText!)),
          ],
        ],
      ),
    );
  }
}
