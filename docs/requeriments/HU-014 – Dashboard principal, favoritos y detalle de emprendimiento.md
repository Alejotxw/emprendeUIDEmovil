# Historia de Usuario – Dashboard Principal de Exploración y Compra

**Como** usuario autenticado  
**Quiero** visualizar el dashboard principal con categorías, emprendimientos destacados y todos los disponibles, acceder a mis favoritos y entrar al detalle de cualquier emprendimiento o servicio/producto  
**Para** descubrir, organizar y comprar servicios o emprendimientos de manera intuitiva y eficiente.

---

## Criterios de Aceptación (Gherkin)

### Escenario: Visualización inicial del dashboard
**Dado** que el usuario inicia sesión correctamente  
**Cuando** accede al dashboard principal  
**Entonces** el sistema debe mostrar:
* Un saludo personalizado (ej.: “Hola, [Nombre], ¿qué necesitas hoy?”).
* Barra de búsqueda.
* Íconos de categorías (Comida, Tecnología, Diseño, Artesanías).
* Sección “TOP Destacadas” con tarjetas de emprendimientos.
* Sección “Todos los Emprendimientos” en formato grid.
* Barra de navegación inferior con opciones: Home, Favoritos, Carrito y Perfil.

### Escenario: Filtrado por categoría
**Dado** que el usuario se encuentra en el dashboard  
**Cuando** selecciona una categoría específica (ej.: Comida)  
**Entonces** el sistema debe filtrar y mostrar únicamente los emprendimientos de esa categoría en todas las secciones y mantener el scroll infinito si aplica.

### Escenario: Búsqueda de emprendimientos o servicios
**Dado** que el usuario utiliza la barra de búsqueda  
**Cuando** ingresa una consulta (ej.: “Diseño web”)  
**Entonces** el sistema debe mostrar resultados relevantes y permitir limpiar la búsqueda para volver al estado inicial.

### Escenario: Gestión de favoritos desde el dashboard
**Dado** que el usuario visualiza una tarjeta de emprendimiento  
**Cuando** presiona el ícono de corazón  
**Entonces** el sistema debe agregar o quitar el emprendimiento de favoritos, actualizar el ícono visualmente y sincronizar el estado con su perfil.

### Escenario: Visualización de la sección “Mis Favoritos”
**Dado** que el usuario accede a la pestaña Favoritos  
**Cuando** se carga la vista  
**Entonces** el sistema debe mostrar un grid de sus favoritos; si no existen, mostrar el mensaje: “No tienes favoritos aún”.

### Escenario: Acceso al detalle de un emprendimiento o servicio
**Dado** que el usuario selecciona una tarjeta desde cualquier sección  
**Cuando** accede al detalle  
**Entonces** el sistema debe mostrar:
* Imagen principal, nombre del emprendedor, categoría y descripción.
* Horario y ubicación con mapa integrado.
* **Sección “Servicios Disponibles”:** Nombre, precio, botones de cantidad (+/-), subtotal en tiempo real y botón “Agregar al Carrito”.

### Escenario: Manejo de datos incompletos y errores
**Dado** que falta información o ocurre un error de red  
**Cuando** se carga la vista  
**Entonces** el sistema debe mostrar placeholders visuales para datos faltantes, un loader durante la carga y un mensaje de error con opción "Reintentar" si la conexión falla.

---

## Notas Técnicas

### Firebase (Firestore & Auth)
* **Colección `emprendimientos`:** Campos de nombre, categoría, descripción, horario, `GeoPoint` para ubicación, array de `servicios` y `favoritos` (userIds).
* **Auth:** Utilizar `displayName` para el saludo personalizado.

### Flutter Implementation
* **Estructura:** `Scaffold` con `BottomNavigationBar` e `IndexedStack` para preservar el estado entre pestañas.
* **Widgets Clave:** `GridView.builder` para cards, `SearchDelegate` para filtros y `GoogleMapsFlutter` para la ubicación.
* **Estado:** Gestión mediante `StreamBuilder` para actualizaciones en tiempo real y `Provider` o `Riverpod` para el carrito global.

### Diseño (Figma)
* **Estética:** Colores institucionales, tipografía sans-serif y sombras en tarjetas.
* **Responsividad:** Uso de `LayoutBuilder` para adaptación a Mobile y Tablet.

---

## Flujo de Trabajo (Git)
* **Rama:** Crear `feature/dashboard-exploracion-compra` desde `develop`.
* **Pull Request:** Realizar PR hacia `developer` para revisión de pares (No realizar merge directo).
