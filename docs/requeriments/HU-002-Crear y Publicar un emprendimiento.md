# Historia de Usuario – Dashboard Estadístico y Agrupación de Productos

**Como** usuario del marketplace universitario UIDE  
**Quiero** visualizar un resumen estadístico en la pantalla principal y ver los productos agrupados por negocio  
**Para** que pueda identificar rápidamente la magnitud del marketplace y navegar de forma organizada entre los emprendimientos.

## Criterios de Aceptación

### Escenario: Visualización del Dashboard de Estadísticas
**Dado** que me encuentro en la pantalla principal de la aplicación  
**Cuando** la interfaz se carga completamente  
**Entonces** el sistema muestra un Widget de Dashboard con tarjetas informativas que resumen:  
- Total de productos registrados  
- Total de emprendimientos registrados

### Escenario: Consumo de datos agregados
**Dado** que el Integrante 3 ha desarrollado los métodos de agregación (conteos, sumatorias, etc.)  
**Cuando** el Widget de Dashboard se inicializa  
**Entonces** las tarjetas de resumen consumen y muestran los datos reales provenientes de dichos métodos de agregación

### Escenario: Visualización de relación 1:N (Emprendimiento - Productos)
**Dado** que existen múltiples productos vinculados a diferentes emprendimientos  
**Cuando** navego a la sección de catálogo  
**Entonces** el sistema muestra una lista donde los productos aparecen agrupados bajo el encabezado de su respectivo Emprendimiento, reflejando la relación uno a muchos

### Escenario: Navegación desde el resumen
**Dado** que estoy observando las tarjetas del dashboard  
**Cuando** interactúo con una de las categorías o tarjetas de resumen  
**Entonces** el sistema permite filtrar o profundizar en la información detallada de los productos asociados
