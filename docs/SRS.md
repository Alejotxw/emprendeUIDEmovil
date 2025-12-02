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
EMPRENDEUIDEMOVIL/
├── backend/                  # API REST Express
│   ├── node_modules          # Dependencias de Node.js (ignoradas por Git)
│   ├── src/                  # Código fuente del Backend
│   │   ├── auth.routes.js    # Definición de rutas de Autenticación (Login, Registro)
│   │   ├── firebase.js       # Configuración o utilidades de Firebase Admin
│   │   ├── index.js          # Servidor principal (Punto de entrada)
│   │   └── products.routes.js# Definición de rutas de Productos/Emprendimientos
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
│       │   └── main.dart     # Punto de entrada y Widget principal (App)
│       ├── test/             # Pruebas de la aplicación Flutter
│       ├── assets/           # (Implícito) Imágenes, fuentes, íconos
│       ├── pubspec.yaml      # Dependencias de Flutter (paquetes)
│       └── ...               # Otros archivos de configuración de Flutter (.metadata, .gitignore, etc.)
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

