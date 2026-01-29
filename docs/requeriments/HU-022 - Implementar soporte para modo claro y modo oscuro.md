Historia de usuario

Como usuario de la aplicación, quiero que la interfaz se adapte automáticamente al modo claro u oscuro y pueda cambiarlo manualamente, para tener una experiencia visual cómoda y consistente en cualquier condición de luz.

Criterios de Aceptación

Dado que el usuario tiene configurado el modo claro u oscuro en su dispositivo
Cuando abre la aplicación
Entonces la interfaz debe adaptarse automáticamente al modo del sistema utilizando theme y darkTheme configurados en la aplicación.

Dado que el usuario presiona el botón de cambio de tema
Cuando selecciona el modo opuesto (claro ↔ oscuro)
Entonces toda la interfaz debe actualizarse inmediatamente, incluyendo fondos, textos, botones y colores, garantizando legibilidad y coherencia visual.

Dado que existen widgets con estilos personalizados
Cuando se renderizan en modo claro y modo oscuro
Entonces no deben utilizarse colores fijos (ej. Colors.blue, #FF0000), sino únicamente los definidos en Theme.of(context).colorScheme (primary, surface, onSurface, etc.).

Dado que el usuario navega entre diferentes pantallas
Cuando cambia el modo de tema
Entonces todas las pantallas deben mantener el nuevo tema sin problemas de contraste o textos ilegibles.

Dado que la aplicación se reinicia
Cuando se abre nuevamente
Entonces debe recordarse el último modo seleccionado por el usuario, independientemente del modo del sistema.

Notas Técnicas

Flutter: Configurar ThemeData y DarkThemeData en MaterialApp, utilizando colorScheme para definir paletas de colores. Implementar un ThemeProvider o ChangeNotifier para gestionar el estado del tema. Usar Provider, Riverpod o Bloc para propagar cambios de tema en toda la aplicación.

Persistencia: Guardar la preferencia del usuario utilizando SharedPreferences o Hive, recuperando el modo seleccionado al iniciar la aplicación.

Arquitectura: Evitar el uso de colores fijos en widgets y centralizar los estilos en el sistema de temas. Implementar un botón o switch de cambio de tema en la UI (ej. AppBar o Settings).

GitHub: Crear branch hacia developer feature/(su tarea HU), y realizar un Pull Request (NO HACER MERGE).
