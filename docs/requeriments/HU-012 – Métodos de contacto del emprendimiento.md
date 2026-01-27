# Historia de Usuario – Dashboard de Métricas Administrativas

**Como** administrador de la plataforma UIDE  
**Quiero** visualizar métricas generales y estadísticas de uso  
**Para que** pueda monitorear el rendimiento, el crecimiento del marketplace y tomar decisiones basadas en datos.

---

## Criterios de Aceptación (Gherkin)

### Escenario: Visualización de indicadores clave (KPIs)
**Dado** que he iniciado sesión con credenciales de administrador  
**Cuando** accedo al Dashboard principal  
**Entonces** el sistema debe mostrar tarjetas de resumen con:
* Total de usuarios registrados.
* Total de emprendimientos activos.
* Total de publicaciones (productos/servicios) realizadas.

### Escenario: Filtrado de datos por rango de fechas
**Dado** que estoy visualizando las métricas en el dashboard  
**Cuando** selecciono un rango de fechas específico (inicio y fin) y aplico el filtro  
**Entonces** las métricas y los gráficos deben actualizarse automáticamente para reflejar únicamente la actividad ocurrida en ese periodo.

### Escenario: Representación visual del rendimiento
**Dado** que existen datos históricos en la plataforma  
**Cuando** la aplicación carga la vista administrativa  
**Entonces** el sistema debe renderizar gráficos (líneas o barras) que muestren la tendencia de crecimiento de emprendimientos y publicaciones.

### Escenario: Precisión de datos agregados
**Dado** que la base de datos Firestore es extensa  
**Cuando** se solicita el conteo de registros  
**Entonces** la aplicación debe utilizar consultas agregadas de Firestore para optimizar el consumo de recursos y garantizar que el conteo sea exacto.

---

## Flujo de Trabajo (Git)
* **Rama:** Crear `feature/admin-dashboard-metrics` desde la rama `developer`.
* **Pull Request:** Al finalizar la tarea, realizar un PR hacia `developer` para revisión de código (Sin hacer merge directo).
