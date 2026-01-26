# Historia de Usuario: Integración y consolidación del proyecto

**Como** equipo desarrollador  
**Quiero** demostrar la integración de todas las tareas completadas  
**Para** reflejar el avance consolidado del proyecto y preparar un entregable funcional.

---

## Escenarios de Aceptación (Gherkin)

### Escenario 1: Integración de ramas y verificación de commits
**Dado** que todas las ramas relevantes han sido mergeadas exitosamente a la rama `main`  
**Y** las ramas incluyen vistas de cliente, vistas de emprendedor y otras funcionalidades implementadas  
**Cuando** se revisa el historial del repositorio  
**Entonces** el historial debe mostrar commits recientes de todos los integrantes del equipo  
**Y** los mensajes de commit deben ser claros y referenciar las Historias de Usuario completadas.

**Ejemplos:**
| Mensaje de commit |
| :--- |
| Merge HU-XXX: Integración vistas cliente y emprendedor |
| Merge HU-YYY: Configuración de tema e idiomas |

### Escenario 2: Ejecución y validación de la aplicación integrada
**Dado** que la aplicación se ejecuta desde la rama `main`  
**Cuando** se prueba la funcionalidad integrada del sistema  
**Entonces** la navegación entre vistas de cliente y emprendedor debe funcionar correctamente.  
**Y** el cambio entre tema claro y oscuro debe ser estable.  
**Y** la configuración de idiomas debe aplicarse correctamente.  
**Y** la aplicación no debe presentar errores ni regresiones.  
**Y** las transiciones entre vistas deben ser fluidas.
