import 'dart:async';

class ChatService {
  // Simulates an API call
  Future<String> sendMessage(String message) async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));

    // Mock logic for "AI" responses
    // Normalize message
    final lowerCaseMessage = message.toLowerCase();
    
    // --- DATABASE OF KNOWLEDGE (Based on Project README) ---
    
    // 1. PROJECT INFO & ORIGIN
    if (lowerCaseMessage.contains('proyecto') || lowerCaseMessage.contains('creo') || lowerCaseMessage.contains('hizo') || lowerCaseMessage.contains('quien')) {
      return "Este proyecto 'Emprende UIDE' fue desarrollado por un equipo de 5 estudiantes de la UIDE:\n\n"
             "• Lander González\n"
             "• Luis Ramírez\n"
             "• Sebastián Chocho\n"
             "• Aidan Carpio\n"
             "• Malena Orbea\n"
             "• Kevin Giron\n\n"
             "El objetivo es fomentar el emprendimiento estudiantil dentro de la universidad.";
    }
    
    // 2. TECH STACK
    if (lowerCaseMessage.contains('tecnologia') || lowerCaseMessage.contains('lenguaje') || lowerCaseMessage.contains('stack') || lowerCaseMessage.contains('flutter')) {
      return "La aplicación está construida con tecnología moderna:\n\n"
             "📱 **Frontend:** Flutter 3.x (Dart)\n"
             "💻 **Backend:** Node.js con Express\n"
             "🔥 **Base de Datos:** Firebase (Firestore & Auth)\n"
             "🚀 **Despliegue:** Soporte para Android, iOS, Windows y Web.";
    }

    // 3. USAGE - HOW TO APP
    if (lowerCaseMessage.contains('como funciona') || lowerCaseMessage.contains('uso') || lowerCaseMessage.contains('usar') || lowerCaseMessage.contains('hacer')) {
      return "¡Es muy fácil! La app tiene dos roles:\n\n"
             "1. **Cliente:** Explora productos, añádelos al carrito y contacta a los emprendedores.\n"
             "2. **Emprendedor:** Sube tus productos o servicios para que toda la comunidad UIDE los vea.\n\n"
             "Prueba navegar por las pestañas inferiores para ver el 'Inicio. o tu 'Perfil'.";
    }

    // 4. USAGE - BUYING/SELLING
    if (lowerCaseMessage.contains('comprar') || lowerCaseMessage.contains('pedir') || lowerCaseMessage.contains('vender')) {
      return "🛒 **Para Comprar:** Ve al Inicio, selecciona un producto y añádelo al carrito.\n\n"
             "📢 **Para Vender:** Regístrate como 'Emprendedor' y ve a la sección 'Mis Emprendimientos' para publicar tu primer servicio.";
    }

    // 5. ACCOUNT & REGISTRATION
    if (lowerCaseMessage.contains('registro') || lowerCaseMessage.contains('cuenta') || lowerCaseMessage.contains('logiar') || lowerCaseMessage.contains('entrar')) {
      return "Puedes registrarte desde la pantalla de inicio de sesión. Necesitas un correo válido. Si eres estudiante, te recomendamos usar tu correo institucional para mayor confianza.";
    }

    // 6. GREETINGS & SMALL TALK
    if (lowerCaseMessage.contains('hola') || lowerCaseMessage.contains('buenos')) {
      return "¡Hola! Soy la IA de Emprende UIDE. 🤖\nPuedes preguntarme sobre cómo usar la app, tecnologías del proyecto o sobre los desarrolladores.";
    }
    
    if (lowerCaseMessage.contains('gracias')) {
      return "¡De nada! Estoy aquí para ayudar. ¿Tienes otra duda sobre la app?";
    }

    // FALLBACK
    return "Mmm, no estoy seguro de eso. 😅\n"
           "Intenta preguntarme cosas concretas como:\n"
           "👉 '¿Quién hizo esta app?'\n"
           "👉 '¿Cómo puedo vender?'\n"
           "👉 '¿Qué tecnologías usa?'";
  }

  // Placeholder for real API integration
  /*
  Future<String> sendMessageToGemini(String message) async {
    final apiKey = 'YOUR_API_KEY';
    final url = Uri.parse('https://generativelanguage.googleapis.com/v1beta/models/gemini-pro:generateContent?key=$apiKey');
    
    // ... implementation ...
  }
  */
}
