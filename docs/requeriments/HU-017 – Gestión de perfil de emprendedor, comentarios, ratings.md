# Historia de Usuario – Perfil del Emprendedor y Gestión de Feedback

**Como** emprendedor autenticado  
**Quiero** acceder a mi perfil para visualizar y editar mi información personal, gestionar los comentarios y ratings recibidos en mis servicios o productos, configurar notificaciones y privacidad, y contactar soporte mediante un chatbot integrado  
**Para** monitorear el feedback de mis clientes, mantener mi cuenta actualizada y recibir asistencia rápida en la gestión de mi emprendimiento.

---

## Criterios de Aceptación (Gherkin)

### Escenario: Visualización del perfil del emprendedor
**Dado** que el emprendedor accede al perfil desde la navegación inferior con el rol Emprendedor activo  
**Cuando** la pantalla se carga  
**Entonces** el sistema debe mostrar:
* Título “Mi Perfil”, foto con ícono “+” para edición, nombre y correo.
* **Toggle de rol:** Cliente / Emprendedor (Emprendedor seleccionado por defecto).
* **Secciones:** Comentarios de mis Servicios/Productos, Rating de mis Servicios/Productos y Configuraciones.
* Botón “CERRAR SESIÓN” en rojo y versión TAEK v1.0.

### Escenario: Cambio de rol y Cierre de sesión
**Dado** que el usuario interactúa con los controles de cuenta  
**Cuando** cambia el rol o decide cerrar sesión  
**Entonces** el sistema debe persistir el rol en Firestore ajustando la UI, o limpiar el almacenamiento local y redirigir al login tras cerrar sesión en Firebase Auth.

### Escenario: Gestión de Comentarios y Respuestas
**Dado** que el emprendedor accede a la sección de comentarios  
**Cuando** visualiza la lista o presiona "Responder"  
**Entonces** el sistema debe mostrar los mensajes ordenados por fecha y permitir abrir un modal (máx. 500 caracteres) para enviar una respuesta.  
**Y** al responder, se debe guardar en Firestore, notificar al cliente vía push y refrescar la lista.

### Escenario: Monitoreo de Ratings en Tiempo Real
**Dado** que se accede a la sección de Ratings  
**Cuando** un cliente envía una nueva calificación  
**Entonces** el sistema debe actualizar el promedio de estrellas en el header y mostrar un badge de “Nuevo” en la lista mediante listeners de tiempo real.

### Escenario: Configuraciones y Edición de Perfil
**Dado** que el emprendedor gestiona su configuración personal  
**Cuando** edita su nombre/teléfono o actualiza la foto de perfil  
**Entonces** el sistema debe validar los campos, subir archivos a Firebase Storage y refrescar el perfil principal inmediatamente.

### Escenario: Privacidad y Soporte
**Dado** que el emprendedor accede a Privacidad o Ayuda  
**Cuando** modifica visibilidad de datos o requiere asistencia  
**Entonces** el sistema debe actualizar las preferencias en Firestore y ofrecer canales de contacto (Email, WhatsApp) junto a un **Chatbot integrado**.

---

## Notas Técnicas

### Firebase (Backend)
* **Auth:** Gestión de sesión activa.
* **Firestore:** Documento `emprendedores/{userId}` con subcolecciones de `comentarios` y `ratings`.
* **Storage:** Almacenamiento de fotos de perfil.
* **Real-time:** Implementación de listeners para actualizaciones instantáneas.

### Flutter Implementation
* **UI:** `Scaffold` con `SingleChildScrollView`, `CircleAvatar` con `ImagePicker`.
* **Listado:** `ListView.builder` para comentarios y `GridView` con `flutter_rating_bar` para las calificaciones.
* **Navegación:** `Navigator.push` para edición y `showDialog` para interacción con feedbacks.

### Diseño (Figma)
* **Colores:** Naranja (#FFA500) para acciones activas, Verde (#008000) para estados de seguridad.
* **UX:** `AnimatedSwitcher` para cambios de estado y cards con bordes redondeados.

---

## Flujo de Trabajo (Git)
* **Rama:** `feature/perfil-emprendedor` (desde `develop`).
* **Pull Request:** Hacia la rama `develop` para revisión de código.
