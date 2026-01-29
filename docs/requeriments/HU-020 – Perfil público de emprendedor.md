Historia de Usuario

Como usuario cliente,
quiero visualizar el perfil público de un emprendedor al seleccionarlo desde el dashboard o una solicitud,
para revisar su información básica, el conteo de servicios y emprendimientos, y navegar a sus servicios, productos y ratings,
con el fin de evaluar y decidir contratar de manera informada.

Criterios de Aceptación

Dado que un usuario cliente selecciona un emprendedor desde el dashboard, destacados, favoritos o una solicitud
Cuando se carga el perfil público
Entonces debe mostrarse la pantalla "Perfil del Emprendedor" con la información básica: foto de perfil, nombre completo, email visible si es público, y contadores de servicios y emprendimientos; además, deben mostrarse las secciones navegables "Servicios o Productos" y "Ratings de Servicios".

Dado que el perfil del emprendedor no tiene foto o el email es privado
Cuando se carga la información
Entonces debe mostrarse una imagen genérica como foto de perfil y ocultar el email, mostrando un mensaje indicando que el dato no es visible.

Dado que el usuario accede a la sección "Servicios o Productos"
Cuando navega desde el perfil del emprendedor
Entonces debe mostrarse una lista o grid de servicios o productos con nombre, descripción, precio y opción para agregar al carrito; si no existen servicios, debe mostrarse el mensaje "No hay servicios disponibles".

Dado que el usuario accede a la sección "Ratings de Servicios"
Cuando navega desde el perfil del emprendedor
Entonces debe mostrarse la lista de valoraciones realizadas por otros clientes, con promedio de estrellas visible; si no existen ratings, debe mostrarse el mensaje "Aún no hay valoraciones".

Dado que el emprendedor agrega o elimina servicios o emprendimientos
Cuando el sistema actualiza la información
Entonces los contadores de servicios y emprendimientos deben actualizarse en tiempo real sin necesidad de recargar la pantalla.

Dado que el usuario intenta visualizar el perfil sin conexión a internet
Cuando se carga la pantalla
Entonces el sistema debe mostrar la última información almacenada en caché y un mensaje indicando que se está visualizando el perfil en modo offline.

Dado que el emprendedor tiene configuraciones de privacidad activas
Cuando el usuario cliente visualiza el perfil
Entonces el sistema debe respetar dichas configuraciones y ocultar los datos sensibles configurados como privados.

Notas Técnicas
Firebase

Firestore: colección emprendedores/{emprId}
Campos: nombre, emailVisible, fotoUrl, contadores de servicios y emprendimientos, createdAt.

Subcolecciones:

servicios: nombre, descripción, precio, fotoUrl

ratings: clienteId, estrellas, comentario, fecha

Uso de Firebase Auth para identificar al usuario cliente.
Actualización en tiempo real mediante listeners.
Persistencia offline habilitada.

Flutter

Pantalla principal implementada con Scaffold y SingleChildScrollView.
Foto de perfil con CircleAvatar y placeholder en caso de error.
Secciones navegables mediante Navigator.push.
Listado de servicios con GridView.builder o ListView.builder.
Listado de ratings con ListView.builder.
Gestión de estado con Provider o Riverpod.

Figma

Diseño basado en mockups del proyecto.
Uso de colores institucionales.
Diseño responsivo para perfil, servicios y ratings.

GitHub

Creación de branch: feature/perfil-publico-emprendedor-hu
Pull request hacia develop.
No realizar merge.
