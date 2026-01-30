# Documentación de Arquitectura

## Visión General

La aplicación móvil **EmprendeUIDE Móvil** es un proyecto que fue creado utilizando Flutter.
enfocada en brindar asistencia a los emprendedores en la gestión elemental de información relacionada con sus emprendimientos

El sistema utiliza una arquitectura **cliente-servidor**, la cual está estructurada como un **monolito en capas**, que posibilita una división nítida de obligaciones entre la lógica de negocio, la interfaz del usuario y la persistencia de información.

La elección de esta perspectiva arquitectónica ha tenido en cuenta el alcance académico. del proyecto, la magnitud del equipo de desarrollo y la exigencia de sostener una estructura sencilla, que puede ser mantenida y que es coherente con las exigencias funcionales.

## Estilo Arquitectónico
Se emplea una **arquitectura monolítica en capas** en la que todos los elementos
del sistema se incorporan en una sola aplicación, aunque están organizadas de manera modular.

### Capas del Sistema

**Capa de Presentación**
- Desarrollada con Flutter.
- Administra la navegación, los eventos y la interfaz de usuario.
- Utiliza los servicios de la lógica del negocio.

**Capa de Lógica de Negocio**
- Incluye las normas que rigen el dominio del sistema.
- Comprueba y procesa la información.
- Separa la interfaz de usuario de la persistencia.

**Capa de Persistencia**
- Realizada a través de Firebase.
- Se encarga de la sincronización y el almacenamiento de datos.
- Posibilita el acceso a la información y asistencia en tiempo real desde ubicaciones remotas.

## Decisiones Arquitectónicas
A través de **Architecture Decision Records (ADR)**, que están disponibles en
la carpeta `/docs/ADR`.
Cada ADR explica el entorno, la resolución que se tomó y sus efectos técnicos.