import 'app_localizations_en.dart';

class AppLocalizationsFr extends AppLocalizationsEn {
  AppLocalizationsFr() : super('fr');

  @override
  String get appTitle => 'Journal Focus';

  @override
  String get authenticationRequired => 'Authentification requise';

  @override
  String get setupPin => 'Configurer le code PIN';

  @override
  String get enterPasswordPrompt => 'Entrez votre mot de passe';

  @override
  String get enterPinPrompt => 'Entrez votre code PIN';

  @override
  String get setupPasswordPrompt => 'Configurez votre mot de passe';

  @override
  String setupPinPrompt(int minLength) =>
      'Configurez votre code PIN (minimum $minLength chiffres)';

  @override
  String get password => 'Mot de passe';

  @override
  String get pin => 'Code PIN';

  @override
  String get unlock => 'Déverrouiller';

  @override
  String get setPassword => 'Définir le mot de passe';

  @override
  String get setPin => 'Définir le code PIN';

  @override
  String get changePassword => 'Changer le mot de passe';

  @override
  String get setupPassword => 'Configurer le mot de passe';

  @override
  String get journal => 'Journal';

  @override
  String get settings => 'Paramètres';

  @override
  String get welcomeToJournal => 'Bienvenue dans Focus Journal';

  @override
  String get journalDescription =>
      'Votre espace sécurisé pour des pensées et réflexions ciblées.';

  @override
  String get setupSecurity => 'Configurer la sécurité';

  @override
  String get chooseAuthMethod => "Choisissez votre méthode d'authentification";

  @override
  String get passwordDescription =>
      'Utiliser un mot de passe pour l\'authentification';

  @override
  String get pinDescription =>
      'Utiliser un code PIN numérique pour l\'authentification';

  @override
  String get pattern => 'Schéma';

  @override
  String get patternDescription =>
      'Dessiner un schéma pour l\'authentification';

  @override
  String get enableBiometrics => 'Activer l\'authentification biométrique';

  @override
  String get biometricsDescription =>
      'Utiliser l\'empreinte digitale ou la reconnaissance faciale pour un accès rapide';

  @override
  String get drawPattern => 'Dessinez votre schéma';

  @override
  String get patternTooShort => 'Le schéma doit relier au moins 4 points';

  @override
  String get confirmPattern => 'Confirmez votre schéma';

  @override
  String get patternsDoNotMatch => 'Les schémas ne correspondent pas';

  @override
  String get changePattern => 'Changer de schéma';

  @override
  String get setupPattern => 'Configurer le schéma';

  @override
  String get reset => 'Réinitialiser';

  @override
  String get clear => 'Effacer';

  @override
  String get confirm => 'Confirmer';

  @override
  String get next => 'Suivant';

  @override
  String get changePin => 'Changer le code PIN';

  @override
  String pinTooShort(int minLength) =>
      'Le code PIN doit comporter au moins $minLength chiffres';

  @override
  String get pinOnlyNumbers => 'Le code PIN ne doit contenir que des chiffres';

  @override
  String get confirmPin => 'Confirmer le code PIN';

  @override
  String get pinsDoNotMatch => 'Les codes PIN ne correspondent pas';

  @override
  String get securitySettings => 'Paramètres de sécurité';

  @override
  String get currentAuthMethod => 'Méthode d\'authentification actuelle';

  @override
  String get changeAuthMethod => 'Changer de méthode d\'authentification';

  @override
  String get selectNewAuthMethod =>
      'Sélectionnez une nouvelle méthode d\'authentification';

  @override
  String get logout => 'Déconnexion';

  @override
  String get themeSettings => 'Paramètres du thème';

  @override
  String get darkMode => 'Mode sombre';

  @override
  String get lightMode => 'Mode clair';

  @override
  String get systemTheme => 'Thème système';

  @override
  String get primaryColor => 'Couleur principale';

  @override
  String get accentColor => 'Couleur d\'accent';

  @override
  String get customFont => 'Police personnalisée';

  @override
  String get backupSettings => 'Paramètres de sauvegarde';

  @override
  String get autoBackup => 'Sauvegarde automatique';

  @override
  String get backupFrequency => 'Fréquence de sauvegarde';

  @override
  String get exportBackup => 'Exporter la sauvegarde';

  @override
  String get importBackup => 'Importer la sauvegarde';

  @override
  String get privacySettings => 'Paramètres de confidentialité';

  @override
  String get analytics => 'Analyses';

  @override
  String get shareUsageData => 'Partager les données d\'utilisation';

  @override
  String get allowScreenshots => 'Autoriser les captures d\'écran';

  @override
  String get storeLocationData => 'Stocker les données de localisation';

  @override
  String get journalPreferences => 'Préférences du journal';

  @override
  String get defaultView => 'Vue par défaut';

  @override
  String get sortOrder => 'Ordre de tri';

  @override
  String get fontSize => 'Taille de police';

  @override
  String get showDateHeaders => 'Afficher les en-têtes de date';

  @override
  String get showTags => 'Afficher les tags';

  @override
  String get enableSpellCheck => 'Activer la vérification orthographique';

  @override
  String get today => 'Aujourd\'hui';

  @override
  String get yesterday => 'Hier';

  @override
  String get newEntry => 'Nouvelle entrée';

  @override
  String get editEntry => 'Modifier l\'entrée';

  @override
  String get writeYourThoughts => 'Écrivez vos pensées...';

  @override
  String get contentRequired => 'Le contenu est requis';
}
