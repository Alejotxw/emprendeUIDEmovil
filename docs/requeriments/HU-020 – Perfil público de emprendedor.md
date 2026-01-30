# Historia de Usuario – Perfil Público del Emprendedor

**Como** usuario cliente,  
**quiero** visualizar el detalle de un emprendedor al seleccionarlo desde el dashboard, listados, destacados o una solicitud,  
**para** revisar eficientemente su información básica, servicios y calificaciones, y decidir su contratación de manera informada.

---

## 📋 Criterios de Aceptación (Gherkin)

### Escenario: Visualización de Perfil Público del Emprendedor

* **Dado** que un usuario cliente selecciona un emprendedor desde el dashboard o favoritos.
* **Cuando** se carga el perfil.
* **Entonces** el sistema debe mostrar:
    * **Perfil del Emprendedor:** Nombre, foto (o avatar genérico).
    * **Email:** Si `emailVisible` es falso, mostrar mensaje: *"Dato no visible"*.
    * **Secciones Navegables:** Ratings de Servicios y Catálogo de Productos.

* **Escenario: Sin servicios o valoraciones**
    * **Si** no existen productos: Mostrar *"No hay servicios disponibles"*.
    * **Si** no existen valoraciones: Mostrar *"Aún no hay valoraciones"*.

---

## 🛠️ Especificaciones Técnicas

### 🏗️ Firebase & Backend
* **Autenticación:** Uso de Firebase Auth para validación de sesión.
* **Firestore:** * Colección: `emprendedores/{emprId}`
    * Campos: `nombre`, `email`, `fotoUrl`, `emailVisible`.
    * Subcolecciones: `servicios` (nombre, descripción, precio, fotoUrl) y `ratings` (estrellas, comentario, fecha).
* **Persistencia:** Modo offline habilitado para consulta en caché.

### 📱 Flutter (Frontend)
* **Interfaz:** Implementación con `Scaffold` y `SingleChildScrollView`.
* **Widgets:** * `CircleAvatar` para fotos de perfil.
    * `ListView.builder` para la lista de servicios y ratings.
* **Estado:** Gestión de datos en tiempo real mediante *Streams* o *Listeners*.

---

## 🚀 Control de Versiones (GitHub)

* **Rama:** `feature/perfil-publico-auth`
* **Pull Request:** Crear PR hacia la rama `develop`.
* **Merge:** No realizar merge manual; esperar revisión de equipo.
