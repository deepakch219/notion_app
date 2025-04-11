import 'package:flutter/material.dart'; // Flutter SDK
import 'package:get/get.dart'; 
import 'package:cached_network_image/cached_network_image.dart'; 

// controllers
import 'package:notion_app/controllers/cart_controller.dart';

//  models
import 'package:notion_app/models/menu_item.dart';

class MenuCard extends StatelessWidget {
  final MenuItem menuItem;
  final CartController cartController = Get.find<CartController>();

  MenuCard({super.key, required this.menuItem});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Get.toNamed('/item-detail', arguments: menuItem),
      child: Card(
        elevation: 1,
        color: Colors.grey[50],
        margin: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
            
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: CachedNetworkImage(
                  imageUrl: menuItem.image,
                  width: 100,
                  height: 100,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Container(
                    color: Colors.grey[200],
                    child: Center(child: CircularProgressIndicator()),
                  ),
                  errorWidget: (context, url, error) => Container(
                    color: Colors.grey[200],
                    child: Icon(Icons.error, color: Colors.grey[400]),
                  ),
                ),
              ),
              SizedBox(width: 12),
           
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                  
                    Row(
                      children: [
                       
                        Container(
                          width: 16,
                          height: 16,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: menuItem.foodType.toLowerCase() == 'veg'
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
                                color: menuItem.foodType.toLowerCase() == 'veg'
                                    ? Colors.green
                                    : Colors.red,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 8),
                       
                        Expanded(
                          child: Text(
                            menuItem.name,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 4),
                 
                    Row(
                      children: [
                        Icon(Icons.star, color: Colors.amber, size: 18),
                        SizedBox(width: 4),
                        Text(
                          menuItem.rating.toStringAsFixed(1),
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 4),
                   
                    Text(
                      menuItem.description,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey[600],
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 8),
                    // Price and Quantity
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '₹${menuItem.originalPrice.toStringAsFixed(0)}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                        Obx(() {
                          int quantity = cartController.getQuantity(menuItem.id);
                          if (quantity == 0) {
                            return Container(
                              height: 32,
                              width: 80,
                              decoration: BoxDecoration(
                                color: Color(0xFFF06292),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: InkWell(
                                onTap: () => cartController.addToCart(menuItem),
                                child: Center(
                                  child: Text(
                                    'ADD',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          } else {
                            return Container(
                              height: 32,
                              decoration: BoxDecoration(
                                border: Border.all(color: Color(0xFFF06292)),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  IconButton(
                                    icon: Icon(Icons.remove, color: Color(0xFFF06292), size: 18),
                                    onPressed: () => cartController.updateQuantity(cartController.cartItems[menuItem.id]!, false),
                                    padding: EdgeInsets.zero,
                                    constraints: BoxConstraints(),
                                  ),
                                  Text(
                                    '$quantity',
                                    style: TextStyle(fontSize: 16),
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.add, color: Color(0xFFF06292), size: 18),
                                    onPressed: () => cartController.updateQuantity(cartController.cartItems[menuItem.id]!, true),
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
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}