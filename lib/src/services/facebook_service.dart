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
          _analytics.logPurchase(
            amount: (params?['amount'] as num?)?.toDouble() ?? 0,
            currency: params?['currency'] as String? ?? 'USD',
            parameters: params,
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
            totalPrice: (params?['totalPrice'] as num?)?.toDouble(),
            currency: params?['currency'] as String?,
            contentType: params?['contentType'] as String?,
            contentId: params?['contentId'] as String?,
            numItems: params?['numItems'] as int?,
            paymentInfoAvailable: params?['paymentInfoAvailable'] == true,
          );
          break;

        case 'subscribe':
          _analytics.logSubscribe(
            price: (params?['price'] as num?)?.toDouble(),
            currency: params?['currency'] as String?,
            orderId: params?['orderId'] as String? ?? '',
          );
          break;

        case 'start_trial':
          _analytics.logStartTrial(
            price: (params?['price'] as num?)?.toDouble(),
            currency: params?['currency'] as String?,
            orderId: params?['orderId'] as String? ?? '',
          );
          break;

        case 'ad_impression':
          _analytics.logAdImpression(
            adType: params?['adType'] as String? ?? '',
          );
          break;

        case 'ad_click':
          _analytics.logAdClick(
            adType: params?['adType'] as String? ?? '',
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