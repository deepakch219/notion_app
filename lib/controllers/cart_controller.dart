import 'package:get/get.dart';
import '../models/cart_item.dart';
import '../models/menu_item.dart';
import '../services/api_service.dart';
import '../utils/network_exceptions.dart'; 

class CartController extends GetxController {
  var cartItems = <int, CartItem>{}.obs;
  var isLoading = false.obs;
  var subAmount = 0.0.obs;
  var amount = 0.0.obs;
  var shippingPrice = 0.0.obs;
  var couponMessage = ''.obs;

  final ApiService _apiService = ApiService();

  @override
  void onInit() {
    fetchCartItems();
    super.onInit();
  }

  Future<void> fetchCartItems() async {
    try {
      isLoading.value = true;
   
      final response = await _apiService.fetchCartItems();
      cartItems.clear();
      for (var item in response) {
        cartItems[item.menuId] = item;
            }
          await syncCartTotal();
    } catch (e) {
      String errorMessage = NetworkExceptions.getErrorMessage(e);
    
      if (errorMessage.isNotEmpty) {
        Get.snackbar('Error', errorMessage, snackPosition: SnackPosition.BOTTOM);
      }
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> addToCart(MenuItem menuItem) async {
    try {
      isLoading.value = true;
    
      await _apiService.addToCart(
        menuId: menuItem.id,
        partnerId: menuItem.partnerId,
        quantity: 1,
        size: 'Standard',
        amount: menuItem.originalPrice,
      );

      int menuId = menuItem.id;
      if (cartItems.containsKey(menuId)) {
        cartItems[menuId]!.quantity++;
      } else {
        cartItems[menuId] = CartItem.fromMenuItem(menuItem, id: DateTime.now().millisecondsSinceEpoch);
      }

      Get.snackbar('Success', '${menuItem.name} added to cart', snackPosition: SnackPosition.BOTTOM);
      await syncCartTotal();
    } catch (e) {
    
      Get.snackbar('Error', NetworkExceptions.getErrorMessage(e), snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateQuantity(CartItem cartItem, bool increase) async {
    try {
      isLoading.value = true;
  
      await _apiService.updateCartQuantity(
        cartItem.id,
        increase ? 'Add' : 'Remove',
      );

      int menuId = cartItem.menuId;
      if (increase) {
        cartItems[menuId]!.quantity++;
      } else {
        if (cartItems[menuId]!.quantity > 1) {
          cartItems[menuId]!.quantity--;
        } else {
          cartItems.remove(menuId);
        }
      }
      cartItems.refresh();
      await syncCartTotal();
    } catch (e) {
   
      Get.snackbar('Error', NetworkExceptions.getErrorMessage(e), snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> syncCartTotal({String couponCode = ''}) async {
    try {
      print('Syncing cart total...'); // Debug log
      final response = await _apiService.fetchCartTotal(couponCode: couponCode);
      subAmount.value = (response['data']['sub_amount'] as num?)?.toDouble() ?? 0.0;
      amount.value = (response['data']['amount'] as num?)?.toDouble() ?? 0.0;
      shippingPrice.value = (response['data']['shipping_price'] as num?)?.toDouble() ?? 0.0;
      couponMessage.value = response['message'] ?? '';
    } catch (e) {
      print('Sync cart total error: $e'); // Debug log
      Get.snackbar('Error', 'Failed to sync cart total: ${NetworkExceptions.getErrorMessage(e)}', snackPosition: SnackPosition.BOTTOM);
      subAmount.value = 0.0;
      amount.value = 0.0;
      shippingPrice.value = 0.0;
      couponMessage.value = '';
    }
  }

  int getQuantity(int menuId) {
    return cartItems[menuId]?.quantity ?? 0;
  }

  int getTotalQuantity() {
    return cartItems.values.fold(0, (sum, item) => sum + item.quantity);
  }
}