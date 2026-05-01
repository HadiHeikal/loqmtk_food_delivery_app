import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:loqmtk_food_delivery_app/features/cart/widgets/cart_item.dart';
import 'package:loqmtk_food_delivery_app/features/checkout/views/checkout_view.dart';
import 'package:loqmtk_food_delivery_app/shared/price_action_section.dart';

class CartView extends StatefulWidget {
  const CartView({super.key});
  @override
  State<CartView> createState() => _CartViewState();
}

class _CartViewState extends State<CartView> {
  List<int> _quantities = [];
  final itemCount = 6;
  void _incrementQuantity(int index) {
    setState(() {
      _quantities[index]++;
    });
  }

  void _decrementQuantity(int index) {
    setState(() {
      if (_quantities[index] > 1) {
        _quantities[index]--;
      }
    });
  }

  void _removeItem(int index) {
    setState(() {
      _quantities[index] = 0;
    });
  }

  @override
  void initState() {
    super.initState();
    _quantities = List<int>.generate(itemCount, (index) => 1);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 20),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: List.generate(6, (index) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 20.0),
                        child: CartItem(
                          itemName: 'Hamburger',
                          itemDescription: 'Veggie Burger',
                          itemImage: 'assets/images/cart/burger.png',
                          onPlus: () => _incrementQuantity(index),
                          onMinus: () => _decrementQuantity(index),
                          onRemoveItem: () => _removeItem(index),
                          itemQuantity: _quantities[index],
                        ),
                      );
                    }),
                  ),
                ),
              ),
              Gap(3),
              PriceActionSection(
                price: '150',
                onTap: () {
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
    );
  }
}
