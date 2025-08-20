import 'package:facebook_app_events/facebook_app_events.dart';

import 'analytics_service.dart';

class FacebookAdapter implements AnalyticsService {
  FacebookAdapter(this._analytics);

  final FacebookAppEvents _analytics;

  final Map<String, String?> _userData = {};

  @override
  Future<void> logEvent(String name, {Map<String, Object>? params}) {
    switch (name) {
      case 'purchase':
        return _analytics.logPurchase(
          amount: (params?['amount'] as num?)?.toDouble() ?? 0,
          currency: params?['currency'] as String? ?? 'USD',
          parameters: params,
        );

      case 'add_to_cart':
        return _analytics.logAddToCart(
          content: params?['content'] as Map<String, dynamic>?,
          id: params?['id'] as String? ?? '',
          type: params?['type'] as String? ?? '',
          currency: params?['currency'] as String? ?? 'USD',
          price: (params?['price'] as num?)?.toDouble() ?? 0,
        );

      case 'add_to_wishlist':
        return _analytics.logAddToWishlist(
          content: params?['content'] as Map<String, dynamic>?,
          id: params?['id'] as String? ?? '',
          type: params?['type'] as String? ?? '',
          currency: params?['currency'] as String? ?? 'USD',
          price: (params?['price'] as num?)?.toDouble() ?? 0,
        );

      case 'view_content':
        return _analytics.logViewContent(
          content: params?['content'] as Map<String, dynamic>?,
          id: params?['id'] as String?,
          type: params?['type'] as String?,
          currency: params?['currency'] as String?,
          price: (params?['price'] as num?)?.toDouble(),
        );

      case 'completed_registration':
        return _analytics.logCompletedRegistration(
          registrationMethod: params?['method'] as String?,
        );

      case 'rated':
        return _analytics.logRated(
          valueToSum: (params?['value'] as num?)?.toDouble(),
        );

      case 'initiated_checkout':
        return _analytics.logInitiatedCheckout(
          totalPrice: (params?['totalPrice'] as num?)?.toDouble(),
          currency: params?['currency'] as String?,
          contentType: params?['contentType'] as String?,
          contentId: params?['contentId'] as String?,
          numItems: params?['numItems'] as int?,
          paymentInfoAvailable: params?['paymentInfoAvailable'] == true,
        );

      case 'subscribe':
        return _analytics.logSubscribe(
          price: (params?['price'] as num?)?.toDouble(),
          currency: params?['currency'] as String?,
          orderId: params?['orderId'] as String? ?? '',
        );

      case 'start_trial':
        return _analytics.logStartTrial(
          price: (params?['price'] as num?)?.toDouble(),
          currency: params?['currency'] as String?,
          orderId: params?['orderId'] as String? ?? '',
        );

      case 'ad_impression':
        return _analytics.logAdImpression(
          adType: params?['adType'] as String? ?? '',
        );

      case 'ad_click':
        return _analytics.logAdClick(
          adType: params?['adType'] as String? ?? '',
        );

      default:
        return _analytics.logEvent(name: name, parameters: params);
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