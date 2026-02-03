import 'package:flutter/material.dart';
import '../models/service_model.dart';

class ServiceProvider extends ChangeNotifier {
  List<ServiceModel> _allServices = [];
  Set<String> _favorites = <String>{};  // Explícito Set<String>

  List<ServiceModel> get allServices => _allServices;
  List<ServiceModel> get favorites => _allServices.where((s) => _favorites.contains(s.id)).toList();
  bool isFavorite(String id) => _favorites.contains(id);

  ServiceProvider() {
    _loadMockData();
  }

  void _loadMockData() {
    _allServices = [
      ServiceModel(
        id: '2',
        name: 'Diseño de Web',
        subtitle: 'Especializados en sitios web responsivos y e-commerce personalizados con paquetes que incluyen SEO y diseño UX/UI intuitivo para potenciar tu presencia en línea',
        category: 'Diseños',
        price: 10.0,
        rating: 2.5,  // Como en imagen
        reviewCount: 10,
        isFavorite: false,
        services: const [
          ServiceItem(name: 'Diseño Web', price: 25.0, description: 'Sitio web completo con Figma, React'),
          ServiceItem(name: 'Diseño Movil', price: 25.0, description: 'App móvil con Figma, Flutter'),
          ServiceItem(name: 'SEO y diseño UX/UI', price: 25.0, description: 'Optimización SEO y UX/UI intuitivo'),
        ],
      ),
      // Producto: Comida (con 6 items)
      ServiceModel(
        id: '1',
        name: 'Delicias Caseras',
        subtitle: 'Especializados en postres artesanales con ingredientes locales frescos, como cheesecakes veganos, ofreciendo delivery y cotillón para endulzar tus momentos',
        category: 'Comida',
        price: 5.0,
        rating: 4.2,
        reviewCount: 5,
        isFavorite: false,
        products: const [
          ProductItem(name: 'Almuezros con sopa', price: 2.50, description: 'Menú del día con sopa y segundo'),
          ProductItem(name: 'Postres Seleccionados', price: 2.50, description: 'Tortas, brownies y más'),
          ProductItem(name: 'Cheesecake Vegano', price: 3.00, description: 'Cheesecake sin lácteos con frutas frescas'),
          ProductItem(name: 'Brownies Artesanales', price: 2.00, description: 'Brownies con nueces locales'),
          ProductItem(name: 'Tortas Personalizadas', price: 4.00, description: 'Tortas para eventos'),
          ProductItem(name: 'Cotillón Dulce', price: 1.50, description: 'Paquete de dulces para fiestas'),  // 6
        ],
      ),
      // Servicio: Diseños (con 4 items)
      ServiceModel(
        id: '2',
        name: 'Diseño de Web',
        subtitle: 'Especializados en sitios web responsivos y e-commerce personalizados con paquetes que incluyen SEO y diseño UX/UI intuitivo para potenciar tu presencia en línea',
        category: 'Diseños',
        price: 10.0,
        rating: 4.5,
        reviewCount: 10,
        isFavorite: false,
        services: const [
          ServiceItem(name: 'Diseño Web', price: 25.0, description: 'Sitio web completo con React'),
          ServiceItem(name: 'Diseño Móvil', price: 25.0, description: 'App móvil con Flutter'),
          ServiceItem(name: 'SEO Básico', price: 15.0, description: 'Optimización inicial para motores de búsqueda'),
          ServiceItem(name: 'UX/UI Personalizado', price: 20.0, description: 'Diseño intuitivo para tu marca'),
        ],
      ),
      // Producto: Libros (con 6 items)
      ServiceModel(
        id: '4',
        name: 'Juan Pérez',
        subtitle: 'Libro de matemáticas avanzadas',
        category: 'Libros',
        price: 8.0,
        rating: 4.3,
        reviewCount: 8,
        isFavorite: false,
        products: const [
          ProductItem(name: 'Álgebra Lineal', price: 10.00, description: 'Libro básico de álgebra'),
          ProductItem(name: 'Cálculo Diferencial', price: 12.00, description: 'Volumen 1 de cálculo'),
          ProductItem(name: 'Estadística Aplicada', price: 9.00, description: 'Introducción a stats'),
          ProductItem(name: 'Geometría Analítica', price: 11.00, description: 'Geometría moderna'),
          ProductItem(name: 'Matemáticas Discretas', price: 13.00, description: 'Lógica y conjuntos'),
          ProductItem(name: 'Avanzado de Probabilidad', price: 14.00, description: 'Probabilidad aplicada'),  // 6
        ],
      ),
      // Servicio: Consultas (con 4 items)
      ServiceModel(
        id: '3',
        name: 'María López',
        subtitle: 'Sesión de consulta legal',
        category: 'Consultas',
        price: 15.0,
        rating: 4.8,
        reviewCount: 20,
        isFavorite: false,
        services: const [
          ServiceItem(name: 'Consulta Laboral', price: 30.0, description: 'Asesoría en derechos laborales'),
          ServiceItem(name: 'Consulta Familiar', price: 35.0, description: 'Divorcios y custodia'),
          ServiceItem(name: 'Consulta Penal', price: 40.0, description: 'Defensa en procesos penales'),
          ServiceItem(name: 'Consulta Civil', price: 25.0, description: 'Contratos y propiedades'),
        ],
      ),
      // Resto sin items (aparecerán vacíos, pero con mensaje)
      ServiceModel(id: '5', name: 'Ana García', subtitle: 'Plantilla para CV', category: 'Plantillas', price: 7.0, rating: 4.6, reviewCount: 12, isFavorite: false),
      ServiceModel(id: '6', name: 'Carlos Ruiz', subtitle: 'Clases de inglés', category: 'Idioma', price: 12.0, rating: 4.7, reviewCount: 15, isFavorite: false),
      ServiceModel(id: '7', name: 'Sofía Mendoza', subtitle: 'Redacción académica', category: 'Redacciones', price: 9.0, rating: 4.4, reviewCount: 6, isFavorite: false),
      ServiceModel(id: '8', name: 'Diego Torres', subtitle: 'Prototipo de app', category: 'Prototipos', price: 20.0, rating: 4.9, reviewCount: 18, isFavorite: false),
      ServiceModel(id: '9', name: 'Laura Vega', subtitle: 'Investigación de mercado', category: 'Investigaciones', price: 18.0, rating: 4.5, reviewCount: 14, isFavorite: false),
      ServiceModel(id: '10', name: 'Miguel Herrera', subtitle: 'Obra de arte digital', category: 'Arte', price: 25.0, rating: 4.8, reviewCount: 22, isFavorite: false),
      ServiceModel(id: '11', name: 'Elena Castro', subtitle: 'Presentación PPT', category: 'Presentaciones', price: 11.0, rating: 4.2, reviewCount: 9, isFavorite: false),
      ServiceModel(id: '12', name: 'Roberto Silva', subtitle: 'Accesorios para eventos', category: 'Accesorios', price: 6.0, rating: 4.1, reviewCount: 7, isFavorite: false),
      ServiceModel(
        id: 'mine_1',
        name: 'Kevin Giron',
        subtitle: 'Diseño web y Posters',
        category: 'Diseño',
        price: 0.0,
        rating: 5.0,
        reviewCount: 0,
        isMine: true,
      ),
      ServiceModel(
        id: 'mine_2',
        name: 'Kevin Giron',
        subtitle: 'Diseño web y Posters',
        category: 'Diseño',
        price: 0.0,
        rating: 5.0,
        reviewCount: 0,
        isMine: true,
      ),
    ];
    _favorites = _allServices.where((s) => s.isFavorite).map((s) => s.id).toSet() as Set<String>;  // Cast explícito
    notifyListeners();
  }

  void toggleFavorite(String id) {
    if (_favorites.contains(id)) {
      _favorites.remove(id);
    } else {
      _favorites.add(id);
    }
    notifyListeners();
  }

  List<ServiceModel> getServicesByCategory(String category) {
    return _allServices.where((s) => s.category == category).toList();
  }

  // user: current user services
  List<ServiceModel> get myServices => _allServices.where((s) => s.isMine).toList();

  void addService(ServiceModel service) {
    _allServices.insert(0, service); // Add to the beginning of the list
    notifyListeners();
  }

  void updateService(ServiceModel updatedService) {
    final index = _allServices.indexWhere((s) => s.id == updatedService.id);
    if (index != -1) {
      _allServices[index] = updatedService;
      notifyListeners();
    }
  }

  void deleteService(String id) {
    _allServices.removeWhere((s) => s.id == id);
    notifyListeners();
  }
}