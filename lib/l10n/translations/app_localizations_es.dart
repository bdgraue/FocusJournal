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
  String get selectNewAuthMethod =>
      'Selecciona un nuevo método de autenticación';

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

  @override
  String get today => 'Hoy';

  @override
  String get yesterday => 'Ayer';

  @override
  String get newEntry => 'Nueva entrada';

  @override
  String get editEntry => 'Editar entrada';

  @override
  String get writeYourThoughts => 'Escribe tus pensamientos...';

  @override
  String get contentRequired => 'El contenido es obligatorio';

  @override
  String get incorrectPattern => 'Patrón incorrecto';
  @override
  String get pleaseDrawYourPattern => 'Por favor dibuja tu patrón';
  @override
  String get useBackupPassword => 'Usar contraseña de respaldo';
  @override
  String get usePin => 'Usar PIN';
  @override
  String get usePattern => 'Usar patrón';
  @override
  String get incorrectPassword => 'Contraseña incorrecta';
  @override
  String get incorrectPin => 'PIN incorrecto';
  @override
  String get incorrectBackupPassword => 'Contraseña de respaldo incorrecta';
  @override
  String get pleaseEnterYourPassword => 'Por favor ingresa tu contraseña';
  @override
  String get pleaseEnterYourPin => 'Por favor ingresa tu PIN';
  @override
  String get pleaseEnterYourBackupPassword => 'Por favor ingresa tu contraseña de respaldo';
  @override
  String get confirmPassword => 'Confirmar contraseña';
  @override
  String get pleaseEnterAPassword => 'Por favor ingresa una contraseña';
  @override
  String passwordMinLength(int minLength) => 'La contraseña debe tener al menos $minLength caracteres';
  @override
  String get passwordsDoNotMatch => 'Las contraseñas no coinciden';
  @override
  String get journalExportedSuccessfully => 'Diario exportado con éxito';
  @override
  String exportFailed(String error) => 'Error al exportar el diario: $error';
  @override
  String importFailed(String error) => 'Error al importar el diario: $error';
  @override
  String get importStrategy => 'Estrategia de importación';
  @override
  String get completeOverwrite => 'Reemplazo completo';
  @override
  String get replaceAllData => 'Reemplazar todos los datos existentes';
  @override
  String get smartMerge => 'Fusión inteligente (Recomendado)';
  @override
  String get mergeWithConflicts => 'Fusionar con resolución de conflictos';
  @override
  String get addNewOnly => 'Solo agregar nuevas';
  @override
  String get onlyImportNew => 'Solo importar entradas nuevas';
  @override
  String get cancel => 'Cancelar';
  @override
  String get proceed => 'Continuar';
  @override
  String get couldNotGetFilePath => 'No se pudo obtener la ruta del archivo';
  @override
  String get noFileSelected => 'Ningún archivo seleccionado';
  @override
  String filePickFailed(String error) => 'Error al seleccionar archivo: $error';
  @override
  String get backupAndRecovery => 'Respaldo y recuperación';
  @override
  String get backupPasswordLabel => 'Contraseña de respaldo';
  @override
  String get backupPasswordHint => 'Establece una contraseña para proteger tus respaldos';
  @override
  String get passwordRequired => 'La contraseña es obligatoria';
  @override
  String get createBackup => 'Crear respaldo';
  @override
  String get restoreBackup => 'Restaurar respaldo';
  @override
  String importSuccessMessage(int added, int updated, int total) =>
      'Importación exitosa: +$added nuevas, ~$updated actualizadas, $total en total.';
  @override
  String get appearance => 'Apariencia';
  @override
  String get colors => 'Colores';
  @override
  String get typography => 'Tipografía';
  @override
  String get useCustomFont => 'Usar fuente personalizada';
  @override
  String get fontFamily => 'Familia de fuente';
  @override
  String get advancedSettings => 'Avanzado';
  @override
  String get dynamicTheming => 'Tema dinámico';
  @override
  String get dynamicThemingDescription => 'Adaptar colores según el fondo de pantalla';
  @override
  String get contrastLabel => 'Contraste';
  @override
  String get pickAColor => 'Elegir un color';

  @override
  String get biometricPrompt => 'Autentícate para acceder a tu diario';

  @override
  String get enableBiometricsQuestion => '¿Deseas activar la autenticación biométrica para un acceso rápido?';

  @override
  String get skip => 'Omitir';

  @override
  String get biometricAuthFailed => 'La autenticación biométrica falló';

  @override
  String get editEntries => 'Editar entradas';
  @override
  String get done => 'Listo';
  @override
  String get notificationsAndReminders => 'Notificaciones y recordatorios';
  @override
  String get dailyReminders => 'Recordatorios diarios';
  @override
  String get dailyRemindersDescription => 'Recibe un recordatorio amigable para escribir en tu diario';
  @override
  String get reminderTime => 'Hora del recordatorio';

  // --- View entry ---
  @override
  String get viewEntry => 'Ver entrada';

  // --- Search & Calendar ---
  @override
  String get search => 'Buscar';
  @override
  String get searchEntries => 'Buscar entradas...';
  @override
  String get noSearchResults => 'No se encontraron entradas';
  @override
  String get calendarOverview => 'Calendario';
  @override
  String get noEntriesForDay => 'No hay entradas para este día';

  // --- Security ---
  @override
  String tooManyAttempts(int seconds) => 'Demasiados intentos. Espere $seconds segundos.';
  @override
  String attemptsRemaining(int count) => '$count intentos restantes';
  @override
  String get passwordComplexityError => 'Debe contener mayúsculas, minúsculas, número y carácter especial';
  @override
  String get unexpectedError => 'Se produjo un error inesperado. Inténtelo de nuevo.';

  // --- Agradecimientos ---
  @override
  String get credits => 'Agradecimientos';
  @override
  String get creditsDeike => 'Por sus maravillosas ideas y su contribuci\u00f3n al \u00e9xito de esta app. Adem\u00e1s, por las conversaciones maravillosas en todo momento, la ternura y el cari\u00f1o que recibo.';
}
