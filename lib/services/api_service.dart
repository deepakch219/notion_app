import 'package:dio/dio.dart';
import '../config/app_config.dart';
import '../models/cart_item.dart';
import '../models/menu_item.dart';
import '../utils/network_exceptions.dart';

class ApiService {
  final Dio _dio;

  ApiService()
      : _dio = Dio(BaseOptions(
          baseUrl: AppConfig.baseUrl,
          connectTimeout: Duration(seconds: 10),
          receiveTimeout: Duration(seconds: 10),
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
        )) {
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        print('Request: ${options.method} ${options.uri}');
        return handler.next(options);
      },
      onResponse: (response, handler) {
        print('Response: ${response.statusCode}');
        return handler.next(response);
      },
      onError: (DioException e, handler) {
        print('Error: ${e.message}');
        return handler.next(e);
      },
    ));
  }

  Future<List<MenuItem>> fetchMenuItems() async {
    try {
      final response = await _dio.get(
        'api/show/menu-list',
        queryParameters: {
          'customer_id': Constants.customerId,
          'hotel_id': Constants.hotelId,
        },
      );
      return (response.data['data'] as List)
          .map((item) => MenuItem.fromJson(item))
          .toList();
    } on DioException catch (e) {
      throw NetworkExceptions.getErrorMessage(e);
    } catch (e) {
      throw 'Unexpected error: $e';
    }
  }

  Future<void> addToCart({
    required int menuId,
    required int partnerId,
    required int quantity,
    required String size,
    required double amount,
  }) async {
    try {
      await _dio.post(
        'api/add/cart',
        data: {
          'menu_id': menuId,
          'customer_id': Constants.customerId,
          'partner_id': partnerId,
          'quantity': quantity,
          'size': size,
          'amount': amount,
        },
      );
    } on DioException catch (e) {
      throw NetworkExceptions.getErrorMessage(e);
    } catch (e) {
      throw 'Unexpected error: $e';
    }
  }

  Future<void> updateCartQuantity(int cartId, String status) async {
    try {
      await _dio.post(
        'api/add-remove/quantity/cart',
        data: {
          'cart_id': cartId,
          'status': status,
        },
      );
    } on DioException catch (e) {
      throw NetworkExceptions.getErrorMessage(e);
    } catch (e) {
      throw 'Unexpected error: $e';
    }
  }

 



  Future<List<CartItem>> fetchCartItems() async {
    try {
     final response = await _dio.get(
        'api/show/cart',
        queryParameters: {
          'customer_id': Constants.customerId,
        },
      );
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['data'] ?? [];
        return data.map((json) => CartItem.fromJson(json)).toList();
      } else if (response.statusCode == 404 && response.data['message'] == 'Empty Cart') {
        return []; // Return empty list for 404 with empty cart
      }
      throw DioException(
        requestOptions: response.requestOptions,
        response: response,
        type: DioExceptionType.badResponse,
      );
    } catch (e) {
      rethrow;
    }
  }

 Future<Map<String, dynamic>> fetchCartTotal({String couponCode = ''}) async {
    try {
      final response = await _dio.post(
        'api/cart/total', 
        data: {
          'customer_id': Constants.customerId,
          'coupon_code': couponCode,
        },
      );
      print('Cart Total Response: ${response.data}');
      return response.data;
    } on DioException catch (e) {
      print('Dio Error: ${e.type} ${e.message} ${e.response?.data}');
      throw NetworkExceptions.getErrorMessage(e);
    } catch (e) {
      print('Unexpected Error: $e');
      throw 'Unexpected error: $e';
    }
  }


}