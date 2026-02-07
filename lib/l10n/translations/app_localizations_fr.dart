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
  String get language => 'Langue';

  @override
  String get languageSettings => 'Paramètres de langue';

  @override
  String get systemLanguage => 'Par défaut du système';

  @override
  String get languageDescription => 'Choisissez votre langue préférée';

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
  String get viewAndLayout => 'Affichage & Disposition';

  @override
  String get displayOptions => 'Options d\'affichage';

  @override
  String get editing => 'Édition';

  @override
  String get calendarView => 'Vue calendrier';

  @override
  String get listView => 'Vue liste';

  @override
  String get timelineView => 'Vue chronologique';

  @override
  String get newestFirst => 'Plus récent d\'abord';

  @override
  String get oldestFirst => 'Plus ancien d\'abord';

  @override
  String get titleAscending => 'Titre (A-Z)';

  @override
  String get titleDescending => 'Titre (Z-A)';

  @override
  String get fontSizeSmall => 'Petit';

  @override
  String get fontSizeMedium => 'Moyen';

  @override
  String get fontSizeLarge => 'Grand';

  @override
  String get fontSizeExtraLarge => 'Très grand';

  @override
  String get showDateHeadersDescription => 'Afficher les séparateurs de date entre les entrées';

  @override
  String get showTagsDescription => 'Afficher les tags dans les aperçus d\'entrée';

  @override
  String get enableSpellCheckDescription => 'Vérifier l\'orthographe pendant la saisie';

  @override
  String get privacyAndData => 'Confidentialité et données';

  @override
  String get privacyControls => 'Contrôles de confidentialité';

  @override
  String get dataManagement => 'Gestion des données';

  @override
  String get collectAnalytics => 'Collecter les analyses';

  @override
  String get collectAnalyticsDescription => 'Aidez à améliorer l\'application en partageant des statistiques d\'utilisation anonymes';

  @override
  String get shareUsageDataDescription => 'Envoyer des modèles d\'utilisation anonymes pour aider au développement';

  @override
  String get showJournalOnWidget => 'Afficher le journal sur le widget';

  @override
  String get showJournalOnWidgetDescription => 'Afficher les entrées récentes sur le widget de l\'écran d\'accueil';

  @override
  String get allowScreenshotsDescription => 'Autoriser la capture d\'écran des entrées de journal';

  @override
  String get storeLocationDataDescription => 'Joindre des informations de localisation aux entrées de journal';

  @override
  String get enableCrashReporting => 'Activer les rapports de crash';

  @override
  String get enableCrashReportingDescription => 'Envoyer automatiquement des rapports de crash pour corriger les bogues';

  @override
  String get clearAllData => 'Effacer toutes les données';

  @override
  String get clearAllDataDescription => 'Supprimer définitivement toutes les entrées de journal et les paramètres';

  @override
  String get clearAllDataWarning => 'Cette action ne peut pas être annulée. Toutes vos entrées de journal seront définitivement supprimées.';

  @override
  String entriesWillBeDeleted(int count) => '$count entrées seront supprimées';

  @override
  String get deleteAll => 'Tout supprimer';

  @override
  String get dataCleared => 'Toutes les données ont été effacées';

  @override
  String get errorClearingData => 'Erreur lors de l\'effacement des données';

  @override
  String get clearDataWarningNote => 'Remarque : L\'effacement des données est permanent et ne peut pas être annulé. Veuillez vous assurer d\'avoir sauvegardé toutes les entrées importantes.';

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

  @override
  String get incorrectPattern => 'Schéma incorrect';
  @override
  String get pleaseDrawYourPattern => 'Veuillez dessiner votre schéma';
  @override
  String get useBackupPassword => 'Utiliser le mot de passe de secours';
  @override
  String get usePin => 'Utiliser le code PIN';
  @override
  String get usePattern => 'Utiliser le schéma';
  @override
  String get incorrectPassword => 'Mot de passe incorrect';
  @override
  String get incorrectPin => 'Code PIN incorrect';
  @override
  String get incorrectBackupPassword => 'Mot de passe de secours incorrect';
  @override
  String get pleaseEnterYourPassword => 'Veuillez entrer votre mot de passe';
  @override
  String get pleaseEnterYourPin => 'Veuillez entrer votre code PIN';
  @override
  String get pleaseEnterYourBackupPassword => 'Veuillez entrer votre mot de passe de secours';
  @override
  String get confirmPassword => 'Confirmer le mot de passe';
  @override
  String get pleaseEnterAPassword => 'Veuillez entrer un mot de passe';
  @override
  String passwordMinLength(int minLength) => 'Le mot de passe doit comporter au moins $minLength caractères';
  @override
  String get passwordsDoNotMatch => 'Les mots de passe ne correspondent pas';
  @override
  String get journalExportedSuccessfully => 'Journal exporté avec succès';
  @override
  String exportFailed(String error) => 'Échec de l\'exportation : $error';
  @override
  String importFailed(String error) => 'Échec de l\'importation : $error';
  @override
  String get importStrategy => 'Stratégie d\'importation';
  @override
  String get completeOverwrite => 'Remplacement complet';
  @override
  String get replaceAllData => 'Remplacer toutes les données existantes';
  @override
  String get smartMerge => 'Fusion intelligente (Recommandé)';
  @override
  String get mergeWithConflicts => 'Fusionner avec résolution des conflits';
  @override
  String get addNewOnly => 'Ajouter uniquement les nouvelles';
  @override
  String get onlyImportNew => 'Importer uniquement les nouvelles entrées';
  @override
  String get cancel => 'Annuler';
  @override
  String get proceed => 'Continuer';
  @override
  String get couldNotGetFilePath => 'Impossible d\'obtenir le chemin du fichier';
  @override
  String get noFileSelected => 'Aucun fichier sélectionné';
  @override
  String filePickFailed(String error) => 'Échec de la sélection du fichier : $error';
  @override
  String get backupAndRecovery => 'Sauvegarde et restauration';
  @override
  String get backupPasswordLabel => 'Mot de passe de sauvegarde';
  @override
  String get backupPasswordHint => 'Définissez un mot de passe pour sécuriser vos sauvegardes';
  @override
  String get passwordRequired => 'Le mot de passe est requis';
  @override
  String get createBackup => 'Créer une sauvegarde';
  @override
  String get restoreBackup => 'Restaurer une sauvegarde';
  @override
  String get saveBackupLocally => 'Enregistrer la sauvegarde localement';
  @override
  String get createAndShareBackup => 'Créer et partager la sauvegarde';
  @override
  String get backupSavedSuccessfully => 'Sauvegarde enregistrée avec succès';
  @override
  String backupSavedTo(String path) => 'Sauvegarde enregistrée dans : $path';
  @override
  String importSuccessMessage(int added, int updated, int total) =>
      'Import réussi : +$added nouvelles, ~$updated mises à jour, $total au total.';
  @override
  String get appearance => 'Apparence';
  @override
  String get colors => 'Couleurs';
  @override
  String get typography => 'Typographie';
  @override
  String get useCustomFont => 'Utiliser une police personnalisée';
  @override
  String get fontFamily => 'Famille de police';
  @override
  String get advancedSettings => 'Avancé';
  @override
  String get dynamicTheming => 'Thème dynamique';
  @override
  String get dynamicThemingDescription => 'Adapter les couleurs en fonction du fond d\'écran';
  @override
  String get contrastLabel => 'Contraste';
  @override
  String get pickAColor => 'Choisir une couleur';

  @override
  String get biometricPrompt => 'Authentifiez-vous pour accéder à votre journal';

  @override
  String get enableBiometricsQuestion => 'Souhaitez-vous activer l\'authentification biométrique pour un accès rapide ?';

  @override
  String get skip => 'Passer';

  @override
  String get biometricAuthFailed => 'Échec de l\'authentification biométrique';

  @override
  String get editEntries => 'Modifier les entrées';
  @override
  String get done => 'Terminé';
  @override
  String get notificationsAndReminders => 'Notifications et rappels';
  @override
  String get dailyReminders => 'Rappels quotidiens';
  @override
  String get dailyRemindersDescription => 'Recevez un rappel amical pour écrire dans votre journal';
  @override
  String get reminderTime => 'Heure du rappel';

  // --- View entry ---
  @override
  String get viewEntry => 'Voir l\'entr\u00e9e';

  // --- Search & Calendar ---
  @override
  String get search => 'Rechercher';
  @override
  String get searchEntries => 'Rechercher des entrées...';
  @override
  String get noSearchResults => 'Aucune entrée trouvée';
  @override
  String get calendarOverview => 'Calendrier';
  @override
  String get noEntriesForDay => 'Aucune entrée pour ce jour';

  // --- Security ---
  @override
  String tooManyAttempts(int seconds) => 'Trop de tentatives. Veuillez patienter $seconds secondes.';
  @override
  String attemptsRemaining(int count) => '$count tentatives restantes';
  @override
  String get passwordComplexityError => 'Doit contenir majuscule, minuscule, chiffre et caractère spécial';
  @override
  String get unexpectedError => 'Une erreur inattendue s\'est produite. Veuillez r\u00e9essayer.';

  // --- Remerciements ---
  @override
  String get credits => 'Remerciements';
  @override
  String get creditsDeike => 'Pour ses id\u00e9es formidables et sa contribution au succ\u00e8s de cette app. Et pour les merveilleuses conversations \u00e0 tout moment, la tendresse et l\'affection que je re\u00e7ois.';
}
