Historia de Usuario – Perfil del Emprendedor y Gestión de Feedback
Como emprendedor autenticado del marketplace

Quiero acceder a mi perfil para gestionar mi información, responder comentarios, monitorear ratings y configurar mi privacidad

Para que pueda mantener mi cuenta actualizada, mejorar mi reputación basada en el feedback de clientes y recibir asistencia rápida.

Criterios de Aceptación (Gherkin)
Escenario: Acceso al Perfil y Cambio de Rol
Dado que accedo al perfil desde la navegación inferior con el rol de emprendedor activo

Cuando se carga la pantalla "Mi Perfil"

Entonces el sistema muestra mi información básica (nombre, email, foto con botón "+" de edición) y un botón Toggle (Cliente/Emprendedor) que permite cambiar de rol y persistir dicho cambio en Firestore.

Escenario: Gestión de Comentarios y Respuestas
Dado que accedo a la sección "Comentarios de mis Servicios/Productos"

Cuando visualizo la lista de mensajes de clientes

Entonces puedo presionar "Responder" para abrir un modal con un campo de texto (máx. 500 caracteres); al enviar, el sistema guarda la respuesta en un sub-thread del comentario y notifica al cliente.

Escenario: Monitoreo de Ratings y Promedios
Dado que accedo a la sección "Rating de mis Servicios/Productos"

Cuando se carga la interfaz

Entonces visualizo un grid con las estrellas promedio por servicio y un promedio global en el header; el sistema utiliza un StreamBuilder para mostrar nuevos ratings en tiempo real con el badge "Nuevo".

Escenario: Configuración de Privacidad y Seguridad
Dado que entro al menú de "Configuraciones" y luego a "Privacidad y Seguridad"

Cuando activo o desactivo los toggles de visibilidad de email o teléfono

Entonces el sistema actualiza inmediatamente mi documento en Firestore y aplica estos cambios en todas las vistas públicas de mis emprendimientos.

Escenario: Edición de Información Personal
Dado que presiono el botón "Editar" en la sección de configuración

Cuando se despliega la pantalla de edición

Entonces puedo modificar mi nombre y teléfono (con validación de 10 dígitos); al presionar "Guardar", el sistema actualiza la base de datos y refresca la vista principal del perfil.

Escenario: Cierre de Sesión y Soporte
Dado que presiono el botón rojo "CERRAR SESIÓN" y confirmo el diálogo

Cuando el proceso finaliza

Entonces el sistema limpia el storage local, cierra la sesión en Firebase Auth y me redirige a la pantalla de Login.

Y si accedo a "Ayuda y Soporte", visualizo accesos directos de contacto vía Email y WhatsApp.

Diseño y Estilo (Figma)
Colores: Naranja (#FFA500) para botones de acción (Responder/Activos), Rojo para el botón de cierre de sesión, y Verde (#008000) para indicadores de seguridad.

Footer: Incluye la versión "TAEK v1.0".

Flujo de Trabajo (Git)
Rama: Crear feature/perfil-gestion-feedback desde la rama develop.

Pull Request: Al finalizar la tarea, realizar un PR hacia develop para revisión (No realizar el merge manualmente).
