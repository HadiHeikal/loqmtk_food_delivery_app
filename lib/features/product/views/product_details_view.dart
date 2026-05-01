import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:loqmtk_food_delivery_app/shared/price_action_section.dart';
import 'package:loqmtk_food_delivery_app/features/product/widgets/custom_section.dart';
import 'package:loqmtk_food_delivery_app/features/product/widgets/spicy_slider.dart';

class ProductDetailsView extends StatefulWidget {
  const ProductDetailsView({super.key});

  @override
  State<ProductDetailsView> createState() => _ProductDetailsViewState();
}

class _ProductDetailsViewState extends State<ProductDetailsView> {
  double spicyLevel = 0.0;
  void _updateSpicyLevel(double value) {
    setState(() {
      spicyLevel = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              // Toppings Section
              CustomSection(
                sectionTitle: 'Toppings',
                itemText: 'Tomato',
                itemImage: 'assets/images/details/toppings/tomato.png',
                onAdd: () {},
              ),
              // Side options Section
              CustomSection(
                sectionTitle: 'Side options',
                itemText: 'Coleslaw',
                itemImage: 'assets/images/details/side_options/coleslaw.png',
                onAdd: () {},
              ),
              Gap(30),
              // add to cart section
              PriceActionSection(
                price: '170.5',
                onTap: () {},
                buttonText: 'Add to Cart',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
