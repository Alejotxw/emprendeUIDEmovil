Historia de Usuario

Como desarrollador de la aplicación,
quiero configurar el sistema nativo de localización de Flutter con soporte inicial para español e inglés,
para separar los textos del código y preparar la aplicación para múltiples idiomas.

Criterios de Aceptación

Dado que el proyecto se configura por primera vez con localización
Cuando se ejecuta flutter pub get y flutter gen-l10n
Entonces deben generarse automáticamente las clases AppLocalizations sin errores.

Dado que el MaterialApp se inicializa
Cuando se configura la aplicación
Entonces debe incluir localizationsDelegates, supportedLocales y permitir el uso de AppLocalizations.of(context) en los widgets.

Dado que existen los archivos app_es.arb y app_en.arb
Cuando se agrega una nueva clave en ambos archivos
Entonces al ejecutar flutter gen-l10n debe actualizarse la clase generada con el nuevo método correspondiente.

Dado que el dispositivo está configurado en español o inglés
Cuando se abre la aplicación
Entonces debe cargarse automáticamente el idioma correspondiente según la configuración del sistema.

Dado que no existe soporte para un idioma no configurado (por ejemplo, francés)
Cuando el dispositivo utiliza ese idioma
Entonces la aplicación debe utilizar el idioma por defecto configurado (español o inglés).

Notas Técnicas

Flutter: Configurar el archivo pubspec.yaml con la sección flutter: generate: true y habilitar el paquete flutter_localizations. Crear los archivos de localización en la carpeta lib/l10n/ (app_es.arb, app_en.arb). Ejecutar flutter gen-l10n para generar las clases de localización.

Arquitectura: Centralizar todos los textos visibles de la aplicación en los archivos .arb y evitar el uso de strings directamente en los widgets. Utilizar AppLocalizations.of(context) para acceder a los textos localizados.

Compatibilidad: Definir un idioma por defecto mediante localeResolutionCallback o configuración de supportedLocales, garantizando fallback automático cuando el idioma del dispositivo no esté soportado.

GitHub: Crear branch hacia developer feature/(su tarea HU) y realizar un Pull Request (NO HACER MERGE).
