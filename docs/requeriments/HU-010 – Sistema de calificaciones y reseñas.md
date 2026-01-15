Historia de Usuario – Métodos de Contacto del Emprendimiento
Como usuario del marketplace universitario UIDE

Quiero visualizar los métodos de contacto de un emprendimiento (WhatsApp, email, redes sociales)

Para que pueda comunicarme directamente con el emprendedor y resolver dudas o coordinar compras.

Criterios de Aceptación (Gherkin)
Escenario: Visualización de métodos de contacto disponibles
Dado que accedo al perfil de un emprendimiento específico

Cuando se carga la información de la base de datos

Entonces el sistema debe mostrar íconos o botones interactivos para WhatsApp, Email, Instagram y Facebook.

Escenario: Gestión de información no registrada
Dado que un emprendimiento no tiene registrado un método de contacto específico (ej. no tiene Instagram)

Cuando visualizo la sección de contacto en el perfil

Entonces ese campo debe mostrar el texto “No disponible” o el ícono debe aparecer inhabilitado (en gris).

Escenario: Acceso a aplicaciones externas
Dado que presiono un método de contacto activo (ej. el ícono de WhatsApp)

Cuando el sistema procesa la solicitud

Entonces la aplicación debe abrir automáticamente la herramienta externa correspondiente (WhatsApp, cliente de correo o navegador) utilizando url_launcher.

Escenario: Validación de datos en tiempo real
Dado que los datos provienen de Firestore

Flujo de Trabajo (Git)
Rama: Crear feature/metodos-contacto-emprendimiento desde la rama develop.

Pull Request: Al finalizar, abrir un PR hacia develop para revisión de código.

Cuando el emprendedor actualiza su número o redes desde su perfil

Entonces los cambios deben reflejarse inmediatamente en la vista del cliente sin necesidad de reiniciar la aplicación.
