import 'app_localizations_en.dart';

class AppLocalizationsEs extends AppLocalizationsEn {
  AppLocalizationsEs() : super('es');

  @override
  String get appTitle => 'Diario Focus';

  @override
  String get authenticationRequired => 'Autenticación requerida';

  @override
  String get setupPin => 'Configurar PIN';

  @override
  String get enterPasswordPrompt => 'Ingresa tu contraseña';

  @override
  String get enterPinPrompt => 'Ingresa tu PIN';

  @override
  String get setupPasswordPrompt => 'Configura tu contraseña';

  @override
  String setupPinPrompt(int minLength) =>
      'Configura tu PIN (mínimo $minLength dígitos)';

  @override
  String get password => 'Contraseña';

  @override
  String get pin => 'PIN';

  @override
  String get unlock => 'Desbloquear';

  @override
  String get setPassword => 'Establecer contraseña';

  @override
  String get setPin => 'Establecer PIN';

  @override
  String get changePassword => 'Cambiar contraseña';

  @override
  String get setupPassword => 'Configurar contraseña';

  @override
  String get journal => 'Diario';

  @override
  String get settings => 'Configuración';

  @override
  String get welcomeToJournal => 'Bienvenido a Focus Diario';

  @override
  String get journalDescription =>
      'Tu espacio seguro para pensamientos y reflexiones enfocados.';

  @override
  String get setupSecurity => 'Configurar seguridad';

  @override
  String get chooseAuthMethod => 'Elige tu método de autenticación';

  @override
  String get passwordDescription => 'Usar una contraseña para la autenticación';

  @override
  String get pinDescription => 'Usar un PIN numérico para la autenticación';

  @override
  String get pattern => 'Patrón';

  @override
  String get patternDescription => 'Dibuja un patrón para la autenticación';

  @override
  String get enableBiometrics => 'Activar autenticación biométrica';

  @override
  String get biometricsDescription =>
      'Usar huella digital o reconocimiento facial para acceso rápido';

  @override
  String get drawPattern => 'Dibuja tu patrón';

  @override
  String get patternTooShort => 'El patrón debe conectar al menos 4 puntos';

  @override
  String get confirmPattern => 'Confirma tu patrón';

  @override
  String get patternsDoNotMatch => 'Los patrones no coinciden';

  @override
  String get changePattern => 'Cambiar patrón';

  @override
  String get setupPattern => 'Configurar patrón';

  @override
  String get reset => 'Reiniciar';

  @override
  String get clear => 'Limpiar';

  @override
  String get confirm => 'Confirmar';

  @override
  String get next => 'Siguiente';

  @override
  String get changePin => 'Cambiar PIN';

  @override
  String pinTooShort(int minLength) =>
      'El PIN debe tener al menos $minLength dígitos';

  @override
  String get pinOnlyNumbers => 'El PIN solo debe contener números';

  @override
  String get confirmPin => 'Confirmar PIN';

  @override
  String get pinsDoNotMatch => 'Los PINs no coinciden';

  @override
  String get securitySettings => 'Configuración de seguridad';

  @override
  String get currentAuthMethod => 'Método de autenticación actual';

  @override
  String get changeAuthMethod => 'Cambiar método de autenticación';

  @override
  String get selectNewAuthMethod => 'Selecciona un nuevo método de autenticación';

  @override
  String get logout => 'Cerrar sesión';

  @override
  String get themeSettings => 'Configuración del tema';

  @override
  String get darkMode => 'Modo oscuro';

  @override
  String get lightMode => 'Modo claro';

  @override
  String get systemTheme => 'Tema del sistema';

  @override
  String get primaryColor => 'Color primario';

  @override
  String get accentColor => 'Color de acento';

  @override
  String get customFont => 'Fuente personalizada';

  @override
  String get backupSettings => 'Configuración de respaldo';

  @override
  String get autoBackup => 'Respaldo automático';

  @override
  String get backupFrequency => 'Frecuencia de respaldo';

  @override
  String get exportBackup => 'Exportar respaldo';

  @override
  String get importBackup => 'Importar respaldo';

  @override
  String get privacySettings => 'Configuración de privacidad';

  @override
  String get analytics => 'Análisis';

  @override
  String get shareUsageData => 'Compartir datos de uso';

  @override
  String get allowScreenshots => 'Permitir capturas de pantalla';

  @override
  String get storeLocationData => 'Almacenar datos de ubicación';

  @override
  String get journalPreferences => 'Preferencias del diario';

  @override
  String get defaultView => 'Vista predeterminada';

  @override
  String get sortOrder => 'Orden de clasificación';

  @override
  String get fontSize => 'Tamaño de fuente';

  @override
  String get showDateHeaders => 'Mostrar encabezados de fecha';

  @override
  String get showTags => 'Mostrar etiquetas';

  @override
  String get enableSpellCheck => 'Activar corrector ortográfico';
}