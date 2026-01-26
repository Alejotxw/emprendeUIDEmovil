# Historia de Usuario – Perfil de Usuario y Gestión de Cuenta

**Como** usuario autenticado (cliente o emprendedor) del marketplace  
**Quiero** acceder a mi perfil para gestionar mi información personal, reseñas, pedidos y configuraciones  
**Para que** pueda mantener el control total sobre mi cuenta y recibir asistencia rápida dentro de la aplicación.

---

## Criterios de Aceptación (Gherkin)

### Escenario: Acceso y visualización del perfil
**Dado** que accedo al perfil desde la navegación inferior  
**Cuando** se carga la pantalla "Mi Perfil"  
**Entonces** el sistema muestra:
* Foto de perfil circular (con placeholder si no hay una cargada).
* Nombre completo y correo institucional.
* **Toggle de Rol:** Botones para alternar entre "Cliente" (default) y "Emprendedor".
* **Secciones navegables:** "Mis Reseñas", "Rating de Servicios", "Mis Pedidos" y "Configuraciones".
* Botón rojo de "Cerrar sesión" y versión de la app "TAEK v1.0" en el footer.

### Escenario: Cambio de Rol (Toggle)
**Dado** que interactúo con el toggle de roles  
**Cuando** selecciono una opción diferente a la actual  
**Entonces** el sistema persiste el cambio en Firestore, actualiza el botón activo a color naranja y ajusta las secciones visibles (ej: el emprendedor visualiza su dashboard de gestión).

### Escenario: Gestión de Reseñas (CRUD)
**Dado** que accedo a la sección "Mis Reseñas"  
**Cuando** visualizo la lista de mis comentarios realizados  
**Entonces** puedo editar el texto (check), eliminarlo (ícono basura) o marcar "like"; si no existen datos, el sistema muestra el mensaje: "No tienes reseñas".

### Escenario: Calificación de Servicios (Ratings)
**Dado** que accedo a la sección "Rating de Servicios"  
**Cuando** selecciono un producto o servicio para calificar  
**Entonces** puedo asignar de 1 a 5 estrellas mediante un gesto táctil; al enviar, el sistema actualiza el promedio en Firestore y muestra un toast: "¡Rating guardado!".

### Escenario: Monitoreo de Pedidos en Tiempo Real
**Dado** que entro a la sección "Mis Pedidos"  
**Cuando** se despliega la lista cronológica  
**Entonces** cada pedido muestra su estado con colores específicos: Pendiente (gris), Aceptado (verde) o Rechazado (rojo); el estado se actualiza automáticamente vía StreamBuilder ante cualquier cambio.

### Escenario: Edición de Perfil y Privacidad
**Dado** que presiono "Editar" dentro de Configuraciones  
**Cuando** se abre el modal o pantalla full-screen  
**Entonces** puedo modificar mi nombre y teléfono (con máscara de 10 dígitos y validación); al guardar, el sistema actualiza Firestore y cierra la interfaz.  
**Y** si accedo a "Privacidad", puedo alternar la visibilidad de mi email/teléfono para el perfil público.

### Escenario: Cierre de Sesión y Soporte
**Dado** que presiono "Cerrar sesión" y confirmo la acción  
**Cuando** el proceso finaliza  
**Entonces** el sistema cierra la sesión en Firebase Auth, limpia el almacenamiento local y me redirige al Login.  
**Y** en "Ayuda y Soporte", puedo iniciar contacto directo vía Email o WhatsApp.

---

## Diseño y Estilo (Figma)
* **Colores:** Naranja (#FFA500) para estados activos, Verde (#00FF00) para confirmaciones, Rojo para acciones críticas (Cerrar sesión/Rechazado).
* **Interacciones:** Animaciones suaves en los toggles y sombras sutiles en las tarjetas de pedidos.

---

## Flujo de Trabajo (Git)
* **Rama:** Crear `feature/perfil-usuario-gestion` desde la rama `developer`.
* **Pull Request:** Al terminar, abrir un PR hacia `developer` para revisión de pares (No realizar merge directo).
