# Historia de Usuario – Gestión de Solicitudes de Clientes

**Como** emprendedor autenticado  
**Quiero** visualizar la lista de solicitudes recibidas, acceder al detalle de cada pedido y gestionar sus estados (Pendiente, Aceptado, Rechazado)  
**Para** gestionar eficientemente las órdenes entrantes, asegurando la integridad de los datos mediante el bloqueo de ediciones en estados finales.

---

## Criterios de Aceptación (Gherkin)

### Escenario: Visualización y Filtrado de Solicitudes
**Dado** que el emprendedor accede a la sección "Ver Solicitudes" desde su perfil o dashboard  
**Cuando** la pantalla se carga  
**Entonces** el sistema debe mostrar:
* Título “Ver Solicitudes” con una lista o grid ordenada por fecha descendente.
* **Información clave:** Nombre del servicio/producto, precio total y **Badge de estado**.
* **Filtros dinámicos:** Permitir segmentar la vista por *Pendiente*, *Aceptado* o *Rechazado*.
* **Empty State:** Si no hay registros, mostrar *"No hay solicitudes. ¡Espera clientes!"*.

### Escenario: Detalle y Revisión de Pedidos
**Dado** que el emprendedor selecciona una solicitud específica  
**Cuando** navega a la pantalla "Detalle de Solicitud"  
**Entonces** el sistema debe desglosar:
* Datos completos del cliente y lista de servicios/productos con cantidades.
* Cálculo automático del **Total** basado en precios unitarios.
* Visualización del estado actual con controles de acción condicionales.

### Escenario: Gestión de Estados y Notificaciones
**Dado** que una solicitud está en estado **Pendiente** **Cuando** el emprendedor selecciona "Aceptar" o "Rechazar"  
**Entonces** el sistema debe:
1. Solicitar una **Confirmación Previa** mediante un diálogo.
2. Actualizar el estado en Firestore y notificar al cliente vía Push.
3. Reflejar el cambio inmediatamente en la lista principal mediante listeners en tiempo real.

### Escenario: Bloqueo de Modificaciones en Rechazados
**Dado** que una solicitud se encuentra en estado **Rechazado** **Cuando** el emprendedor accede al detalle del registro  
**Entonces** el sistema debe mostrar la información en **modo solo lectura**.  
**Y** deshabilitar cualquier control de cambio de estado para evitar ediciones retroactivas.

### Escenario: Resiliencia Offline y Errores
**Dado** que el emprendedor opera con conexión inestable  
**Cuando** intenta actualizar un estado o cargar la lista  
**Entonces** el sistema debe guardar la acción localmente para sincronizarla después.  
**Y** en caso de fallo crítico de carga, mostrar un mensaje de error con opción de **"Reintentar"**.

---

## Notas Técnicas

### Firebase (Backend)
* **Firestore:** Colección `emprendedores/{userId}/emprendimientos/{emprId}/solicitudes`.
* **Estructura de Documento:** * `clienteId`: String (Relación Auth).
    * `servicios`: List<Map> (nombre, cantidad, precio).
    * `total`: Double.
    * `estado`: String (Enum: PENDIENTE, ACEPTADO, RECHAZADO).
    * `timestamps`: `createdAt`, `updatedAt`.
* **Real-time:** Uso de `snapshots()` para actualización reactiva de la UI.
* **Persistencia:** Offline habilitado para gestión de estados sin red.

### Flutter Implementation
* **UI:** `GridView.builder` o `ListView.builder` para el listado; `SingleChildScrollView` para el detalle.
* **State Management:** Gestión mediante **Provider** o **Riverpod**.
* **Interacción:** Diálogos de confirmación (`showDialog`) y `SnackBars` para notificaciones de éxito/error.
* **Lógica de Bloqueo:** Condicionales en la UI para deshabilitar botones si `estado == 'RECHAZADO'`.

### Diseño (Figma)
* **Estética:** Uso de colores institucionales y diseño responsivo.
* **Feedback Visual:** Badges de colores (Amarillo: Pendiente, Verde: Aceptado, Rojo: Rechazado).

---

## Flujo de Trabajo (Git)
* **Rama:** `feature/solicitudes-hu` (desde `develop`).
* **Pull Request:** Hacia la rama `develop` para revisión de lógica y manejo de errores.
