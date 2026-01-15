Historia de Usuario – Calificaciones y Reseñas
Como usuario del marketplace universitario UIDE

Quiero calificar un emprendimiento y dejar una reseña basada en mi experiencia

Para que pueda expresar mi opinión y ayudar a otros miembros de la comunidad a tomar decisiones informadas.

Criterios de Aceptación (Gherkin)
Escenario: Registro de calificación y reseña exitosa
Dado que accedo al detalle de un emprendimiento específico

Cuando selecciono un puntaje en el widget de estrellas, ingreso un comentario y presiono "Enviar"

Entonces la reseña debe guardarse correctamente en la colección reseñas de Firebase, vinculando mi ID de usuario y el ID del emprendimiento.

Escenario: Restricción de calificación duplicada
Dado que ya he calificado previamente a un emprendimiento

Cuando intento enviar una nueva calificación para el mismo negocio

Entonces el sistema debe impedir el envío y mostrar el mensaje: “Ya has calificado este emprendimiento”.

Escenario: Actualización del promedio del emprendimiento
Dado que se ha guardado una nueva reseña

Cuando el sistema procesa el dato

Entonces el campo de promedio general del emprendimiento debe recalcularse (vía trigger de Firebase o lógica en el repositorio) para reflejar la calificación actualizada en tiempo real.

Escenario: Validación de campos obligatorios
Dado que estoy en el formulario de reseña

Cuando intento enviar la calificación sin seleccionar estrellas

Entonces el sistema debe mostrar una alerta indicando que la puntuación es obligatoria antes de procesar el guardado.

Flujo de Trabajo (Git)
Rama: Crear feature/calificaciones-resenas desde la rama develop.

Pull Request: Al finalizar la tarea, realizar un PR hacia develop para revisión de código (Sin hacer merge directo).
