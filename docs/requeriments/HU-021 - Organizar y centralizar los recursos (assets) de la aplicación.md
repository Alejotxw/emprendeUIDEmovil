# Historia de Usuario: Centralización de Recursos (Assets)

**Como** desarrollador del equipo,  
**quiero** centralizar todas las rutas de imágenes, íconos y fuentes en una clase de constantes,  
**para** evitar errores de tipeo, mejorar la organización del proyecto y facilitar el mantenimiento futuro.

---

## ✅ Criterios de Aceptación (Gherkin)

### Escenario: Uso de la clase AppAssets
* **Dado** que la aplicación utiliza imágenes, íconos y fuentes en diferentes pantallas.
* **Cuando** se referencia un recurso en cualquier widget.
* **Entonces** debe usarse exclusivamente la clase `AppAssets` (ej. `AppAssets.logo`), prohibiendo el uso de strings directos en los widgets.

### Escenario: Carga correcta de recursos
* **Dado** que los recursos existen en `assets/images/`, `assets/icons/` o `assets/fonts/`.
* **Cuando** se compila y ejecuta la aplicación.
* **Entonces** todos los recursos deben visualizarse correctamente sin errores de tipo *"Unable to load asset"*.

### Escenario: Manejo de errores y placeholders
* **Dado** que un recurso no existe o la ruta es incorrecta.
* **Cuando** el widget intenta cargar dicho recurso.
* **Entonces** debe mostrarse un **placeholder** predeterminado (contenedor gris o ícono genérico) evitando que la app falle.

### Escenario: Configuración del proyecto
* **Dado** que se agrega un nuevo recurso a las carpetas de assets.
* **Cuando** se declara la carpeta completa en el `pubspec.yaml` y se ejecuta `flutter pub get`.
* **Entonces** el recurso debe estar disponible para su uso inmediato sin declarar archivos individuales.

---

## 🛠️ Notas Técnicas

### 💻 Flutter & Implementación
* **Clase de Constantes:** Crear `lib/core/constants/app_assets.dart`.
  ```dart
  class AppAssets {
    static const String _images = 'assets/images/';
    static const String _icons = 'assets/icons/';
    
    static const String logo = '${_images}logo.png';
    static const String iconHome = '${_icons}icon_home.svg';
  }
