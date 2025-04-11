import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';

// controllers
import 'package:notion_app/controllers/cart_controller.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final CartController cartController = Get.find<CartController>();
    final TextEditingController couponController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: Text('Your Cart'),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Get.back(),
        ),
      ),
      body: Obx(() {
        if (cartController.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        }
        if (cartController.cartItems.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.shopping_cart, size: 100, color: Colors.grey[400]),
                SizedBox(height: 16),

                Text(
                  'Your cart is empty',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          );
        }
        return Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: cartController.cartItems.length,
                itemBuilder: (context, index) {
                  final cartItem = cartController.cartItems.values.elementAt(
                    index,
                  );
                  return Card(
                    margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    elevation: 1,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(12),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: CachedNetworkImage(
                              imageUrl: cartItem.menuImage,
                              width: 60,
                              height: 60,
                              fit: BoxFit.cover,
                              placeholder:
                                  (context, url) => Center(
                                    child: CircularProgressIndicator(),
                                  ),
                              errorWidget:
                                  (context, url, error) => Icon(Icons.error),
                            ),
                          ),
                          SizedBox(width: 12),

                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  cartItem.menuName,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                SizedBox(height: 4),
                                Text(
                                  '${cartItem.size}',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                          ),

                          SizedBox(width: 8),

                          // Price Details
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                '₹${(cartItem.menuPrice * cartItem.quantity).toStringAsFixed(2)}',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green[700],
                                ),
                              ),
                              Text(
                                '₹${cartItem.menuPrice.toStringAsFixed(2)}',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[600],
                                  decoration: TextDecoration.lineThrough,
                                ),
                              ),
                              Container(
                                height: 32,
                                padding: EdgeInsets.symmetric(horizontal: 4),
                                decoration: BoxDecoration(
                                  color: Color(0xFFF06292),
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    IconButton(
                                      icon: Icon(
                                        Icons.remove,
                                        color: Colors.white,
                                        size: 16,
                                      ),
                                      onPressed:
                                          cartItem.quantity > 0
                                              ? () =>
                                                  cartController.updateQuantity(
                                                    cartItem,
                                                    false,
                                                  )
                                              : null,
                                      padding: EdgeInsets.zero,
                                      constraints: BoxConstraints(),
                                    ),
                                    Text(
                                      '${cartItem.quantity}',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    IconButton(
                                      icon: Icon(
                                        Icons.add,
                                        color: Colors.white,
                                        size: 16,
                                      ),
                                      onPressed:
                                          () => cartController.updateQuantity(
                                            cartItem,
                                            true,
                                          ),
                                      padding: EdgeInsets.zero,
                                      constraints: BoxConstraints(),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            // Coupon Input
            Padding(
              padding: EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: couponController,
                      decoration: InputDecoration(
                        labelText: 'Enter Coupon Code',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () async {
                      final coupon = couponController.text.trim();
                      if (coupon.isNotEmpty) {
                        await cartController.syncCartTotal(couponCode: coupon);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFF06292),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text('Apply', style: TextStyle(color: Colors.white)),
                  ),
                ],
              ),
            ),
          
            Obx(() {
              return Column(
                crossAxisAlignment:
                    CrossAxisAlignment
                        .start, 
                mainAxisAlignment:
                    MainAxisAlignment
                        .center, 
                children: [
              
                  if (cartController.couponMessage.value.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 16.0,
                        bottom: 16.0,
                      ), 
                      child: Text(
                        cartController.couponMessage.value,
                        style: TextStyle(color: Colors.red, fontSize: 14),
                      ),
                    ),

                 
                  Column(
                    crossAxisAlignment:
                        CrossAxisAlignment
                            .start, 
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 16.0,
                        ), 
                        child: Row(
                          mainAxisAlignment:
                              MainAxisAlignment
                                  .start, 
                          children: [
                            Text(
                              'Sub Amount: ',
                              style: TextStyle(
                                color: Colors.black87,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Obx(
                              () => Text(
                                '${cartController.subAmount.value.toStringAsFixed(2)}',
                                style: TextStyle(
                                  color: Colors.black87,
                                  fontSize: 16,

                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 8,
                      ), 
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 16.0,
                        ), 
                        child: Row(
                          mainAxisAlignment:
                              MainAxisAlignment
                                  .start, 
                          children: [
                            Text(
                              'Shipping Price: ',
                              style: TextStyle(
                                color: Colors.black87,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                
                              ),
                            ),
                            Obx(
                              () => Text(
                                '${cartController.shippingPrice.value.toStringAsFixed(2)}',
                                style: TextStyle(
                                  color: Colors.black87,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              );
            }),
          ],
        );
      }),
      bottomNavigationBar: Obx(() {
        if (cartController.cartItems.isEmpty) return SizedBox.shrink();
        return SafeArea(
          child: Container(
            padding: EdgeInsets.all(16),
            color: Colors.white,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // To Pay Section
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'To Pay',
                      style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                    ),
                    Obx(
                      () => Text(
                        '₹${cartController.amount.value.toStringAsFixed(2)}', // Changed from cartTotal to amount
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                  ],
                ),
                // Payment Buttons
                Row(
                  children: [
                    GestureDetector(
                      onTap: () {},
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          color: Color(0xFFF5F5F5),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          'Pay Online',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 8),

                    GestureDetector(
                      onTap: () {},
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          color: Color(0xFFF06292),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          'Pay Cash ',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
