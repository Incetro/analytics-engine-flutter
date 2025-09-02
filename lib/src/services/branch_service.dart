import 'package:analytics_manager/src/index.dart';

class BranchAnalyticsAdapter implements AnalyticsService {
  BranchAnalyticsAdapter({required this.logger}) {
    FlutterBranchSdk.init();
  }

  @override
  final AnalysisLogger logger;
  @override
  Future<void> logEvent(String name, {Map<String, Object>? params}) async {
    try {
      final rawParams = params ?? {};

      switch (name.toLowerCase()) {
        // Commerce events
        case 'add_to_cart':
          final event = BranchEvent.standardEvent(BranchStandardEvent.ADD_TO_CART);
          _fillStandardFields(event, rawParams);
          break;

        case 'add_to_wishlist':
          final event = BranchEvent.standardEvent(BranchStandardEvent.ADD_TO_WISHLIST);
          _fillStandardFields(event, rawParams);
          break;

        case 'view_cart':
          final event = BranchEvent.standardEvent(BranchStandardEvent.VIEW_CART);
          _fillStandardFields(event, rawParams);
          break;

        case 'initiate_purchase':
          final event = BranchEvent.standardEvent(BranchStandardEvent.INITIATE_PURCHASE);
          _fillStandardFields(event, rawParams);
          break;

        case 'purchase':
          final event = BranchEvent.standardEvent(BranchStandardEvent.PURCHASE);
          _fillStandardFields(event, rawParams);
          break;

        case 'click_ad':
          final event = BranchEvent.standardEvent(BranchStandardEvent.CLICK_AD);
          _fillStandardFields(event, rawParams);
          break;

        case 'reserve':
          final event = BranchEvent.standardEvent(BranchStandardEvent.RESERVE);
          _fillStandardFields(event, rawParams);
          break;

        case 'view_ad':
          final event = BranchEvent.standardEvent(BranchStandardEvent.VIEW_AD);
          _fillStandardFields(event, rawParams);
          break;

        // Content events
        case 'search':
          final event = BranchEvent.standardEvent(BranchStandardEvent.SEARCH);
          _fillStandardFields(event, rawParams);
          break;

        case 'view_item':
          final event = BranchEvent.standardEvent(BranchStandardEvent.VIEW_ITEM);
          _fillStandardFields(event, rawParams);
          break;

        case 'view_items':
          final event = BranchEvent.standardEvent(BranchStandardEvent.VIEW_ITEMS);
          _fillStandardFields(event, rawParams);
          break;

        case 'rate':
          final event = BranchEvent.standardEvent(BranchStandardEvent.RATE);
          _fillStandardFields(event, rawParams);
          break;

        case 'share':
          final event = BranchEvent.standardEvent(BranchStandardEvent.SHARE);
          _fillStandardFields(event, rawParams);
          break;

        // User lifecycle events
        case 'complete_registration':
          final event = BranchEvent.standardEvent(BranchStandardEvent.COMPLETE_REGISTRATION);
          _fillStandardFields(event, rawParams);
          break;

        case 'complete_tutorial':
          final event = BranchEvent.standardEvent(BranchStandardEvent.COMPLETE_TUTORIAL);
          _fillStandardFields(event, rawParams);
          break;

        case 'achieve_level':
          final event = BranchEvent.standardEvent(BranchStandardEvent.ACHIEVE_LEVEL);
          _fillStandardFields(event, rawParams);
          break;

        case 'unlock_achievement':
          final event = BranchEvent.standardEvent(BranchStandardEvent.UNLOCK_ACHIEVEMENT);
          _fillStandardFields(event, rawParams);
          break;

        case 'invite':
          final event = BranchEvent.standardEvent(BranchStandardEvent.INVITE);
          _fillStandardFields(event, rawParams);
          break;

        case 'login':
          final event = BranchEvent.standardEvent(BranchStandardEvent.LOGIN);
          _fillStandardFields(event, rawParams);
          break;

        case 'start_trial':
          final event = BranchEvent.standardEvent(BranchStandardEvent.START_TRIAL);
          _fillStandardFields(event, rawParams);
          break;

        case 'subscribe':
          final event = BranchEvent.standardEvent(BranchStandardEvent.SUBSCRIBE);
          _fillStandardFields(event, rawParams);
          break;

        default:
          final event = BranchEvent.customEvent(name);
          rawParams.forEach((k, v) => event.addCustomData(k, v));
          FlutterBranchSdk.trackContentWithoutBuo(branchEvent: event);
          break;
      }

      logger.logSuccess(
        text: 'Event sent',
        source: 'Branch Adapter',
        eventName: name,
        params: params,
      );
    } catch (e, stack) {
      logger.logError(
        source: 'Branch Adapter',
        text: 'Failed to send event',
        stack: stack,
        eventName: name,
        params: params,
      );
    }
  }

  void _fillStandardFields(BranchEvent event, Map<String, Object> params) {
    if (params['transaction_id'] != null) {
      event.transactionID = params['transaction_id'].toString();
    }
    if (params['revenue'] != null) {
      event.revenue = double.tryParse(params['revenue'].toString()) ?? -1;
    }
    if (params['currency'] != null) {
      event.currency = params['currency'] == 'RUB' ?  BranchCurrencyType.RUB : params['currency'] == 'EUR' ? BranchCurrencyType.EUR : BranchCurrencyType.USD;
    }
    if (params['shipping'] != null) {
      event.shipping = double.tryParse(params['shipping'].toString()) ?? -1;
    }
    if (params['tax'] != null) {
      event.tax = double.tryParse(params['tax'].toString()) ?? -1;
    }
    if (params['coupon'] != null) {
      event.coupon = params['coupon'].toString();
    }
    if (params['affiliation'] != null) {
      event.affiliation = params['affiliation'].toString();
    }
    if (params['event_description'] != null) {
      event.eventDescription = params['event_description'].toString();
    }
    if (params['search_query'] != null) {
      event.searchQuery = params['search_query'].toString();
    }

    params.forEach((k, v) {
      if (![
        'transaction_id',
        'revenue',
        'currency',
        'shipping',
        'tax',
        'coupon',
        'affiliation',
        'event_description',
        'search_query',
      ].contains(k)) {
        event.addCustomData(k, v);
      }
    });

    FlutterBranchSdk.trackContentWithoutBuo(branchEvent: event);
  }


  @override
  Future<void> setUserId(String userId) async {
    FlutterBranchSdk.setIdentity(userId);
  }

  @override
  Future<void> setUserProperty(String key, String value) async {
    FlutterBranchSdk.setRequestMetadata(key, value);
  }
}
