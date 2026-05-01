import 'package:flutter/material.dart';
import 'package:loqmtk_food_delivery_app/features/orderHistory/widgets/order_item.dart';

class OrderHistoryView extends StatefulWidget {
  const OrderHistoryView({super.key});

  @override
  State<OrderHistoryView> createState() => _OrderHistoryViewState();
}

class _OrderHistoryViewState extends State<OrderHistoryView> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 20),
          child: SingleChildScrollView(
            child: Column(
              children: List.generate(
                6,
                (index) => Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: OrderItem(
                    orderImage: 'assets/images/cart/burger.png',
                    orderName: 'Hamburger',
                    orderQuantity: 6,
                    orderPrice: 150,
                    onOrderAgain: () {},
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
