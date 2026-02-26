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
  String get english => 'እንግሊዝኛ';

  @override
  String get defaultStatus => 'ነባሪ';

  @override
  String get supported => 'የሚደገፍ';

  @override
  String get continueButton => 'ቀጥል';

  @override
  String get splashTitle => 'አገልግሎት ሊንክ';

  @override
  String get splashSubtitle => 'ደንበኞችን ታማኝ እና ጥራታቸዉን ከጠበቁ ባለሞያዎች ጋር እናገናኛለን.';

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
  String get boleAddisAbaba => 'አካባቢ በመጫን ላይ';

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

  @override
  String get decline => 'ውድቅ አድርግ';

  @override
  String get rateAndPay => 'ደረጃ ይስጡ እና ይክፈሉ';

  @override
  String get howWasYourService => 'አገልግሎቱ እንዴት ነበር?';

  @override
  String get amountPaid => 'የተከፈለው መጠን';

  @override
  String get pleaseEnterAmount => 'እባክዎ መጠን ያስገቡ';

  @override
  String get pleaseEnterValidNumber => 'እባክዎ ትክክለኛ ቁጥር ያስገቡ';

  @override
  String get submitPaymentAndReview => 'ክፍያ እና ግምገማ ያስገቡ';

  @override
  String get searchForServicesAndPackages => 'አገልግሎቶችን እና ፓኬጆችን ይፈልጉ';

  @override
  String get cleaningServices => 'የጽዳት አገልግሎቶች';

  @override
  String get qualityWorkAffordablePrice => 'ጥራት ያለው ስራ\nበተመጣጣኝ ዋጋ';

  @override
  String get weBringProfessionalCleaningServices =>
      'ሙያዊ የጽዳት አገልግሎቶችን ወደ ቤትዎ እናመጣለን';

  @override
  String get welcomeBack => 'እንኳን ደህና መመለስ!';

  @override
  String get loginToYourAccount => 'ወደ መለያዎ ይግቡ';

  @override
  String get createYourAccount => 'መለያዎን ይፍጠሩ';

  @override
  String get photoLibrary => 'የፎቶ ቤተ-መጽሐፍት';

  @override
  String get camera => 'ካሜራ';

  @override
  String mustBeNdigits(int maxLength) {
    return '$maxLength አሃዞች መሆን አለበት';
  }

  @override
  String get describeYourIssue => 'ችግርዎን ይግለጹ';

  @override
  String get preferredDates => 'የሚመረጡ ቀኖች';

  @override
  String get selectADateRange => 'የቀን ክልል ይምረጡ';

  @override
  String get pleaseFillAllFields => 'እባክዎ ከመያዝዎ በፊት ሁሉንም መስኮች ይሙሉ.';

  @override
  String get summary => 'ማጠቃለያ';

  @override
  String get dates => 'ቀኖች';

  @override
  String get requestSent => 'ጥያቄ ተልኳል!';

  @override
  String get providerNotified =>
      'ባለሙያው እንዲያውቅ ተደርጓል። የጥያቄዎን ሁኔታ በቦታ ማስያዣዎች ትር ውስጥ ማየት ይችላሉ።';

  @override
  String get backToHome => 'ወደ ዋናው ገጽ ይመለሱ';

  @override
  String get enterDetailedDescription => 'ዝርዝር መግለጫ ያስገቡ...';

  @override
  String get enter6DigitPIN => 'ባለ 6-አሃዝ ፒን ያስገቡ';

  @override
  String get enterYourFirstName => 'የመጀመሪያ ስምዎን ያስገቡ';

  @override
  String get enterYourLastName => 'የአያት ስምዎን ያስገቡ';

  @override
  String get providerAgreementTitle => 'FIXADDIS የአገልግሎት አቅራቢ ስምምነት';

  @override
  String get iAgreeToTheTerms => 'በข้อตกลงและเงื่อนไขฉันยอมรับ';

  @override
  String get providerAgreementText =>
      '(የግል ሥራ ተቋራጭ ስምምነት)\nይህ ስምምነት በሚከተሉት መካከል ተደርጓል፦\nFIXADDIS (“መተግበሪያ”)\nእና\nየተመዘገበው አገልግሎት አቅራቢ (“አቅራቢ”)።\n\nበመፈረም ወይም መተግበሪያውን በመጠቀም፣ አቅራቢው ለሚከተሉት ተስማምቷል፦\n\n1️⃣ ግንኙነት\n\n1.1 አቅራቢው የግል ሥራ ተቋራጭ ነው፣ የFixAddis ሠራተኛ፣ አጋር ወይም ወኪል አይደለም።\n1.2 አቅራቢው ለሁሉም ግብሮች፣ ፈቃዶች፣ መሣሪያዎች፣ መጓጓዣ፣ ኢንሹራንስ (የሚመለከተው ከሆነ) እና የአሠራር ወጪዎች ኃላፊ ነው።\n1.3 FixAddis ደንበኞችን እና አቅራቢዎችን የሚያገናኝ ዲጂታል የገበያ ቦታ ብቻ ሆኖ ይሠራል።\n\n2️⃣ የአገልግሎቶች ወሰን\n\nአቅራቢው የሚከተሉትን አገልግሎቶች ሊያቀርብ ይችላል፥\nየመንገድ ዳር መካኒክ አገልግሎቶች\nየቤት ጥገና (የቧንቧ፣ የኤሌክትሪክ፣ የአናጢነት፣ ወዘተ)\nየቤት ዕቃዎች ጥገና\nየጽዳት አገልግሎቶች\nየተከላ አገልግሎቶች\nበመተግበሪያው ላይ የተዘረዘሩ ሌሎች የተፈቀዱ የሙያ አገልግሎቶች\nአቅራቢዎች ብቁ የሆኑባቸውን አገልግሎቶች ብቻ ማከናወን ይችላሉ።\n\n3️⃣ ማረጋገጫ እና ብቁነት\n\nመተግበሪያው የሚያረጋግጣቸው፦\nየገባው መታወቂያ ትክክለኛነት\nትክክለኛ የግል እና የመገኛ አድራሻዎች\nበቂ ችሎታ እና ልምድ\nበሕግ የሚፈለጉ ማናቸውም ፈቃዶች\nአቅራቢው በኢትዮጵያ ውስጥ አገልግሎት ለመስጠት ሕጋዊ ብቁነት\nየሐሰት መረጃ መስጠት ወዲያውኑ ውል እንዲቋረጥ ያደርጋል።\n\n4️⃣ የሙያ ሥነ ምግባር እና ተግሣጽ\n\nአቅራቢው ለሚከተሉት ተስማምቷል፦\nደንበኞችን በአክብሮት መያዝ\nሥራ ከመጀመሩ በፊት ዋጋን በግልጽ ማስረዳት\nተጨማሪ ክፍያዎች ከመፈጸሙ በፊት የደንበኛን ይሁንታ ማግኘት\nበተመጣጣኝ ጊዜ ውስጥ መድረስ\nየሙያዊ ገጽታን እና ባህሪን መጠበቅ\n\nአቅራቢው የሚከተሉትን ማድረግ የለበትም፦\n\nደንበኞችን ማዋከብ፣ ማስፈራራት ወይም ማሸማቀቅ\nዋጋን ከልክ በላይ መጫን ወይም ዋጋን ያለአግባብ ማዛባት\nበአልኮል ወይም በአደንዛዥ ዕፅ ተጽዕኖ ሥር አገልግሎት መስጠት\nበመድልዎ ውስጥ መሳተፍ\nከተስማማው መጠን በላይ ክፍያ መጠየቅ\nFIXADDISን በተሳሳተ መንገድ መወከል\nከባድ ጥሰቶች ወዲያውኑ ውል እንዲቋረጥ ያደርጋሉ።\n\n5️⃣ የደህንነት ግዴታዎች\n\nአቅራቢው ሙሉ በሙሉ ኃላፊ ነው ለ፦\n\nደህንነቱ የተጠበቀ የሥራ ልምዶች\nትክክለኛ መሣሪያዎችን መጠቀም\nየመንገድ ዳር እና የሥራ ቦታ ደህንነት\nንብረት ላይ ጉዳት እንዳይደርስ ማድረግ\nየትራፊክ እና የደህንነት ሕጎችን ማክበር\n\nFixAddis ለሚከተሉት ተጠያቂ አይደለም፦\n\nጉዳቶች\nየንብረት ውድመት\nየሜካኒካዊ ብልሽት\nበአቅራቢው ቸልተኝነት ምክንያት ለሚከሰቱ የሥራ ጉድለቶች\nአቅራቢው ለሚያከናውናቸው አገልግሎቶች ሙሉ ሕጋዊ ኃላፊነት ይወስዳል።\n\n6️⃣ የዋጋ አወጣጥ እና ኮሚሽን\n\n6.1 አቅራቢው የመተግበሪያውን የዋጋ አሰጣጥ መመሪያዎችን ለመከተል ተስማምቷል።\n6.2 የመጨረሻው ዋጋ ሥራ ከመጀመሩ በፊት መስማማት አለበት።\n6.3 አቅራቢው የተስማማበትን ኮሚሽን ወይም የመተግበሪያ ክፍያዎችን ለመክፈል ተስማምቷል።\n6.4 ኮሚሽን አለመክፈል ለእገዳ እና ለሕጋዊ እርምጃ ሊዳርግ ይችላል።\n\n7️⃣ የማለፍ-የማገድ አንቀጽ\n\nአቅራቢው ተስማምቷል፦\nደንበኞችን ከመተግበሪያው ውጭ ላለማግባባት\nለወደፊት ቀጥታ ሥራዎች የግል መገኛ አድራሻዎችን ላለማጋራት\nሆን ብሎ ኮሚሽን ላለማስቀረት\nመጣስ ለቋሚ መወገድ እና ለገንዘብ ቅጣት ሊዳርግ ይችላል።\n\n8️⃣ አገልግሎት አቅራቢዎች ደረጃ እና የአፈጻጸም ክትትል\n\nFIXADDIS የሚከተሉትን በጥብቅ ይከታተላል:-\n\nየአገልግሎት አቅራቢዎች ደረጃ አሰጣጥ\n\nየደንበኛ አስተያየት\nየቅሬታ ድግግሞሽ\nየዋጋ ተገቢነት\nየስራ መቀበያ እና ማጠናቀቂያ ፍጥነት\n\nተደጋጋሚ ዝቅተኛ አፈፃፀም ያላቸው አቅራቢዎች፦\n\nማስጠንቀቂያ\nጊዜያዊ እገዳ\nቋሚ እገዳን ያስተናግዳሉ።\n\n9️⃣ የደንበኛ ቅሬታዎች እና ተመላሽ ገንዘቦች\n\nአገልግሎት አቅራቢው የሚከተለውን ለማድረግ ተስማምቷል፦\n\nከምርመራዎች ጋር መተባበር\nበ48 ሰዓታት ውስጥ ምላሽ መስጠት\nፍትሃዊ የክርክር መፍትሄን መቀበል\n\nFIXADDIS የተረጋገጠ ጥፋት ሲኖር ተመላሽ ገንዘብ ሊጠይቅ ይችላል።\n\n1️⃣0️⃣ እገዳ እና መቋረጥ\n\nFIXADDIS በሚከተሉት ምክንያቶች ወዲያውኑ አገልግሎት አቅራቢዉን ሊያግድ ወይም ሊሠርዝ ይችላል፦\n\nየደህንነት ጥሰቶች\nማጭበርበር\nትንኮሳ\nየወንጀል ድርጊት\nተደጋጋሚ ደካማ አፈጻጸም \nየኮሚሽን ማጭበርበር\n\nበከባድ ጉዳዮች ላይ ማስጠንቀቂያ አያስፈልግም።\n1️⃣1️⃣ ሚስጥራዊነት\n\nአቅራቢው ላለማሳወቅ ተስማምቷል፦\n\nየደንበኛ መረጃ\nውስጣዊ መመሪያዎች\nየዋጋ አወጣጥ መዋቅሮች\nየመተግበሪያ የአሠራር መረጃ\n\n1️⃣2️⃣ ማሻሻያዎች\n\nFIXADDIS ይህንን ስምምነት በማንኛውም ጊዜ ሊያዘምን ይችላል።\nመተግበሪያን መጠቀም መቀጠል መስማማትን ያሳያል።';
}
