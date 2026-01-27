# Historia de Usuario – Arquitectura de Repositorios y Modelado

**Como** desarrollador del marketplace universitario UIDE  
**Quiero** desacoplar la base de datos de la interfaz mediante la implementación de repositorios y modelos de datos  
**Para** que el código sea testeable, limpio y las responsabilidades de la lógica de datos estén centralizadas.

## Criterios de Aceptación

### Escenario: Serialización y Modelado de datos
**Dado** que necesito manejar información de Emprendimientos o Productos  
**Cuando** implemento las clases de modelo en el código  
**Entonces** cada modelo debe incluir los métodos:  
- `fromMap()` (para transformar datos de la DB a objetos)  
- `toMap()` (para transformar objetos a un formato almacenable en la DB)

### Escenario: Implementación del Repositorio de Emprendimientos
**Dado** que la aplicación requiere gestionar la persistencia de datos  
**Cuando** se crea la clase `EntrepreneurshipRepository`  
**Entonces** esta clase debe actuar como el único punto de acceso a los datos, encapsulando las consultas SQL o llamadas a la base de datos

### Escenario: Desacoplamiento de la Interfaz de Usuario (UI)
**Dado** que estoy desarrollando una pantalla de la aplicación  
**Cuando** necesito mostrar o guardar información  
**Entonces** la UI debe realizar llamadas exclusivamente a los métodos del Repositorio y nunca invocar directamente a la instancia de la base de datos

### Escenario: Verificación de Testabilidad
**Dado** que la lógica de datos está aislada en repositorios  
**Cuando** se realizan pruebas unitarias del flujo de información  
**Entonces** el sistema debe permitir el uso de "mocks" o datos simulados sin necesidad de levantar una base de datos real
