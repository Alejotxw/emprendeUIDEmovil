Historia de Usuario

Como usuario internacional,
quiero que todos los textos de la aplicación aparezcan en mi idioma preferido (español o inglés),
para comprender correctamente todas las funcionalidades de la app.

Criterios de Aceptación

Dado que el usuario cambia el idioma mediante el mecanismo temporal (botón o selector)
Cuando selecciona español o inglés
Entonces todos los textos visibles en todas las pantallas deben actualizarse inmediatamente al idioma seleccionado.

Dado que existe un texto en la interfaz (botones, títulos, mensajes, placeholders, etc.)
Cuando se renderiza cualquier pantalla
Entonces no debe mostrarse texto hard-coded, sino únicamente textos obtenidos mediante AppLocalizations.of(context).

Dado que una clave falta en uno de los archivos .arb
Cuando se carga la aplicación en ese idioma
Entonces debe mostrarse la clave como fallback para facilitar la detección de errores de localización.

Dado que el usuario navega por cualquier pantalla de la aplicación (dashboard, perfil, carrito, solicitudes, etc.)
Cuando cambia el idioma
Entonces todos los textos visibles y mensajes de la interfaz deben traducirse correctamente al idioma seleccionado.

Dado que se implementa una nueva pantalla sin textos previamente definidos
Cuando se agregan nuevos mensajes
Entonces deben registrarse las claves correspondientes en los archivos de localización en ambos idiomas.

Notas Técnicas

Flutter: Implementar la internacionalización utilizando el sistema nativo de Flutter (flutter_localizations y intl). Configurar los archivos .arb en la carpeta lib/l10n/ y generar las clases de localización mediante flutter gen-l10n.

Arquitectura: Centralizar todos los textos en los archivos de localización y evitar el uso de strings directamente en los widgets. Utilizar AppLocalizations.of(context) para acceder a los textos traducidos.

Persistencia: Almacenar la preferencia de idioma del usuario mediante SharedPreferences o almacenamiento local para mantener el idioma seleccionado entre sesiones.

GitHub: Crear branch hacia developer feature/(su tarea HU) y realizar un Pull Request (NO HACER MERGE).
