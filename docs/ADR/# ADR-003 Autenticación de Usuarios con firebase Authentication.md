# ADR-003: Autenticación de Usuarios con Firebase Authentication

## Estado
Aceptado

## Contexto
La aplicación necesita un sistema de autenticación seguro para permitir que los usuarios accedan, registren cuentas y gestionen sesiones.

Se consideraron opciones tales como la autenticación propia a través del backend y el empleo de servicios externos.

## Decisión
Firebase Authentication se adopta como el método de autenticación del sistema.

## Justificación Técnica
- Integración nativa con Flutter.
- Apoyo para la verificación de identidad mediante correo y contraseña.
- Administración segura de sesiones.
- Supresión de la necesidad de crear un backend propio.
- Gran fiabilidad y escalabilidad.

## Consecuencias
- Dependencia del entorno de Firebase.
- Menor control sobre el razonamiento interno de autenticación.
- Disminución del nivel de complejidad del sistema.
- Avance en la seguridad y la experiencia que tiene el usuario.