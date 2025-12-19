import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:mamicoach_mobile/core/constants/api_constants.dart' as api_constants;
import 'package:mamicoach_mobile/models/payment.dart';

class PaymentService {
  /// Process payment for a booking
  /// POST /payment/booking/{booking_id}/process/
  static Future<PaymentResponse> processPayment(
    CookieRequest request,
    int bookingId,
    String paymentMethod,
  ) async {
    try {
      final response = await request.post(
        '${api_constants.baseUrl}/payment/booking/$bookingId/process/',
        {
          'payment_method': paymentMethod,
        },
      );

      return PaymentResponse.fromJson(response);
    } catch (e) {
      throw Exception('Failed to process payment: $e');
    }
  }

  /// Get payment status
  /// GET /payment/status/{payment_id}/
  static Future<PaymentStatusResponse> getPaymentStatus(
    CookieRequest request,
    int paymentId, {
    bool refresh = false,
  }) async {
    try {
      final url = refresh
          ? '${api_constants.baseUrl}/payment/status/$paymentId/?refresh=true'
          : '${api_constants.baseUrl}/payment/status/$paymentId/';
      
      final response = await request.get(url);

      return PaymentStatusResponse.fromJson(response);
    } catch (e) {
      throw Exception('Failed to get payment status: $e');
    }
  }

  /// Poll payment status with retry logic
  /// Returns true if payment successful, false if failed, null if still pending after timeout
  static Future<bool?> pollPaymentStatus(
    CookieRequest request,
    int paymentId, {
    int maxAttempts = 20,
    Duration pollInterval = const Duration(seconds: 3),
    Function(PaymentStatusResponse)? onStatusUpdate,
  }) async {
    for (int attempt = 0; attempt < maxAttempts; attempt++) {
      try {
        final status = await getPaymentStatus(request, paymentId, refresh: true);
        
        // Notify caller of status update
        onStatusUpdate?.call(status);

        if (status.isSuccessful) {
          return true;
        } else if (status.isFailed) {
          return false;
        }

        // Still pending, wait before next attempt
        if (attempt < maxAttempts - 1) {
          await Future.delayed(pollInterval);
        }
      } catch (e) {
        // On error, continue polling unless it's the last attempt
        if (attempt == maxAttempts - 1) {
          throw Exception('Failed to poll payment status: $e');
        }
        await Future.delayed(pollInterval);
      }
    }

    // Timeout - payment still pending
    return null;
  }

  /// Check if a URL is a payment callback URL
  static bool isPaymentCallbackUrl(String url) {
    return url.contains('/payment/callback/') ||
        url.contains('/payment/unfinish/') ||
        url.contains('/payment/error/');
  }

  /// Determine payment result from callback URL
  static PaymentCallbackResult getCallbackResult(String url) {
    if (url.contains('/payment/callback/')) {
      return PaymentCallbackResult.completed;
    } else if (url.contains('/payment/unfinish/')) {
      return PaymentCallbackResult.unfinished;
    } else if (url.contains('/payment/error/')) {
      return PaymentCallbackResult.error;
    }
    return PaymentCallbackResult.unknown;
  }
}

enum PaymentCallbackResult {
  completed,
  unfinished,
  error,
  unknown,
}
