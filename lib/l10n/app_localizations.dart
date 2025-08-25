import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

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
/// Please make sure to update your pubspec.yaml file to include the following
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
/// To configure the locales supported by your app, you'll need to edit this
/// file.
///
/// First, open your project's ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project's Runner folder.
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
    Locale('de'),
    Locale('fr'),
    Locale('es'),
    Locale('it'),
    Locale('nl'),
    Locale('pl')
  ];

  /// App title
  /// 
  /// In en, this message translates to:
  /// **'Focus Journal'**
  String get appTitle;

  /// Authentication required message
  /// 
  /// In en, this message translates to:
  /// **'Authentication Required'**
  String get authenticationRequired;

  /// Setup PIN message
  /// 
  /// In en, this message translates to:
  /// **'Setup PIN'**
  String get setupPin;

  /// Enter password prompt
  /// 
  /// In en, this message translates to:
  /// **'Enter your password'**
  String get enterPasswordPrompt;

  /// Enter PIN prompt
  /// 
  /// In en, this message translates to:
  /// **'Enter your PIN'**
  String get enterPinPrompt;

  /// Setup password prompt
  /// 
  /// In en, this message translates to:
  /// **'Setup your password'**
  String get setupPasswordPrompt;

  /// Setup PIN prompt with minimum length
  /// 
  /// In en, this message translates to:
  /// **'Setup your PIN (minimum {minLength} digits)'**
  String setupPinPrompt(int minLength);

  /// Password label
  /// 
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// PIN label
  /// 
  /// In en, this message translates to:
  /// **'PIN'**
  String get pin;

  /// Unlock button
  /// 
  /// In en, this message translates to:
  /// **'Unlock'**
  String get unlock;

  /// Set password button
  /// 
  /// In en, this message translates to:
  /// **'Set Password'**
  String get setPassword;

  /// Set PIN button
  /// 
  /// In en, this message translates to:
  /// **'Set PIN'**
  String get setPin;

  /// Use biometrics label
  /// 
  /// In en, this message translates to:
  /// **'Use Biometrics'**
  String get useBiometrics;

  /// Change password
  /// 
  /// In en, this message translates to:
  /// **'Change Password'**
  String get changePassword;

  /// Setup password
  /// 
  /// In en, this message translates to:
  /// **'Setup Password'**
  String get setupPassword;

  /// Journal tab label
  /// 
  /// In en, this message translates to:
  /// **'Journal'**
  String get journal;

  /// Settings tab label
  /// 
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// Welcome to journal message
  /// 
  /// In en, this message translates to:
  /// **'Welcome to Focus Journal'**
  String get welcomeToJournal;

  /// Journal description
  /// 
  /// In en, this message translates to:
  /// **'Your secure space for focused thoughts and reflections.'**
  String get journalDescription;

  /// Logout button
  /// 
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['de', 'en', 'es', 'fr', 'it', 'nl', 'pl'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'de': return AppLocalizationsDe();
    case 'en': return AppLocalizationsEn();
    case 'es': return AppLocalizationsEs();
    case 'fr': return AppLocalizationsFr();
    case 'it': return AppLocalizationsIt();
    case 'nl': return AppLocalizationsNl();
    case 'pl': return AppLocalizationsPl();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue on GitHub with a '
    'reproducible sample app and the gen-l10n configuration that was used.'
  );
}

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Focus Journal';

  @override
  String get authenticationRequired => 'Authentication Required';

  @override
  String get setupPin => 'Setup PIN';

  @override
  String get enterPasswordPrompt => 'Enter your password';

  @override
  String get enterPinPrompt => 'Enter your PIN';

  @override
  String get setupPasswordPrompt => 'Setup your password';

  @override
  String setupPinPrompt(int minLength) {
    return 'Setup your PIN (minimum $minLength digits)';
  }

  @override
  String get password => 'Password';

  @override
  String get pin => 'PIN';

  @override
  String get unlock => 'Unlock';

  @override
  String get setPassword => 'Set Password';

  @override
  String get setPin => 'Set PIN';

  @override
  String get useBiometrics => 'Use Biometrics';

  @override
  String get changePassword => 'Change Password';

  @override
  String get setupPassword => 'Setup Password';

  @override
  String get journal => 'Journal';

  @override
  String get settings => 'Settings';

  @override
  String get welcomeToJournal => 'Welcome to Focus Journal';

  @override
  String get journalDescription => 'Your secure space for focused thoughts and reflections.';

  @override
  String get logout => 'Logout';
}

/// Basic implementations for other languages (simplified for now)
class AppLocalizationsDe extends AppLocalizationsEn {
  AppLocalizationsDe() : super('de');

  @override
  String get appTitle => 'Focus Tagebuch';

  @override
  String get authenticationRequired => 'Authentifizierung erforderlich';

  @override
  String get setupPin => 'PIN einrichten';

  @override
  String get password => 'Passwort';

  @override
  String get pin => 'PIN';

  @override
  String get unlock => 'Entsperren';

  @override
  String get changePassword => 'Passwort ändern';

  @override
  String get setupPassword => 'Passwort einrichten';

  @override
  String get journal => 'Tagebuch';

  @override
  String get settings => 'Einstellungen';

  @override
  String get logout => 'Abmelden';
}

class AppLocalizationsEs extends AppLocalizationsEn {
  AppLocalizationsEs() : super('es');

  @override
  String get appTitle => 'Diario Focus';

  @override
  String get authenticationRequired => 'Autenticación requerida';

  @override
  String get password => 'Contraseña';

  @override
  String get unlock => 'Desbloquear';

  @override
  String get changePassword => 'Cambiar contraseña';

  @override
  String get journal => 'Diario';

  @override
  String get settings => 'Configuración';

  @override
  String get logout => 'Cerrar sesión';
}

class AppLocalizationsFr extends AppLocalizationsEn {
  AppLocalizationsFr() : super('fr');

  @override
  String get appTitle => 'Journal Focus';

  @override
  String get authenticationRequired => 'Authentification requise';

  @override
  String get password => 'Mot de passe';

  @override
  String get unlock => 'Déverrouiller';

  @override
  String get changePassword => 'Changer le mot de passe';

  @override
  String get journal => 'Journal';

  @override
  String get settings => 'Paramètres';

  @override
  String get logout => 'Déconnexion';
}

class AppLocalizationsIt extends AppLocalizationsEn {
  AppLocalizationsIt() : super('it');

  @override
  String get appTitle => 'Diario Focus';

  @override
  String get authenticationRequired => 'Autenticazione richiesta';

  @override
  String get password => 'Password';

  @override
  String get unlock => 'Sblocca';

  @override
  String get changePassword => 'Cambia password';

  @override
  String get journal => 'Diario';

  @override
  String get settings => 'Impostazioni';

  @override
  String get logout => 'Disconnetti';
}

class AppLocalizationsNl extends AppLocalizationsEn {
  AppLocalizationsNl() : super('nl');

  @override
  String get appTitle => 'Focus Dagboek';

  @override
  String get authenticationRequired => 'Authenticatie vereist';

  @override
  String get password => 'Wachtwoord';

  @override
  String get unlock => 'Ontgrendelen';

  @override
  String get changePassword => 'Wachtwoord wijzigen';

  @override
  String get journal => 'Dagboek';

  @override
  String get settings => 'Instellingen';

  @override
  String get logout => 'Uitloggen';
}

class AppLocalizationsPl extends AppLocalizationsEn {
  AppLocalizationsPl() : super('pl');

  @override
  String get appTitle => 'Dziennik Focus';

  @override
  String get authenticationRequired => 'Wymagana autoryzacja';

  @override
  String get password => 'Hasło';

  @override
  String get unlock => 'Odblokuj';

  @override
  String get changePassword => 'Zmień hasło';

  @override
  String get journal => 'Dziennik';

  @override
  String get settings => 'Ustawienia';

  @override
  String get logout => 'Wyloguj';
}