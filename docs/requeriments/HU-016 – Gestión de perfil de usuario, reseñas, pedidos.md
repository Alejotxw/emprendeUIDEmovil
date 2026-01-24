Historia de Usuario – Perfil de Usuario y Gestión de Cuenta

Como usuario autenticado (cliente o emprendedor)
Quiero acceder a mi perfil para visualizar y editar mi información personal, ver mis reseñas y ratings, consultar pedidos, configurar notificaciones y privacidad, y contactar soporte mediante un chatbot integrado
Para mantener control sobre mi cuenta y recibir asistencia rápida dentro de la aplicación.

Criterios de Aceptación (Gherkin)
Escenario: Visualización del perfil

Dado que el usuario accede a la sección Perfil desde la navegación inferior
Cuando la pantalla se carga
Entonces el sistema debe mostrar:

Título “Mi Perfil”

Foto de perfil (placeholder si no existe)

Nombre completo (ej.: Sebastián Chochó)

Correo electrónico (ej.: sechocosi@uide.edu.ec
)

Toggle de rol:

Cliente (seleccionado por defecto)

Emprendedor

Secciones navegables:

Mis Reseñas

Rating de Servicios

Mis Pedidos

Configuraciones

Botón “Cerrar sesión” en color rojo

Footer con versión de la app (TAEK v1.0)

Escenario: Cambio de rol (Cliente / Emprendedor)

Dado que el usuario visualiza su perfil
Cuando cambia entre Cliente y Emprendedor
Entonces el sistema debe:

Actualizar el rol temporal del usuario

Persistir el rol en Firestore

Ajustar las secciones visibles según el rol

Actualizar el estado visual del toggle (color naranja activo)

Escenario: Cierre de sesión

Dado que el usuario presiona Cerrar sesión
Cuando confirma la acción
Entonces el sistema debe:

Cerrar sesión mediante Firebase Auth

Limpiar almacenamiento local

Redirigir a la pantalla de login

Escenario: Visualización de “Mis Reseñas”

Dado que el usuario accede a Mis Reseñas
Cuando la vista se carga
Entonces el sistema debe mostrar una lista de reseñas con:

Nombre del servicio o producto

Emprendimiento asociado

Monto de referencia

Texto editable

Íconos para editar/publicar, eliminar y like

Si no existen reseñas, mostrar:

“No tienes reseñas”.

Escenario: Edición o eliminación de reseñas

Dado que el usuario interactúa con una reseña
Cuando selecciona editar o eliminar
Entonces el sistema debe:

Mostrar un modal de edición o confirmación

Actualizar los datos en Firestore

Refrescar la lista de reseñas

Escenario: Visualización y registro de ratings

Dado que el usuario accede a Rating de Servicios
Cuando la vista se carga
Entonces el sistema debe mostrar un grid con:

Servicios o productos adquiridos

Estrellas calificables (1 a 5)

Comentario opcional

Promedio de rating visible

Escenario: Envío de rating

Dado que el usuario califica un servicio
Cuando envía el rating
Entonces el sistema debe:

Guardar el rating en Firestore

Actualizar el promedio

Mostrar mensaje:

“¡Rating guardado!”

Escenario: Visualización de pedidos

Dado que el usuario accede a Mis Pedidos
Cuando la pantalla se carga
Entonces el sistema debe mostrar:

Lista cronológica de pedidos

Nombre del servicio o producto

Cantidad total

Estado del pedido con badge de color:

Pendiente (gris)

Aceptado (verde)

Rechazado (rojo)

Botón para ver detalles

Filtro por estado si existen más de 5 pedidos

Escenario: Actualización de estado de pedidos en tiempo real

Dado que el estado de un pedido cambia
Cuando se recibe la actualización
Entonces el sistema debe reflejar el cambio automáticamente en la lista mediante actualizaciones en tiempo real.

Escenario: Acceso a configuraciones

Dado que el usuario selecciona Configuraciones
Cuando la vista se carga
Entonces el sistema debe mostrar:

Edición de perfil (nombre y teléfono)

Toggles de notificaciones

Selector de idioma (Español / English)

Enlaces a Privacidad y Seguridad y Ayuda y Soporte

Escenario: Edición de información personal

Dado que el usuario presiona Editar perfil
Cuando interactúa
Entonces el sistema debe mostrar una vista modal o pantalla completa con:

Campos prellenados

Validaciones (ej.: teléfono de 10 dígitos)

Botones Cancelar y Guardar cambios

Al guardar, actualizar Firestore y cerrar la vista

Escenario: Privacidad y seguridad

Dado que el usuario accede a Privacidad y Seguridad
Cuando la pantalla se carga
Entonces el sistema debe mostrar:

Estado de seguridad de la cuenta

Opciones de visibilidad de email y teléfono

Enlaces a Política de Privacidad y Términos de Uso

Escenario: Gestión de privacidad

Dado que el usuario modifica opciones de privacidad
Cuando guarda los cambios
Entonces el sistema debe:

Actualizar preferencias en Firestore

Aplicar cambios en los perfiles públicos

Escenario: Ayuda y soporte

Dado que el usuario accede a Ayuda y Soporte
Cuando la vista se carga
Entonces el sistema debe mostrar opciones de contacto:

Email

WhatsApp

Chatbot integrado para soporte inmediato

Notas Técnicas
Firebase

Auth: displayName, email, photoURL

Firestore

Documento usuarios/{userId}:

rol

telefono

notificaciones

idioma

privacidad

createdAt

Subcolecciones:

reseñas

ratings

pedidos

Flutter

Scaffold + ListView

CircleAvatar (imagen con image_picker)

ToggleButtons para rol

showModalBottomSheet / Navigator.push para edición

flutter_rating_bar para estrellas

StreamBuilder para pedidos en tiempo real

Diseño (Figma)

Colores institucionales

Naranja #FFA500 para acciones activas

Verde #00FF00 para estados confirmados

Cards con sombras

Diseño responsive

Flujo de Trabajo (Git)

Rama: feature/perfil-usuario

Pull Request: hacia develop
