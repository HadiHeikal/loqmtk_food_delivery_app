import 'package:flutter/material.dart';
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
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              SpicySlider(
                initialValue: spicyLevel,
                onChanged: _updateSpicyLevel,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
