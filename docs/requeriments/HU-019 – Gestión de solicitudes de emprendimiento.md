Historia de Usuario

Como emprendedor autenticado,
quiero visualizar la lista de solicitudes recibidas de clientes, acceder al detalle de cada una para ver los servicios o productos solicitados y actualizar su estado (Pendiente, Aceptado, Rechazado),
para gestionar eficientemente las órdenes entrantes,
con edición permitida solo en los estados Pendiente y Aceptado, y bloqueo en Rechazado para evitar cambios retroactivos.

Criterios de Aceptación

Dado que el emprendedor accede a la sección "Ver Solicitudes" desde el perfil o dashboard del emprendimiento
Cuando se carga la pantalla
Entonces debe mostrar el título "Ver Solicitudes" con una lista o grid de solicitudes, mostrando el nombre del servicio o producto, precio total y estado actual (Pendiente, Aceptado o Rechazado); si no existen solicitudes, debe mostrarse el mensaje "No hay solicitudes. ¡Espera clientes!". Las solicitudes deben ordenarse por fecha de creación descendente y permitir filtros por estado.

Dado que el emprendedor selecciona una solicitud
Cuando navega al detalle
Entonces debe mostrarse la pantalla "Detalle de Solicitud" con la información completa del pedido: datos del cliente, lista de servicios o productos solicitados, cantidades, precios unitarios, total calculado y estado actual de la solicitud.

Dado que el emprendedor revisa una solicitud en estado Pendiente
Cuando interactúa con las opciones disponibles
Entonces debe poder cambiar el estado a Aceptado o Rechazado mediante confirmación previa.

Dado que el emprendedor cambia el estado de una solicitud a Aceptado
Cuando confirma la acción
Entonces el sistema debe actualizar el estado a Aceptado, notificar al cliente y reflejar el cambio en la lista principal en tiempo real.

Dado que el emprendedor cambia el estado de una solicitud a Rechazado
Cuando confirma la acción
Entonces el sistema debe actualizar el estado a Rechazado, notificar al cliente y bloquear futuras modificaciones en dicha solicitud.

Dado que una solicitud se encuentra en estado Rechazado
Cuando el emprendedor accede al detalle
Entonces debe mostrarse la información en modo solo lectura, sin permitir cambios en el estado ni en los datos de la solicitud.

Dado que llegan nuevas solicitudes
Cuando el sistema recibe la información
Entonces deben agregarse automáticamente a la lista y mostrarse como Pendientes.

Dado que el emprendedor filtra las solicitudes por estado
Cuando selecciona un filtro
Entonces deben mostrarse únicamente las solicitudes que coincidan con el estado seleccionado.

Dado que no existe conexión a internet
Cuando el emprendedor intenta actualizar el estado de una solicitud
Entonces el sistema debe guardar la acción localmente y sincronizarla cuando se restablezca la conexión.

Dado que ocurre un error al cargar las solicitudes
Cuando el sistema detecta la falla
Entonces debe mostrarse un mensaje de error y permitir reintentar la carga.

Notas Técnicas
Firebase

Firestore: colección emprendedores/{userId}/emprendimientos/{emprId}/solicitudes
Campos: clienteId, servicios, total, estado, razonRechazo, createdAt, updatedAt.

Uso de Firebase Auth para identificación del emprendedor.
Actualización en tiempo real mediante listeners.
Persistencia offline habilitada.

Flutter

Listado de solicitudes mediante GridView.builder o ListView.builder.
Pantalla de detalle con Scaffold y SingleChildScrollView.
Gestión de estados con Provider o Riverpod.
Diálogos de confirmación para cambios de estado.
Sincronización offline y manejo de errores.

Figma

Diseño basado en mockups del proyecto.
Uso de colores institucionales.
Diseño responsivo para listado y detalle de solicitudes.

GitHub

Creación de branch: feature/solicitudes-hu
Pull request hacia develop.
No realizar merge.
