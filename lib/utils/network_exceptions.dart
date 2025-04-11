import 'package:dio/dio.dart';

class NetworkExceptions {
  static String getErrorMessage(dynamic error) {
  
    if (error is DioException) {
   
      switch (error.type) {
        case DioExceptionType.connectionTimeout:
          return 'Connection timeout. Please check your internet.';
        case DioExceptionType.sendTimeout:
          return 'Request timeout. Please try again.';
        case DioExceptionType.receiveTimeout:
          return 'Response timeout. Please try again.';
        case DioExceptionType.badResponse:
          return _handleStatusCode(error.response);
        case DioExceptionType.cancel:
          return 'Request was cancelled.';
        case DioExceptionType.connectionError:
          return 'Connection error. Please check your network.';
        default:
          return 'An unexpected error occurred: ${error.message ?? error.toString()}';
      }
    }
    return 'Unknown error: $error';
  }

  static String _handleStatusCode(Response? response) {
    if (response == null) {
    
      return 'No response from server.';
    }

  
    final data = response.data;
    if (data is Map && data['message'] == 'Empty Cart' && response.statusCode == 404) {
      return ''; 
    }

    switch (response.statusCode) {
      case 400:
        return 'Bad request. Please check your input.';
      case 401:
        return 'Unauthorized. Please log in again.';
      case 403:
        return 'Forbidden. You don’t have permission.';
      case 404:
        return 'Resource not found.';
      case 500:
        return 'Server error. Please try again later.';
      default:
        return 'HTTP error: ${response.statusCode}';
    }
  }
}