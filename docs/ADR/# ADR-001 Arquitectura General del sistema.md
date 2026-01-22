# ADR-001: Arquitectura General del Sistema

## Estado
Aceptado


## Contexto
La aplicación EmprendeUIDE Móvil, creada en Flutter, está dirigida a la administración y adquisición de productos, incluyendo la autenticación de usuarios y el almacenamiento permanente de datos en la nube.

Dada la finalidad académica del proyecto, la escasa dimensión del equipo y la importancia de conservar la simplicidad, se hace necesaria una arquitectura que sea transparente, mantenible y sencilla de entender.

## Decisión
Se implementa una arquitectura de capas monolítica, que consta de:

- Capa de presentación: interfaz de usuario construida con Flutter.
- Capa de lógica de negocios: servicios y controladores que administran las normas del sistema.

- Capa de datos: servicios de Firebase para la persistencia y la autenticación.

## Justificación Técnica
- Disminuir la complejidad del desarrollo inicial.
- Hace más sencillo mantener el código.
- Facilita una adecuada diferenciación de las responsabilidades.
- Es apropiada para aplicaciones móviles de tamaño medio y pequeño.
- Se incorpora de manera natural con Firebase.

## Consecuencias
- Arquitectura coherente y nítida.
- Capacidad de escalar adecuadamente para el marco del proyecto.
- Puede que sea necesaria una refactorización si el sistema crece de manera significativa.

