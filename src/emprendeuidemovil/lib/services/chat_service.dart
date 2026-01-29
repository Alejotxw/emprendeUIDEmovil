import 'dart:async';

class ChatService {
  // Simula la llamada a una API
  Future<String> sendMessage(String message) async {
    await Future.delayed(const Duration(milliseconds: 800));

    final lowerMsg = message.toLowerCase();
    
    // --- LÓGICA DE RESPUESTA PROFESIONAL ---

    // 1. SALUDO INICIAL Y AYUDA GENERAL
    if (lowerMsg.contains('hola') || lowerMsg.contains('buenos') || lowerMsg.contains('saludos')) {
      return "Estimado usuario, es un placer saludarle. Soy el asistente virtual de Emprende UIDE. 🤖\n\n"
             "¿En qué puedo asistirle el día de hoy con respecto a nuestra plataforma de Marketplace universitario?";
    }

    // 2. EXPLICACIÓN DEL SISTEMA (Marketplace UIDE)
    if (lowerMsg.contains('que es') || lowerMsg.contains('sistema') || lowerMsg.contains('de que trata')) {
      return "Emprende UIDE es un Marketplace exclusivo para la comunidad universitaria. "
             "Aquí, estudiantes y docentes pueden publicar productos o servicios, permitiendo que otros miembros de la comunidad los soliciten o compren de manera directa y segura.";
    }

    // 3. ROL CLIENTE (Navegación y Funciones)
    if (lowerMsg.contains('cliente') || lowerMsg.contains('comprar') || lowerMsg.contains('buscar')) {
      return "Como **Cliente**, usted dispone de una experiencia completa:\n\n"
             "• **Exploración:** Visualice productos y emprendimientos destacados desde el inicio. Puede usar la barra de búsqueda o filtrar por categorías.\n"
             "• **Favoritos:** Guarde los emprendimientos que le resulten interesantes en la sección de 'Guardados'.\n"
             "• **Gestión de Compra:** Acceda al carrito (subdividido en productos y servicios) para gestionar sus pedidos.\n"
             "• **Pagos:** El sistema soporta pagos en físico o mediante transferencia bancaria.";
    }

    // 4. ROL EMPRENDEDOR (Gestión y Creación)
    if (lowerMsg.contains('emprendedor') || lowerMsg.contains('vender') || lowerMsg.contains('crear')) {
      return "Para los **Emprendedores**, la plataforma ofrece herramientas de gestión robustas:\n\n"
             "• **Solicitudes:** Pantalla dedicada para gestionar pedidos de productos o servicios recibidos.\n"
             "• **Creación:** Usted puede generar y administrar múltiples emprendimientos simultáneamente.\n"
             "• **Feedback:** En su perfil podrá revisar los comentarios y reseñas que los clientes dejan sobre su trabajo.";
    }

    // 5. PERFIL DE OTROS EMPRENDEDORES
    if (lowerMsg.contains('perfil de otro') || lowerMsg.contains('ver emprendedor') || lowerMsg.contains('nombre')) {
      return "Al seleccionar el nombre de un emprendedor en cualquier parte de la app, usted será dirigido a su **Perfil Público**. "
             "Allí podrá visualizar todos los servicios que tiene disponibles y su reputación dentro de la comunidad.";
    }

    // 6. CONFIGURACIONES Y PERSONALIZACIÓN
    if (lowerMsg.contains('configuracion') || lowerMsg.contains('ajustes') || lowerMsg.contains('perfil') || lowerMsg.contains('tema')) {
      return "En el apartado de **Configuraciones**, usted tiene el control total de su experiencia:\n\n"
             "• **Perfil:** Edite su información personal en cualquier momento.\n"
             "• **Personalización:** Cambie entre el tema claro o oscuro según su preferencia.\n"
             "• **Notificaciones:** Opción para silenciar alertas.\n"
             "• **Historial:** Revise sus reseñas y el estado de 'Mis pedidos'.";
    }

    // 7. DESARROLLADORES (Mantenido del anterior pero con tono formal)
    if (lowerMsg.contains('quien') || lowerMsg.contains('creo') || lowerMsg.contains('equipo')) {
      return "Esta iniciativa fue desarrollada por un distinguido equipo de estudiantes de la UIDE conformado por: "
             "Lander González, Luis Ramírez, Sebastián Chocho, Aidan Carpio, Malena Orbea y Kevin Giron.";
    }

    // 8. CIERRE / GRACIAS
    if (lowerMsg.contains('gracias')) {
      return "Ha sido un gusto informarle. Quedo a su entera disposición si requiere más detalles sobre el funcionamiento de Emprende UIDE. ¡Que tenga un excelente día!";
    }

    // FALLBACK (Respuesta por defecto profesional)
    return "Disculpe, no he logrado identificar su requerimiento con exactitud. 😅\n\n"
           "¿Podría serme más específico? Puedo informarle sobre:\n"
           "👉 Funciones del Cliente y Marketplace.\n"
           "👉 Herramientas para Emprendedores.\n"
           "👉 Ajustes de Perfil y Temas.\n"
           "👉 Cómo ver perfiles de otros vendedores.";
  }
}