// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get language => 'Language';

  @override
  String get selectYourLanguage => 'Select Language';

  @override
  String get amharic => 'Amharic';

  @override
  String get english => 'English';

  @override
  String get defaultStatus => 'Default';

  @override
  String get supported => 'Supported';

  @override
  String get continueButton => 'CONTINUE';

  @override
  String get splashTitle => 'Service Link';

  @override
  String get splashSubtitle =>
      'A premium marketplace that connects customers and service providers.';

  @override
  String get welcome => 'Welcome';

  @override
  String get customer => 'Customer';

  @override
  String get provider => 'Provider';

  @override
  String get phone => 'Phone';

  @override
  String get firstName => 'First Name';

  @override
  String get lastName => 'Last Name';

  @override
  String get pin => 'Pin';

  @override
  String get profilePhoto => 'Profile Photo';

  @override
  String get idUpload => 'ID Upload';

  @override
  String get getOtp => 'GET OTP';

  @override
  String get sending => 'SENDING...';

  @override
  String get enterOtp => 'Enter OTP';

  @override
  String otpSentTo(Object phoneNumber) {
    return 'An OTP has been sent to $phoneNumber';
  }

  @override
  String get verify => 'VERIFY';

  @override
  String get verifying => 'VERIFYING...';

  @override
  String get fieldRequired => 'This field is required';

  @override
  String get otpMustBe6Digits => 'OTP must be 6 digits';

  @override
  String get requiredForProviders => '(Required for Providers only)';

  @override
  String get upload => 'UPLOAD';

  @override
  String get alreadyHaveAccount => 'Already have an account? ';

  @override
  String get login => 'Login';

  @override
  String get dontHaveAccount => 'Don\'t have an account? ';

  @override
  String get register => 'Register';

  @override
  String get registrationRequiredTitle => 'Registration Required';

  @override
  String get registrationRequiredMessage =>
      'It seems you do not have an account. Please register.';

  @override
  String get cancel => 'Cancel';

  @override
  String get phoneMustBe9Digits => 'Phone number must be 9 digits';

  @override
  String get pinMustBe6Digits => 'PIN must be 6 digits';

  @override
  String get userAlreadyExists => 'User already exists. Please log in.';

  @override
  String get invalidCredentials => 'Invalid PIN.';

  @override
  String get otpExpiredOrInvalid =>
      'OTP expired or is invalid. Please request a new one.';

  @override
  String get otpTooManyAttempts =>
      'Too many incorrect attempts. Please request a new OTP.';

  @override
  String get forgotPin => 'Forgot PIN?';

  @override
  String get resetPin => 'Reset PIN';

  @override
  String get confirmPin => 'Confirm New PIN';

  @override
  String get pinsDoNotMatch => 'PINs do not match';

  @override
  String get resetting => 'RESETTING...';

  @override
  String get genericError => 'An unexpected error occurred. Please try again.';

  @override
  String get helloDawit => 'Hello, Dawit';

  @override
  String get searchForExperts => 'Search for experts...';

  @override
  String get categories => 'Categories';

  @override
  String get seeAll => 'See All';

  @override
  String get electric => 'Electric';

  @override
  String get plumbing => 'Plumbing';

  @override
  String get cleaning => 'Cleaning';

  @override
  String get repair => 'Repair';

  @override
  String get boleAddisAbaba => 'Bole, Addis Ababa';

  @override
  String discountOff(Object amount) {
    return '$amount ETB off';
  }

  @override
  String get on => 'on';

  @override
  String get electricians => 'Electricians';

  @override
  String get limitedTime => 'LIMITED TIME';

  @override
  String get bookings => 'Bookings';

  @override
  String get upcoming => 'Upcoming';

  @override
  String get completed => 'Completed';

  @override
  String get cancelled => 'Cancelled';

  @override
  String get chat => 'Chat';

  @override
  String get profile => 'Profile';

  @override
  String get editProfile => 'Edit Profile';

  @override
  String get settings => 'Settings';

  @override
  String get paymentMethods => 'Payment Methods';

  @override
  String get logout => 'Logout';

  @override
  String get verified => 'VERIFIED';

  @override
  String get offline => 'OFFLINE';

  @override
  String get masterElectrician => 'Master Electrician';

  @override
  String get yearsExp => 'YEARS EXP';

  @override
  String get rating => 'RATING';

  @override
  String get jobs => 'JOBS';

  @override
  String get about => 'About';

  @override
  String get services => 'Services';

  @override
  String get quickFix => 'Quick Fix';

  @override
  String get fullRewiring => 'Full Rewiring';

  @override
  String get bookNow => 'Book Now';

  @override
  String get requestDetails => 'Request Details';

  @override
  String get problemDescription => 'Problem Description';

  @override
  String get problemDescriptionHint =>
      'e.g. Wall socket sparking in the kitchen...';

  @override
  String get scheduledTime => 'Scheduled Time';

  @override
  String get estimatedCost => 'Estimated Cost';

  @override
  String get serviceFee => 'Service Fee';

  @override
  String get grandTotal => 'Grand Total';

  @override
  String get confirmAndBook => 'CONFIRM & BOOK';

  @override
  String get online => 'Online';

  @override
  String get typeMessage => 'Type message...';

  @override
  String get providerDashboard => 'Provider Dashboard';

  @override
  String get totalEarningsMonth => 'Total Earnings (Month)';

  @override
  String get avgRating => 'Avg Rating';

  @override
  String get status => 'Status';

  @override
  String get incomingRequests => 'Incoming Requests';

  @override
  String get schedule => 'Schedule';

  @override
  String get earnings => 'Earnings';

  @override
  String get monthlyEarnings => 'Monthly Earnings';

  @override
  String get recentTransactions => 'Recent Transactions';

  @override
  String get withdrawal => 'Withdrawal';

  @override
  String get availabilitySettings => 'Availability Settings';

  @override
  String get serviceHistory => 'Service History';

  @override
  String get home => 'Home';

  @override
  String get bookingWillAppearHere => 'Booking will appear here';

  @override
  String get comingSoon => 'Coming Soon!';

  @override
  String get changeProfilePhoto => 'Change Profile Photo';

  @override
  String get updateProfile => 'Update Profile';

  @override
  String get darkMode => 'Dark Mode';

  @override
  String get enableNotifications => 'Enable Notifications';

  @override
  String get selectAll => 'Select All';

  @override
  String get viewProviders => 'View Providers';

  @override
  String helloUser(Object firstName) {
    return 'Hello, $firstName';
  }

  @override
  String get selectYourServices => 'Select Your Services';

  @override
  String get skip => 'Skip';

  @override
  String get save => 'Save';

  @override
  String get rateProvider => 'Rate Provider';

  @override
  String get availableProviders => 'Available Providers';

  @override
  String get noProvidersFound => 'No Providers Found';

  @override
  String get confirmBooking => 'Confirm Booking';

  @override
  String get addAComment => 'Add a comment...';

  @override
  String get submitReview => 'Submit Review';

  @override
  String get accept => 'Accept';
}
