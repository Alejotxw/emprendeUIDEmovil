# Historia de Usuario: Configuración de Localización (i18n)

**Como** desarrollador de la aplicación,  
**quiero** configurar el sistema nativo de localización de Flutter con soporte inicial para español e inglés,  
**para** separar los textos del código y preparar la aplicación para múltiples idiomas.

---

## ✅ Criterios de Aceptación (Gherkin)

### Escenario: Generación de clases de localización
* **Dado** que el proyecto se configura por primera vez con localización.
* **Cuando** se ejecutan los comandos `flutter pub get` y `flutter gen-l10n`.
* **Entonces** deben generarse automáticamente las clases `AppLocalizations` sin errores.

### Escenario: Integración con MaterialApp
* **Dado** que el `MaterialApp` se está inicializando.
* **Cuando** se configura la aplicación.
* **Entonces** deben incluirse los `localizationsDelegates` y `supportedLocales`, permitiendo el acceso mediante `AppLocalizations.of(context)`.

### Escenario: Sincronización de claves ARB
* **Dado** que existen los archivos `app_es.arb` y `app_en.arb`.
* **Cuando** se agrega una nueva clave en ambos archivos.
* **Entonces** la clase generada debe actualizarse automáticamente con el nuevo método correspondiente tras la generación.

### Escenario: Detección automática e Idioma por defecto
* **Dado** que el dispositivo tiene un idioma configurado.
* **Cuando** se abre la aplicación:
    * **Si** el idioma es Español o Inglés, debe cargarse automáticamente.
    * **Si** el idioma no está soportado (ej. Francés), debe aplicarse el idioma por defecto configurado.

---

## 🛠️ Notas Técnicas

### 🌎 Flutter i18n
* **Configuración:** Activar `generate: true` en la sección `flutter:` del `pubspec.yaml`.
* **Dependencias:** Habilitar el paquete `flutter_localizations` (SDK de Flutter).
* **Estructura:** Crear los archivos en la ruta `lib/l10n/`:
    * `app_es.arb` (Español)
    * `app_en.arb` (Inglés)
* **Comandos:** Uso de `flutter gen-l10n` para la creación de las clases sintéticas.

### 🏗️ Arquitectura y Fallback
* **Acceso:** Centralizar todos los strings en los archivos `.arb` y evitar el "hardcoding" de texto en los widgets.
* **Compatibilidad:** Implementar `localeResolutionCallback` para garantizar el fallback automático hacia el idioma base cuando el idioma del sistema no coincida con los soportados.

---

## 🚀 Control de Versiones (GitHub)

* **Rama:** `feature/configuracion-localizacion-hu`
* **Pull Request:** Crear PR hacia la rama `develop`.
* **Regla de Oro:** **NO HACER MERGE** manualmente; esperar validación técnica.
