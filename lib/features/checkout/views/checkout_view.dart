import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:loqmtk_food_delivery_app/core/constants/app_colors.dart';
import 'package:loqmtk_food_delivery_app/features/checkout/widgets/order_summary.dart';
import 'package:loqmtk_food_delivery_app/features/checkout/widgets/payment_method_item.dart';
import 'package:loqmtk_food_delivery_app/features/checkout/widgets/save_card.dart';
import 'package:loqmtk_food_delivery_app/features/checkout/widgets/success_dialog.dart';
import 'package:loqmtk_food_delivery_app/shared/custom_text.dart';
import 'package:loqmtk_food_delivery_app/shared/price_action_section.dart';

class CheckoutView extends StatefulWidget {
  const CheckoutView({super.key, required this.totalPrice});
  final String totalPrice;
  @override
  State<CheckoutView> createState() => _CheckoutViewState();
}

class _CheckoutViewState extends State<CheckoutView> {
  String paymentMethod = 'cash';
  bool saveCard = false;
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
      body: Padding(
        padding: const EdgeInsets.only(
          top: 10,
          right: 16,
          left: 16,
          bottom: 25,
        ),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Gap(10),
                    // order summary section
                    OrderSummary(totalPrice: widget.totalPrice),
                    Gap(40),
                    // select payment method section
                    CustomText(
                      text: 'Payment method',
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.blackColor,
                    ),
                    Gap(10),
                    // cash on delivery payment method
                    PaymentMethodItem(
                      title: 'Cash on delivery',
                      image: 'assets/images/payment/cash.png',
                      value: 'cash',
                      groupValue: paymentMethod,
                      onChanged: (value) {
                        setState(() {
                          paymentMethod = value!;
                        });
                      },
                      selectedColor: AppColors.primaryColor,
                    ),
                    Gap(10),
                    // credit card payment method
                    PaymentMethodItem(
                      title: 'Credit card',
                      image: 'assets/images/payment/visa.png',
                      value: 'credit card',
                      groupValue: paymentMethod,
                      onChanged: (value) {
                        setState(() {
                          paymentMethod = value!;
                        });
                      },
                      selectedColor: AppColors.darkBlueColor,
                    ),
                    Gap(10),
                    // save card checkbox
                    SaveCard(
                      saveCard: saveCard,
                      onChanged: (value) {
                        setState(() {
                          saveCard = value!;
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),

            // confirm order button
            PriceActionSection(
              price: widget.totalPrice,
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) => Center(
                    child: Dialog(
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      backgroundColor: Colors.transparent,
                      child: SuccessPaymentWidget(
                        onGoBack: () => Navigator.pop(context),
                      ),
                    ),
                  ),
                );
              },
              buttonText: 'Confirm order',
            ),
          ],
        ),
      ),
    );
  }
}
