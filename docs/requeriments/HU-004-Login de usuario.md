# Historia de Usuario – Integración Continua y Entrega Consolidada

**Como** equipo desarrollador del marketplace universitario UIDE  
**Quiero** demostrar la integración de las tareas completadas en una rama principal unificada  
**Para** que el avance del proyecto sea visible, se facilite la revisión del progreso y se genere un entregable completo y funcional.

## Criterios de Aceptación

### Escenario: Consolidación del repositorio en la rama Main
**Dado** que todas las ramas de desarrollo (vistas cliente, emprendedor y funcionalidades core) han sido finalizadas  
**Cuando** se realiza el proceso de merge exitosamente hacia la rama main  
**Entonces** el historial del repositorio debe mostrar los commits recientes de todos los integrantes del equipo con mensajes claros (Ej: "Merge HU-XXX: Integración de vistas")

### Escenario: Estabilidad del sistema integrado
**Dado** que la aplicación se ejecuta desde la rama main tras la integración  
**Cuando** se realiza una prueba de punta a punta (End-to-End)  
**Entonces** la app debe funcionar de manera estable, sin cierres inesperados y manteniendo la integridad de todas las funciones previas

### Escenario: Verificación de funcionalidades transversales
**Dado** que se han integrado múltiples módulos  
**Cuando** pruebo la navegación entre vistas de cliente/emprendedor y cambio ajustes de idioma y tema (claro/oscuro)  
**Entonces** el sistema debe responder con transiciones fluidas y aplicar los cambios globalmente sin regresiones

### Escenario: Preparación del entregable final
**Dado** que el código está consolidado y testeado en main  
**Cuando** se genera la versión final para revisión  
**Entonces** el producto debe reflejar el estado actual del proyecto, permitiendo al evaluador validar todas las historias de usuario implementadas hasta la fecha
