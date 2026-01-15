Historia de Usuario – Configuración y Registro
Como usuario del marketplace universitario UIDE

Quiero personalizar la apariencia de la aplicación y registrar productos asociados a un emprendimiento

Para que mi experiencia sea persistente, organizada y adaptada a mis preferencias.

Criterios de Aceptación (Gherkin)
Escenario: Acceso a la pantalla de Configuración
Dado que estoy autenticado en la aplicación

Cuando accedo a la opción "Configuración" desde el menú

Entonces el sistema muestra la pantalla de configuración con opciones de Tema (Oscuro/Claro) y Tamaño de Fuente.

Escenario: Personalización de apariencia
Dado que estoy en la pantalla de Configuración

Cuando activo o desactivo el interruptor de Tema y ajusto el Tamaño de Fuente

Entonces la aplicación aplica los cambios visuales inmediatamente en la interfaz.

Escenario: Persistencia de configuración
Dado que he modificado el Tema o el Tamaño de Fuente

Cuando cierro o reinicio la aplicación

Entonces el sistema conserva mis preferencias utilizando SharedPreferences para que no se pierdan.

Escenario: Registro de producto exitoso
Dado que estoy autenticado y accedo al formulario de registro de producto

Cuando ingreso los datos del producto y selecciono un Emprendimiento desde el dropdown (selección de Padre)

Entonces el sistema registra el producto correctamente y lo vincula al emprendimiento seleccionado.

Escenario: Validación de formulario de producto
Dado que estoy en el formulario de registro de producto

Cuando intento guardar sin completar campos obligatorios (nombre, precio o emprendimiento)

Entonces el sistema muestra mensajes de validación indicando los campos requeridos.
