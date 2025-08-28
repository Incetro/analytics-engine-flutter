import 'package:facebook_app_events/facebook_app_events.dart';
import 'package:flutter/foundation.dart';

import 'analytics_service.dart';

class FacebookAdapter implements AnalyticsService {
  FacebookAdapter(this._analytics);

  final FacebookAppEvents _analytics;

  final Map<String, String?> _userData = {};

  @override
  Future<void> logEvent(String name, {Map<String, Object>? params}) async {
    try {
      switch (name) {
        case 'purchase':
          final raw = params ?? {};

          final amount = (raw['amount'] as num?)?.toDouble() ?? 0;
          final currency = raw['currency'] as String? ?? 'USD';

          final parameters = Map<String, dynamic>.from(raw)
            ..remove('amount')
            ..remove('currency');

          _analytics.logPurchase(
            amount: amount,
            currency: currency,
            parameters: parameters,
          );
          break;

        case 'add_to_cart':
          _analytics.logAddToCart(
            content: params?['content'] as Map<String, dynamic>?,
            id: params?['id'] as String? ?? '',
            type: params?['type'] as String? ?? '',
            currency: params?['currency'] as String? ?? 'USD',
            price: (params?['price'] as num?)?.toDouble() ?? 0,
          );
          break;

        case 'add_to_wishlist':
          _analytics.logAddToWishlist(
            content: params?['content'] as Map<String, dynamic>?,
            id: params?['id'] as String? ?? '',
            type: params?['type'] as String? ?? '',
            currency: params?['currency'] as String? ?? 'USD',
            price: (params?['price'] as num?)?.toDouble() ?? 0,
          );
          break;

        case 'view_content':
          _analytics.logViewContent(
            content: params?['content'] as Map<String, dynamic>?,
            id: params?['id'] as String?,
            type: params?['type'] as String?,
            currency: params?['currency'] as String?,
            price: (params?['price'] as num?)?.toDouble(),
          );
          break;

        case 'completed_registration':
          _analytics.logCompletedRegistration(
            registrationMethod: params?['method'] as String?,
          );
          break;

        case 'rated':
           _analytics.logRated(
            valueToSum: (params?['value'] as num?)?.toDouble(),
          );
          break;

        case 'initiated_checkout':
          _analytics.logInitiatedCheckout(
            totalPrice: (params?['total_price'] as num?)?.toDouble(),
            currency: params?['currency'] as String?,
            contentType: params?['content_type'] as String?,
            contentId: params?['content_id'] as String?,
            numItems: params?['num_items'] as int?,
            paymentInfoAvailable: params?['payment_info_available'] == true,
          );
          break;

        case 'subscribe':
          _analytics.logSubscribe(
            price: (params?['price'] as num?)?.toDouble(),
            currency: params?['currency'] as String?,
            orderId: params?['order_id'] as String? ?? '',
          );
          break;

        case 'start_trial':
          _analytics.logStartTrial(
            price: (params?['price'] as num?)?.toDouble(),
            currency: params?['currency'] as String?,
            orderId: params?['order_id'] as String? ?? '',
          );
          break;

        case 'ad_impression':
          _analytics.logAdImpression(
            adType: params?['ad_type'] as String? ?? '',
          );
          break;

        case 'ad_click':
          _analytics.logAdClick(
            adType: params?['ad_type'] as String? ?? '',
          );
          break;

        default:
          _analytics.logEvent(name: name, parameters: params);
      }
      debugPrint(
        "✅ [FacebookAdapter] Event sent → "
        "name: '$name', params: ${params ?? {}}",
      );
    } catch (e, stack) {
       debugPrint(
        "❌ [FacebookAdapter] Failed to send event → "
        "name: '$name', error: $e\n$stack",
      );
    }
    
  }

  @override
  Future<void> setUserId(String userId) {
    return _analytics.setUserID(userId);
  }

  @override
  Future<void> setUserProperty(String key, String value) {
    
    const allowedKeys = {
      'email',
      'firstName',
      'lastName',
      'phone',
      'dateOfBirth',
      'gender',
      'city',
      'state',
      'zip',
      'country',
    };

    if (!allowedKeys.contains(key)) {
      return Future.value();
    }

    _userData[key] = value;

    return _analytics.setUserData(
      email: _userData['email'],
      firstName: _userData['firstName'],
      lastName: _userData['lastName'],
      phone: _userData['phone'],
      dateOfBirth: _userData['dateOfBirth'],
      gender: _userData['gender'],
      city: _userData['city'],
      state: _userData['state'],
      zip: _userData['zip'],
      country: _userData['country'],
    );
  }
}