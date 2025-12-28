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
<<<<<<< HEAD
* **Kevin Giron** -Full stack Developer - @KevinGiron
=======
* **Kevin Giron** - Full Stack Developer - @KevinGiron
>>>>>>> main

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

**RF1. Formulario de creación de emprendimiento:**
El sistema deberá mostrar un formulario con todos los campos necesarios (nombre, descripción, categoría, contacto, imagen/logo y estado).

**RF2. Validación de datos obligatorios:**
El sistema deberá validar que todos los campos obligatorios estén completos antes de permitir guardar o publicar.

**RF3. Acceso según rol del usuario:**
Una vez autenticado, el sistema deberá redirigir primero al cliente o usuario para luego que se elija si quiere ser emprendedor o un cliente panel correspondiente según su rol.

**RF4. Edición de información personal del usuario:**
El sistema permitira que el usuario modifique su nombre y foto desde la pantalla de perfil > configuraciones.

**RF5. Actualización de datos en Firestore y Storage:**
El sistema deberá guardar el nombre actualizado en Firestore y, si la foto cambia, subirla a Firebase Storage y asociarla al perfil.

**RF6. Visualización de emprendimientos del usuario:**
El sistema deberá mostrar al emprendedor autenticado todos los emprendimientos asociados desde Firestore.

**RF7. Gestión de emprendimientos (editar y eliminar):**
El sistema deberá permitir editar o eliminar emprendimientos, guardando cambios o eliminándolos de la base de datos tras confirmación.

**RF8. Visualización del catálogo de emprendimientos activos:**
El sistema deberá mostrar al usuario la lista de emprendimientos activos al abrir el catálogo.

**RF9. Filtrado y navegación al detalle del emprendimiento:**
El sistema deberá permitir filtrar por categoría y redirigir al detalle al seleccionar un emprendimiento.

**RF10. Visualización de métricas globales del sistema:**
El sistema deberá mostrar al administrador: total de usuarios, total de emprendimientos y total de publicaciones.

**RF11. Filtrado de métricas por rango de fechas:**
El sistema deberá actualizar las métricas del dashboard según el rango de fechas seleccionado.

**RF12. Registro de calificaciones y reseñas:**
El sistema deberá permitir enviar una calificación y comentario y guardarlos en Firestore.

**RF13. Validación de reseñas duplicadas por usuario:**
El sistema deberá impedir que un usuario califique el mismo emprendimiento más de una vez y mostrar el mensaje correspondiente.

**RF14. Visualización de notificaciones en orden cronológico:**
El sistema deberá mostrar al emprendedor una lista cronológica de notificaciones guardadas en Firestore.

**RF15. Visualización de métodos de contacto del emprendimiento:**
El sistema deberá mostrar teléfono, email del emprendimiento si están registrados.



### Requerimientos No Funcionales (RNF)

**RNF1. Validación de formato y tamaño de imagen:**
El sistema solo deberá aceptar imágenes JPG/PNG de máximo 5 MB.

**RNF2. Validación mínima de descripción:**
La descripción del emprendimiento deberá tener mínimo 50 caracteres.

**RNF3. Manejo seguro de la sesión del usuario:**
La sesión deberá almacenarse de forma segura usando Provider o SharedPreferences.

**RNF4. Retroalimentación inmediata ante credenciales incorrectas:**
El mensaje “Credenciales incorrectas” deberá aparecer en menos de 5 segundo.

**RNF5. Integridad de los datos actualizados:**
Los datos del perfil deberán actualizarse sin inconsistencias entre Firestore y Storage.

**RNF6. Optimización en la carga de la imagen de perfil:**
La imagen deberá actualizarse en menos de 5 segundos.

**RNF7. Consistencia en operaciones de modificación:**
Las operaciones de editar o eliminar emprendimientos deberán ejecutarse sin pérdida de datos.

**RNF8. Rendimiento en la carga de emprendimientos:**
La lista de emprendimientos deberá cargarse en máximo 2–4 segundos.

**RNF9. Eficiencia en el filtrado del catálogo:**
Los filtros deberán aplicarse en menos de 2 segundos.

**RNF10. Orden y relevancia del contenido mostrado:**
Los emprendimientos deberán mostrarse ordenados según categoría o relevancia definida.

**RNF11. Optimización de consultas agregadas:**
Las métricas del dashboard deberán cargar en máximo 3–4 segundos.

**RNF12. Representación visual clara y comprensible:**
Las métricas deberán representarse mediante gráficos legibles y de alto rendimiento.

**RNF13. Cálculo eficiente del promedio de calificaciones:**
El promedio deberá actualizarse sin retrasos perceptibles.

**RNF14. Fluidez del widget de calificación:**
El widget deberá reaccionar al toque de forma instantánea incluso en dispositivos de gama media.

**RNF15. Entrega oportuna de notificaciones:**
Las notificaciones deberán recibirse en máximo 5 segundos después del evento.

**RNF16. Persistencia confiable del historial de notificaciones:**
Las notificaciones deberán almacenarse sin riesgos de pérdida, incluso offline.

**RNF17. Integración confiable con servicios externos de contacto:**
Los enlaces deben abrirse correctamente mediante url_launcher sin errores.

**RNF18. Orden y claridad en la presentación de métodos de contacto:**
Los métodos de contacto deberán mostrarse de forma organizada y accesible para el usuario.



