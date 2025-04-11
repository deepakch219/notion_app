import 'package:flutter/material.dart'; 
import 'package:get/get.dart'; 

//  controllers
import 'package:notion_app/controllers/cart_controller.dart';
import 'package:notion_app/controllers/menu_controller.dart';

//  widgets
import 'package:notion_app/views/widgets/menu_card.dart';

class MenuScreen extends StatelessWidget {
  final FoodMenuController menuController = Get.find<FoodMenuController>();
  final CartController cartController = Get.find<CartController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Menu'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          Obx(() {
            int totalQuantity = cartController.getTotalQuantity();
            return Stack(
              children: [
                IconButton(
                  icon: Icon(Icons.shopping_cart),
                  onPressed: () => Get.toNamed('/cart'),
                ),
                if (totalQuantity > 0)
                  Positioned(
                    right: 8,
                    top: 8,
                    child: Container(
                      padding: EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: Color(0xFFF06292),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      constraints: BoxConstraints(
                        minWidth: 16,
                        minHeight: 16,
                      ),
                      child: Text(
                        '$totalQuantity',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
              ],
            );
          }),
        ],
      ),
      body: Stack(
        children: [
          Obx(() {
            if (menuController.menuItems.isEmpty &&
                !menuController.isLoading.value) {
              return Center(child: Text('No items available'));
            }
            return ListView.builder(
              itemCount: menuController.menuItems.length,
              itemBuilder: (context, index) {
                return MenuCard(menuItem: menuController.menuItems[index]);
              },
            );
          }),
          Obx(() {
            return menuController.isLoading.value || cartController.isLoading.value
                ? Center(child: CircularProgressIndicator())
                : SizedBox.shrink();
          }),
        ],
      ),
    );
  }
}