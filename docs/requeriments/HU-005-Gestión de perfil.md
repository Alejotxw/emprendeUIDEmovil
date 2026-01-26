# Historia de Usuario – Centralización de Recursos y Gestión de Assets

**Como** desarrollador del equipo del marketplace UIDE  
**Quiero** centralizar todas las rutas de imágenes, íconos y fuentes en una clase de constantes  
**Para que** se eviten errores de tipeo, se facilite el mantenimiento y la actualización de recursos sea eficiente en toda la aplicación.

---

## Criterios de Aceptación (Gherkin)

### Escenario: Referencia centralizada mediante AppAssets
**Dado** que la aplicación utiliza imágenes e íconos en diferentes pantallas  
**Cuando** necesito mostrar un recurso en un Widget  
**Entonces** debo utilizar exclusivamente la clase AppAssets (ej. AppAssets.logo), quedando prohibido el uso de rutas escritas directamente como strings dentro de la interfaz.

### Escenario: Carga correcta desde carpetas de origen
**Dado** que los recursos están organizados en assets/images/, assets/icons/ y assets/fonts/  
**Cuando** se compila y ejecuta la aplicación  
**Entonces** el sistema debe cargar y renderizar correctamente cada archivo referenciado desde sus respectivas rutas.

### Escenario: Manejo de recursos faltantes (Placeholders)
**Dado** que una imagen o ícono no existe en la ruta indicada o el archivo está corrupto  
**Cuando** el Widget correspondiente intenta cargar el recurso  
**Entonces** el sistema debe mostrar un placeholder predeterminado (ej. un contenedor gris o un ícono genérico) evitando que la aplicación se cierre o lance una excepción crítica.

### Escenario: Actualización masiva de recursos en pubspec.yaml
**Dado** que se agregan nuevos archivos a las carpetas de assets  
**Cuando** se declara la carpeta completa en el archivo pubspec.yaml y se ejecuta flutter pub get  
**Entonces** los nuevos recursos deben estar disponibles inmediatamente para ser mapeados en la clase de constantes sin necesidad de registro individual.

### Escenario: Portabilidad y consistencia del entorno
**Dado** que el proyecto se clona en un nuevo dispositivo o es abierto por otro desarrollador  
**Cuando** se ejecuta la aplicación por primera vez  
**Entonces** todos los recursos deben cargar sin errores de tipo "Unable to load asset", garantizando que el entorno de desarrollo es consistente para todo el equipo.
