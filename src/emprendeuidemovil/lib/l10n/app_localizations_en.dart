// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Client Service App';

  @override
  String hello(Object name) {
    return 'Hello, $name';
  }

  @override
  String get myCart => 'My Cart';

  @override
  String get services => 'Services';

  @override
  String get products => 'Products';

  @override
  String get cartEmpty => 'Your cart is empty. Add something!';

  @override
  String get add => 'Add';

  @override
  String get remove => 'Remove';

  @override
  String get edit => 'Edit';

  @override
  String get cancel => 'Cancel';

  @override
  String get save => 'Save';

  @override
  String get saveChanges => 'Save Changes';

  @override
  String get accept => 'Accept';

  @override
  String get accepted => 'Accepted';

  @override
  String get pending => 'Pending';

  @override
  String get comment => 'Comment';

  @override
  String get quantity => 'Quantity';

  @override
  String get price => 'Price';

  @override
  String get total => 'Total';

  @override
  String get subtotal => 'Subtotal';

  @override
  String get editComment => 'Edit Comment';

  @override
  String get editQuantity => 'Edit Quantity';

  @override
  String get commentPlaceholder => 'Describe what you need...';

  @override
  String get commentCannotBeEmpty => 'Comment cannot be empty';

  @override
  String get commentUpdated => 'Comment updated';

  @override
  String quantityUpdated(Object quantity) {
    return 'Quantity updated to $quantity';
  }

  @override
  String get quantityMustBeGreaterThanZero => 'Quantity must be greater than 0';

  @override
  String get paymentMethod => 'Payment Method';

  @override
  String get paymentMethodTitle => 'Payment Method';

  @override
  String get selectPaymentMethod => 'Select a payment method';

  @override
  String get payInPerson => 'Pay in person';

  @override
  String get payByTransfer => 'Pay by transfer';

  @override
  String get secureLocation => 'Secure location';

  @override
  String get transferData => 'Transfer data';

  @override
  String get bankName => 'Bank: National Bank';

  @override
  String get accountNumber => 'Account: 1234-5678-9012';

  @override
  String get holderID => 'Holder ID: 1234567890';

  @override
  String get reference => 'Reference: Purchase at EmprendeUI';

  @override
  String get pay => 'Pay';

  @override
  String paymentSuccessful(Object method) {
    return 'Payment successful via $method!';
  }

  @override
  String get myProfile => 'My Profile';

  @override
  String get fullName => 'Full Name';

  @override
  String get phone => 'Phone';

  @override
  String get cellphone => 'Cell phone';

  @override
  String get cellphonePlaceholder => 'e.g. ';

  @override
  String get email => 'Email';

  @override
  String get settings => 'Settings';

  @override
  String get customize => 'Customize your experience';

  @override
  String get notifications => 'Notifications';

  @override
  String get generalNotifications => 'General notifications';

  @override
  String get generalNotificationsSubtitle => 'Receive important updates';

  @override
  String get requests => 'Requests';

  @override
  String get requestsSubtitle => 'Status of your requests';

  @override
  String get offersAndPromotions => 'Offers and promotions';

  @override
  String get offersSubtitle => 'Exclusive UIDE discounts';

  @override
  String get appearance => 'Appearance';

  @override
  String get darkMode => 'Dark Mode';

  @override
  String get darkModeComingSoon => 'Coming soon';

  @override
  String get language => 'Language';

  @override
  String get spanish => 'Spanish';

  @override
  String get english => 'English';

  @override
  String get privacyAndSecurity => 'Privacy and Security';

  @override
  String get privacySubtitle => 'Protect your information';

  @override
  String get helpAndSupport => 'Help and Support';

  @override
  String get helpSubtitle => 'We\'re here to help you';

  @override
  String get appVersion => 'EmprendeUIDE v1.0';

  @override
  String get appDescription => 'Official student marketplace';

  @override
  String get university => 'International University of Ecuador';

  @override
  String get copyright => '© 2025 UIDE. All rights reserved.';

  @override
  String get changesSaved => 'Changes saved';

  @override
  String get myFavorites => 'My Favorites';

  @override
  String get noFavorites => 'No favorites. Add some from Home!';

  @override
  String get search => 'Search';

  @override
  String get searchPlaceholder => 'What do you need today? Search for services or entrepreneurships';

  @override
  String searchResults(Object query) {
    return 'Search results ($query)';
  }

  @override
  String get suggestedOptions => 'Suggested options';

  @override
  String get topFeatured => 'TOP Featured';

  @override
  String get allEntrepreneurships => 'All Entrepreneurships';

  @override
  String get moreResults => 'More results';

  @override
  String get noExactResults => 'No exact results found.';

  @override
  String showingServices(Object category, Object count) {
    return 'Showing $count services in $category';
  }

  @override
  String get categories => 'Categories';

  @override
  String get food => 'Food';

  @override
  String get tutoring => 'Tutoring';

  @override
  String get portfolios => 'Portfolios';

  @override
  String get consultations => 'Consultations';

  @override
  String get designs => 'Designs';

  @override
  String get books => 'Books';

  @override
  String get templates => 'Templates';

  @override
  String get languages => 'Languages';

  @override
  String get writing => 'Writing';

  @override
  String get prototypes => 'Prototypes';

  @override
  String get research => 'Research';

  @override
  String get art => 'Art';

  @override
  String get presentations => 'Presentations';

  @override
  String get accessories => 'Accessories';

  @override
  String get technology => 'Technology';

  @override
  String get crafts => 'Crafts';

  @override
  String get availableServices => 'Available Services';

  @override
  String get availableProducts => 'Available Products';

  @override
  String get noServicesAvailable => 'No services available at this time.';

  @override
  String get noProductsAvailable => 'No products available at this time.';

  @override
  String get serviceDescription => 'Service Description';

  @override
  String get request => 'Request';

  @override
  String get addToCart => 'Add to Cart';

  @override
  String get serviceRequested => 'Service requested and added to cart';

  @override
  String productAdded(Object quantity) {
    return 'Product added to cart ($quantity)';
  }

  @override
  String get information => 'Information';

  @override
  String get schedule => 'Schedule';

  @override
  String get location => 'Location';

  @override
  String get scheduleValue => 'Mon-Fri 10:00-16:00';

  @override
  String get locationValue => 'Mock address, Quito, Ecuador';

  @override
  String get mapPlaceholder => 'Map Placeholder';

  @override
  String get myOrders => 'My Orders';

  @override
  String get myReviews => 'My Reviews';

  @override
  String get serviceRating => 'Service Rating';

  @override
  String get logout => 'Logout';

  @override
  String get sessionClosed => 'Session closed';

  @override
  String get client => 'Client';

  @override
  String get entrepreneur => 'Entrepreneur';

  @override
  String get clientModeActivated => 'Client mode activated';

  @override
  String get entrepreneurModeActivated => 'Entrepreneur mode activated';

  @override
  String get register => 'Register';

  @override
  String get login => 'Login';

  @override
  String get password => 'Password';

  @override
  String get institutionalEmail => 'Institutional email';

  @override
  String get selectYourRole => 'Select your role';

  @override
  String get seller => 'Seller';

  @override
  String get buyer => 'Buyer';

  @override
  String get registerMe => 'Register';

  @override
  String get mustUseInstitutionalEmail => 'Must use an institutional email @uide.edu.ec';

  @override
  String get mustSelectOneRole => 'Must choose only one role: seller or buyer';

  @override
  String userRegisteredSuccessfully(Object name) {
    return 'User $name registered successfully';
  }

  @override
  String get requiredField => 'Required field';

  @override
  String get minimumCharacters => 'Minimum 6 characters';

  @override
  String get createEntrepreneurship => 'Create Entrepreneurship';

  @override
  String get basicInformation => 'Basic Information';

  @override
  String get entrepreneurshipName => 'Entrepreneurship Name';

  @override
  String get entrepreneurshipNamePlaceholder => 'E.g. Homemade Delights';

  @override
  String get category => 'Category';

  @override
  String get description => 'Description';

  @override
  String get descriptionPlaceholder => 'Describe your entrepreneurship';

  @override
  String get locationPlaceholder => 'E.g. Quito Campus';

  @override
  String get scheduleAttention => 'Business Hours';

  @override
  String get schedulePlaceholder => 'E.g. Mon-Fri 9:00-17:00';

  @override
  String servicesProducts(Object count) {
    return 'Services / Products ($count Services)';
  }

  @override
  String get noServicesYet => 'You haven\'t added services yet.';

  @override
  String get addNewService => 'Add new service:';

  @override
  String get serviceName => 'Service name';

  @override
  String get briefDescription => 'Brief description';

  @override
  String get priceExample => 'Price (E.g: \$5.00)';

  @override
  String get addService => 'Add Service';

  @override
  String get entrepreneurshipCreated => 'Entrepreneurship created';

  @override
  String get protectedAccount => 'Protected Account';

  @override
  String get accountProtectedMessage => 'Your account is active and protected. Keep your data safe with our recommendations.';

  @override
  String get profilePrivacy => 'Profile privacy';

  @override
  String get showEmail => 'Show email';

  @override
  String get showEmailSubtitle => 'Visible on your public profile';

  @override
  String get showPhone => 'Show phone';

  @override
  String get showPhoneSubtitle => 'Visible on your public profile';

  @override
  String get privacyCommitment => 'We are committed to protecting your privacy and keeping your data secure.';

  @override
  String get privacyPolicy => 'Privacy Policy';

  @override
  String get termsOfUse => 'Terms of Use';

  @override
  String get writeYourMessage => 'Write your message...';

  @override
  String get send => 'Send';

  @override
  String get assistantGreeting => 'Hello, I\'m your Emprende UIDE virtual assistant. How can I help you?';

  @override
  String get thankYouMessage => 'Thank you for your message. We will respond soon.';

  @override
  String get whatsapp => 'WhatsApp';

  @override
  String viewDetails(Object name) {
    return 'View $name';
  }

  @override
  String get ordersScreenPlaceholder => 'My Orders Screen - Implement orders list with status';

  @override
  String get reviewsScreenPlaceholder => 'My Reviews Screen - Implement reviews list with check/trash';

  @override
  String get ratingsScreenPlaceholder => 'Service Rating Screen - Implement cards with stars';
}
