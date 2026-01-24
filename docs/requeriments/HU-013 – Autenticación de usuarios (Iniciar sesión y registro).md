Historia de Usuario – Autenticación de Usuarios (Login & Registro)

Como usuario de la plataforma UIDE
Quiero poder iniciar sesión con mi correo y contraseña o registrarme con mis datos personales
Para acceder de manera segura a las funcionalidades de la aplicación y crear una cuenta nueva si no la tengo.

Criterios de Aceptación (Gherkin)
Escenario: Visualización de la pantalla de inicio de sesión

Dado que el usuario abre la pantalla de autenticación inicial
Cuando selecciona la opción “Iniciar sesión”
Entonces el sistema debe mostrar un formulario con:

Campo Correo (email)

Campo Contraseña

Botón Ingresar

Enlace “Regístrate una cuenta”

Escenario: Inicio de sesión exitoso

Dado que el usuario ingresa credenciales válidas
Cuando presiona el botón Ingresar
Entonces el sistema debe autenticarlo correctamente
Y redirigirlo al dashboard principal de la aplicación.

Escenario: Error por credenciales inválidas

Dado que el usuario ingresa un correo o contraseña incorrectos
Cuando presiona Ingresar
Entonces el sistema debe mostrar un mensaje de error
Y el mensaje debe indicar:

“Correo o contraseña incorrectos”.

Escenario: Navegación entre login y registro

Dado que el usuario se encuentra en la vista de inicio de sesión
Cuando selecciona el enlace “Regístrate una cuenta”
Entonces el sistema debe cargar la vista de registro sin errores
Y mantener el diseño responsivo y el estado visual (modo claro/oscuro si aplica).

Escenario: Visualización del formulario de registro

Dado que el usuario accede a la vista de registro
Cuando la pantalla se carga
Entonces el sistema debe mostrar los campos:

Nombre completo

Correo institucional (email)

Contraseña

Botón Registrarse

Enlace “Inicia sesión”

Escenario: Registro exitoso de un nuevo usuario

Dado que el usuario completa el formulario con datos válidos
Y el correo no existe previamente en el sistema
Cuando presiona Registrarse
Entonces el sistema debe crear la cuenta correctamente
Y almacenar los datos adicionales del usuario
Y redirigirlo al dashboard principal o a una pantalla de confirmación.

Escenario: Registro con correo ya existente

Dado que el usuario intenta registrarse con un correo ya registrado
Cuando presiona Registrarse
Entonces el sistema debe mostrar un mensaje de error
Y el mensaje debe indicar:

“El correo ya está registrado”.

Escenario: Validación de campos en tiempo real

Dado que el usuario ingresa datos inválidos o deja campos vacíos
Cuando intenta enviar el formulario
Entonces el sistema debe validar en tiempo real
Y mostrar errores inline como:

Formato de email inválido

Contraseña con menos de 6 caracteres

Notas Técnicas

Firebase Authentication

Login: signInWithEmailAndPassword

Registro: createUserWithEmailAndPassword

Validación de email único incluida por Firebase

Firestore

Al registrar un usuario, crear documento en la colección users con:

displayName

email

createdAt (timestamp)

Flutter

Uso de Form y TextFormField con validadores:

EmailValidator

MinLengthValidator

ElevatedButton para acciones

Navegación con Navigator o PageView para alternar login/registro

Diseño

Basado en mockups de Figma

Colores institucionales para login

Gris #808080 para registro

Diseño responsive usando MediaQuery

Persistencia segura con flutter_secure_storage

Flujo de Trabajo (Git)

Rama: Crear feature/auth-login-register desde develop

Pull Request:

Realizar PR hacia develop

No realizar merge directo

Código sujeto a revisión
