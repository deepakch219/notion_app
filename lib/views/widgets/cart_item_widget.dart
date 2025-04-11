import 'package:flutter/material.dart'; 
import 'package:get/get.dart'; 
import 'package:cached_network_image/cached_network_image.dart'; // image caching

// Local project controllers
import 'package:notion_app/controllers/cart_controller.dart';

// Local project models
import 'package:notion_app/models/cart_item.dart';

class CartItemWidget extends StatelessWidget {
  final CartItem cartItem;
  final CartController cartController = Get.find<CartController>();

  CartItemWidget({super.key, required this.cartItem});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Padding(
        padding: EdgeInsets.all(8),
        child: Row(
          children: [
             ClipRRect(
              borderRadius: BorderRadius.circular(8),
            child: CachedNetworkImage(
              imageUrl:
                  cartItem.menuImage, 
              width: 60,
              height: 60,
              fit: BoxFit.cover,
              placeholder: (context, url) => CircularProgressIndicator(),
              errorWidget: (context, url, error) => Icon(Icons.error),
            )),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    cartItem.menuName, 
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '₹${cartItem.menuPrice}', 
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ),
            Row(
              children: [
                IconButton(
                  icon: Icon(Icons.remove),
                  onPressed:
                      () => cartController.updateQuantity(cartItem, false),
                ),
                Text('${cartItem.quantity}', style: TextStyle(fontSize: 16)),
                IconButton(
                  icon: Icon(Icons.add),
                  onPressed:
                      () => cartController.updateQuantity(cartItem, true),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
