# Emprende UIDE
Es un Marketplace de servicios y emprendimientos estudiantiles desarrolada especialmente para la comunidad UIDE.
EmprendeUIDE busca ser un Marketplace interno donde los estudiantes puedan ofrecer sus productos/servicios y otros estudiantes o docentes puedan contratarlos. Es un proyecto que conecta directamente con la generación de ingresos, espíritu emprendedor y uso real de la app después del curso.

### Objetivo del Proyecto
* Registrar y autenticar usuarios utilizando **Firebase**.
* Permitir la publicación y administración de emprendimientos por parte de los estudiantes.
* Mostrar un catálogo de productos/servicios centralizado.
* Promover iniciativas emprendedoras dentro de la UIDE.
* Conectar estudiantes, clientes internos y externos.

## Integrantes del Equipo
El equipo de desarrollo está compuesto por 5 miembros:
* **Lander González** - Full Stack Developer - @santiiis
* **Luis Ramírez** - Full Stack Developer – @luisramirezrv
* **Sebastián Chocho** - Full Stack Developer - @Alejotxw
* **Aidan Carpio** - Full Stack Developer - @Aidan-5
* **Malena Orbea** - Full Stack Developer - @maleorbea
* **Kevin Giron** - Full Stack Developer - @KevinGiron

## Enlaces a GitHub Projects
Aquí puedes encontrar la planificación completa del proyecto y el estado actual del trabajo:
- [Product Backlog](https://github.com/users/Alejotxw/projects/2)
- [Sprint 1 - Kanban Board](https://github.com/users/Alejotxw/projects/3/views/1)

## Tecnologías Utilizadas
| Componente | Tecnología | Framework/Librería Clave | 
 | ----- | ----- | ----- | 
| **Frontend (App Móvil)** | Flutter 3.x | Dart, Material Design, Manejo de estado (Provider/Bloc) | 
| **Backend (API REST)** | Node.js | Express, Firebase Admin, `bcryptjs`, `cors`, `dotenv` | 
| **Base de Datos** | Firebase (Firestore/Auth) | \- | 
| **Gestión de Código** | Git, GitHub | \- | 

## Estructura del Proyecto
| EMPRENDEUIDEMOVIL/
├── backend/                  # API REST Express
│   ├── node_modules          # Dependencias de Node.js (ignoradas por Git)
│   ├── src/                  # Código fuente del Backend
|   |___|__ Reporte-sistemas/ # Reporte de actualizaciones del Sistema
│   │   ├── auth.routes.js    # Definición de rutas de Autenticación (Login, Registro)
│   │   ├── firebase.js       # Configuración o utilidades de Firebase Admin
│   │   ├── index.js          # Servidor principal (Punto de entrada)
│   │   └── products.routes.js# Definición de rutas de Productos/Emprendimientos
|   |__|__ reporte.js         # Coodigo para reportes de actualizacion del sistema  
│   ├── package-lock.json     # Archivo de bloqueo de dependencias
│   └── package.json          # Dependencias y scripts del Backend
│
├── docs/                     # Documentación y artefactos de diseño
│   ├── .gitkeep              # Placeholder para mantener la carpeta
│   └── SRS.md                # Especificación de Requerimientos del Sistema (en formato Markdown)
│
├── src/                      # Contenedor de la aplicación Flutter
│   ├── .gitkeep              # Placeholder para mantener la carpeta (Añadido)
│   └── emprendeuidemovil/    # Proyecto base de la aplicación Flutter
│       ├── android/          # Código nativo de Android
│       ├── ios/              # Código nativo de iOS
│       ├── lib/              # Código fuente Dart de la aplicación
│       │   ├── screens/      # Pantallas completas de la aplicación (UI principal)
│       │   │   ├── chat_screen.dart
│       │   │   ├── configuration_screen.dart
│       │   │   ├── emprendimiento_form.dart
│       │   │   ├── history_screen.dart
│       │   │   ├── home_screen.dart
│       │   │   ├── login_screen.dart
│       │   │   ├── profile_screen.dart
│       │   │   └── services_screen.dart
│       │   ├── models/      # carpeta de modelos
│       │   │   ├── notification_model.dart
│       │   │   ├── user_model.dart
│       │   ├── services/      # carpeta de servicios
│       │   │   ├── auth_service.dart
│       │   │   ├── notification_service.dart
│       │   └── main.dart     # Punto de entrada y Widget principal (App)
│       ├── test/             # Pruebas de la aplicación Flutter
│       ├── assets/           # (Implícito) Imágenes, fuentes, íconos
│       ├── pubspec.yaml      # Dependencias de Flutter (paquetes)
│       └── analysis_option.yaml     # Otros archivos de configuración de Flutter (.metadata, .gitignore, etc.)
│       └── pobspec.lock
│       └── .metadata
│       └── .gitignore  
│
├── tests/                    # Tests de nivel superior
│   └── .gitkeep              # Placeholder para mantener la carpeta
├── .gitignore                # Archivos ignorados por Git
└── README.md                 # Documentación principal del proyecto

## Instalación del Proyecto

### Instalación y Ejecución de la App Flutter
1. Navegar a la carpeta de la aplicación:
cd emprendeUIDEmovil/src/emprendeuidemovil
2. Instalar las dependencias de Flutter:
flutter pub get
3. Verificar el estado de la instalación de Flutter y dispositivos conectados:
flutter doctor
4. Ejecutar la aplicación en modo desarrollo:
flutter run

### Instalación y Configuración del Backend (Node.js)
1. Navegar a la carpeta del backend:
cd emprendeUIDEmovil/backend
2. Instalar las dependencias de Node.js:
npm install
3. **Configuración de Variables de Entorno y Firebase Admin:**
* Copia el archivo de ejemplo para crear el archivo `.env`:
  ```
  cp .env.example .env
  ```
* Coloca el archivo de credenciales de servicio de Firebase (`serviceAccountKey.json`) en la carpeta `backend/`.
* Actualiza el archivo `.env` con las credenciales de tu proyecto de Firebase:
  ```
  FIREBASE_PROJECT_ID=
  FIREBASE_PRIVATE_KEY=
  FIREBASE_CLIENT_EMAIL=
  # Otras variables como el puerto del servidor
  PORT=3000
  ```
4. Ejecutar el servidor en modo desarrollo (usando `nodemon` si está configurado en `package.json`):
npm run dev

## Convenciones

### Modelo de Ramificación (Branching Model)
Utilizamos un modelo basado en Git Flow simplificado:
| Rama | Propósito | 
| ----- | ----- | 
| `main` | Código en producción (estable). | 
| `develop` | Rama de integración para el desarrollo activo. | 
| `feature/#ID-nombre` | Desarrollo de nuevas funcionalidades. | 
| `bugfix/#ID-descripcion` | Corrección de errores. | 
| `release/#version` | Preparación para un nuevo lanzamiento. | 

### Convenciones de Commits (Convencional Commits)
Utilizamos el estándar Conventional Commits:
* `feat`: Nueva funcionalidad.
* `fix`: Corrección de un bug.
* `docs`: Cambios en la documentación.
* `test`: Adición o modificación de pruebas.
* `refactor`: Reestructuración del código sin cambiar funcionalidad.
* `chore`: Tareas de mantenimiento o construcción (e.g., actualizar dependencias, configuración).

##  Definition of Ready (DoR)
Una Historia de Usuario (HU) está lista para ser trabajada cuando:
* Tiene criterios de aceptación claros, preferiblemente en formato Gherkin.
* Está estimada con **story points**.
* Tiene una prioridad asignada (must/should/could/wont-have).
* No tiene dependencias bloqueantes con otras HU.
* Los diseños/mockups están disponibles (si aplica).
* El equipo entiende completamente lo que se debe hacer.

## Definition of Done (DoD)
Una Historia de Usuario (HU) está completa cuando:
* El código está implementado y funciona correctamente.
* Los tests unitarios y de integración pasan exitosamente (**coverage recomendado: >80%**).
* La documentación técnica está actualizada (README, estructura del sistema, etc.).
* La HU cumple todos los criterios de aceptación definidos.
* No hay bugs críticos o bloqueantes conocidos.
* Los commits están vinculados al issue (#número de GitHub).
* El estado del issue está actualizado en GitHub Projects.

## Capacidad del Equipo
* **Integrantes:** 5 personas
* **Disponibilidad:** 12 horas por persona por sprint
* **Velocidad estimada:** 3.5 SP por persona = **17.5 SP total por sprint**
* **Duración del Sprint:** 2 semanas

## Pruebas y Documentación

### Ejecución de Pruebas
| Componente | Comando | 
| ----- | ----- | 
| **Frontend (Flutter)** | `flutter test` | 
| **Backend (Node.js)** | `npm test` | 
**Cobertura:** Se espera alcanzar un **80% o más** de cobertura de código en ambos componentes.

### Documentación Adicional (`docs/`)
La carpeta `docs/` contiene la documentación detallada del proyecto, incluyendo:
* Casos de uso.
* Diagramas UML (Clases, Secuencia, Componentes).
* Estructura del sistema y arquitectura.
* Modelos de datos.
* Flujos de la aplicación.
* Documentación técnica específica del backend.
4.2 Subir Documento SRS/Arquitectura
Si tienes un documento de Especificación de Requerimientos (SRS) o de Arquitectura inicial, es el momento de subirlo y versionarlo.

# Copiar tu documento a la carpeta docs
cp ruta/a/tu/documento.pdf docs/

# O editar docs/ARQUITECTURA.md con tu contenido

# Commit de la documentación
git add docs/
git commit -m "docs: add initial Architecture or SRS document"
git push origin main

### Requerimientos Funcionales

### Requerimientos Funcionales
----------------------------------------------

**RF1. Creación de emprendimiento**
- Mostrar formulario para ingresar nombre, descripción, categoría, contacto, imagen/logo y estado.

**RF2. Verificación de campos obligatorios**
- Comprobar campos completos antes de guardar/publicar.

**RF3. Acceso según tipo de usuario**
- Permitir acceso por rol (cliente/emprendedor) post-login, mostrando panel correspondiente.

**RF4. Edición del perfil del usuario**
- Permitir cambiar nombre y foto en sección de perfil.

**RF5. Actualización de información del perfil**
- Guardar nombre actualizado y subir/asociar nueva foto.

**RF6. Visualización de emprendimientos propios**
- Mostrar emprendimientos registrados al emprendedor.

**RF7. Edición y eliminación de emprendimientos**
- Permitir modificar/eliminar con confirmación.

**RF8. Visualización del catálogo de emprendimientos**
- Mostrar listado de emprendimientos activos.

**RF9. Filtrado y acceso al detalle del emprendimiento**
- Filtrar por categoría y acceder a detalles.

**RF10. Visualización de estadísticas generales**
- Mostrar total de usuarios, emprendimientos y publicaciones al admin.

**RF11. Filtrado de estadísticas por fechas**
- Ajustar estadísticas por rango de fechas.

**RF12. Registro de calificaciones y comentarios**
- Permitir calificación y comentario por emprendimiento.

**RF13. Control de calificaciones repetidas**
- Evitar calificaciones repetidas y mostrar mensaje.

**RF14. Visualización de notificaciones**
- Mostrar notificaciones ordenadas por fecha descendente.

**RF15. Visualización de datos de contacto del emprendimiento**
- Mostrar teléfono y email si registrados.

**RF16. Registro de nuevos usuarios**
- Permitir registro con datos básicos.

**RF17. Inicio y cierre de sesión**
- Permitir login y logout.

**RF18. Recuperación de contraseña**
- Permitir recuperación de contraseña.

**RF19. Cambio de rol de usuario**
- Permitir cambio de cliente a emprendedor en perfil.

**RF20. Publicación y despublicación de emprendimientos**
- Permitir activar/desactivar visibilidad.

**RF21. Visualización del estado del emprendimiento**
- Mostrar estado activo/inactivo.

**RF22. Búsqueda por nombre del emprendimiento**
- Buscar por nombre o parte.

**RF23. Visualización de calificaciones promedio**
- Mostrar promedio de calificaciones.

**RF24. Acceso al historial de calificaciones**
- Visualizar comentarios y calificaciones.

**RF25. Visualización de información básica del emprendedor**
- Mostrar info básica asociada a emprendimiento.

----------------------------------------------
### Requerimientos No Funcionales (RNF)
----------------------------------------------

**RNF1. Validación de imágenes**
- Permitir solo JPG/PNG hasta 5MB.

**RNF2. Longitud mínima de la descripción**
- Descripción mínimo 50 caracteres.

**RNF3. Seguridad de la sesión del usuario**
- Mantener sesión segura contra accesos no autorizados.

**RNF4. Mensajes claros ante errores de inicio de sesión**
- Mostrar mensaje claro rápido por credenciales incorrectas.

**RNF5. Consistencia de la información del perfil**
- Actualizar datos sin errores ni inconsistencias.

**RNF6. Rapidez al actualizar la imagen de perfil**
- Actualizar foto rápidamente sin afectar UX.

**RNF7. Confiabilidad en cambios de emprendimientos**
- Editar/eliminar sin pérdida de info.

**RNF8. Tiempo de carga del listado de emprendimientos**
- Cargar listado rápidamente al ingresar.

**RNF9. Rapidez en los filtros del catálogo**
- Aplicar filtros de forma rápida.

**RNF10. Orden del contenido mostrado**
- Mostrar ordenado por categoría/relevancia.

**RNF11. Rendimiento del panel de estadísticas**
- Cargar estadísticas sin demoras.

**RNF12. Visualización clara de estadísticas**
- Mostrar con gráficos claros y fáciles.

**RNF13. Actualización del promedio de calificaciones**
- Actualizar promedio rápidamente con nuevas valoraciones.

**RNF14. Respuesta inmediata del sistema de calificación**
- Reaccionar inmediatamente al interactuar.

**RNF15. Rapidez en la entrega de notificaciones**
- Entregar notificaciones poco después del evento.

**RNF16. Almacenamiento confiable de notificaciones**
- Guardar notificaciones incluso offline.

**RNF17. Funcionamiento correcto de enlaces de contacto**
- Abrir enlaces sin errores.

**RNF18. Presentación clara de los métodos de contacto**
- Mostrar métodos ordenados y identificables.

**RNF19. Usabilidad del sistema**
- Fácil de usar para no técnicos.

**RNF20. Diseño adaptable a distintos dispositivos**
- Adaptable a móvil, tablet y PC.

**RNF21. Disponibilidad del sistema**
- Disponible sin interrupciones frecuentes.

**RNF22. Protección de la información del usuario**
- Proteger datos personales.

**RNF23. Mensajes claros y comprensibles**
- Mensajes claros y entendibles.

**RNF24. Estabilidad del sistema**
- Funcionamiento sin crashes en uso normal.

**RNF25. Experiencia fluida de navegación**
- Navegación rápida sin retrasos.
