Historia de Usuario – Dashboard Principal de Exploración y Compra

Como usuario autenticado
Quiero visualizar el dashboard principal con categorías, emprendimientos destacados y todos los disponibles, acceder a mis favoritos y entrar al detalle de cualquier emprendimiento o servicio/producto
Para descubrir, organizar y comprar servicios o emprendimientos de manera intuitiva y eficiente.

Criterios de Aceptación (Gherkin)
Escenario: Visualización inicial del dashboard

Dado que el usuario inicia sesión correctamente
Cuando accede al dashboard principal
Entonces el sistema debe mostrar:

Un saludo personalizado (ej.: “Hola, [Nombre], ¿qué necesitas hoy?”)

Barra de búsqueda

Íconos de categorías (Comida, Tecnología, Diseño, Artesanías)

Sección “TOP Destacadas” con tarjetas de emprendimientos

Sección “Todos los Emprendimientos” en formato grid

Barra de navegación inferior con opciones: Home, Favoritos, Carrito y Perfil

Escenario: Filtrado por categoría

Dado que el usuario se encuentra en el dashboard
Cuando selecciona una categoría específica (ej.: Comida)
Entonces el sistema debe filtrar y mostrar únicamente los emprendimientos de esa categoría
Y aplicar el filtro tanto en TOP Destacadas como en Todos los Emprendimientos
Y mantener el scroll infinito si aplica.

Escenario: Búsqueda de emprendimientos o servicios

Dado que el usuario utiliza la barra de búsqueda
Cuando ingresa una consulta (ej.: “Diseño web”)
Entonces el sistema debe mostrar resultados relevantes en formato listado o grid
Y permitir limpiar la búsqueda para volver al estado inicial.

Escenario: Gestión de favoritos desde el dashboard

Dado que el usuario visualiza una tarjeta de emprendimiento
Cuando presiona el ícono de corazón
Entonces el sistema debe agregar o quitar el emprendimiento de favoritos
Y actualizar el ícono visualmente (corazón lleno o vacío)
Y sincronizar el estado con la lista de favoritos del usuario.

Escenario: Visualización de la sección “Mis Favoritos”

Dado que el usuario accede a la pestaña Favoritos desde la navegación inferior
Cuando se carga la vista
Entonces el sistema debe mostrar un grid de emprendimientos marcados como favoritos
Y permitir removerlos presionando el ícono de corazón
Y si no existen favoritos, mostrar el mensaje:

“No tienes favoritos aún”.

Escenario: Acceso al detalle de un emprendimiento o servicio

Dado que el usuario selecciona una tarjeta desde cualquier sección (Dashboard, TOP, Todos o Favoritos)
Cuando accede al detalle
Entonces el sistema debe mostrar una vista consistente que incluya:

Imagen principal del emprendimiento

Título y nombre del emprendedor

Categoría

Descripción del servicio o producto

Información adicional (horario y ubicación con mapa integrado)

Sección “Servicios Disponibles” con:

Nombre del servicio

Precio

Botones + / - para cantidad

Subtotal calculado en tiempo real

Botón “Agregar al Carrito”

Escenario: Manejo de datos incompletos

Dado que un emprendimiento no tiene imagen o información completa
Cuando se carga la vista de detalle
Entonces el sistema debe mostrar un placeholder visual
Y textos como “Información no disponible” en secciones vacías.

Escenario: Ajuste de cantidades y validación

Dado que el usuario interactúa con los botones + / -
Cuando modifica la cantidad de un servicio
Entonces el sistema debe recalcular el subtotal en tiempo real
Y validar límites de stock si aplica.

Escenario: Agregar productos o servicios al carrito

Dado que el usuario selecciona servicios en el detalle
Cuando presiona “Agregar al Carrito”
Entonces el sistema debe:

Agregar los ítems al carrito global

Mostrar un mensaje de confirmación (toast/snackbar)

Ofrecer opción para navegar al carrito

Escenario: Navegación de retorno

Dado que el usuario se encuentra en el detalle de un emprendimiento
Cuando presiona el botón Regresar
Entonces debe volver a la vista anterior
Y mantener el estado previo (ej.: posición del scroll).

Escenario: Manejo de errores y carga

Dado que ocurre un error de red o carga de datos
Cuando la pantalla intenta renderizar
Entonces el sistema debe mostrar un loader inicial
Y un mensaje de error con opción Reintentar.

Notas Técnicas
Firebase

Firestore

Colección emprendimientos con campos:

nombre

emprendedor

categoria

descripcion

horario

ubicacion (GeoPoint)

servicios (array de maps: { nombre, precio, stock })

fotoUrl

rating

favoritos (array de userIds)

Subcolección usuarios/{userId}/favoritos

Auth

Usar displayName para saludo personalizado

Flutter

Scaffold con BottomNavigationBar

IndexedStack o TabBarView para Home / Favoritos / Carrito / Perfil

GridView.builder para cards responsivas

SearchDelegate para búsquedas

StreamBuilder para favoritos en tiempo real

Vista detalle con:

SingleChildScrollView

Image.network

GoogleMapsFlutter

ListView para servicios

Manejo de estado con Provider o Riverpod

Diseño (Figma)

Colores institucionales

Tipografía sans-serif

Cards con sombras para profundidad

Responsive con LayoutBuilder (mobile y tablet)
