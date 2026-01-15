Historia de usuario
Como usuario autenticado (cliente o emprendedor), quiero acceder a mi perfil para visualizar y editar información personal, ver mis reseñas y ratings, consultar pedidos, configurar notificaciones y privacidad, y contactar soporte vía chatbot integrado, para mantener control sobre mi cuenta y recibir asistencia rápida en la app.

Criterios de Aceptación

Dado que el usuario accede al perfil desde la navegación inferior
Cuando se carga la pantalla
Entonces debe mostrar "Mi Perfil" con foto de perfil (placeholder si no hay), nombre completo (e.g., "Sebastián Chochó"), email (e.g., "sechocosi@uide.edu.ec"), botones toggle "Cliente" (seleccionado por default) / "Emprendedor" (cambia vista si aplica), secciones navegables: "Mis Reseñas", "Rating de Servicios", "Mis Pedidos", "Configuraciones", y botón rojo "Cerrar sesión" al final; footer con versión "TAEK v1.0" y navegación.
Dado que el usuario toggles entre "Cliente" y "Emprendedor"
Cuando interactúa
Entonces debe cambiar el rol temporalmente (persistir en Firestore), ajustar secciones visibles (e.g., emprendedor ve dashboard de ventas) y actualizar UI (botón activo en naranja).
Dado que el usuario presiona "Cerrar sesión"
Cuando confirma dialog
Entonces debe logout via Firebase Auth, limpiar storage local y redirigir a pantalla de login.
Dado que el usuario accede a "Mis Reseñas"
Cuando se carga
Entonces debe mostrar lista de reseñas (e.g., "Comida Casera" por "Rommy Rios" $12.00 con texto editable, check para publicar/editar, basura para eliminar, corazón para like); si vacío, mostrar "No tienes reseñas".
Dado que el usuario edita o elimina una reseña
Cuando interactúa (check o basura)
Entonces debe abrir modal para editar texto o confirmar eliminación, actualizar en backend y refrescar lista.
Dado que el usuario accede a "Rating de Servicios"
Cuando se carga
Entonces debe mostrar grid de servicios/productos (e.g., "Comida Casera" por "Rommy Rios" con estrellas calificables 1-5, texto descriptivo); permitir rating nuevo si no calificado, promedio visible.
Dado que el usuario califica un servicio (e.g., arrastra estrellas)
Cuando envía
Entonces debe guardar rating en Firestore, actualizar promedio y mostrar toast "¡Rating guardado!".
Dado que el usuario accede a "Mis Pedidos"
Cuando se carga
Entonces debe mostrar lista cronológica de pedidos (e.g., "Diseño web y Posters" por "Kevin Girón" $10.00 con badge de cantidad, status: Pendiente (gris), Aceptado (verde), Rechazado (rojo), botón para detalles); filtro por status si >5 items.
Dado que un pedido cambia de status (real-time)
Cuando notifica
Entonces debe actualizar badge y color en lista via StreamBuilder.
Dado que el usuario presiona "Configuraciones"
Cuando se carga
Entonces debe mostrar: edición de perfil (nombre, teléfono con botón "Editar" que emerge modal/pantalla overlay con campos TextFormField, "Cancelar"/"Guardar cambios"), toggles para notificaciones (generales, solicitudes), selector de idioma (Español/English), enlaces a "Privacidad y Seguridad" y "Ayuda y Soporte".
Dado que el usuario presiona "Editar" en perfil
Cuando interactúa
Entonces debe emergir una pantalla modal o full-screen con campos prellenados (e.g., nombre editable, teléfono con máscara), validación (e.g., teléfono 10 dígitos), botones "Cancelar" (cierra sin guardar) y "Guardar cambios" (actualiza Firestore y cierra).
Dado que el usuario accede a "Privacidad y Seguridad"
Cuando se carga
Entonces debe mostrar status "Cuenta protegida" (check verde si 2FA activo), toggles para visibilidad pública de email/teléfono, enlaces a "Política de Privacidad" y "Términos de Uso" (abre webview).
Dado que el usuario toggles visibilidad (e.g., email)
Cuando guarda
Entonces debe actualizar preferencias en user doc de Firestore y aplicar en perfiles públicos.
Dado que el usuario accede a "Ayuda y Soporte"
Cuando se carga
Entonces debe mostrar íconos "Email" y "WhatsApp"
Notas Técnicas

Firebase: Usar Auth para user data (displayName, email, photoURL); Firestore para usuarios/{userId} (campos: rol, telefono, notificaciones: map, idioma, privacidad: map, createdAt) y subcolecciones reseñas {servicioId, texto, editable: bool, likes}, ratings {servicioId, estrellas: int, comentario}, pedidos {emprendimientoId, items: array, status: enum, total, timestamp}.
Flutter: Implementar perfil con Scaffold y ListView para secciones, CircleAvatar para foto (upload via image_picker), ToggleButtons para rol, Navigator.push para sub-pantallas (e.g., MisReseñas como StatefulWidget con ListView.builder). Para edición: showModalBottomSheet o Navigator.push con Form y TextFormField (validators, InputFormatter para teléfono). Ratings con flutter_rating_bar. Pedidos con StreamBuilder para real-time.
Figma: Basado en mockups adjuntos – colores institucionales para headers/acciones críticas, naranja (#FFA500) para botones activos, verde (#00FF00) para checks/aceptados; cards con shadows, responsive grid para ratings. Prototipo interacciones para modal edición y chat flow.
GitHub: Crear branch hacia develop feature/(su tarea HU), y realizar un PR (NO HACER MERGE)

Diseño y Estilo (Figma)
Colores: Naranja (#開A500) para estados activos, Verde (#00FF00) para confirmaciones, Rojo para acciones críticas (Cerrar sesión/Rechazado).

Interacciones: Animaciones suaves en los toggles y sombras sutiles en las tarjetas de pedidos.

Flujo de Trabajo (Git)
Rama: Crear feature/perfil-usuario-gestion desde la rama develop.

Pull Request: Al terminar, abrir un PR hacia develop para revisión de pares (No realizar merge directo).
