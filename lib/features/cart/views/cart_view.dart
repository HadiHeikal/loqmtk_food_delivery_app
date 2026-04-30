import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:loqmtk_food_delivery_app/features/cart/widgets/cart_item.dart';
import 'package:loqmtk_food_delivery_app/shared/add_to_cart_section.dart';

class CartView extends StatefulWidget {
  const CartView({super.key});
  @override
  State<CartView> createState() => _CartViewState();
}

class _CartViewState extends State<CartView> {
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
                          onPlus: () {},
                          onMinus: () {},
                          onRemoveItem: () {},
                          itemQuantity: 0,
                        ),
                      );
                    }),
                  ),
                ),
              ),
              Gap(3),
              PriceActionSection(
                price: '150',
                onTap: () {},
                buttonText: 'Check Out',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
