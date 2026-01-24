// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appTitle => 'Servicio App Cliente';

  @override
  String hello(Object name) {
    return 'Hola, $name';
  }

  @override
  String get myCart => 'Mi Carrito';

  @override
  String get services => 'Servicios';

  @override
  String get products => 'Productos';

  @override
  String get cartEmpty => 'Tu carrito está vacío. ¡Agrega algo!';

  @override
  String get add => 'Agregar';

  @override
  String get remove => 'Eliminar';

  @override
  String get edit => 'Editar';

  @override
  String get cancel => 'Cancelar';

  @override
  String get save => 'Guardar';

  @override
  String get saveChanges => 'Guardar Cambios';

  @override
  String get accept => 'Aceptar';

  @override
  String get accepted => 'Aceptada';

  @override
  String get pending => 'Pendiente';

  @override
  String get comment => 'Comentario';

  @override
  String get quantity => 'Cantidad';

  @override
  String get price => 'Precio';

  @override
  String get total => 'Total';

  @override
  String get subtotal => 'Subtotal';

  @override
  String get editComment => 'Editar Comentario';

  @override
  String get editQuantity => 'Editar Cantidad';

  @override
  String get commentPlaceholder => 'Describe lo que necesitas...';

  @override
  String get commentCannotBeEmpty => 'El comentario no puede estar vacío';

  @override
  String get commentUpdated => 'Comentario actualizado';

  @override
  String quantityUpdated(Object quantity) {
    return 'Cantidad actualizada a $quantity';
  }

  @override
  String get quantityMustBeGreaterThanZero => 'La cantidad debe ser mayor a 0';

  @override
  String get paymentMethod => 'Forma de Pago';

  @override
  String get paymentMethodTitle => 'Método de Pago';

  @override
  String get selectPaymentMethod => 'Selecciona un método de pago';

  @override
  String get payInPerson => 'Pago en físico';

  @override
  String get payByTransfer => 'Pago por transferencia';

  @override
  String get secureLocation => 'Ubicación segura';

  @override
  String get transferData => 'Datos para transferencia';

  @override
  String get bankName => 'Banco: Banco Nacional';

  @override
  String get accountNumber => 'Cuenta: 1234-5678-9012';

  @override
  String get holderID => 'C.I. Titular: 1234567890';

  @override
  String get reference => 'Referencia: Compra en EmprendeUI';

  @override
  String get pay => 'Pagar';

  @override
  String paymentSuccessful(Object method) {
    return 'Pago exitoso por $method!';
  }

  @override
  String get myProfile => 'Mi Perfil';

  @override
  String get fullName => 'Nombre Completo';

  @override
  String get phone => 'Teléfono';

  @override
  String get cellphone => 'Celular';

  @override
  String get cellphonePlaceholder => 'e.j. ';

  @override
  String get email => 'Correo electrónico';

  @override
  String get settings => 'Configuraciones';

  @override
  String get customize => 'Personaliza tu experiencia';

  @override
  String get notifications => 'Notificaciones';

  @override
  String get generalNotifications => 'Notificaciones generales';

  @override
  String get generalNotificationsSubtitle => 'Recibe actualizaciones importantes';

  @override
  String get requests => 'Solicitudes';

  @override
  String get requestsSubtitle => 'Estado de tus solicitudes';

  @override
  String get offersAndPromotions => 'Ofertas y promociones';

  @override
  String get offersSubtitle => 'Descuentos exclusivos UIDE';

  @override
  String get appearance => 'Apariencia';

  @override
  String get darkMode => 'Modo Oscuro';

  @override
  String get darkModeComingSoon => 'Próximamente disponible';

  @override
  String get language => 'Idioma';

  @override
  String get spanish => 'Español';

  @override
  String get english => 'Inglés';

  @override
  String get privacyAndSecurity => 'Privacidad y Seguridad';

  @override
  String get privacySubtitle => 'Protege tu información';

  @override
  String get helpAndSupport => 'Ayuda y Soporte';

  @override
  String get helpSubtitle => 'Estamos aquí para ayudarte';

  @override
  String get appVersion => 'EmprendeUIDE v1.0';

  @override
  String get appDescription => 'Marketplace estudiantil oficial';

  @override
  String get university => 'Universidad Internacional del Ecuador';

  @override
  String get copyright => '© 2025 UIDE. Todos los derechos reservados.';

  @override
  String get changesSaved => 'Cambios guardados';

  @override
  String get myFavorites => 'Mis Favoritos';

  @override
  String get noFavorites => 'No hay favoritos. ¡Agrega en Home!';

  @override
  String get search => 'Buscar';

  @override
  String get searchPlaceholder => '¿Qué necesitas hoy? Busca servicios o emprendimientos';

  @override
  String searchResults(Object query) {
    return 'Resultados de búsqueda ($query)';
  }

  @override
  String get suggestedOptions => 'Opciones sugeridas';

  @override
  String get topFeatured => 'TOP Destacadas';

  @override
  String get allEntrepreneurships => 'Todos los Emprendimientos';

  @override
  String get moreResults => 'Más resultados';

  @override
  String get noExactResults => 'No se encontraron resultados exactos.';

  @override
  String showingServices(Object category, Object count) {
    return 'Mostrando $count servicios en $category';
  }

  @override
  String get categories => 'Categorías';

  @override
  String get food => 'Comida';

  @override
  String get tutoring => 'Tutorías';

  @override
  String get portfolios => 'Portafolios';

  @override
  String get consultations => 'Consultas';

  @override
  String get designs => 'Diseños';

  @override
  String get books => 'Libros';

  @override
  String get templates => 'Plantillas';

  @override
  String get languages => 'Idioma';

  @override
  String get writing => 'Redacciones';

  @override
  String get prototypes => 'Prototipos';

  @override
  String get research => 'Investigaciones';

  @override
  String get art => 'Arte';

  @override
  String get presentations => 'Presentaciones';

  @override
  String get accessories => 'Accesorios';

  @override
  String get technology => 'Tecnología';

  @override
  String get crafts => 'Artesanías';

  @override
  String get availableServices => 'Servicios Disponibles';

  @override
  String get availableProducts => 'Productos Disponibles';

  @override
  String get noServicesAvailable => 'No hay servicios disponibles en este momento.';

  @override
  String get noProductsAvailable => 'No hay productos disponibles en este momento.';

  @override
  String get serviceDescription => 'Descripción del Servicio';

  @override
  String get request => 'Solicitar';

  @override
  String get addToCart => 'Agregar al Carrito';

  @override
  String get serviceRequested => 'Servicio solicitado y agregado al carrito';

  @override
  String productAdded(Object quantity) {
    return 'Producto agregado al carrito ($quantity)';
  }

  @override
  String get information => 'Información';

  @override
  String get schedule => 'Horario';

  @override
  String get location => 'Ubicación';

  @override
  String get scheduleValue => 'Lun-Vie 10:00-16:00';

  @override
  String get locationValue => 'Dirección mock, Quito, Ecuador';

  @override
  String get mapPlaceholder => 'Mapa Placeholder';

  @override
  String get myOrders => 'Mis Pedidos';

  @override
  String get myReviews => 'Mis Reseñas';

  @override
  String get serviceRating => 'Rating de Servicios';

  @override
  String get logout => 'Cerrar sesión';

  @override
  String get sessionClosed => 'Sesión cerrada';

  @override
  String get client => 'Cliente';

  @override
  String get entrepreneur => 'Emprendedor';

  @override
  String get clientModeActivated => 'Modo Cliente activado';

  @override
  String get entrepreneurModeActivated => 'Modo Emprendedor activado';

  @override
  String get register => 'Registro';

  @override
  String get login => 'Iniciar Sesión';

  @override
  String get password => 'Contraseña';

  @override
  String get institutionalEmail => 'Correo institucional';

  @override
  String get selectYourRole => 'Selecciona tu rol';

  @override
  String get seller => 'Vendedor';

  @override
  String get buyer => 'Comprador';

  @override
  String get registerMe => 'Registrarme';

  @override
  String get mustUseInstitutionalEmail => 'Debe usar un correo institucional @uide.edu.ec';

  @override
  String get mustSelectOneRole => 'Debe elegir solo un rol: vendedor o comprador';

  @override
  String userRegisteredSuccessfully(Object name) {
    return 'Usuario $name registrado con éxito';
  }

  @override
  String get requiredField => 'Campo obligatorio';

  @override
  String get minimumCharacters => 'Mínimo 6 caracteres';

  @override
  String get createEntrepreneurship => 'Crear Emprendimiento';

  @override
  String get basicInformation => 'Información Básica';

  @override
  String get entrepreneurshipName => 'Nombres del Emprendimiento';

  @override
  String get entrepreneurshipNamePlaceholder => 'Ej. Delicias Caseras';

  @override
  String get category => 'Categoría';

  @override
  String get description => 'Descripción';

  @override
  String get descriptionPlaceholder => 'Describe tu emprendimiento';

  @override
  String get locationPlaceholder => 'Ej. Campus Quito';

  @override
  String get scheduleAttention => 'Horario de Atención';

  @override
  String get schedulePlaceholder => 'Ej. Lun-Vie 9:00-17:00';

  @override
  String servicesProducts(Object count) {
    return 'Servicios / Productos ($count Servicios)';
  }

  @override
  String get noServicesYet => 'No has agregado servicios aún.';

  @override
  String get addNewService => 'Agregar nuevo servicio:';

  @override
  String get serviceName => 'Nombre del servicio';

  @override
  String get briefDescription => 'Descripción breve';

  @override
  String get priceExample => 'Precio (Ej: \$5.00)';

  @override
  String get addService => 'Agregar Servicio';

  @override
  String get entrepreneurshipCreated => 'Emprendimiento creado';

  @override
  String get protectedAccount => 'Cuenta Protegida';

  @override
  String get accountProtectedMessage => 'Tu cuenta está activa y protegida. Mantén tus datos seguros con nuestras recomendaciones.';

  @override
  String get profilePrivacy => 'Privacidad de perfil';

  @override
  String get showEmail => 'Mostrar correo electrónico';

  @override
  String get showEmailSubtitle => 'Visible en tu perfil público';

  @override
  String get showPhone => 'Mostrar teléfono';

  @override
  String get showPhoneSubtitle => 'Visible en tu perfil público';

  @override
  String get privacyCommitment => 'Nos comprometemos a proteger tu privacidad y mantener tus datos seguros.';

  @override
  String get privacyPolicy => 'Política de Privacidad';

  @override
  String get termsOfUse => 'Términos de Uso';

  @override
  String get writeYourMessage => 'Escribe tu mensaje...';

  @override
  String get send => 'Enviar';

  @override
  String get assistantGreeting => 'Hola soy tu asistente virtual de Emprende UIDE. ¿En qué puedo ayudarte?';

  @override
  String get thankYouMessage => 'Gracias por tu mensaje. Te responderemos pronto.';

  @override
  String get whatsapp => 'WhatsApp';

  @override
  String viewDetails(Object name) {
    return 'Ver $name';
  }

  @override
  String get ordersScreenPlaceholder => 'Pantalla de Mis Pedidos - Implementar lista de pedidos con status';

  @override
  String get reviewsScreenPlaceholder => 'Pantalla de Mis Reseñas - Implementar lista de reseñas con check/trash';

  @override
  String get ratingsScreenPlaceholder => 'Pantalla de Rating de Servicios - Implementar cards con stars';
}
