# Historia de Usuario: Implementación de Textos Multi-idioma (i18n)

**Como** usuario internacional,  
**quiero** que todos los textos de la aplicación aparezcan en mi idioma preferido (español o inglés),  
**para** comprender correctamente todas las funcionalidades de la app.

---

## ✅ Criterios de Aceptación (Gherkin)

### Escenario: Cambio dinámico de idioma
* **Dado** que el usuario utiliza el mecanismo de selección (botón o selector).
* **Cuando** selecciona un idioma (Español ↔ Inglés).
* **Entonces** todos los textos visibles en todas las pantallas deben actualizarse inmediatamente sin necesidad de reiniciar la app.

### Escenario: Prohibición de Hard-coded Strings
* **Dado** que se renderiza cualquier pantalla (botones, títulos, placeholders).
* **Cuando** el widget se construye.
* **Entonces** el sistema debe obtener los textos exclusivamente mediante `AppLocalizations.of(context)`, prohibiendo el uso de strings directos.

### Escenario: Fallback de claves faltantes
* **Dado** que una clave no existe en uno de los archivos `.arb`.
* **Cuando** se carga la aplicación en ese idioma específico.
* **Entonces** debe mostrarse la clave como fallback para facilitar la depuración y detección de errores.

### Escenario: Persistencia de selección
* **Dado** que el usuario ha seleccionado un idioma preferido.
* **Cuando** la aplicación se cierra y se vuelve a abrir.
* **Entonces** la interfaz debe cargar automáticamente el último idioma seleccionado almacenado en el dispositivo.

---

## 🛠️ Notas Técnicas

### 🌎 Internacionalización (i18n)
* **Framework:** Uso de `flutter_localizations` y el paquete `intl`.
* **Gestión de Recursos:** Centralización de textos en `lib/l10n/` con archivos `app_es.arb` y `app_en.arb`.
* **Generación:** Uso mandatorio de `flutter gen-l10n` para actualizar las clases sintéticas.

### 🏗️ Arquitectura y Persistencia
* **Acceso a Datos:** Uso de `AppLocalizations.of(context)!.clave` en la capa de UI.
* **Almacenamiento Local:** Implementación de `shared_preferences` o `Hive` para guardar el locale seleccionado (ej. `es` o `en`).
* **Estado:** Integración con el gestor de estado (Provider/Riverpod) para notificar el cambio de `Locale` al widget raíz (`MaterialApp`).

---

## 🚀 Control de Versiones (GitHub)

* **Rama:** `feature/implementacion-traducciones-hu`
* **Pull Request:** Crear PR hacia la rama `develop`.
* **Regla de Oro:** **NO HACER MERGE** manualmente; requiere aprobación del Code Review.
