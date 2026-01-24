import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_es.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('es')
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Client Service App'**
  String get appTitle;

  /// No description provided for @hello.
  ///
  /// In en, this message translates to:
  /// **'Hello, {name}'**
  String hello(Object name);

  /// No description provided for @myCart.
  ///
  /// In en, this message translates to:
  /// **'My Cart'**
  String get myCart;

  /// No description provided for @services.
  ///
  /// In en, this message translates to:
  /// **'Services'**
  String get services;

  /// No description provided for @products.
  ///
  /// In en, this message translates to:
  /// **'Products'**
  String get products;

  /// No description provided for @cartEmpty.
  ///
  /// In en, this message translates to:
  /// **'Your cart is empty. Add something!'**
  String get cartEmpty;

  /// No description provided for @add.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get add;

  /// No description provided for @remove.
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get remove;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @saveChanges.
  ///
  /// In en, this message translates to:
  /// **'Save Changes'**
  String get saveChanges;

  /// No description provided for @accept.
  ///
  /// In en, this message translates to:
  /// **'Accept'**
  String get accept;

  /// No description provided for @accepted.
  ///
  /// In en, this message translates to:
  /// **'Accepted'**
  String get accepted;

  /// No description provided for @pending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get pending;

  /// No description provided for @comment.
  ///
  /// In en, this message translates to:
  /// **'Comment'**
  String get comment;

  /// No description provided for @quantity.
  ///
  /// In en, this message translates to:
  /// **'Quantity'**
  String get quantity;

  /// No description provided for @price.
  ///
  /// In en, this message translates to:
  /// **'Price'**
  String get price;

  /// No description provided for @total.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get total;

  /// No description provided for @subtotal.
  ///
  /// In en, this message translates to:
  /// **'Subtotal'**
  String get subtotal;

  /// No description provided for @editComment.
  ///
  /// In en, this message translates to:
  /// **'Edit Comment'**
  String get editComment;

  /// No description provided for @editQuantity.
  ///
  /// In en, this message translates to:
  /// **'Edit Quantity'**
  String get editQuantity;

  /// No description provided for @commentPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Describe what you need...'**
  String get commentPlaceholder;

  /// No description provided for @commentCannotBeEmpty.
  ///
  /// In en, this message translates to:
  /// **'Comment cannot be empty'**
  String get commentCannotBeEmpty;

  /// No description provided for @commentUpdated.
  ///
  /// In en, this message translates to:
  /// **'Comment updated'**
  String get commentUpdated;

  /// No description provided for @quantityUpdated.
  ///
  /// In en, this message translates to:
  /// **'Quantity updated to {quantity}'**
  String quantityUpdated(Object quantity);

  /// No description provided for @quantityMustBeGreaterThanZero.
  ///
  /// In en, this message translates to:
  /// **'Quantity must be greater than 0'**
  String get quantityMustBeGreaterThanZero;

  /// No description provided for @paymentMethod.
  ///
  /// In en, this message translates to:
  /// **'Payment Method'**
  String get paymentMethod;

  /// No description provided for @paymentMethodTitle.
  ///
  /// In en, this message translates to:
  /// **'Payment Method'**
  String get paymentMethodTitle;

  /// No description provided for @selectPaymentMethod.
  ///
  /// In en, this message translates to:
  /// **'Select a payment method'**
  String get selectPaymentMethod;

  /// No description provided for @payInPerson.
  ///
  /// In en, this message translates to:
  /// **'Pay in person'**
  String get payInPerson;

  /// No description provided for @payByTransfer.
  ///
  /// In en, this message translates to:
  /// **'Pay by transfer'**
  String get payByTransfer;

  /// No description provided for @secureLocation.
  ///
  /// In en, this message translates to:
  /// **'Secure location'**
  String get secureLocation;

  /// No description provided for @transferData.
  ///
  /// In en, this message translates to:
  /// **'Transfer data'**
  String get transferData;

  /// No description provided for @bankName.
  ///
  /// In en, this message translates to:
  /// **'Bank: National Bank'**
  String get bankName;

  /// No description provided for @accountNumber.
  ///
  /// In en, this message translates to:
  /// **'Account: 1234-5678-9012'**
  String get accountNumber;

  /// No description provided for @holderID.
  ///
  /// In en, this message translates to:
  /// **'Holder ID: 1234567890'**
  String get holderID;

  /// No description provided for @reference.
  ///
  /// In en, this message translates to:
  /// **'Reference: Purchase at EmprendeUI'**
  String get reference;

  /// No description provided for @pay.
  ///
  /// In en, this message translates to:
  /// **'Pay'**
  String get pay;

  /// No description provided for @paymentSuccessful.
  ///
  /// In en, this message translates to:
  /// **'Payment successful via {method}!'**
  String paymentSuccessful(Object method);

  /// No description provided for @myProfile.
  ///
  /// In en, this message translates to:
  /// **'My Profile'**
  String get myProfile;

  /// No description provided for @fullName.
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get fullName;

  /// No description provided for @phone.
  ///
  /// In en, this message translates to:
  /// **'Phone'**
  String get phone;

  /// No description provided for @cellphone.
  ///
  /// In en, this message translates to:
  /// **'Cell phone'**
  String get cellphone;

  /// No description provided for @cellphonePlaceholder.
  ///
  /// In en, this message translates to:
  /// **'e.g. '**
  String get cellphonePlaceholder;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @customize.
  ///
  /// In en, this message translates to:
  /// **'Customize your experience'**
  String get customize;

  /// No description provided for @notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// No description provided for @generalNotifications.
  ///
  /// In en, this message translates to:
  /// **'General notifications'**
  String get generalNotifications;

  /// No description provided for @generalNotificationsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Receive important updates'**
  String get generalNotificationsSubtitle;

  /// No description provided for @requests.
  ///
  /// In en, this message translates to:
  /// **'Requests'**
  String get requests;

  /// No description provided for @requestsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Status of your requests'**
  String get requestsSubtitle;

  /// No description provided for @offersAndPromotions.
  ///
  /// In en, this message translates to:
  /// **'Offers and promotions'**
  String get offersAndPromotions;

  /// No description provided for @offersSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Exclusive UIDE discounts'**
  String get offersSubtitle;

  /// No description provided for @appearance.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get appearance;

  /// No description provided for @darkMode.
  ///
  /// In en, this message translates to:
  /// **'Dark Mode'**
  String get darkMode;

  /// No description provided for @darkModeComingSoon.
  ///
  /// In en, this message translates to:
  /// **'Coming soon'**
  String get darkModeComingSoon;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @spanish.
  ///
  /// In en, this message translates to:
  /// **'Spanish'**
  String get spanish;

  /// No description provided for @english.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @privacyAndSecurity.
  ///
  /// In en, this message translates to:
  /// **'Privacy and Security'**
  String get privacyAndSecurity;

  /// No description provided for @privacySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Protect your information'**
  String get privacySubtitle;

  /// No description provided for @helpAndSupport.
  ///
  /// In en, this message translates to:
  /// **'Help and Support'**
  String get helpAndSupport;

  /// No description provided for @helpSubtitle.
  ///
  /// In en, this message translates to:
  /// **'We\'re here to help you'**
  String get helpSubtitle;

  /// No description provided for @appVersion.
  ///
  /// In en, this message translates to:
  /// **'EmprendeUIDE v1.0'**
  String get appVersion;

  /// No description provided for @appDescription.
  ///
  /// In en, this message translates to:
  /// **'Official student marketplace'**
  String get appDescription;

  /// No description provided for @university.
  ///
  /// In en, this message translates to:
  /// **'International University of Ecuador'**
  String get university;

  /// No description provided for @copyright.
  ///
  /// In en, this message translates to:
  /// **'© 2025 UIDE. All rights reserved.'**
  String get copyright;

  /// No description provided for @changesSaved.
  ///
  /// In en, this message translates to:
  /// **'Changes saved'**
  String get changesSaved;

  /// No description provided for @myFavorites.
  ///
  /// In en, this message translates to:
  /// **'My Favorites'**
  String get myFavorites;

  /// No description provided for @noFavorites.
  ///
  /// In en, this message translates to:
  /// **'No favorites. Add some from Home!'**
  String get noFavorites;

  /// No description provided for @search.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get search;

  /// No description provided for @searchPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'What do you need today? Search for services or entrepreneurships'**
  String get searchPlaceholder;

  /// No description provided for @searchResults.
  ///
  /// In en, this message translates to:
  /// **'Search results ({query})'**
  String searchResults(Object query);

  /// No description provided for @suggestedOptions.
  ///
  /// In en, this message translates to:
  /// **'Suggested options'**
  String get suggestedOptions;

  /// No description provided for @topFeatured.
  ///
  /// In en, this message translates to:
  /// **'TOP Featured'**
  String get topFeatured;

  /// No description provided for @allEntrepreneurships.
  ///
  /// In en, this message translates to:
  /// **'All Entrepreneurships'**
  String get allEntrepreneurships;

  /// No description provided for @moreResults.
  ///
  /// In en, this message translates to:
  /// **'More results'**
  String get moreResults;

  /// No description provided for @noExactResults.
  ///
  /// In en, this message translates to:
  /// **'No exact results found.'**
  String get noExactResults;

  /// No description provided for @showingServices.
  ///
  /// In en, this message translates to:
  /// **'Showing {count} services in {category}'**
  String showingServices(Object category, Object count);

  /// No description provided for @categories.
  ///
  /// In en, this message translates to:
  /// **'Categories'**
  String get categories;

  /// No description provided for @food.
  ///
  /// In en, this message translates to:
  /// **'Food'**
  String get food;

  /// No description provided for @tutoring.
  ///
  /// In en, this message translates to:
  /// **'Tutoring'**
  String get tutoring;

  /// No description provided for @portfolios.
  ///
  /// In en, this message translates to:
  /// **'Portfolios'**
  String get portfolios;

  /// No description provided for @consultations.
  ///
  /// In en, this message translates to:
  /// **'Consultations'**
  String get consultations;

  /// No description provided for @designs.
  ///
  /// In en, this message translates to:
  /// **'Designs'**
  String get designs;

  /// No description provided for @books.
  ///
  /// In en, this message translates to:
  /// **'Books'**
  String get books;

  /// No description provided for @templates.
  ///
  /// In en, this message translates to:
  /// **'Templates'**
  String get templates;

  /// No description provided for @languages.
  ///
  /// In en, this message translates to:
  /// **'Languages'**
  String get languages;

  /// No description provided for @writing.
  ///
  /// In en, this message translates to:
  /// **'Writing'**
  String get writing;

  /// No description provided for @prototypes.
  ///
  /// In en, this message translates to:
  /// **'Prototypes'**
  String get prototypes;

  /// No description provided for @research.
  ///
  /// In en, this message translates to:
  /// **'Research'**
  String get research;

  /// No description provided for @art.
  ///
  /// In en, this message translates to:
  /// **'Art'**
  String get art;

  /// No description provided for @presentations.
  ///
  /// In en, this message translates to:
  /// **'Presentations'**
  String get presentations;

  /// No description provided for @accessories.
  ///
  /// In en, this message translates to:
  /// **'Accessories'**
  String get accessories;

  /// No description provided for @technology.
  ///
  /// In en, this message translates to:
  /// **'Technology'**
  String get technology;

  /// No description provided for @crafts.
  ///
  /// In en, this message translates to:
  /// **'Crafts'**
  String get crafts;

  /// No description provided for @availableServices.
  ///
  /// In en, this message translates to:
  /// **'Available Services'**
  String get availableServices;

  /// No description provided for @availableProducts.
  ///
  /// In en, this message translates to:
  /// **'Available Products'**
  String get availableProducts;

  /// No description provided for @noServicesAvailable.
  ///
  /// In en, this message translates to:
  /// **'No services available at this time.'**
  String get noServicesAvailable;

  /// No description provided for @noProductsAvailable.
  ///
  /// In en, this message translates to:
  /// **'No products available at this time.'**
  String get noProductsAvailable;

  /// No description provided for @serviceDescription.
  ///
  /// In en, this message translates to:
  /// **'Service Description'**
  String get serviceDescription;

  /// No description provided for @request.
  ///
  /// In en, this message translates to:
  /// **'Request'**
  String get request;

  /// No description provided for @addToCart.
  ///
  /// In en, this message translates to:
  /// **'Add to Cart'**
  String get addToCart;

  /// No description provided for @serviceRequested.
  ///
  /// In en, this message translates to:
  /// **'Service requested and added to cart'**
  String get serviceRequested;

  /// No description provided for @productAdded.
  ///
  /// In en, this message translates to:
  /// **'Product added to cart ({quantity})'**
  String productAdded(Object quantity);

  /// No description provided for @information.
  ///
  /// In en, this message translates to:
  /// **'Information'**
  String get information;

  /// No description provided for @schedule.
  ///
  /// In en, this message translates to:
  /// **'Schedule'**
  String get schedule;

  /// No description provided for @location.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get location;

  /// No description provided for @scheduleValue.
  ///
  /// In en, this message translates to:
  /// **'Mon-Fri 10:00-16:00'**
  String get scheduleValue;

  /// No description provided for @locationValue.
  ///
  /// In en, this message translates to:
  /// **'Mock address, Quito, Ecuador'**
  String get locationValue;

  /// No description provided for @mapPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Map Placeholder'**
  String get mapPlaceholder;

  /// No description provided for @myOrders.
  ///
  /// In en, this message translates to:
  /// **'My Orders'**
  String get myOrders;

  /// No description provided for @myReviews.
  ///
  /// In en, this message translates to:
  /// **'My Reviews'**
  String get myReviews;

  /// No description provided for @serviceRating.
  ///
  /// In en, this message translates to:
  /// **'Service Rating'**
  String get serviceRating;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// No description provided for @sessionClosed.
  ///
  /// In en, this message translates to:
  /// **'Session closed'**
  String get sessionClosed;

  /// No description provided for @client.
  ///
  /// In en, this message translates to:
  /// **'Client'**
  String get client;

  /// No description provided for @entrepreneur.
  ///
  /// In en, this message translates to:
  /// **'Entrepreneur'**
  String get entrepreneur;

  /// No description provided for @clientModeActivated.
  ///
  /// In en, this message translates to:
  /// **'Client mode activated'**
  String get clientModeActivated;

  /// No description provided for @entrepreneurModeActivated.
  ///
  /// In en, this message translates to:
  /// **'Entrepreneur mode activated'**
  String get entrepreneurModeActivated;

  /// No description provided for @register.
  ///
  /// In en, this message translates to:
  /// **'Register'**
  String get register;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @institutionalEmail.
  ///
  /// In en, this message translates to:
  /// **'Institutional email'**
  String get institutionalEmail;

  /// No description provided for @selectYourRole.
  ///
  /// In en, this message translates to:
  /// **'Select your role'**
  String get selectYourRole;

  /// No description provided for @seller.
  ///
  /// In en, this message translates to:
  /// **'Seller'**
  String get seller;

  /// No description provided for @buyer.
  ///
  /// In en, this message translates to:
  /// **'Buyer'**
  String get buyer;

  /// No description provided for @registerMe.
  ///
  /// In en, this message translates to:
  /// **'Register'**
  String get registerMe;

  /// No description provided for @mustUseInstitutionalEmail.
  ///
  /// In en, this message translates to:
  /// **'Must use an institutional email @uide.edu.ec'**
  String get mustUseInstitutionalEmail;

  /// No description provided for @mustSelectOneRole.
  ///
  /// In en, this message translates to:
  /// **'Must choose only one role: seller or buyer'**
  String get mustSelectOneRole;

  /// No description provided for @userRegisteredSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'User {name} registered successfully'**
  String userRegisteredSuccessfully(Object name);

  /// No description provided for @requiredField.
  ///
  /// In en, this message translates to:
  /// **'Required field'**
  String get requiredField;

  /// No description provided for @minimumCharacters.
  ///
  /// In en, this message translates to:
  /// **'Minimum 6 characters'**
  String get minimumCharacters;

  /// No description provided for @createEntrepreneurship.
  ///
  /// In en, this message translates to:
  /// **'Create Entrepreneurship'**
  String get createEntrepreneurship;

  /// No description provided for @basicInformation.
  ///
  /// In en, this message translates to:
  /// **'Basic Information'**
  String get basicInformation;

  /// No description provided for @entrepreneurshipName.
  ///
  /// In en, this message translates to:
  /// **'Entrepreneurship Name'**
  String get entrepreneurshipName;

  /// No description provided for @entrepreneurshipNamePlaceholder.
  ///
  /// In en, this message translates to:
  /// **'E.g. Homemade Delights'**
  String get entrepreneurshipNamePlaceholder;

  /// No description provided for @category.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get category;

  /// No description provided for @description.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get description;

  /// No description provided for @descriptionPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Describe your entrepreneurship'**
  String get descriptionPlaceholder;

  /// No description provided for @locationPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'E.g. Quito Campus'**
  String get locationPlaceholder;

  /// No description provided for @scheduleAttention.
  ///
  /// In en, this message translates to:
  /// **'Business Hours'**
  String get scheduleAttention;

  /// No description provided for @schedulePlaceholder.
  ///
  /// In en, this message translates to:
  /// **'E.g. Mon-Fri 9:00-17:00'**
  String get schedulePlaceholder;

  /// No description provided for @servicesProducts.
  ///
  /// In en, this message translates to:
  /// **'Services / Products ({count} Services)'**
  String servicesProducts(Object count);

  /// No description provided for @noServicesYet.
  ///
  /// In en, this message translates to:
  /// **'You haven\'t added services yet.'**
  String get noServicesYet;

  /// No description provided for @addNewService.
  ///
  /// In en, this message translates to:
  /// **'Add new service:'**
  String get addNewService;

  /// No description provided for @serviceName.
  ///
  /// In en, this message translates to:
  /// **'Service name'**
  String get serviceName;

  /// No description provided for @briefDescription.
  ///
  /// In en, this message translates to:
  /// **'Brief description'**
  String get briefDescription;

  /// No description provided for @priceExample.
  ///
  /// In en, this message translates to:
  /// **'Price (E.g: \$5.00)'**
  String get priceExample;

  /// No description provided for @addService.
  ///
  /// In en, this message translates to:
  /// **'Add Service'**
  String get addService;

  /// No description provided for @entrepreneurshipCreated.
  ///
  /// In en, this message translates to:
  /// **'Entrepreneurship created'**
  String get entrepreneurshipCreated;

  /// No description provided for @protectedAccount.
  ///
  /// In en, this message translates to:
  /// **'Protected Account'**
  String get protectedAccount;

  /// No description provided for @accountProtectedMessage.
  ///
  /// In en, this message translates to:
  /// **'Your account is active and protected. Keep your data safe with our recommendations.'**
  String get accountProtectedMessage;

  /// No description provided for @profilePrivacy.
  ///
  /// In en, this message translates to:
  /// **'Profile privacy'**
  String get profilePrivacy;

  /// No description provided for @showEmail.
  ///
  /// In en, this message translates to:
  /// **'Show email'**
  String get showEmail;

  /// No description provided for @showEmailSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Visible on your public profile'**
  String get showEmailSubtitle;

  /// No description provided for @showPhone.
  ///
  /// In en, this message translates to:
  /// **'Show phone'**
  String get showPhone;

  /// No description provided for @showPhoneSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Visible on your public profile'**
  String get showPhoneSubtitle;

  /// No description provided for @privacyCommitment.
  ///
  /// In en, this message translates to:
  /// **'We are committed to protecting your privacy and keeping your data secure.'**
  String get privacyCommitment;

  /// No description provided for @privacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacyPolicy;

  /// No description provided for @termsOfUse.
  ///
  /// In en, this message translates to:
  /// **'Terms of Use'**
  String get termsOfUse;

  /// No description provided for @writeYourMessage.
  ///
  /// In en, this message translates to:
  /// **'Write your message...'**
  String get writeYourMessage;

  /// No description provided for @send.
  ///
  /// In en, this message translates to:
  /// **'Send'**
  String get send;

  /// No description provided for @assistantGreeting.
  ///
  /// In en, this message translates to:
  /// **'Hello, I\'m your Emprende UIDE virtual assistant. How can I help you?'**
  String get assistantGreeting;

  /// No description provided for @thankYouMessage.
  ///
  /// In en, this message translates to:
  /// **'Thank you for your message. We will respond soon.'**
  String get thankYouMessage;

  /// No description provided for @whatsapp.
  ///
  /// In en, this message translates to:
  /// **'WhatsApp'**
  String get whatsapp;

  /// No description provided for @viewDetails.
  ///
  /// In en, this message translates to:
  /// **'View {name}'**
  String viewDetails(Object name);

  /// No description provided for @ordersScreenPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'My Orders Screen - Implement orders list with status'**
  String get ordersScreenPlaceholder;

  /// No description provided for @reviewsScreenPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'My Reviews Screen - Implement reviews list with check/trash'**
  String get reviewsScreenPlaceholder;

  /// No description provided for @ratingsScreenPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Service Rating Screen - Implement cards with stars'**
  String get ratingsScreenPlaceholder;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en', 'es'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en': return AppLocalizationsEn();
    case 'es': return AppLocalizationsEs();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
