# Historia de Usuario – Gestión de Emprendimientos y Catálogo

**Como** emprendedor autenticado  
**Quiero** listar, crear, editar y guardar como borrador mis emprendimientos, integrando ubicación mediante mapa interactivo, configuración de horarios y catálogo de servicios  
**Para** configurar y publicar mis servicios/productos de manera flexible, asegurando la persistencia de datos mediante un sistema de auto-guardado y soporte offline.

---

## Criterios de Aceptación (Gherkin)

### Escenario: Visualización y gestión del listado
**Dado** que el emprendedor accede a la sección "Emprendimientos" desde su perfil con el rol activo  
**Cuando** la pantalla se carga  
**Entonces** el sistema debe mostrar:
* Botón **“Crear”** y lista de cards (ej: "Kevin Girón" en "Diseño").
* **Badges de estado:** `Activo`, `Editar`, `Borrador`.
* Botón de acción **"Editar Emprendimiento"** o **"Borrador"** en cada card con imagen placeholder.
* **Empty State:** Si la lista está vacía, mostrar *"No tienes emprendimientos. ¡Crea uno!"*.

### Escenario: Formulario de Registro con Mapa y Horarios
**Dado** que el emprendedor inicia la creación o edición de un emprendimiento  
**Cuando** se carga el formulario  
**Entonces** debe permitir la entrada de:
* **Información Básica:** Nombre y Categoría (RadioButtons: Comida, Tecnología, Diseño, Artesanías).
* **Descripción:** Campo de texto multilínea.
* **Ubicación:** Mapa interactivo con marcador *draggable*; debe validar disponibilidad de GPS y mostrar la dirección legible. El botón de envío se deshabilita si la ubicación no está confirmada.
* **Horario:** Tabla editable por día con selectores donde $Hora_{fin} > Hora_{inicio}$, con opción de marcar día como "Cerrado".

### Escenario: Gestión Dinámica de Servicios y Productos
**Dado** que el emprendedor gestiona su catálogo  
**Cuando** interactúa con las opciones de agregar o eliminar  
**Entonces** debe abrir un **formulario modal** para ingresar Nombre, Descripción y Precio.  
**Y** validar campos obligatorios, actualizar la lista numerada y respetar el límite máximo de servicios permitidos.

### Escenario: Sistema de Auto-guardado y Borradores
**Dado** que el emprendedor presiona "Guardar Borrador" o intenta salir del formulario  
**Cuando** confirma la acción, retrocede o cierra la aplicación  
**Entonces** el sistema debe mostrar un diálogo para Guardar, Descartar o Cancelar.  
**Y** al guardar, persistir la información con estado `borrador` y mostrar el badge correspondiente en el listado.

### Escenario: Publicación y Sincronización Offline
**Dado** que se presiona "Crear/Actualizar Emprendimiento"  
**Cuando** todos los campos obligatorios están validados  
**Entonces** debe cambiar el estado a `activo`, mostrar confirmación y navegar al listado.  
**Y** ante la falta de internet, almacenar localmente y sincronizar con Firestore al recuperar la conexión.

---

## Notas Técnicas

### Firebase (Backend)
* **Firestore:** Colección `emprendedores/{userId}/emprendimientos` y subcolección para `borradores`.
* **Data Model:** Campos `GeoPoint` (ubicación), `Map` (horario), `Array` (servicios), `estado` y `timestamps`.
* **Storage:** Almacenamiento de imágenes mediante Firebase Storage.
* **Offline:** Persistencia de datos habilitada nativamente.

### Flutter Implementation
* **UI:** `ListView.builder` para el listado y formularios con validaciones dinámicas.
* **Geolocalización:** Integración de `Maps_flutter` y `geolocator`.
* **Estado & Persistencia:** Gestión de estado con **Provider**. Uso de `WillPopScope` y `SharedPreferences` para la lógica de autosave.
* **Pickers:** Implementación de `showTimePicker` para la selección de horarios.

### Diseño (Figma)
* **UX/UI:** Estructura de cards basada en mockups, uso de colores institucionales y jerarquía visual definida.

---

## Flujo de Trabajo (Git)
* **Rama:** `feature/emprendimientos-hu` (desde `develop`).
* **Pull Request:** Hacia la rama `develop` para revisión de código (Sin merge manual).
