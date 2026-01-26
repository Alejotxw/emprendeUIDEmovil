# Historia de Usuario – Gestión de Emprendimientos (Borradores, Ubicación y Horarios)

**Como** emprendedor autenticado del marketplace universitario  
**Quiero** listar, crear, editar y guardar como borrador mis emprendimientos, con ubicación vía mapa y gestión de horarios  
**Para que** pueda configurar y publicar mis servicios de manera flexible, asegurando que mis avances no se pierdan gracias al autosave.

---

## Criterios de Aceptación (Gherkin)

### Escenario: Visualización y listado de emprendimientos
**Dado** que accedo a la sección "Emprendimientos" con el rol de emprendedor activo  
**Cuando** se carga la pantalla principal de la sección  
**Entonces** el sistema muestra:
* Botón naranja "+" Crear.
* Lista de cards con emprendimientos existentes y borradores (Ej: "Kevin Girón" en categoría "Diseño").
* Badges de estado: Activo (rojo), Editar (naranja) o Borrador (gris).
* Si la lista está vacía, muestra el mensaje: "No tienes emprendimientos. ¡Crea uno!".

### Escenario: Formulario de Creación/Edición con Mapa y Horarios
**Dado** que presiono "Crear" o "Editar" en una card  
**Cuando** se despliega el formulario dinámico  
**Entonces** el sistema permite gestionar:
* **Información Básica:** Nombre y categoría (Comida, Tecnología, Diseño, Artesanías).
* **Ubicación:** Mapa interactivo de Google con marcador movible y dirección obtenida vía reverse geocoding.
* **Horarios:** Tabla editable por día (Lunes-Viernes/Sábado) con selectores de hora (TimePickers).
* **Servicios/Productos:** Lista dinámica (máximo 10 ítems) con nombre, descripción y precio.

### Escenario: Interacción con el Mapa y GPS
**Dado** que estoy seleccionando la ubicación del negocio  
**Cuando** muevo el marcador o hago zoom en el mapa  
**Entonces** el sistema actualiza el GeoPoint en tiempo real y valida que el GPS esté activo; de lo contrario, deshabilita el botón de creación.

### Escenario: Gestión de Horarios y Validación
**Dado** que edito el horario de un día específico  
**Cuando** selecciono las horas de inicio y fin  
**Entonces** el sistema valida que la hora de fin sea mayor a la de inicio, marca el día como laborable (en rojo) y permite la opción de marcar días como "Cerrado".

### Escenario: Persistencia de Borradores y Autosave
**Dado** que tengo cambios no guardados en el formulario  
**Cuando** presiono el botón atrás, cierro la app o presiono "Guardar Borrador"  
**Entonces** el sistema detecta el estado del ciclo de vida y muestra un diálogo de confirmación para guardar como borrador, persistiendo los datos localmente vía SharedPreferences y en Firebase con el status 'borrador'.

### Escenario: Publicación Final y Validación
**Dado** que he completado todos los campos obligatorios (mínimo 1 servicio y horario coherente)  
**Cuando** presiono "Crear/Actualizar Emprendimiento"  
**Entonces** el sistema sube la foto (opcional), crea el documento en la colección principal con status 'activo', genera un ID único y muestra un toast de éxito: "¡Emprendimiento creado!".

### Escenario: Operación Offline y Eliminación
**Dado** que intento guardar cambios sin conexión a internet  
**Cuando** se confirma la acción  
**Entonces** el sistema encola la tarea mediante la persistencia de Firestore y muestra el mensaje: "Guardado localmente. Sincroniza al conectar".  
**Y** si decido eliminar un emprendimiento, el sistema solicita confirmación antes de borrar el documento y refresca la lista con una animación.
