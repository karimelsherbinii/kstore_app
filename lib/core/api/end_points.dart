class EndPoints {
  static const String baseUrl = 'https://www.kstoremarket.shop/api';
  static const String products = '$baseUrl/products';
  static const String categories = '$baseUrl/categories';
  static const String login = '$baseUrl/login';
  static const String register = '$baseUrl/register';
  static const String orders = '$baseUrl/orders';
  static const String favorites = '$baseUrl/favorites';
  static const String stories = '$baseUrl/stories';
  static const String cart = '$baseUrl/carts';
  static const String address = '$baseUrl/addresses';
  static const String user = '$baseUrl/user';
  static const String notifications = '$baseUrl/notifications';
  static const String ads = '$baseUrl/ads';
  static const String notificationsBroadcastingAuth =
      '$baseUrl/Illuminate\Notifications\Events\BroadcastNotificationCreated'; //TODO: change channel name to be dynamic id
//stripe base url
static const String stripeBaseUrl = 'https://api.stripe.com/v1';
static const String stripePaymentIntent = '$stripeBaseUrl/payment_intents';
static const String stripePaymentMethod = '$stripeBaseUrl/payment_methods';
static const String stripePaymentIntentConfirm = '$stripeBaseUrl/payment_intents/{PAYMENT_INTENT_ID}/confirm';
static const String stripePaymentIntentCapture = '$stripeBaseUrl/payment_intents/{PAYMENT_INTENT_ID}/capture';
static const String stripePaymentIntentCancel = '$stripeBaseUrl/payment_intents/{PAYMENT_INTENT_ID}/cancel';
static const String stripePaymentIntentRetrieve = '$stripeBaseUrl/payment_intents/{PAYMENT_INTENT_ID}';
static const String stripePaymentIntentList = '$stripeBaseUrl/payment_intents';
static const String stripePaymentIntentUpdate = '$stripeBaseUrl/payment_intents/{PAYMENT_INTENT_ID}';



//paymob base url
static const String paymobBaseUrl = 'https://accept.paymob.com/api';
static const String paymobAuth = '$paymobBaseUrl/auth/tokens';
static const String paymobOrders = '$paymobBaseUrl/ecommerce/orders';
static const String paymobPaymentKeys = '$paymobBaseUrl/acceptance/payment_keys';


}

