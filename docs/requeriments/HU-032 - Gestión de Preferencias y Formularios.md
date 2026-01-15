**Historia de Usuario**

Como usuario de la plataforma, Quiero configurar mis preferencias visuales y registrar la información de mi emprendimiento.

Para que mi entorno de trabajo sea cómodo y mis datos se mantengan organizados y persistentes.

**Criterios de Aceptación**
Escenario 1: Cambio de tema visual
Dado que el usuario se encuentra en la pantalla de "Configuración" Cuando el usuario activa el interruptor de "Tema Oscuro" Entonces la interfaz de la aplicación debe cambiar su paleta de colores inmediatamente Y el estado debe persistir aunque se reinicie la aplicación.

Escenario 2: Registro de producto vinculado a emprendimiento
Dado que el usuario está en el formulario de "Registro de Producto" Y existen emprendimientos previamente creados Cuando el usuario selecciona un "Emprendimiento Padre" del menú desplegable Y completa los datos del producto Entonces el sistema debe guardar el producto vinculado exclusivamente a ese emprendimiento.

Escenario 3: Persistencia de datos de configuración
Dado que el usuario modificó el tamaño de la fuente a "Grande" Cuando el usuario cierra la aplicación y la vuelve a abrir Entonces la aplicación debe cargar el tamaño de fuente "Grande" consultando el almacenamiento local (SharedPreferences).