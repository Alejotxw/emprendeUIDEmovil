# Característica: Integridad referencial en base de datos SQLite

**Como** desarrollador del sistema  
**Quiero** configurar la base de datos SQLite con integridad referencial  
**Para** evitar la existencia de productos huérfanos sin un emprendimiento asociado.

---

## Escenarios de Aceptación (Gherkin)

### Escenario 1: Implementación de DatabaseHelper como Singleton
**Dado** que el sistema utiliza SQLite como base de datos local  
**Cuando** se implementa la clase `DatabaseHelper`  
**Entonces** la clase debe seguir el patrón **Singleton**.  
**Y** debe garantizar una única instancia de conexión a la base de datos para evitar conflictos de escritura.

### Escenario 2: Activación de claves foráneas en SQLite
**Dado** que la base de datos SQLite ha sido inicializada  
**Cuando** el sistema ejecuta la instrucción `PRAGMA foreign_keys = ON`  
**Entonces** el motor de base de datos debe validar la integridad referencial.  
**Y** no debe permitir la inserción de registros inconsistentes entre tablas relacionadas.

### Escenario: Creación de tablas con relación uno a muchos
**Dado** que se definen las tablas `entrepreneurships` y `products`  
**Cuando** se crean las tablas en la base de datos  
**Entonces** la tabla `entrepreneurships` debe ser la tabla padre.  
**Y** la tabla `products` debe referenciar a `entrepreneurships` mediante una clave foránea (**FK**).  
**Y** la relación debe ser de **uno a muchos**.  
**Y** al eliminar un emprendimiento, sus productos asociados deben eliminarse automáticamente mediante la instrucción `ON DELETE CASCADE`.
