# Requerimientos del Proyecto EmprendeUIDE

## Requerimientos Funcionales
RF01: El sistema deberá permitir el registro de nuevos usuarios mediante correo y contraseña.
RF02: El sistema deberá permitir el inicio de sesión seguro a través de Firebase Authentication.
RF03: El sistema deberá permitir a los usuarios recuperar su acceso mediante el envío de correos de restablecimiento.
RF04: El sistema deberá permitir la creación y personalización de perfiles de emprendimiento.
RF05: El sistema deberá permitir la publicación de productos con nombre, descripción y precio.
RF06: El sistema deberá permitir la gestión de servicios disponibles con sus respectivos horarios.
RF07: El sistema deberá permitir a los clientes añadir múltiples productos al carrito de compras.
RF08: El sistema deberá permitir la visualización del historial de pedidos realizados por el usuario.
RF09: El sistema deberá permitir a los emprendedores recibir y gestionar solicitudes de servicios.
RF10: El sistema deberá permitir el envío de mensajes en tiempo real entre cliente y vendedor.
RF11: El sistema deberá permitir la carga de imágenes de comprobantes para pagos por transferencia.
RF12: El sistema deberá permitir a los usuarios calificar los negocios con una escala de 1 a 5 estrellas.
RF13: El sistema deberá permitir la redacción de reseñas detalladas sobre la experiencia de compra.
RF14: El sistema deberá permitir al administrador realizar la eliminación de usuarios y sus datos en cascada.
RF15: El sistema deberá permitir al administrador la creación y difusión de eventos institucionales.
RF16: El sistema deberá permitir la búsqueda y filtrado de emprendimientos por categorías específicas.
RF17: El sistema deberá permitir la visualización de la ubicación geográfica de los emprendimientos.
RF18: El sistema deberá permitir la actualización del estado de los pedidos (Pendiente, Aceptado, Entregado).
RF19: El sistema deberá permitir a los usuarios configurar la visibilidad de su información de contacto.
RF20: El sistema deberá permitir a los emprendedores responder formalmente a las reseñas de sus clientes.

## Requerimientos No Funcionales
RNF01: El sistema deberá utilizar Firebase Firestore como el motor principal de base de datos NoSQL.
RNF02: El sistema deberá asegurar que la carga de imágenes no bloquee el hilo principal de la interfaz.
RNF03: El sistema deberá ofrecer una interfaz adaptativa con soporte total para el modo oscuro.
RNF04: El sistema deberá garantizar tiempos de carga de datos menores a 3 segundos en condiciones normales.
RNF05: El sistema deberá proteger la integridad de los datos mediante reglas de seguridad de Firestore.
RNF06: El sistema deberá soportar el almacenamiento y renderizado de imágenes en formato Base64.
RNF07: El sistema deberá ser desarrollado utilizando el patrón de gestión de estados Provider.
RNF08: El sistema deberá mantener compatibilidad con dispositivos móviles Android API 21 en adelante.
RNF09: El sistema deberá seguir los lineamientos estéticos y de usabilidad de Material Design 3.
RNF10: El sistema deberá asegurar que al eliminar un negocio se borren todas sus reseñas y pedidos asociados.
RNF11: El sistema deberá garantizar una disponibilidad del servicio del 99.9% mediante Google Cloud.
RNF12: El sistema deberá capturar y gestionar errores de conexión sin degradar la experiencia del usuario.
RNF13: El sistema deberá optimizar el uso de recursos de red para minimizar el consumo de datos móviles.
RNF14: El sistema deberá cumplir con los estándares internacionales de protección de datos personales.
RNF15: El sistema deberá ser capaz de manejar al menos 100 transacciones simultáneas de pedidos.
RNF16: El sistema deberá estructurarse mediante una arquitectura de capas (Modelos, Providers, Screens).
RNF17: El sistema deberá validar la calidad y tamaño de los archivos antes de subirlos a Firebase Storage.
RNF18: El sistema deberá mostrar indicadores de carga (Spinners) en todas las transacciones asíncronas.
RNF19: El sistema deberá ser modular para facilitar la integración de futuras pasarelas de pago.
RNF20: El sistema deberá implementar Firebase Cloud Messaging para el envío eficiente de notificaciones.
