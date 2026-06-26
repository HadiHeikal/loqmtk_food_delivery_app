import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:loqmtk_food_delivery_app/core/constants/app_colors.dart';
import 'package:loqmtk_food_delivery_app/core/services/api_error.dart';
import 'package:loqmtk_food_delivery_app/core/utils/pref_helper.dart';
import 'package:loqmtk_food_delivery_app/features/cart/data/cart_repo/cart_repo.dart';
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
  List<int> _quantities = [];

  // Functions to handle quantity changes ------------
  void _incrementQuantity(int index) {
    if (index < 0 || index >= _quantities.length) return;

    setState(() {
      _quantities[index]++;
    });
  }

  void _decrementQuantity(int index) {
    if (index < 0 || index >= _quantities.length) return;

    setState(() {
      if (_quantities[index] > 1) {
        _quantities[index]--;
      }
    });
  }

  Future<void> _removeItem(int index) async {
    final items = _cartItems?.data.items ?? [];
    if (index < 0 || index >= items.length) return;

    final item = items[index];

    try {
      await _cartRepo.removeFromCart(item.itemId);
      await _getCartItemsData();
    } on ApiError catch (error) {
      _showSnackBar(error.message);
    } catch (error) {
      _showSnackBar('Failed to remove item from cart');
    }
  }

  int _quantityAt(int index, CartItemModel item) {
    if (index >= 0 && index < _quantities.length) {
      return _quantities[index];
    }

    return item.quantity;
  }
  // -------------------------------------------------

  // get cart items ----------------------------------
  final CartRepo _cartRepo = CartRepo();
  GetCartModel? _cartItems;
  bool _isLoading = true;
  String? _errorMessage;

  Future<void> _getCartItemsData() async {
    try {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

      final token = await PrefHelper.getToken();
      if (token == null || token.isEmpty || token == 'Guest') {
        if (!mounted) return;
        setState(() {
          _cartItems = null;
          _quantities = [];
          _errorMessage = 'Please log in to view your cart';
          _isLoading = false;
        });
        return;
      }

      final response = await _cartRepo.getCartItems();
      if (!mounted) return;

      setState(() {
        _cartItems = response;
        _quantities =
            response?.data.items.map((item) => item.quantity).toList() ?? [];
        _isLoading = false;
      });
    } on ApiError catch (error) {
      if (!mounted) return;
      setState(() {
        _cartItems = null;
        _quantities = [];
        _errorMessage = error.message;
        _isLoading = false;
      });
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _cartItems = null;
        _quantities = [];
        _errorMessage = 'Failed to load cart items';
        _isLoading = false;
      });
    }
  }

  String get _totalPrice {
    final items = _cartItems?.data.items ?? [];
    if (items.isEmpty) return '0';

    final total = items.asMap().entries.fold<double>(0, (sum, entry) {
      final price = double.tryParse(entry.value.price) ?? 0;
      final quantity = entry.key < _quantities.length
          ? _quantities[entry.key]
          : 0;
      return sum + (price * quantity);
    });

    return total.toStringAsFixed(total.truncateToDouble() == total ? 0 : 2);
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
    final items = _cartItems?.data.items ?? [];
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
                      MaterialPageRoute(builder: (context) => CheckoutView()),
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
        return CartItem(
          itemName: item.name,
          itemDescription: 'Quantity: ${item.quantity}',
          itemImage: item.image,
          onPlus: () => _incrementQuantity(index),
          onMinus: () => _decrementQuantity(index),
          onRemoveItem: () => _removeItem(index),
          itemQuantity: _quantityAt(index, item),
        );
      },
    );
  }
}

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
