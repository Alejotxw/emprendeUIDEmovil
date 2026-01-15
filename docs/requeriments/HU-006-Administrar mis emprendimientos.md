Historia de Usuario – Perfil Público del Emprendedor
Como usuario cliente del marketplace universitario

Quiero visualizar el perfil público de un emprendedor al seleccionarlo desde el dashboard o una solicitud

Para que pueda revisar su información, cantidad de servicios, calificaciones y decidir mi compra de manera informada.

Criterios de Aceptación (Gherkin)
Escenario: Visualización inicial del perfil
Dado que selecciono un emprendedor desde el dashboard, TOP destacados o favoritos

Cuando se carga la pantalla de perfil

Entonces el sistema muestra la pantalla "Perfil de [Nombre]" con:

Botón de retroceso (Back button).

Foto circular (100x100 dp) con placeholder rojo si no existe.

Nombre completo y email (si es público).

Counters en badges para "Servicios" y "Emprendimientos".

Secciones navegables hacia "Servicios/Productos" y "Rating".

Footer con la versión "EmprendeUIDE v1.0".

Escenario: Privacidad de datos sensibles
Dado que el emprendedor tiene su email configurado como privado o no tiene foto

Cuando el cliente carga el perfil

Entonces el sistema debe mostrar un ícono genérico en el avatar y omitir el email mostrando el mensaje "Email no visible".

Escenario: Navegación a catálogo de servicios
Dado que presiono la sección "Sus servicios/productos"

Cuando accedo a la sub-pantalla

Entonces visualizo un grid/lista con fotos, precios y descripciones; si hay más de 5 ítems se habilita un filtro por categoría y cada ítem incluye el botón "Agregar al Carrito".

Escenario: Consulta de Ratings y Reseñas
Dado que accedo a la sección "Rating de Servicios"

Cuando se carga la lista de calificaciones

Entonces el sistema muestra el promedio global en el header y una lista de comentarios ordenados por fecha; si no hay datos, muestra el mensaje: "Aún no hay ratings. ¡Sé el primero!".

Escenario: Actualización en tiempo real y offline
Dado que un emprendedor agrega un nuevo servicio mientras veo su perfil

Cuando el sistema detecta el cambio en la base de datos

Entonces los badges de conteo se actualizan automáticamente vía StreamBuilder sin recargar la página.

Y si no tengo conexión, el sistema carga la última versión guardada en caché local.

Flujo de Trabajo (Git)
Rama: Crear feature/perfil-publico-emprendedor desde la rama developer.

Pull Request: Al finalizar, abrir un PR hacia developer para revisión de código (Sin hacer merge directo).
