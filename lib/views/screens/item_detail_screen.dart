import 'package:flutter/material.dart'; 
import 'package:get/get.dart'; 
import 'package:cached_network_image/cached_network_image.dart'; 

// controllers
import 'package:notion_app/controllers/cart_controller.dart';

//  models
import 'package:notion_app/models/menu_item.dart';

class ItemDetailScreen extends StatelessWidget {
  final MenuItem menuItem = Get.arguments;
  final CartController cartController = Get.find<CartController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                
                Container(
                  color: Colors.white,
                  width: double.infinity,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: CachedNetworkImage(
                      imageUrl: menuItem.image,
                      height: 350,
                      width:
                          double
                              .infinity, 
                      fit:
                          BoxFit
                              .cover, 
                      placeholder:
                          (context, url) =>
                              Center(child: CircularProgressIndicator()),
                      errorWidget: (context, url, error) => Icon(Icons.error),
                    ),
                  ),
                ),

                // Product Details Card
                Container(
                  margin: EdgeInsets.all(16),
                  padding: EdgeInsets.all(16),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 18,
                            height: 18,
                            margin: EdgeInsets.only(top: 8),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color:
                                    menuItem.foodType.toLowerCase() == 'veg'
                                        ? Colors.green
                                        : Colors.red,
                                width: 1.5,
                              ),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Center(
                              child: Container(
                                width: 8,
                                height: 8,
                                decoration: BoxDecoration(
                                  color:
                                      menuItem.foodType?.toLowerCase() == 'veg'
                                          ? Colors.green
                                          : Colors.red,
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      // Product Title
                      Text(
                        menuItem.name,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        menuItem.description,
                        style: TextStyle(fontSize: 16, color: Colors.black54),
                      ),


                       SizedBox(height: 8),
                  
                      Row(
                        children: [
                         
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Color(0xFF006D4E),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Row(
                              children: [
                                Icon(Icons.star, color: Colors.white, size: 16),
                                Text(
                                  menuItem.rating.toStringAsFixed(1),
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: 8),
                        ],
                      ),

                      // Price
                      SizedBox(height: 16),
                      Text(
                        "₹${menuItem.originalPrice}",
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                  
                      SizedBox(height: 8),

                  
                      SizedBox(
                        height: 100,
                      ), 
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Loading 
          Obx(() {
            return cartController.isLoading.value
                ? Center(child: CircularProgressIndicator())
                : SizedBox.shrink();
          }),
        ],
      ),
      
      bottomNavigationBar: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                spreadRadius: 2,
                blurRadius: 5,
                offset: Offset(0, -2),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
           
              Obx(() {
                int totalQuantity = cartController.getTotalQuantity();
                return GestureDetector(
                  onTap: () => Get.toNamed('/cart'),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey[300]!),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.shopping_cart, color: Colors.black),
                        if (totalQuantity > 0)
                          Padding(
                            padding: EdgeInsets.only(left: 4),
                            child: Container(
                              padding: EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: Color(0xFFF06292), 
                                shape: BoxShape.circle,
                              ),
                              child: Text(
                                '$totalQuantity',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        SizedBox(width: 4),
                        Text(
                          'View Cart',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
           
              Obx(() {
                int quantity = cartController.getQuantity(menuItem.id);
                if (quantity == 0) {
                  return ElevatedButton(
                    onPressed: () => cartController.addToCart(menuItem),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFF06292), 
                      padding: EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      'Add to cart',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  );
                } else {
                  return Container(
                    height: 48,
                    decoration: BoxDecoration(
                      color: Color(0xFFF06292), 
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          icon: Icon(
                            Icons.remove,
                            color: Colors.white,
                            size: 20,
                          ),
                          onPressed:
                              () => cartController.updateQuantity(
                                cartController.cartItems[menuItem.id]!,
                                false,
                              ),
                          padding: EdgeInsets.zero,
                          constraints: BoxConstraints(),
                        ),
                        Text(
                          '$quantity',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.add, color: Colors.white, size: 20),
                          onPressed:
                              () => cartController.updateQuantity(
                                cartController.cartItems[menuItem.id]!,
                                true,
                              ),
                          padding: EdgeInsets.zero,
                          constraints: BoxConstraints(),
                        ),
                      ],
                    ),
                  );
                }
              }),
            ],
          ),
        ),
      ),
    );
  }
}
