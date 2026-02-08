# Guía de Configuración del Backend y Firebase

Sigue estos pasos para configurar correctamente tu backend y conectarlo con Firebase.

## 1. Crear Proyecto en Firebase

1. Ve a [Firebase Console](https://console.firebase.google.com/).
2. Haz clic en **"Agregar proyecto"**.
3. Ponle un nombre (ej: `emprende-uide-movil`).
4. Desactiva Google Analytics si no lo necesitas (opcional).
5. Haz clic en **"Crear proyecto"**.

## 2. Configurar Firestore Database

1. En el panel izquierdo, ve a **Compilación > Firestore Database**.
2. Haz clic en **"Crear base de datos"**.
3. **Selecciona "Edición Standard"** (tal como se ve en la imagen que me mostraste). Luego haz clic en **Siguiente**.
4. Selecciona la ubicación del servidor. **Deja la que viene por defecto** (en tu imagen aparece `nam5 (United States)`), es la mejor opción. Luego haz clic en **Siguiente**.
5. Selecciona **"Comenzar en modo de prueba"** (la segunda opción).
   - Esto es ideal para empezar, ya que te deja guardar y leer datos sin bloqueos por 30 días.
6. Haz clic en el botón azul **"Crear"**.

¡Listo! Ya tienes tu base de datos vacía.

## 3. Configurar Firebase Storage (Para Fotos)

1. En el panel izquierdo, ve a **Compilación > Storage**.
2. **Si te aparece el mensaje "Actualizar proyecto" y luego "Crea una cuenta de Facturación":**
   - Haz clic en **"Crea una cuenta de Facturación de Cloud"**.
   - Esto es un requisito de Google Cloud para habilitar servicios de almacenamiento en algunas regiones.
   - Sigue los pasos: Elige tu país, acepta los términos y, si te pide una tarjeta, ponla con confianza. **Google NO te cobrará nada** mientras solo estemos haciendo pruebas (tienes un límite gratuito de 5GB de fotos, que es muchísimo para este proyecto).
   - Una vez creada la cuenta de facturación, regresa a Firebase y selecciona el **Plan Blaze**.
3. Haz clic en el botón **"Comenzar"** (Ahora ya debería aparecerte).
4. Selecciona **"Comenzar en modo de prueba"**.
5. Elige la ubicación del servidor (usa `us-central1` si no sabes cuál elegir).
6. Haz clic en **"Listo"**.
7. **REGLAS DE ACCESO (FUNDAMENTAL)**: Ve a la pestaña **Reglas** y asegúrate de que el código sea exactamente este:
   ```javascript
   rules_version = '2';
   service firebase.storage {
     match /b/{bucket}/o {
       match /{allPaths=**} {
         allow read, write: if true;
       }
     }
   }
   ```
   *Pulsa en **"Publicar"** para guardar los cambios.*

---

## 7. Configuración de Colecciones (Basado en tu código)

Ahora, viendo la imagen que me pasaste (donde sale "Tu base de datos está lista"), lo que debes hacer es dar clic en **"+ Iniciar colección"** para crear las estructuras que tu App y Backend esperan.

He analizado tu código en `lib/` y en `src/backend/` y estas son las 3 colecciones que DEBES crear para que todo funcione conectado:

### 1. Colección `users` (Usuarios y Perfiles)
**Esta colección DEBE tener todos los campos del formulario de "Editar Perfil" y Login.**

1. Haz clic en **"+ Iniciar colección"**.
2. ID de colección: **`users`**. Siguiente.
3. **Primer Documento (Tu Usuario Adm/Vendedor):**
   *   **ID de documento**: Dale a **"ID automático"**.
   *   **Campo**: `email` | **Tipo**: string | **Valor**: `prueba@uide.edu.ec`
   *   **Campo**: `nombre` | **Tipo**: string | **Valor**: `Usuario Prueba`
   *   **Campo**: `rol` | **Tipo**: string | **Valor**: `vendedor`
   *   **Campo**: `phone` | **Tipo**: string | **Valor**: `0991234567` (Para el formulario de perfil).
   *   **Campo**: `imagePath` | **Tipo**: string | **Valor**: `` (Déjalo vacío o pon una URL de prueba).

   **⚠️ SOLUCIÓN DEFINITIVA (Si el botón sigue gris):**
   Es muy probable que haya **un campo vacío extra** que no ves o que el navegador se quedó "trabado".
   1. **Dale a "Cancelar"** para cerrar esa ventana.
   2. **Refresca la página** de Firebase (presiona F5).
   3. Vuelve a dar clic en **"Iniciar colección"**.
   4. ID: `users` > ID Automático.
   5. Solo llena UN campo: `email` = `prueba@uide.edu.ec`.
   6. **BORRA** cualquier fila extra vacía con el botón `(-)` a la derecha.
   7. Dale a **"Guardar"**.
   8. (Luego entras al documento creado y le añades `nombre`, `rol`, `phone` con el botón "Agregar campo").

---

### 2. Colección `emprendimientos` (Formulario Completo)
**Esta es crítica. Debe tener todos los campos que pide tu pantalla `FormEmprendimientoScreen.dart`.**

1. Haz clic en **"+ Iniciar colección"**.
2. ID de colección: **`emprendimientos`**. Siguiente.
3. **Primer Documento (Emprendimiento de Prueba):**
   *   **ID de documento**: **Automático**.
   *   **Campo**: `title` | **Tipo**: `string` | **Valor**: `Delicias Caseras`
   *   **Campo**: `subtitle` | **Tipo**: `string` | **Valor**: `Postres ricos y artesanales`
   *   **Campo**: `category` | **Tipo**: `string` | **Valor**: `Comida`
   *   **Campo**: `ownerId` | **Tipo**: `string` | **Valor**: *(Copia y pega el ID del documento `users` que creaste arriba)*.
   *   **Campo**: `imagePath` | **Tipo**: `string` | **Valor**: `` (Vacío por ahora).
   *   **Campo**: `location` | **Tipo**: `string` | **Valor**: `Sede Loja Universidad Internacional del Ecuador`.
   *   **Campo**: `schedule` | **Tipo**: `map` (Mapa) -> Dentro agrega:
      *   `days`: **Tipo**: `string` | **Valor**: `Lun - Vie`
      *   `openTime`: **Tipo**: `string` | **Valor**: `09:00`
      *   `closeTime`: **Tipo**: `string` | **Valor**: `18:00`
   *   **Campo**: `services` | **Tipo**: `array` (Matriz) -> Déjala vacía por ahora (se llenará desde la App).
   *   **Campo**: `products` | **Tipo**: `array` (Matriz) -> Déjala vacía por ahora.

### 3. Colección `productos` (Sincronizado)
Aunque tu formulario guarda productos dentro de `emprendimientos`, tu código también busca una colección suelta para listados rápidos.

1. Haz clic en **"+ Iniciar colección"**.
2. ID de colección: **`productos`**.
3. Campos:
   - `name`: **Tipo**: `string` | **Valor**: `Hamburguesa`
   - `price`: **Tipo**: `number` | **Valor**: `5.50`
   - `emprendimientoId`: **Tipo**: `string` | **Valor**: *(ID del emprendimiento de arriba)*
   - `description`: **Tipo**: `string` | **Valor**: `Hamburguesa clásica`
   - `imagePath`: **Tipo**: `string` | **Valor**: ``
   - `stock`: **Tipo**: `number` | **Valor**: `10`

### 4. Colección `ratings` (Calificaciones)
Para que funcionen las estrellas y comentarios (`ratings_service.dart`).

1. Haz clic en **"+ Iniciar colección"**.
2. ID de colección: **`ratings`**.
3. Campos:
   - `rating`: **Tipo**: `number` | **Valor**: `5`
   - `comment`: **Tipo**: `string` | **Valor**: `Excelente servicio`
   - `userId`: **Tipo**: `string` | **Valor**: *(ID del usuario)*
   - `emprendimientoId`: **Tipo**: `string` | **Valor**: *(ID del emprendimiento)*

---

## ## 9. Próximos Pasos: Probar la App

¡Ya configuraste la Base de Datos! Pero falta un paso vital para poder entrar a tu App con el usuario de prueba que creamos.

**1. Crear el Usuario en Authentication:**
Aunque creamos el documento en la base de datos (colección `users`), necesitamos crear las credenciales de acceso.
1. Ve al panel izquierdo de Firebase > **Authentication**.
2. Haz clic en **"Agregar usuario"**.
3. Correo electrónico: `prueba@uide.edu.ec` (El mismo que pusiste en la base de datos).
4. Contraseña: `123456` (o la que tú quieras).
5. Haz clic en **"Agregar usuario"**.

**3. Ejecutar la App:**
1. Ve a tu código en Flutter (`src/emprendeuidemovil`).
2. Ejecuta la app en tu emulador o celular.
3. En la pantalla de Login, ingresa:
   *   **Correo**: `prueba@uide.edu.ec`
   *   **Contraseña**: `123456`
4. ¡Si entra, la conexión de LOGIN funciona!

---

## 10. ¿Por qué sigo viendo datos de ejemplo? (IMPORTANTE)

Si ves en tu pantalla cosas como **"Hola, Alejandro"**, **"Delicias Caseras"** o **"Diseño Web"**, **¡ES NORMAL!**

*   **Estado Actual**: Tu aplicación está programada para mostrar **Datos de Prueba (Mock Data)** para que puedas diseñar la interfaz sin internet.
*   **La Base de Datos**: Ya está creada y lista en Firebase (pasos 1-8).
*   **Siguiente Paso de Programación**: Ahora debes actualizar tus archivos de Flutter (`service_provider.dart`, `user_profile_provider.dart`) para que dejen de usar los datos falsos y empiecen a leer de la Base de Datos que acabamos de crear.

**¡Tu infraestructura está lista! Solo falta conectar los cables en el código.**

---

## 11. Solución de Errores Comunes

### Error: `Couldn't resolve the package 'firebase_auth'`
Si al ejecutar `flutter run` te sale este error rojo, es porque falta la librería de autenticación.
**Solución:**
1.  Abre tu terminal en la carpeta `src/emprendeuidemovil`.
2.  Ejecuta: `flutter pub add firebase_auth`.
3.  Vuelve a ejecutar `flutter run`.

*(Nota: Yo ya agregué esta librería a tu archivo `pubspec.yaml` automáticamente, así que solo necesitas reiniciar la app).*

---

## 12. Personalización Completada

Hemos realizado los siguientes cambios en tu código para que la App deje de ser una maqueta y sea real:
1.  **Nombre Real**: En la pantalla de inicio, ahora dice "Hola, [Tu Nombre]" (leído desde Firebase) en lugar de "Hola, Alejandro".
2.  **Fotos de Perfil**: El perfil ahora soporta fotos subidas a internet. Si cambias tu foto en otro celular, se verá aquí porque ya no guardamos solo la ruta local.
3.  **Persistencia**: Si cierras sesión y vuelves a entrar, tus cambios de nombre y teléfono se mantienen guardados en la nube.


---

## 13. ¡IMPORTANTE! Si el Registro Falla (Protección contra Enumeración)

Si ya habilitaste "Correo/Contraseña" (como se ve en tu captura) y **todavía te sale el error rojo**, es por una nueva seguridad de Google llamada "Protección contra enumeración de correo".

**Para que TODOS puedan registrarse sin problemas (y sin que tú hagas nada más), haz esto:**

1.  Ve a **Firebase Console** -> **Authentication**.
2.  Entra en la pestaña **Settings** (Configuración).
3.  Busca la sección **User actions** (Acciones de usuario) o **Security**.
4.  Desmarca la casilla que dice **"Email enumeration protection"** (Protección de enumeración de correo electrónico).
5.  Dale a **Guardar** (Save).

al hacer esto, eliminas el requisito de verificación compleja y **cualquier persona que descargue tu App podrá registrarse libremente**.

---

## 14. Si SIGUE fallando: La Huella Digital (SHA-1)


---

## 14. Si SIGUE fallando: La Huella Digital (SHA-1)


---


---


---


---

## 14. ¡SOLUCIÓN FINAL! Tu App no está registrada

Tu captura de pantalla muestra que **NO tienes ninguna app creada** en Firebase. Ese es el problema raíz. Aunque tengas el archivo en tu PC, Firebase no "conoce" tu app.

**Pasos para arreglarlo ahora mismo:**

1.  En esa pantalla de "No hay apps en tu proyecto", haz clic en el **icono de Android** (el robot).
2.  Llena los datos así:
    *   **Nombre del paquete:** `com.example.emprendeuidemovil`
    *   **Sobrenombre:** `Emprende UIDE`
    *   **Certificado SHA-1:** Copia y pega este código:
        `70:C4:13:1E:BA:93:5F:41:6C:72:82:5F:72:D2:90:14:40:BB:A2:38`
3.  Dale clic al botón azul **Registrar app**.
4.  **MUY IMPORTANTE:** Te pedirá descargar `google-services.json`.
    *   Descárgalo.
    *   **MUEVELO** a la carpeta: `src/emprendeuidemovil/android/app/`
    *   **BORRA** el archivo viejo que hay ahí.
    *   **PEGA** el nuevo. (Asegúrate que se llame `google-services.json` y no tenga numeros como `(1)`).

5.  **IGNORA EL PASO 3 (Agregar SDK)**: Firebase te mostrará código para `build.gradle`. **NO LO TOQUES**. Tu proyecto Flutter ya lo tiene listo.
6.  Dale a "Siguiente" hasta terminar e ir a la consola.

7.  En tu terminal:
    *   Detén la app (`Control + C`).
    *   Ejecuta `flutter clean`.
    *   Ejecuta `flutter run`.

¡Con esto funcionará el registro sí o sí!

