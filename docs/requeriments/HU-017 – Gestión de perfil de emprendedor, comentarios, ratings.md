Historia de Usuario – Perfil del Emprendedor y Gestión de Feedback

Como emprendedor autenticado
Quiero acceder a mi perfil para visualizar y editar mi información personal, gestionar los comentarios y ratings recibidos en mis servicios o productos, configurar notificaciones y privacidad, y contactar soporte mediante un chatbot integrado
Para monitorear el feedback de mis clientes, mantener mi cuenta actualizada y recibir asistencia rápida en la gestión de mi emprendimiento.

Criterios de Aceptación (Gherkin)
Escenario: Visualización del perfil del emprendedor

Dado que el emprendedor accede al perfil desde la navegación inferior
Y tiene el rol Emprendedor activo
Cuando la pantalla se carga
Entonces el sistema debe mostrar:

Título “Mi Perfil”

Foto de perfil (placeholder si no existe)

Nombre completo

Correo electrónico

Toggle de rol Cliente / Emprendedor (Emprendedor seleccionado por defecto)

Ícono “+” para editar foto de perfil

Secciones navegables:

Comentarios de mis Servicios/Productos

Rating de mis Servicios/Productos

Configuraciones

Botón “CERRAR SESIÓN” en color rojo

Footer con versión TAEK v1.0

Escenario: Cambio de rol Cliente / Emprendedor

Dado que el emprendedor visualiza el toggle de rol
Cuando cambia entre Cliente y Emprendedor
Entonces el sistema debe:

Persistir el rol seleccionado en Firestore

Ajustar las secciones visibles según el rol

Actualizar la UI indicando el rol activo (color naranja)

Escenario: Cierre de sesión

Dado que el emprendedor presiona CERRAR SESIÓN
Cuando confirma la acción
Entonces el sistema debe:

Cerrar sesión mediante Firebase Auth

Limpiar almacenamiento local

Redirigir a la pantalla de inicio de sesión

Escenario: Actualización de foto de perfil

Dado que el emprendedor presiona el ícono “+” en la foto de perfil
Cuando selecciona o captura una imagen
Entonces el sistema debe:

Abrir el selector de imágenes

Subir la imagen a Firebase Storage

Actualizar la foto de perfil en tiempo real

Escenario: Visualización de comentarios recibidos

Dado que el emprendedor accede a Comentarios de mis Servicios/Productos
Cuando la vista se carga
Entonces el sistema debe mostrar:

Lista de comentarios recibidos

Información del servicio o producto

Nombre del cliente

Texto del comentario

Botón “Responder” en color naranja

Mensaje informativo si no existen comentarios:

“No hay comentarios aún. ¡Anima a tus clientes a opinar!”

Comentarios ordenados por fecha descendente

Escenario: Respuesta a comentarios

Dado que el emprendedor presiona Responder en un comentario
Cuando ingresa su respuesta
Entonces el sistema debe:

Mostrar un modal con campo de texto (máx. 500 caracteres)

Guardar la respuesta en Firestore

Notificar al cliente mediante push notification

Refrescar la lista de comentarios

Escenario: Edición o eliminación de respuestas

Dado que el emprendedor interactúa con una respuesta propia
Cuando selecciona editar o eliminar
Entonces el sistema debe:

Validar la acción

Actualizar el backend

Refrescar la vista con animación

Escenario: Visualización de ratings recibidos

Dado que el emprendedor accede a Rating de mis Servicios/Productos
Cuando la vista se carga
Entonces el sistema debe mostrar:

Grid de servicios o productos calificados

Promedio de estrellas por servicio

Lista de calificaciones individuales

Promedio global visible en el header

Filtro por servicio o producto

Escenario: Recepción de nuevos ratings en tiempo real

Dado que un cliente envía un nuevo rating
Cuando el sistema recibe la actualización
Entonces debe:

Actualizar el promedio de estrellas

Mostrar un badge “Nuevo”

Refrescar la vista en tiempo real

Escenario: Acceso a configuraciones

Dado que el emprendedor accede a Configuraciones
Cuando la pantalla se carga
Entonces el sistema debe mostrar:

Edición de perfil (nombre y teléfono)

Configuración de notificaciones

Selector de idioma

Accesos a Privacidad y Seguridad y Ayuda y Soporte

Escenario: Edición de información del perfil

Dado que el emprendedor presiona Editar perfil
Cuando interactúa
Entonces el sistema debe:

Mostrar una pantalla de edición con datos prellenados

Validar los campos en tiempo real

Permitir Cancelar o Guardar cambios

Actualizar Firestore y refrescar el perfil principal

Escenario: Privacidad y seguridad

Dado que el emprendedor accede a Privacidad y Seguridad
Cuando la vista se carga
Entonces el sistema debe mostrar:

Estado de seguridad de la cuenta

Toggles de visibilidad de email y teléfono

Enlaces a Política de Privacidad y Términos de Uso

Escenario: Actualización de preferencias de privacidad

Dado que el emprendedor modifica una preferencia de visibilidad
Cuando guarda los cambios
Entonces el sistema debe:

Persistir la configuración en Firestore

Aplicar los cambios en vistas públicas del emprendimiento

Escenario: Ayuda y soporte

Dado que el emprendedor accede a Ayuda y Soporte
Cuando la pantalla se carga
Entonces el sistema debe mostrar:

Opciones de contacto por Email

WhatsApp

Chatbot integrado para soporte inmediato

Notas Técnicas
Firebase

Auth: datos del usuario autenticado

Firestore

emprendedores/{userId}

Subcolecciones:

comentarios

ratings

Storage: fotos de perfil

Real-time: listeners para comentarios y ratings

Flutter

Scaffold + SingleChildScrollView

CircleAvatar con ImagePicker

ToggleButtons para rol

ListView.builder para comentarios

showDialog para respuestas

GridView + flutter_rating_bar para ratings

Navigator.push para edición de perfil

Diseño (Figma)

Colores institucionales

Naranja #FFA500 para acciones activas

Verde #008000 para estado protegido

Animaciones con AnimatedSwitcher

Cards con bordes redondeados

Flujo de Trabajo (Git)

Rama: feature/perfil-emprendedor

Pull Request: hacia develop
