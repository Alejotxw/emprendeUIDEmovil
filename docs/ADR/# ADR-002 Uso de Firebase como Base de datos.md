# ADR-002: Uso de Firebase como Base de Datos

## Estado
Aceptado

## Contexto	
Para guardar información de productos y usuarios, la aplicación necesita una base de datos a la que se pueda acceder en tiempo real desde dispositivos móviles.

Se examinaron opciones como las bases de datos relacionales tradicionales y las locales (SQLite).

## Decisión
Se escoge Firebase Cloud Firestore como la base de datos principal del sistema.

## Justificación Técnica
- Firestore es una base de datos NoSQL, que se basa en documentos.
- Posibilita el almacenamiento de información de manera flexible.
- Se ajusta con facilidad a las aplicaciones móviles.
- No es necesario establecer patrones estrictos.

## Consecuencias
- Dependencia del ecosistema de Firebase para la autenticación y la persistencia.
- Aplicación de un modelo de datos no relacional fundamentado en documentos.
- Disminución de la complejidad del backend.
- La sincronización en tiempo real favorece que la experiencia del usuario mejore.