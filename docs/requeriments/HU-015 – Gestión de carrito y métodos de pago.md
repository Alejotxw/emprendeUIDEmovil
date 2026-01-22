Historia de Usuario – Gestión de Carrito y Pago

Como usuario autenticado
Quiero gestionar mi carrito con los ítems agregados, ajustar cantidades, remover elementos y seleccionar un método de pago (efectivo o transferencia)
Para finalizar mis compras de manera segura y sencilla, con una confirmación que me devuelva al carrito actualizado (vacío si aplica).

Criterios de Aceptación (Gherkin)
Escenario: Visualización del carrito

Dado que el usuario accede al carrito desde la navegación inferior o después de agregar ítems
Cuando se carga la pantalla
Entonces el sistema debe mostrar:

Título “Mi Carrito”

Lista de ítems (ej.: “Comida Casera” por “Rommy Ríos” – $3.25)

Por cada ítem:

Checkbox (seleccionar / deseleccionar)

Ícono de eliminar (basura)

Botones + / - para cantidad

Subtotal por ítem

Total general del carrito

Si el carrito está vacío, mostrar el mensaje:

“Tu carrito está vacío”
con un botón para Explorar emprendimientos

Escenario: Ajuste de cantidad de un ítem

Dado que el carrito contiene ítems
Cuando el usuario presiona + / - en un ítem
Entonces el sistema debe:

Actualizar la cantidad en tiempo real

Recalcular el subtotal del ítem

Recalcular el total general

Validar límites (mínimo 1, máximo stock disponible)

Escenario: Eliminación de ítems del carrito

Dado que el usuario visualiza un ítem en el carrito
Cuando presiona el ícono de basura
Entonces el sistema debe solicitar confirmación (opcional)
Y remover el ítem de la lista
Y actualizar el total general del carrito.

Escenario: Selección y deselección de ítems

Dado que el carrito contiene múltiples ítems
Cuando el usuario selecciona o deselecciona un ítem mediante el checkbox
Entonces el sistema debe actualizar el estado visual
Y solo incluir los ítems seleccionados en el cálculo del total.

Escenario: Navegación a métodos de pago

Dado que el carrito contiene ítems seleccionados
Cuando el usuario presiona “Tipo de Pago” o “Método de Pago”
Entonces el sistema debe navegar a la pantalla de pago
Y mostrar el subtotal y total calculados previamente.

Escenario: Visualización de métodos de pago

Dado que el usuario accede a la pantalla de métodos de pago
Cuando la vista se carga
Entonces el sistema debe mostrar:

Opción Pago en físico (ícono personas, radio button)

Opción Pago por transferencia (ícono tarjeta, radio button)

Subtotal y total

Botón Solicitar o Pagar

Para pago en físico: mapa con ubicación del emprendimiento

Para transferencia: campos

Número de cuenta

Fecha de vencimiento

Código de seguridad (CVV)

Escenario: Pago en físico

Dado que el usuario selecciona Pago en físico
Cuando confirma la opción
Entonces el sistema debe:

Ocultar los campos de transferencia

Mostrar el mapa con marcador de ubicación

Habilitar el botón Solicitar

Generar una orden de retiro (pickup)

Escenario: Pago por transferencia

Dado que el usuario selecciona Pago por transferencia
Cuando interactúa con los campos
Entonces el sistema debe:

Mostrar los campos de pago

Validar en tiempo real:

Número de cuenta (16 dígitos)

Fecha (MM/AA)

CVV (3 dígitos)

Deshabilitar Pagar si los datos son inválidos

Mostrar errores inline

Escenario: Confirmación de pago

Dado que el usuario completa correctamente el método de pago
Cuando presiona Solicitar o Pagar
Entonces el sistema debe:

Procesar el pago (simulado o real)

Crear la orden en el backend

Mostrar mensaje de confirmación:

“¡Pago exitoso!”

Redirigir al carrito

Mostrar el carrito vacío o con los ítems restantes

Escenario: Error en el proceso de pago

Dado que ocurre un error (campos inválidos o red)
Cuando el usuario intenta pagar
Entonces el sistema debe:

Mostrar un mensaje de error (snackbar)

No navegar fuera de la pantalla

Permitir reintentar la acción

Escenario: Navegación hacia atrás

Dado que el usuario se encuentra en la pantalla de pago
Cuando presiona el botón Regresar
Entonces debe volver al carrito
Y mantener el estado original sin cambios.

Escenario: Acceso indebido a pago sin ítems

Dado que el carrito no tiene ítems
Cuando el usuario intenta acceder directamente a métodos de pago
Entonces el sistema debe:

Mostrar un mensaje de error:

“Agrega ítems al carrito primero”

O redirigir al dashboard principal.

Notas Técnicas
Firebase

Firestore

Subcolección usuarios/{userId}/carrito:

itemId

cantidad

seleccionado

timestamp

Colección ordenes:

items

metodoPago

subtotal

total

status (pendiente / confirmado)

createdAt

Auth

Uso de userId autenticado

Pagos

Simulado o integración opcional con Stripe

Flutter

ListView.builder para carrito

CheckboxListTile para selección

IconButton para + / -

Dismissible para swipe-to-delete

Pantalla de pago con Form y TextFormField

RadioListTile para métodos de pago

GoogleMapsFlutter para pago en físico

Manejo de estado global con Provider o Riverpod

Navegación con Navigator.push / pop

Diseño (Figma)

Colores institucionales

Botones/accentos en naranja #FFA500

Cards con sombras

Diseño responsive

Soporte para modo oscuro si aplica

Flujo de Trabajo (Git)

Rama: feature/carrito-pago

Pull Request: hacia develop
