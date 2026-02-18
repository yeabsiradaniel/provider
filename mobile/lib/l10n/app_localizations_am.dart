// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Amharic (`am`).
class AppLocalizationsAm extends AppLocalizations {
  AppLocalizationsAm([String locale = 'am']) : super(locale);

  @override
  String get language => 'ቋንቋ';

  @override
  String get selectYourLanguage => 'ቋንቋዎን ይምረጡ';

  @override
  String get amharic => 'አማርኛ';

  @override
  String get english => 'English';

  @override
  String get defaultStatus => 'Default';

  @override
  String get supported => 'Supported';

  @override
  String get continueButton => 'ቀጥል';

  @override
  String get splashTitle => 'አገልግሎት ሊንክ';

  @override
  String get splashSubtitle => 'ደንበኞችን እና ባለሞያ የሚያገናኝ ፕሪሚየም የገበያ ቦታ።';

  @override
  String get welcome => 'እንኳን ደህና መጡ';

  @override
  String get customer => 'ደንበኛ';

  @override
  String get provider => 'ባለሙያ';

  @override
  String get phone => 'ስልክ';

  @override
  String get firstName => 'የመጀመሪያ ስም';

  @override
  String get lastName => 'የአባት ስም';

  @override
  String get pin => 'ሚስጥር ቁጥር';

  @override
  String get profilePhoto => 'የመገለጫ ፎቶ';

  @override
  String get idUpload => 'መታወቂያ ይጫኑ';

  @override
  String get getOtp => 'ኦቲፒ አግኝ';

  @override
  String get sending => 'በመላክ ላይ...';

  @override
  String get enterOtp => 'ኦቲፒ ያስገቡ';

  @override
  String otpSentTo(Object phoneNumber) {
    return 'ኦቲፒ ወደ $phoneNumber ተልኳል';
  }

  @override
  String get verify => 'አረጋግጥ';

  @override
  String get verifying => 'በማረጋገጥ ላይ...';

  @override
  String get fieldRequired => 'ይህ መስክ ያስፈልጋል';

  @override
  String get otpMustBe6Digits => 'ኦቲፒ 6 አሃዞች መሆን አለበት';

  @override
  String get requiredForProviders => '(ለባለሙያዎች ብቻ)';

  @override
  String get upload => 'ይጫኑ';

  @override
  String get alreadyHaveAccount => 'አካውንት አለዎት? ';

  @override
  String get login => 'ይግቡ';

  @override
  String get dontHaveAccount => 'አካውንት የለዎትም? ';

  @override
  String get register => 'ይመዝገቡ';

  @override
  String get registrationRequiredTitle => 'ምዝገባ ያስፈልጋል';

  @override
  String get registrationRequiredMessage => 'አካውንት የሌለዎት ይመስላል። እባክዎ ይመዝገቡ።';

  @override
  String get cancel => 'ይቅር';

  @override
  String get phoneMustBe9Digits => 'ስልክ ቁጥር 9 አሃዝ መሆን አለበት';

  @override
  String get pinMustBe6Digits => 'ፒን 6 አሃዝ መሆን አለበት';

  @override
  String get userAlreadyExists => 'ተጠቃሚው አስቀድሞ አለ። እባክዎ ይግቡ።';

  @override
  String get invalidCredentials => 'የተሳሳተ ፒን።';

  @override
  String get otpExpiredOrInvalid =>
      'ኦቲፒ ጊዜው አልፎበታል ወይም ልክ ያልሆነ ነው። እባክዎ አዲስ ይጠይቁ።';

  @override
  String get otpTooManyAttempts => 'በጣም ብዙ የተሳሳቱ ሙከራዎች። እባክዎ አዲስ ኦቲፒ ይጠይቁ።';

  @override
  String get forgotPin => 'ፒን ረሱ?';

  @override
  String get resetPin => 'ፒን ዳግም አስጀምር';

  @override
  String get confirmPin => 'አዲስ ፒን ያረጋግጡ';

  @override
  String get pinsDoNotMatch => 'ፒን አይዛመዱም';

  @override
  String get resetting => 'ዳግም በማስጀመር ላይ...';

  @override
  String get genericError => 'ያልተጠበቀ ስህተት ተከስቷል። እባክዎ እንደገና ይሞክሩ።';

  @override
  String get helloDawit => 'ሰላም ዳዊት';

  @override
  String get searchForExperts => 'ባለሙያዎችን ይፈልጉ...';

  @override
  String get categories => 'ምድቦች';

  @override
  String get seeAll => 'ሁሉንም ይመልከቱ';

  @override
  String get electric => 'ኤሌክትሪክ';

  @override
  String get plumbing => 'ቧንቧ';

  @override
  String get cleaning => 'ጽዳት';

  @override
  String get repair => 'ጥገና';

  @override
  String get boleAddisAbaba => 'ቦሌ, አዲስ አበባ';

  @override
  String discountOff(Object amount) {
    return '$amount ብር ቅናሽ';
  }

  @override
  String get on => 'ላይ';

  @override
  String get electricians => 'የኤሌክትሪክ ባለሙያዎች';

  @override
  String get limitedTime => 'ለተወሰነ ጊዜ';

  @override
  String get bookings => 'የኔ ቀጠሮዎች';

  @override
  String get upcoming => 'የሚመጣ';

  @override
  String get completed => 'የተጠናቀቀ';

  @override
  String get cancelled => 'የተሰረዘ';

  @override
  String get chat => 'ቻት';

  @override
  String get profile => 'መገለጫ';

  @override
  String get editProfile => 'መገለጫ ያርትዑ';

  @override
  String get settings => 'ቅንብሮች';

  @override
  String get paymentMethods => 'የመክፈያ ዘዴዎች';

  @override
  String get logout => 'ውጣ';

  @override
  String get verified => 'የተረጋገጠ';

  @override
  String get offline => 'ከመስመር ውጭ';

  @override
  String get masterElectrician => 'ዋና የኤሌክትሪክ ባለሙያ';

  @override
  String get yearsExp => 'የአገልግሎት ዘመን';

  @override
  String get rating => 'ደረጃ';

  @override
  String get jobs => 'ስራዎች';

  @override
  String get about => 'ስለ';

  @override
  String get services => 'አገልግሎቶች';

  @override
  String get quickFix => 'ፈጣን ጥገና';

  @override
  String get fullRewiring => 'ሙሉ ሽቦ መቀየር';

  @override
  String get bookNow => 'አሁን ይመዝገቡ';

  @override
  String get requestDetails => 'የአገልግሎት ጥያቄ ዝርዝሮች';

  @override
  String get problemDescription => 'የችግር መግለጫ';

  @override
  String get problemDescriptionHint =>
      'ለምሳሌ: በኩሽና ውስጥ ያለው ግድግዳ ሶኬት ብልጭታ ያሳያል...';

  @override
  String get scheduledTime => 'የተያዘለት ሰዓት';

  @override
  String get estimatedCost => 'ግምታዊ ወጪ';

  @override
  String get serviceFee => 'የአገልግሎት ክፍያ';

  @override
  String get grandTotal => 'ጠቅላላ ድምር';

  @override
  String get confirmAndBook => 'አረጋግጥ እና አስይዝ';

  @override
  String get online => 'ኦንላይን';

  @override
  String get typeMessage => 'መልእክት ይጻፉ...';

  @override
  String get providerDashboard => 'የባለሙያ ዳሽቦርድ';

  @override
  String get totalEarningsMonth => 'አጠቃላይ ወርሃዊ ገቢ';

  @override
  String get avgRating => 'አማካይ ደረጃ';

  @override
  String get status => 'ሁኔታ';

  @override
  String get incomingRequests => 'ገቢ ጥያቄዎች';

  @override
  String get schedule => 'መርሃግብር';

  @override
  String get earnings => 'ገቢዎች';

  @override
  String get monthlyEarnings => 'ወርሃዊ ገቢ';

  @override
  String get recentTransactions => 'የቅርብ ጊዜ ግብይቶች';

  @override
  String get withdrawal => 'ገንዘብ ማውጣት';

  @override
  String get availabilitySettings => 'የመገኘት ቅንብሮች';

  @override
  String get serviceHistory => 'የአገልግሎት ታሪክ';

  @override
  String get home => 'ዋና ገጽ';

  @override
  String get bookingWillAppearHere => 'የስራ ዝርዝሮች እዚህ ይታያሉ';

  @override
  String get comingSoon => 'በቅርቡ የሚመጣ!';

  @override
  String get changeProfilePhoto => 'የመገለጫ ፎቶ ይቀይሩ';

  @override
  String get updateProfile => 'መገለጫ አዘምን';

  @override
  String get darkMode => 'ጨለማ ገጽታ';

  @override
  String get enableNotifications => 'ማሳወቂያዎችን አንቃ';

  @override
  String get selectAll => 'ሁሉንም ምረጥ';

  @override
  String get viewProviders => 'ባለሙያዎችን ይመልከቱ';

  @override
  String helloUser(Object firstName) {
    return 'ሰላም, $firstName';
  }

  @override
  String get selectYourServices => 'አገልግሎቶችዎን ይምረጡ';

  @override
  String get skip => 'ዝለል';

  @override
  String get save => 'አስቀምጥ';

  @override
  String get rateProvider => 'ባለሙያን ደረጃ ይስጡ';

  @override
  String get availableProviders => 'ያሉ ባለሙያዎች';

  @override
  String get noProvidersFound => 'ምንም ባለሙያዎች አልተገኙም';

  @override
  String get confirmBooking => 'ቦታ ማስያዝ ያረጋግጡ';

  @override
  String get addAComment => 'አስተያየት ያክሉ...';

  @override
  String get submitReview => 'ግምገማ ያስገቡ';

  @override
  String get accept => 'ተቀበል';
}
