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
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

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
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('es'),
  ];

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// No description provided for @dashboard.
  ///
  /// In en, this message translates to:
  /// **'Dashboard'**
  String get dashboard;

  /// No description provided for @favorites.
  ///
  /// In en, this message translates to:
  /// **'Favorites'**
  String get favorites;

  /// No description provided for @cart.
  ///
  /// In en, this message translates to:
  /// **'Cart'**
  String get cart;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @noServices.
  ///
  /// In en, this message translates to:
  /// **'No services available yet'**
  String get noServices;

  /// No description provided for @hello.
  ///
  /// In en, this message translates to:
  /// **'Hello'**
  String get hello;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @myProfile.
  ///
  /// In en, this message translates to:
  /// **'My Profile'**
  String get myProfile;

  /// No description provided for @nameLabel.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get nameLabel;

  /// No description provided for @phoneLabel.
  ///
  /// In en, this message translates to:
  /// **'Phone'**
  String get phoneLabel;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @generalNotifications.
  ///
  /// In en, this message translates to:
  /// **'General Notifications'**
  String get generalNotifications;

  /// No description provided for @importantUpdates.
  ///
  /// In en, this message translates to:
  /// **'Receive important updates'**
  String get importantUpdates;

  /// No description provided for @requestStatus.
  ///
  /// In en, this message translates to:
  /// **'Request status updates'**
  String get requestStatus;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @privacySecurity.
  ///
  /// In en, this message translates to:
  /// **'Privacy & Security'**
  String get privacySecurity;

  /// No description provided for @helpSupport.
  ///
  /// In en, this message translates to:
  /// **'Help & Support'**
  String get helpSupport;

  /// No description provided for @aboutUIDE.
  ///
  /// In en, this message translates to:
  /// **'About UIDE'**
  String get aboutUIDE;

  /// No description provided for @aboutUIDEDescription.
  ///
  /// In en, this message translates to:
  /// **'Emprende UIDE V1\nMarketplace for the UIDE community\nInternational University of Ecuador'**
  String get aboutUIDEDescription;

  /// No description provided for @copyright.
  ///
  /// In en, this message translates to:
  /// **'© 2025 UIDE. All rights reserved.'**
  String get copyright;

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

  /// No description provided for @myOrders.
  ///
  /// In en, this message translates to:
  /// **'My Orders'**
  String get myOrders;

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

  /// No description provided for @emptyCart.
  ///
  /// In en, this message translates to:
  /// **'Your cart is empty. Add something!'**
  String get emptyCart;

  /// No description provided for @paymentMethod.
  ///
  /// In en, this message translates to:
  /// **'Payment Method'**
  String get paymentMethod;

  /// No description provided for @editComment.
  ///
  /// In en, this message translates to:
  /// **'Edit Comment'**
  String get editComment;

  /// No description provided for @commentHint.
  ///
  /// In en, this message translates to:
  /// **'Describe what you need...'**
  String get commentHint;

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

  /// No description provided for @commentUpdated.
  ///
  /// In en, this message translates to:
  /// **'Comment updated'**
  String get commentUpdated;

  /// No description provided for @commentEmpty.
  ///
  /// In en, this message translates to:
  /// **'Comment cannot be empty'**
  String get commentEmpty;

  /// No description provided for @editQuantity.
  ///
  /// In en, this message translates to:
  /// **'Edit Quantity'**
  String get editQuantity;

  /// No description provided for @quantityUpdated.
  ///
  /// In en, this message translates to:
  /// **'Quantity updated to'**
  String get quantityUpdated;

  /// No description provided for @quantityInvalid.
  ///
  /// In en, this message translates to:
  /// **'Quantity must be greater than 0'**
  String get quantityInvalid;

  /// No description provided for @itemDetails.
  ///
  /// In en, this message translates to:
  /// **'Comment'**
  String get itemDetails;

  /// No description provided for @quantity.
  ///
  /// In en, this message translates to:
  /// **'Quantity'**
  String get quantity;

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

  /// No description provided for @clientMode.
  ///
  /// In en, this message translates to:
  /// **'Client Mode Activated'**
  String get clientMode;

  /// No description provided for @entrepreneurMode.
  ///
  /// In en, this message translates to:
  /// **'Entrepreneur Mode Activated'**
  String get entrepreneurMode;

  /// No description provided for @sessionClosed.
  ///
  /// In en, this message translates to:
  /// **'Session closed'**
  String get sessionClosed;

  /// No description provided for @emptyFavorites.
  ///
  /// In en, this message translates to:
  /// **'No favorites yet. Add some from Home!'**
  String get emptyFavorites;

  /// No description provided for @viewService.
  ///
  /// In en, this message translates to:
  /// **'View'**
  String get viewService;

  /// No description provided for @selectPaymentMethod.
  ///
  /// In en, this message translates to:
  /// **'Select Payment Method'**
  String get selectPaymentMethod;

  /// No description provided for @physicalPayment.
  ///
  /// In en, this message translates to:
  /// **'Pay in Person'**
  String get physicalPayment;

  /// No description provided for @transferPayment.
  ///
  /// In en, this message translates to:
  /// **'Bank Transfer'**
  String get transferPayment;

  /// No description provided for @secureLocation.
  ///
  /// In en, this message translates to:
  /// **'Secure Location'**
  String get secureLocation;

  /// No description provided for @mapPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Map Placeholder'**
  String get mapPlaceholder;

  /// No description provided for @transferData.
  ///
  /// In en, this message translates to:
  /// **'Transfer Data'**
  String get transferData;

  /// No description provided for @bank.
  ///
  /// In en, this message translates to:
  /// **'Bank'**
  String get bank;

  /// No description provided for @account.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get account;

  /// No description provided for @idHolder.
  ///
  /// In en, this message translates to:
  /// **'ID Holder'**
  String get idHolder;

  /// No description provided for @reference.
  ///
  /// In en, this message translates to:
  /// **'Reference'**
  String get reference;

  /// No description provided for @paymentSuccess.
  ///
  /// In en, this message translates to:
  /// **'Payment successful with method'**
  String get paymentSuccess;

  /// No description provided for @pay.
  ///
  /// In en, this message translates to:
  /// **'Pay'**
  String get pay;

  /// No description provided for @subtotal.
  ///
  /// In en, this message translates to:
  /// **'Subtotal'**
  String get subtotal;

  /// No description provided for @total.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get total;

  /// No description provided for @accountProtected.
  ///
  /// In en, this message translates to:
  /// **'Protected Account'**
  String get accountProtected;

  /// No description provided for @accountProtectedDescription.
  ///
  /// In en, this message translates to:
  /// **'Your account is active and protected. Keep your data safe with our recommendations.'**
  String get accountProtectedDescription;

  /// No description provided for @profilePrivacy.
  ///
  /// In en, this message translates to:
  /// **'Profile Privacy'**
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
  /// **'We are committed to protecting your privacy and keeping your data safe.'**
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

  /// No description provided for @basicInformation.
  ///
  /// In en, this message translates to:
  /// **'Basic Information'**
  String get basicInformation;

  /// No description provided for @businessName.
  ///
  /// In en, this message translates to:
  /// **'Business Name'**
  String get businessName;

  /// No description provided for @exampleBusiness.
  ///
  /// In en, this message translates to:
  /// **'Ex. Homemade Delights'**
  String get exampleBusiness;

  /// No description provided for @category.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get category;

  /// No description provided for @food.
  ///
  /// In en, this message translates to:
  /// **'Food'**
  String get food;

  /// No description provided for @design.
  ///
  /// In en, this message translates to:
  /// **'Design'**
  String get design;

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

  /// No description provided for @description.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get description;

  /// No description provided for @describeYourBusiness.
  ///
  /// In en, this message translates to:
  /// **'Describe your business'**
  String get describeYourBusiness;

  /// No description provided for @location.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get location;

  /// No description provided for @exampleLocation.
  ///
  /// In en, this message translates to:
  /// **'Ex. Quito Campus'**
  String get exampleLocation;

  /// No description provided for @schedule.
  ///
  /// In en, this message translates to:
  /// **'Schedule'**
  String get schedule;

  /// No description provided for @exampleSchedule.
  ///
  /// In en, this message translates to:
  /// **'Ex. Mon-Fri 9:00-17:00'**
  String get exampleSchedule;

  /// No description provided for @servicesProducts.
  ///
  /// In en, this message translates to:
  /// **'Services / Products'**
  String get servicesProducts;

  /// No description provided for @atLeastOneService.
  ///
  /// In en, this message translates to:
  /// **'At least one service'**
  String get atLeastOneService;

  /// No description provided for @businessCreated.
  ///
  /// In en, this message translates to:
  /// **'Business created'**
  String get businessCreated;

  /// No description provided for @noServicesYet.
  ///
  /// In en, this message translates to:
  /// **'No services added yet.'**
  String get noServicesYet;

  /// No description provided for @addNewService.
  ///
  /// In en, this message translates to:
  /// **'Add new service:'**
  String get addNewService;

  /// No description provided for @serviceName.
  ///
  /// In en, this message translates to:
  /// **'Service Name'**
  String get serviceName;

  /// No description provided for @shortDescription.
  ///
  /// In en, this message translates to:
  /// **'Short Description'**
  String get shortDescription;

  /// No description provided for @priceExample.
  ///
  /// In en, this message translates to:
  /// **'Price (Ex: 5.00)'**
  String get priceExample;

  /// No description provided for @addService.
  ///
  /// In en, this message translates to:
  /// **'Add Service'**
  String get addService;

  /// No description provided for @serviceNamePriceRequired.
  ///
  /// In en, this message translates to:
  /// **'Service name and price are required.'**
  String get serviceNamePriceRequired;

  /// No description provided for @duplicateService.
  ///
  /// In en, this message translates to:
  /// **'You already have a product or service with this name'**
  String get duplicateService;

  /// No description provided for @createBusiness.
  ///
  /// In en, this message translates to:
  /// **'Create Business'**
  String get createBusiness;

  /// No description provided for @supportTitle.
  ///
  /// In en, this message translates to:
  /// **'Help & Support'**
  String get supportTitle;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @whatsapp.
  ///
  /// In en, this message translates to:
  /// **'WhatsApp'**
  String get whatsapp;

  /// No description provided for @writeMessageHint.
  ///
  /// In en, this message translates to:
  /// **'Write your message...'**
  String get writeMessageHint;

  /// No description provided for @assistantGreeting.
  ///
  /// In en, this message translates to:
  /// **'Hi, I am your virtual assistant of Emprende UIDE. How can I help you?'**
  String get assistantGreeting;

  /// No description provided for @assistantReply.
  ///
  /// In en, this message translates to:
  /// **'Thank you for your message. We will get back to you soon.'**
  String get assistantReply;

  /// No description provided for @add.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get add;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'es'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
