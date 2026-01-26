# Historia de Usuario – Gestión de Carrito y Pago

**Como** usuario autenticado  
**Quiero** gestionar mi carrito con los ítems agregados, ajustar cantidades, remover elementos y seleccionar un método de pago (efectivo o transferencia)  
**Para** finalizar mis compras de manera segura y sencilla, con una confirmación que me devuelva al carrito actualizado (vacío si aplica).

---

## Criterios de Aceptación (Gherkin)

### Escenario: Visualización del carrito
**Dado** que el usuario accede al carrito desde la navegación inferior o tras agregar ítems  
**Cuando** se carga la pantalla  
**Entonces** el sistema debe mostrar:
* Lista de ítems con checkbox, ícono de basura, botones +/- y subtotal.
* Total general del carrito.
* Si está vacío, mostrar el mensaje: “Tu carrito está vacío” con un botón para "Explorar emprendimientos".

### Escenario: Ajuste de cantidad y selección
**Dado** que el carrito contiene ítems  
**Cuando** el usuario modifica la cantidad o selecciona/deselecciona mediante el checkbox  
**Entonces** el sistema debe actualizar el subtotal del ítem y recalcular el total general en tiempo real, validando stock y mínimos.

### Escenario: Eliminación de ítems
**Dado** que el usuario visualiza un ítem en el carrito  
**Cuando** presiona el ícono de basura  
**Entonces** el sistema debe solicitar confirmación, remover el ítem y actualizar el total general.

### Escenario: Navegación y Visualización de Métodos de Pago
**Dado** que el usuario tiene ítems seleccionados y presiona “Método de Pago”  
**Cuando** se carga la pantalla de pago  
**Entonces** el sistema debe mostrar las opciones:
* **Pago en físico:** Mapa con ubicación del emprendimiento y botón "Solicitar".
* **Pago por transferencia:** Campos para número de cuenta (16 dígitos), fecha (MM/AA) y CVV (3 dígitos).

### Escenario: Procesamiento de Pago (Físico/Transferencia)
**Dado** que el usuario selecciona un método de pago  
**Cuando** completa la información y presiona el botón de acción  
**Entonces** el sistema debe:
* Validar datos en tiempo real (si es transferencia).
* Generar la orden en el backend.
* Mostrar mensaje de “¡Pago exitoso!” y redirigir al carrito (vacío o con ítems restantes).

### Escenario: Manejo de errores y navegación
**Dado** que el carrito está vacío o ocurre un error de red  
**Cuando** el usuario intenta proceder al pago  
**Entonces** el sistema debe impedir el acceso o mostrar un snackbar de error permitiendo reintentar.

---

## Notas Técnicas

### Firebase (Firestore & Auth)
* **Subcolección `usuarios/{userId}/carrito`:** Campos de `itemId`, `cantidad`, `seleccionado` y `timestamp`.
* **Colección `ordenes`:** Registro de `items`, `metodoPago`, `subtotal`, `total`, `status` (pendiente/confirmado) y `createdAt`.

### Flutter Implementation
* **Carrito:** `ListView.builder`, `CheckboxListTile`, `IconButton` y `Dismissible` para gestos de eliminación.
* **Pago:** `Form` con `TextFormField` para validaciones bancarias, `RadioListTile` para selección de método y `GoogleMapsFlutter` para pago físico.
* **Estado:** Gestión global mediante `Provider` o `Riverpod`.

### Diseño (Figma)
* **Estética:** Colores institucionales con acentos en naranja (#FFA500).
* **UI:** Cards con sombras para profundidad y diseño responsive (Mobile/Tablet).

---

## Flujo de Trabajo (Git)
* **Rama:** `feature/carrito-pago` (desde `develop`).
* **Pull Request:** Hacia la rama `develop` para revisión de código.
