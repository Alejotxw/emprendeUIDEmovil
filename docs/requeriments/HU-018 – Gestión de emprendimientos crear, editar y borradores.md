Historia de Usuario

Como emprendedor autenticado,
quiero listar, crear, editar y guardar como borrador mis emprendimientos, con selección de ubicación vía mapa interactivo y selector de horarios por día,
para configurar y publicar mis servicios/productos de manera flexible,
con autosave en borradores al retroceder, cerrar la app o presionar botón manual.

Criterios de Aceptación

Dado que el emprendedor accede a la sección "Emprendimientos" desde el perfil (rol "Emprendedor" activo)
Cuando se carga la pantalla
Entonces debe mostrar "Emprendimientos" con botón "Crear", lista de cards existentes y borradores (por ejemplo: "Kevin Girón" en "Diseño" con "Diseño web y Posters", badges de estado: activo, editar, borrador), cada card con imagen placeholder y botón "Editar Emprendimiento" o "Borrador"; si la lista está vacía, debe mostrar el mensaje "No tienes emprendimientos. ¡Crea uno!" con acceso al botón Crear.

Dado que el emprendedor presiona "Crear" o "Editar Emprendimiento" en una card
Cuando se carga el formulario
Entonces debe mostrar la pantalla "Crear/Editar Emprendimiento" con los campos: Información Básica (nombre en TextField prellenado en edición, categoría mediante RadioButtons: Comida, Tecnología, Diseño, Artesanías), Descripción (TextField multiline), Ubicación (mapa interactivo con marcador draggable y botón para confirmar posición), Horario (tabla editable por día con selectores de hora de inicio y fin), Servicios/Productos (lista dinámica con opción de agregar y eliminar servicios); además, debe mostrar los botones "Guardar Borrador" y "Crear/Actualizar Emprendimiento".

Dado que el emprendedor selecciona la ubicación en el mapa
Cuando interactúa con el mapa
Entonces debe actualizarse la ubicación en tiempo real, validar la disponibilidad de GPS y mostrar la dirección legible en un campo editable; si la ubicación no está confirmada, el botón de creación debe permanecer deshabilitado.

Dado que el emprendedor edita el horario de un día
Cuando selecciona un día específico
Entonces debe abrir un selector de horario con validación (hora de fin mayor a la hora de inicio), opción de marcar el día como cerrado, actualización visual de la tabla y persistencia del horario como un mapa por día.

Dado que el emprendedor agrega o elimina un servicio o producto
Cuando interactúa con las opciones de agregar o eliminar
Entonces debe abrir un formulario modal para ingresar nombre, descripción y precio, validar los campos obligatorios, actualizar la lista numerada de servicios y limitar la cantidad máxima permitida.

Dado que el emprendedor presiona "Guardar Borrador"
Cuando confirma la acción
Entonces debe validar los campos obligatorios, guardar el emprendimiento con estado "borrador", mostrar un mensaje de confirmación y regresar al listado con el badge correspondiente.

Dado que el emprendedor intenta salir del formulario con cambios no guardados
Cuando presiona el botón de retroceso o cierra la aplicación
Entonces debe mostrarse un diálogo para guardar los cambios como borrador, descartarlos o cancelar la acción; si selecciona guardar, el sistema debe almacenar automáticamente el emprendimiento como borrador.

Dado que el emprendedor presiona "Crear/Actualizar Emprendimiento"
Cuando todos los campos obligatorios están validados
Entonces debe crearse o actualizarse el emprendimiento con estado "activo", mostrar un mensaje de confirmación y navegar al listado o detalle correspondiente.

Dado que no existe conexión a internet
Cuando el emprendedor guarda o crea un emprendimiento
Entonces el sistema debe almacenar la información localmente y sincronizarla cuando exista conexión.

Dado que el emprendedor elimina un emprendimiento
Cuando confirma la acción
Entonces debe eliminarse el registro y actualizarse la lista de emprendimientos.

Notas Técnicas

Firebase

Firestore: colección emprendedores/{userId}/emprendimientos con campos: nombre, categoría, descripción, ubicación (GeoPoint), horario, servicios, estado, fechas de creación y actualización.
Subcolección para borradores.
Uso de Firebase Auth para autenticación y Firebase Storage para imágenes.
Persistencia offline habilitada.

Flutter

Listado con ListView.builder.
Formulario con validaciones.
Integración de Google Maps y Geolocator para ubicación.
Uso de TimePicker para horarios.
Gestión de estado con Provider.
Autosave mediante WillPopScope y SharedPreferences.

Figma

Diseño basado en mockups.
Uso de colores institucionales.
Estructura de cards y jerarquía visual.

GitHub

Creación de branch feature/emprendimientos-hu.
Pull request hacia develop.
No realizar merge.
