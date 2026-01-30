# Historia de Usuario: Implementación de Modo Claro y Oscuro

**Como** usuario de la aplicación,  
**quiero** que la interfaz se adapte automáticamente al modo claro u oscuro y pueda cambiarlo manualmente,  
**para** tener una experiencia visual cómoda y consistente en cualquier condición de luz.

---

## ✅ Criterios de Aceptación (Gherkin)

### Escenario: Adaptación automática al sistema
* **Dado** que el usuario tiene configurado un modo (claro/oscuro) en su dispositivo.
* **Cuando** abre la aplicación por primera vez.
* **Entonces** la interfaz debe adaptarse automáticamente utilizando `theme` y `darkTheme`.

### Escenario: Cambio manual de tema
* **Dado** que el usuario presiona el botón de cambio de tema.
* **Cuando** selecciona el modo opuesto (Claro ↔ Oscuro).
* **Entonces** toda la interfaz (fondos, textos, botones) debe actualizarse inmediatamente garantizando legibilidad.

### Escenario: Uso de colores semánticos
* **Dado** que existen widgets con estilos personalizados.
* **Cuando** se renderizan en cualquier modo.
* **Entonces** no deben usarse colores fijos (ej. `Colors.blue`), sino únicamente los definidos en `Theme.of(context).colorScheme`.

### Escenario: Persistencia de preferencia
* **Dado** que el usuario selecciona un modo específico.
* **Cuando** la aplicación se reinicia o se abre nuevamente.
* **Entonces** el sistema debe recordar el último modo seleccionado, independientemente del modo del sistema.

---

## 🛠️ Notas Técnicas

### 🎨 UI & Tematización (Flutter)
* **Configuración:** Definir `ThemeData` y `DarkThemeData` en el widget `MaterialApp`.
* **Sistema de Colores:** Utilizar `colorScheme` para manejar variables como `primary`, `surface`, `onSurface`, etc.
* **Gestión de Estado:** Implementar `ThemeProvider` mediante **Provider**, **Riverpod** o **Bloc** para la propagación del estado.

### 💾 Persistencia y Arquitectura
* **Almacenamiento:** Usar `shared_preferences` o `Hive` para guardar la elección del usuario de forma local.
* **Desacoplamiento:** Centralizar los estilos en una clase de temas y evitar el "hardcoding" de colores en los widgets individuales.
* **Componentes:** Agregar un `Switch` o `IconButton` de alternancia en la `AppBar` o pantalla de Configuración.

---

## 🚀 Control de Versiones (GitHub)

* **Rama:** `feature/tema-claro-oscuro-hu`
* **Pull Request:** Realizar el PR hacia la rama `develop`.
* **Regla de Oro:** **NO HACER MERGE**; esperar la aprobación del Code Review.
