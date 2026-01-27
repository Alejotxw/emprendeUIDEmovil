# Historia de Usuario – Perfil de Usuario y Gestión de Cuenta

**Como** usuario autenticado (cliente o emprendedor)  
**Quiero** acceder a mi perfil para visualizar y editar mi información personal, ver mis reseñas y ratings, consultar pedidos, configurar notificaciones y privacidad, y contactar soporte mediante un chatbot integrado  
**Para** mantener control sobre mi cuenta y recibir asistencia rápida dentro de la aplicación.

---

## Criterios de Aceptación (Gherkin)

### Escenario: Visualización y Cambio de Rol
**Dado** que el usuario accede a la sección Perfil  
**Cuando** la pantalla se carga  
**Entonces** el sistema debe mostrar el título “Mi Perfil”, foto, nombre, correo y un **Toggle de Rol** (Cliente/Emprendedor).  
**Y** al cambiar el rol, el sistema debe persistir el cambio en Firestore, ajustar las secciones visibles y actualizar el color del toggle a naranja activo.

### Escenario: Cierre de Sesión
**Dado** que el usuario presiona "Cerrar sesión"  
**Cuando** confirma la acción  
**Entonces** el sistema debe cerrar la sesión en Firebase Auth, limpiar el almacenamiento local y redirigirlo al login.

### Escenario: Gestión de Reseñas y Ratings
**Dado** que el usuario accede a "Mis Reseñas" o "Rating de Servicios"  
**Cuando** visualiza o interactúa con estos elementos  
**Entonces** el sistema debe permitir editar/eliminar reseñas existentes y calificar nuevos servicios (1-5 estrellas).  
**Y** al guardar, debe actualizar Firestore y mostrar el mensaje: “¡Rating guardado!”.

### Escenario: Monitoreo de Pedidos en Tiempo Real
**Dado** que el usuario accede a "Mis Pedidos"  
**Cuando** se carga la lista cronológica  
**Entonces** el sistema debe mostrar cada pedido con un badge de estado:
* **Pendiente:** Gris.
* **Aceptado:** Verde.
* **Rechazado:** Rojo.  
**Y** el estado debe actualizarse automáticamente mediante un `StreamBuilder` ante cualquier cambio en la base de datos.

### Escenario: Configuraciones y Edición de Perfil
**Dado** que el usuario entra a "Configuraciones"  
**Cuando** edita su información personal (nombre/teléfono) o ajusta la privacidad  
**Entonces** el sistema debe validar los campos (ej. 10 dígitos para teléfono), actualizar Firestore y aplicar los cambios en las vistas públicas de inmediato.

### Escenario: Ayuda y Soporte
**Dado** que el usuario accede a "Ayuda y Soporte"  
**Cuando** selecciona una opción de contacto  
**Entonces** el sistema debe ofrecer enlaces directos a Email, WhatsApp y acceso a un **Chatbot integrado** para asistencia inmediata.

---

## Notas Técnicas

### Firebase (Firestore & Auth)
* **Auth:** Manejo de `displayName`, `email` y `photoURL`.
* **Firestore Document (`usuarios/{userId}`):** Campos para `rol`, `telefono`, `notificaciones`, `idioma`, `privacidad` y `createdAt`.
* **Subcolecciones:** `reseñas`, `ratings` y `pedidos`.

### Flutter Implementation
* **UI Components:** `CircleAvatar` con `image_picker` para la foto, `ToggleButtons` para el rol y `flutter_rating_bar` para las estrellas.
* **Flujos:** `showModalBottomSheet` para ediciones rápidas y `StreamBuilder` para la reactividad de los pedidos.

### Diseño (Figma)
* **Colores:** Naranja (#FFA500) para acciones activas, Verde (#00FF00) para confirmaciones y Rojo para cierre de sesión.
* **UX:** Cards con sombras para profundidad y diseño completamente responsive.

---

## Flujo de Trabajo (Git)
* **Rama:** `feature/perfil-usuario` (desde `develop`).
* **Pull Request:** Hacia la rama `develop` para revisión de código.
