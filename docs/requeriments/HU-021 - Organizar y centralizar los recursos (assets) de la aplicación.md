Historia de usuario

Como desarrollador del equipo, quiero centralizar todas las rutas de imágenes, íconos y fuentes en una clase de constantes, para evitar errores de tipeo, mejorar la organización del proyecto y facilitar el mantenimiento cuando se agreguen o modifiquen recursos.

Criterios de Aceptación

Dado que la aplicación utiliza imágenes, íconos y fuentes en diferentes pantallas
Cuando se compila y ejecuta la aplicación
Entonces todas las imágenes, íconos y fuentes deben cargarse correctamente desde las carpetas assets/images/, assets/icons/ y assets/fonts/.

Dado que existe un recurso (e.g., logo.png, banner_home.png, icon_home.svg)
Cuando se referencia en cualquier widget o componente de la aplicación
Entonces debe usarse exclusivamente a través de la clase AppAssets (e.g., AppAssets.logo, AppAssets.iconHome), sin utilizar rutas escritas directamente como strings.

Dado que no existe una imagen, ícono o fuente en la ruta indicada
Cuando se carga el widget correspondiente
Entonces debe mostrarse un placeholder predeterminado (e.g., ícono genérico o contenedor gris), sin que la aplicación falle o genere excepciones.

Dado que se agrega un nuevo recurso a alguna carpeta de assets
Cuando se actualiza el archivo pubspec.yaml declarando la carpeta completa
Entonces el nuevo recurso debe estar disponible después de ejecutar flutter pub get, sin necesidad de declarar archivos individuales.

Dado que el proyecto se abre en otro dispositivo o por otro desarrollador del equipo
Cuando se ejecuta la aplicación
Entonces todos los recursos deben cargarse correctamente sin errores del tipo "Unable to load asset".

Notas Técnicas

Flutter: Crear una clase AppAssets en un archivo dedicado (e.g., app_assets.dart) con constantes estáticas para cada recurso (static const String logo = 'assets/images/logo.png';). Definir rutas base para images, icons y fonts. Implementar manejo de errores en widgets de imágenes mediante errorBuilder o fallback widgets. Evitar el uso de rutas directas en el código y centralizar el acceso a recursos en AppAssets.

Arquitectura: Organizar las carpetas assets/images/, assets/icons/ y assets/fonts/ dentro del proyecto. Aplicar naming conventions consistentes para los recursos. Validar el uso de AppAssets mediante revisiones de código o lint rules.

Configuración: Declarar las carpetas completas en pubspec.yaml bajo la sección flutter: assets:. Ejecutar flutter pub get para sincronizar los recursos.

GitHub: Crear branch hacia developer feature/(su tarea HU), y realizar un Pull Request (NO HACER MERGE).
