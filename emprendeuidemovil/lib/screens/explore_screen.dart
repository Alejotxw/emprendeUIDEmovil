import 'package:flutter/material.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedFilter = 'Todos'; // Filtro por defecto

  // Carrito de compras
  Map<String, int> _cart = {}; // key: título del servicio, value: cantidad

  // Lista de filtros
  final List<String> _filters = ['Todos', 'Comida', 'Diseño', 'Tecnología', 'Foto'];

  // Datos simulados para resultados (8 items)
  final List<Map<String, dynamic>> _services = [
    {
      'title': 'Menú del día casero',
      'price': r'$3.5',
      'description': 'Almuerzos caseros deliciosos y saludables. Incluye sopa, plato fuerte y...',
      'rating': 4.8,
      'reviews': 45,
      'user': 'María González',
      'imageUrl': 'https://via.placeholder.com/150x100/4CAF50/FFFFFF?text=Comida',
      'category': 'Comida',
    },
    {
      'title': 'Diseño de logos...',
      'price': r'$25',
      'description': 'Creo logos únicos y profesionales para tu marca o emprendimiento. Incluye 3...',
      'rating': 4.9,
      'reviews': 32,
      'user': 'Carlos Ramirez',
      'imageUrl': 'https://via.placeholder.com/150x100/2196F3/FFFFFF?text=Diseño',
      'category': 'Diseño',
    },
    {
      'title': 'Reparación de...',
      'price': r'$15',
      'description': 'Mantenimiento y reparación de PCs y laptops. Diagnóstico gratuito.',
      'rating': 4.7,
      'reviews': 28,
      'user': 'Pedro Morales',
      'imageUrl': 'https://via.placeholder.com/150x100/FF9800/FFFFFF?text=Tecnología',
      'category': 'Tecnología',
    },
    {
      'title': 'Sesión fotográfica',
      'price': r'$35',
      'description': 'Sesiones creativas y profesionales para eventos o portafolios.',
      'rating': 4.8,
      'reviews': 22,
      'user': 'Laura Torres',
      'imageUrl': 'https://via.placeholder.com/150x100/9C27B0/FFFFFF?text=Foto',
      'category': 'Foto',
    },
    {
      'title': 'Clases de matemáticas',
      'price': r'$10',
      'description': 'Tutorías personalizadas para mejorar tus notas.',
      'rating': 4.9,
      'reviews': 50,
      'user': 'Ana López',
      'imageUrl': 'https://via.placeholder.com/150x100/FFC107/FFFFFF?text=Tutoría',
      'category': 'Comida', // Ejemplo para filtrado
    },
    {
      'title': 'Gestión de redes',
      'price': r'$50',
      'description': 'Estrategias para crecer tu presencia online.',
      'rating': 4.6,
      'reviews': 15,
      'user': 'Miguel Herrera',
      'imageUrl': 'https://via.placeholder.com/150x100/00BCD4/FFFFFF?text=Marketing',
      'category': 'Diseño',
    },
    {
      'title': 'Artesanías únicas',
      'price': r'$5',
      'description': 'Piezas hechas a mano con materiales locales.',
      'rating': 4.5,
      'reviews': 20,
      'user': 'Sofía Vargas',
      'imageUrl': 'https://via.placeholder.com/150x100/E91E63/FFFFFF?text=Artesanía',
      'category': 'Tecnología',
    },
    {
      'title': 'Edición de video',
      'price': r'$20',
      'description': 'Videos profesionales para redes sociales.',
      'rating': 4.7,
      'reviews': 35,
      'user': 'Diego Ruiz',
      'imageUrl': 'https://via.placeholder.com/150x100/8BC34A/FFFFFF?text=Video',
      'category': 'Foto',
    },
  ];

  // Filtrar servicios basados en _selectedFilter
  List<Map<String, dynamic>> get _filteredServices {
    if (_selectedFilter == 'Todos') {
      return _services;
    }
    return _services.where((service) => service['category'] == _selectedFilter).toList();
  }

  // Función para obtener total de items en carrito
  int get _totalCartItems {
    return _cart.values.fold(0, (sum, qty) => sum + qty);
  }

  // Función para navegar al carrito
  void _navigateToCart() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CartScreen(
          cart: _cart,
          services: _services,
          onCartUpdated: (updatedCart) {
            setState(() {
              _cart = updatedCart;
            });
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Explorar'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.purple, Colors.blue],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(80.0),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                // Barra de búsqueda
                TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Buscar servicios...',
                    prefixIcon: const Icon(Icons.search, color: Colors.grey),
                    suffixIcon: const Icon(Icons.filter_list, color: Colors.grey),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  onChanged: (value) {
                    setState(() {});
                  },
                ),
                const SizedBox(height: 8),
                // Chips de filtros
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: _filters.map((filter) {
                      return Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: ChoiceChip(
                          label: Text(filter),
                          selected: _selectedFilter == filter,
                          onSelected: (selected) {
                            if (selected) {
                              setState(() {
                                _selectedFilter = filter;
                              });
                            }
                          },
                          selectedColor: Colors.purple[100],
                          backgroundColor: Colors.white,
                          labelStyle: TextStyle(
                            color: _selectedFilter == filter ? Colors.purple : Colors.grey,
                            fontWeight: _selectedFilter == filter ? FontWeight.bold : FontWeight.normal,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
        ),
        actions: [
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_cart),
                onPressed: _navigateToCart,
              ),
              if (_totalCartItems > 0)
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 16,
                      minHeight: 16,
                    ),
                    child: Text(
                      '$_totalCartItems',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Contador de resultados
            Text(
              '${_filteredServices.length} resultados',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.grey),
            ),
            const SizedBox(height: 16),
            // Lista de servicios
            Expanded(
              child: ListView.builder(
                itemCount: _filteredServices.length,
                itemBuilder: (context, index) {
                  final service = _filteredServices[index];
                  final String title = service['title'];
                  final int currentQuantity = _cart[title] ?? 0;
                  return ServiceCard(
                    title: title,
                    price: service['price'],
                    description: service['description'],
                    rating: service['rating'],
                    reviews: service['reviews'],
                    user: service['user'],
                    imageUrl: service['imageUrl'],
                    currentQuantity: currentQuantity,
                    onAdd: () {
                      setState(() {
                        _cart[title] = (currentQuantity + 1);
                      });
                    },
                    onRemove: currentQuantity > 0
                        ? () {
                            setState(() {
                              if (currentQuantity > 1) {
                                _cart[title] = currentQuantity - 1;
                              } else {
                                _cart.remove(title);
                              }
                            });
                          }
                        : null,
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: _totalCartItems > 0
          ? FloatingActionButton.extended(
              onPressed: _navigateToCart,
              icon: const Icon(Icons.shopping_cart),
              label: Text('Carrito ($_totalCartItems)'),
              backgroundColor: Colors.purple,
            )
          : null,
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}

// Pantalla del carrito
class CartScreen extends StatefulWidget {
  final Map<String, int> cart;
  final List<Map<String, dynamic>> services;
  final Function(Map<String, int>) onCartUpdated;

  const CartScreen({
    super.key,
    required this.cart,
    required this.services,
    required this.onCartUpdated,
  });

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  late Map<String, int> _localCart;
  String? _selectedPaymentMethod = 'Tarjeta de Crédito';
  final List<String> _paymentMethods = ['Tarjeta de Crédito', 'Tarjeta de Débito', 'Transferencia Bancaria', 'PayPal'];

  @override
  void initState() {
    super.initState();
    _localCart = Map.from(widget.cart);
  }

  // Función para calcular el total
  double _calculateTotal() {
    double total = 0.0;
    _localCart.forEach((title, qty) {
      final service = widget.services.firstWhere((s) => s['title'] == title);
      final price = double.parse(service['price'].replaceAll(r'$', ''));
      total += price * qty;
    });
    return total;
  }

  @override
  Widget build(BuildContext context) {
    if (_localCart.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Carrito'),
          backgroundColor: Colors.purple,
        ),
        body: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.shopping_cart_outlined, size: 64, color: Colors.grey),
              SizedBox(height: 16),
              Text('Tu carrito está vacío', style: TextStyle(fontSize: 18, color: Colors.grey)),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Carrito de Compras'),
        backgroundColor: Colors.purple,
        actions: [
          TextButton(
            onPressed: () {
              widget.onCartUpdated(_localCart);
              Navigator.pop(context);
            },
            child: const Text('Guardar', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              children: _localCart.entries.map((entry) {
                final serviceTitle = entry.key;
                final qty = entry.value;
                final service = widget.services.firstWhere((s) => s['title'] == serviceTitle);
                final price = double.parse(service['price'].replaceAll(r'$', ''));
                final totalPrice = price * qty;
                return Card(
                  margin: const EdgeInsets.all(8.0),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(service['imageUrl']),
                      onBackgroundImageError: (_, __) => const Icon(Icons.image_not_supported),
                    ),
                    title: Text(serviceTitle),
                    subtitle: Text('Precio unitario: ${service['price']}'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.remove, color: Colors.red),
                          onPressed: () {
                            setState(() {
                              if (qty > 1) {
                                _localCart[serviceTitle] = qty - 1;
                              } else {
                                _localCart.remove(serviceTitle);
                              }
                            });
                          },
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text('$qty', style: const TextStyle(fontWeight: FontWeight.bold)),
                        ),
                        IconButton(
                          icon: const Icon(Icons.add, color: Colors.green),
                          onPressed: () {
                            setState(() {
                              _localCart[serviceTitle] = qty + 1;
                            });
                          },
                        ),
                        Text('\$${totalPrice.toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          // Sección de pago
          Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: Column(
              children: [
                // Método de pago
                const Text('Método de Pago', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  value: _selectedPaymentMethod,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    filled: true,
                  ),
                  items: _paymentMethods.map((method) {
                    return DropdownMenuItem(value: method, child: Text(method));
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedPaymentMethod = value;
                    });
                  },
                ),
                const SizedBox(height: 16),
                // Total y botón de pagar
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Total:', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    Text('\$${_calculateTotal().toStringAsFixed(2)}', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.green)),
                  ],
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Procesando pago con $_selectedPaymentMethod por \$${_calculateTotal().toStringAsFixed(2)}...'),
                          backgroundColor: Colors.green,
                        ),
                      );
                      widget.onCartUpdated(_localCart);
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.purple,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: const Text('Pagar', style: TextStyle(fontSize: 18, color: Colors.white)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Widget reutilizable para tarjetas de servicios
class ServiceCard extends StatelessWidget {
  final String title;
  final String price;
  final String description;
  final double rating;
  final int reviews;
  final String user;
  final String imageUrl;
  final int currentQuantity;
  final VoidCallback? onAdd;
  final VoidCallback? onRemove;

  const ServiceCard({
    super.key,
    required this.title,
    required this.price,
    required this.description,
    required this.rating,
    required this.reviews,
    required this.user,
    required this.imageUrl,
    required this.currentQuantity,
    required this.onAdd,
    this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Abriendo detalle de: $title'),
            backgroundColor: Colors.blue,
            duration: const Duration(seconds: 2),
            action: SnackBarAction(
              label: 'Contactar',
              textColor: Colors.white,
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Enviando mensaje al emprendedor...')),
                );
              },
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                imageUrl,
                width: 80,
                height: 80,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: 80,
                    height: 80,
                    color: Colors.grey[200],
                    child: const Icon(Icons.image_not_supported, size: 40),
                  );
                },
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          title,
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Text(
                        price,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Row(
                        children: List.generate(5, (index) => Icon(
                          index < rating ? Icons.star : Icons.star_border,
                          color: Colors.amber,
                          size: 16,
                        )),
                      ),
                      const SizedBox(width: 4),
                      Text('$rating ($reviews)'),
                      const SizedBox(width: 8),
                      Text(user, style: const TextStyle(fontWeight: FontWeight.w500)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  // Controles de carrito
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      if (currentQuantity > 0) ...[
                        IconButton(
                          icon: const Icon(Icons.remove, size: 20, color: Colors.red),
                          onPressed: onRemove,
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            '$currentQuantity',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.add, size: 20, color: Colors.green),
                          onPressed: onAdd,
                        ),
                      ] else ...[
                        IconButton(
                          icon: const Icon(Icons.add_shopping_cart, size: 20, color: Colors.green),
                          onPressed: onAdd,
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}