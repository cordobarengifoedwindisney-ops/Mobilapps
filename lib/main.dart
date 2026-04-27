import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// ============================================================
// DATA MODELS
// ============================================================

class Product {
  final String id;
  final String name;
  final double price;
  final String imageUrl;
  final double rating;
  final String description;
  final String category;
  final List<Map<String, String>> specifications;

  const Product({
    required this.id,
    required this.name,
    required this.price,
    required this.imageUrl,
    required this.rating,
    this.description = 'Un producto tecnológico de alta calidad y rendimiento.',
    required this.category,
    required this.specifications,
  });
}

class Review {
  final String author;
  final String comment;
  final double rating;

  const Review({
    required this.author,
    required this.comment,
    required this.rating,
  });
}

class CartItem {
  final String productId;
  final String name;
  final double price;
  int quantity;

  CartItem({
    required this.productId,
    required this.name,
    required this.price,
    this.quantity = 1,
  });

  CartItem copyWith({int? quantity}) {
    return CartItem(
      productId: productId,
      name: name,
      price: price,
      quantity: quantity ?? this.quantity,
    );
  }
}

class Offer {
  final Product product;
  final double discountPercentage;

  const Offer({required this.product, required this.discountPercentage});

  double get discountedPrice => product.price * (1 - discountPercentage);
  String get discountText => '${(discountPercentage * 100).toInt()}% Off';
}

// ============================================================
// STATE MANAGEMENT
// ============================================================

class CartModel extends ChangeNotifier {
  final Map<String, CartItem> _items = {};

  List<CartItem> get items => _items.values.toList();

  int get totalItems {
    int count = 0;
    _items.forEach((key, value) => count += value.quantity);
    return count;
  }

  double get totalPrice {
    double total = 0.0;
    _items.forEach((key, value) => total += value.price * value.quantity);
    return total;
  }

  void addProduct(Product product) {
    if (_items.containsKey(product.id)) {
      _items[product.id]!.quantity++;
    } else {
      _items[product.id] = CartItem(
        productId: product.id,
        name: product.name,
        price: product.price,
      );
    }
    notifyListeners();
  }

  void incrementQuantity(String productId) {
    if (_items.containsKey(productId)) {
      _items[productId]!.quantity++;
      notifyListeners();
    }
  }

  void decrementQuantity(String productId) {
    if (_items.containsKey(productId)) {
      if (_items[productId]!.quantity > 1) {
        _items[productId]!.quantity--;
      } else {
        _items.remove(productId);
      }
      notifyListeners();
    }
  }

  void removeItem(String productId) {
    _items.remove(productId);
    notifyListeners();
  }

  void clearCart() {
    _items.clear();
    notifyListeners();
  }
}

// ============================================================
// INITIAL DATA
// ============================================================

final List<Product> _allProducts = [
  const Product(
    id: "p1",
    name: "Laptop Gamer",
    price: 1200.0,
    imageUrl: "https://images.unsplash.com/photo-1517336714731-489689fd1ca8",
    rating: 4.5,
    description:
        'Potente laptop para los gamers más exigentes. Rápida y eficiente para todo tipo de tareas. Equipada con procesador de última generación y tarjeta gráfica de alto rendimiento.',
    category: "Laptops",
    specifications: [
      {'key': 'Procesador', 'value': 'Intel Core i9'},
      {'key': 'RAM', 'value': '32GB DDR4'},
      {'key': 'Almacenamiento', 'value': '1TB SSD NVMe'},
      {'key': 'Tarjeta Gráfica', 'value': 'NVIDIA GeForce RTX 4080'},
      {'key': 'Pantalla', 'value': '15.6" Full HD 144Hz'},
      {'key': 'Sistema Operativo', 'value': 'Windows 11 Home'},
    ],
  ),
  const Product(
    id: "p2",
    name: "Smartphone Pro",
    price: 800.0,
    imageUrl: "https://images.unsplash.com/photo-1511707171634-5f897ff02aa9",
    rating: 4.0,
    description:
        'El último smartphone con cámara de alta resolución, gran batería y rendimiento superior. Captura fotos impresionantes y mantente conectado todo el día.',
    category: "Smartphones",
    specifications: [
      {'key': 'Pantalla', 'value': '6.7" OLED'},
      {'key': 'Procesador', 'value': 'Snapdragon 8 Gen 3'},
      {'key': 'RAM', 'value': '12GB'},
      {'key': 'Almacenamiento', 'value': '256GB'},
      {'key': 'Cámara Principal', 'value': '50MP Triple'},
      {'key': 'Batería', 'value': '5000 mAh'},
    ],
  ),
  const Product(
    id: "p3",
    name: "Audífonos Bluetooth",
    price: 150.0,
    imageUrl: "https://images.unsplash.com/photo-1505740420928-5e560c06d30e",
    rating: 4.5,
    description:
        'Sonido envolvente, cancelación de ruido y comodidad para disfrutar tu música sin interrupciones. Batería de larga duración para horas de entretenimiento.',
    category: "Audífonos",
    specifications: [
      {'key': 'Tipo', 'value': 'Over-ear inalámbricos'},
      {'key': 'Conectividad', 'value': 'Bluetooth 5.2'},
      {'key': 'Cancelación de Ruido', 'value': 'Activa (ANC)'},
      {'key': 'Duración Batería', 'value': 'Hasta 30 horas'},
      {'key': 'Micrófono', 'value': 'Integrado'},
      {'key': 'Controladores', 'value': '40mm Neodimio'},
    ],
  ),
  const Product(
    id: "p4",
    name: "Monitor UltraWide",
    price: 300.0,
    imageUrl:
        "https://tse1.mm.bing.net/th/id/OIP.hSeds2vDO0LKW9bmekgiQQHaFA?rs=1&pid=ImgDetMain&o=7&rm=3",
    rating: 3.5,
    description:
        'Monitor de gran tamaño con resolución 4K para una experiencia visual inmersiva. Ideal para trabajo, diseño gráfico y entretenimiento.',
    category: "Monitores",
    specifications: [
      {'key': 'Tamaño', 'value': '34 pulgadas'},
      {'key': 'Resolución', 'value': '3440 x 1440 (UltraWide QHD)'},
      {'key': 'Frecuencia de Actualización', 'value': '100Hz'},
      {'key': 'Tiempo de Respuesta', 'value': '5ms'},
      {'key': 'Tipo de Panel', 'value': 'IPS'},
      {'key': 'Conectividad', 'value': 'HDMI, DisplayPort, USB-C'},
    ],
  ),
  const Product(
    id: "p5",
    name: "Teclado Mecánico",
    price: 90.0,
    imageUrl:
        "https://http2.mlstatic.com/D_NQ_NP_928830-CBT77640147622_072024-O.webp",
    rating: 4.8,
    description:
        'Teclado mecánico de alta respuesta, ideal para gamers y programadores, con retroiluminación RGB personalizable.',
    category: "Accesorios",
    specifications: [
      {'key': 'Tipo de Switch', 'value': 'Redragon Red Switches'},
      {'key': 'Retroiluminación', 'value': 'RGB personalizable'},
      {'key': 'Conectividad', 'value': 'USB Alámbrico'},
      {'key': 'Diseño', 'value': 'Compacto TKL (87 teclas)'},
      {'key': 'Durabilidad', 'value': '50 millones de pulsaciones'},
      {'key': 'Material', 'value': 'Aluminio y ABS'},
    ],
  ),
  const Product(
    id: "p6",
    name: "Smartwatch Deportivo",
    price: 250.0,
    imageUrl:
        "https://cdn.mos.cms.futurecdn.net/fgvEZRacdHbG4GAzA25AQj-1920-80.jpg",
    rating: 4.2,
    description:
        'Controla tu actividad física, monitorea tu salud y recibe notificaciones en tu muñeca. Múltiples modos deportivos y seguimiento de frecuencia cardíaca.',
    category: "Wearables",
    specifications: [
      {'key': 'Pantalla', 'value': '1.4" AMOLED'},
      {'key': 'Sensores', 'value': 'Frecuencia Cardíaca, SpO2, GPS'},
      {'key': 'Resistencia al Agua', 'value': '5 ATM'},
      {'key': 'Duración Batería', 'value': 'Hasta 14 días'},
      {'key': 'Conectividad', 'value': 'Bluetooth 5.0'},
      {'key': 'Compatibilidad', 'value': 'Android, iOS'},
    ],
  ),
];

final List<Review> _allReviews = [
  const Review(
    author: "Carlos M.",
    comment:
        'Excelente servicio y productos de gran calidad. Mi laptop llegó muy rápido y en perfectas condiciones.',
    rating: 5.0,
  ),
  const Review(
    author: "Laura P.",
    comment:
        "Compré un monitor y funciona perfectamente. La imagen es increíble y la entrega fue puntual.",
    rating: 4.5,
  ),
  const Review(
    author: "Andrés R.",
    comment:
        "Muy buenos precios y entrega rápida. Los audífonos son top! Volvería a comprar aquí sin dudar.",
    rating: 4.0,
  ),
  const Review(
    author: "Sofía G.",
    comment:
        'La atención al cliente es fantástica, me ayudaron a elegir el smartphone ideal. Totalmente recomendados.',
    rating: 5.0,
  ),
  const Review(
    author: "Diego F.",
    comment:
        'El teclado mecánico es una maravilla, muy cómodo y la retroiluminación es genial. ¡Excelente compra!',
    rating: 4.8,
  ),
  const Review(
    author: "Elena V.",
    comment: "Mi smartwatch es perfecto para mis entrenamientos. Duración de batería increíble.",
    rating: 4.7,
  ),
];

final List<Offer> _allOffers = [
  Offer(product: _allProducts[0], discountPercentage: 0.20),
  Offer(product: _allProducts[1], discountPercentage: 0.15),
  Offer(product: _allProducts[2], discountPercentage: 0.25),
  Offer(product: _allProducts[3], discountPercentage: 0.10),
  Offer(product: _allProducts[4], discountPercentage: 0.12),
];

// ============================================================
// MAIN
// ============================================================

void main() {
  runApp(const ProvTecnoApp());
}

// ============================================================
// ROOT APP
// ============================================================

class ProvTecnoApp extends StatelessWidget {
  const ProvTecnoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<CartModel>(
      create: (_) => CartModel(),
      builder: (context, child) {
        return MaterialApp(
          title: 'ProvTecno',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primarySwatch: Colors.blueGrey,
            visualDensity: VisualDensity.adaptivePlatformDensity,
            appBarTheme: const AppBarTheme(
              backgroundColor: Colors.blueGrey,
              foregroundColor: Colors.white,
              elevation: 0,
            ),
            cardTheme: CardThemeData(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              color: Colors.white,
            ),
            elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueGrey,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                textStyle: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            colorScheme: ColorScheme.fromSwatch(
              primarySwatch: Colors.blueGrey,
            ).copyWith(secondary: Colors.tealAccent[400]),
          ),
          home: const Inicio(),
        );
      },
    );
  }
}

// ============================================================
// SHARED / HELPER WIDGETS
// ============================================================

class _ShoppingCartIcon extends StatelessWidget {
  const _ShoppingCartIcon();

  @override
  Widget build(BuildContext context) {
    return Consumer<CartModel>(
      builder: (context, cart, child) {
        final int itemCount = cart.totalItems;
        return Stack(
          children: [
            IconButton(
              icon: const Icon(Icons.shopping_cart),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const Carrito()),
                );
              },
            ),
            if (itemCount > 0)
              Positioned(
                right: 8,
                top: 8,
                child: Container(
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
                  child: Text(
                    '$itemCount',
                    style: const TextStyle(color: Colors.white, fontSize: 10),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}

class RatingStars extends StatelessWidget {
  final double rating;
  final double starSize;
  final Color starColor;

  const RatingStars({
    super.key,
    required this.rating,
    this.starSize = 18,
    this.starColor = Colors.amber,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        if (index < rating.floor()) {
          return Icon(Icons.star, color: starColor, size: starSize);
        } else if (index < rating && rating - index >= 0.5) {
          return Icon(Icons.star_half, color: starColor, size: starSize);
        } else {
          return Icon(Icons.star_border, color: starColor, size: starSize);
        }
      }),
    );
  }
}

// ============================================================
// REUSABLE CARD WIDGETS
// ============================================================

class ProductCard extends StatelessWidget {
  final Product product;

  const ProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ProductDetailsPage(product: product),
          ),
        );
      },
      child: Card(
        elevation: 6,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Hero(
                tag: 'productImage_${product.id}',
                child: ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                  child: Image.network(
                    product.imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => const Center(
                      child: Icon(Icons.image_not_supported, size: 40, color: Colors.grey),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    product.description,
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  RatingStars(rating: product.rating, starSize: 16),
                  const SizedBox(height: 8),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      '\$${product.price.toStringAsFixed(2)}',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.secondary,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Provider.of<CartModel>(context, listen: false).addProduct(product);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('${product.name} añadido al carrito!'),
                            duration: const Duration(seconds: 1),
                          ),
                        );
                      },
                      icon: const Icon(Icons.add_shopping_cart),
                      label: const Text("Agregar"),
                    ),
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

class OfferCard extends StatelessWidget {
  final Offer offer;

  const OfferCard({super.key, required this.offer});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
      elevation: 6,
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ProductDetailsPage(product: offer.product),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Hero(
                  tag: 'productImage_${offer.product.id}_offer',
                  child: Image.network(
                    offer.product.imageUrl,
                    width: 70,
                    height: 70,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => const Icon(
                      Icons.image_not_supported,
                      size: 40,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      offer.product.name,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Text(
                          '\$${offer.product.price.toStringAsFixed(2)}',
                          style: const TextStyle(
                            decoration: TextDecoration.lineThrough,
                            color: Colors.grey,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '\$${offer.discountedPrice.toStringAsFixed(2)}',
                          style: const TextStyle(
                            color: Colors.redAccent,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  offer.discountText,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ReviewCard extends StatelessWidget {
  final Review review;

  const ReviewCard({super.key, required this.review});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const CircleAvatar(
                  backgroundColor: Colors.blueGrey,
                  child: Icon(Icons.person, color: Colors.white),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    review.author,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ),
                RatingStars(rating: review.rating, starSize: 16),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              review.comment,
              style: const TextStyle(fontSize: 14, color: Colors.black87),
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================
// PAGES
// ============================================================

class Inicio extends StatelessWidget {
  const Inicio({super.key});

  void _abrirPagina(BuildContext context, Widget pagina) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => pagina));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("ProvTecno"),
        actions: const [_ShoppingCartIcon()],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.blueGrey),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Icon(Icons.memory, color: Colors.white, size: 50),
                  SizedBox(height: 10),
                  Text(
                    "ProvTecno",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "Tecnología inteligente a tu alcance",
                    style: TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.devices),
              title: const Text("Productos", style: TextStyle(fontSize: 16)),
              onTap: () => _abrirPagina(context, const Productos()),
            ),
            ListTile(
              leading: const Icon(Icons.local_offer),
              title: const Text("Ofertas", style: TextStyle(fontSize: 16)),
              onTap: () => _abrirPagina(context, const Ofertas()),
            ),
            ListTile(
              leading: const Icon(Icons.shopping_cart),
              title: const Text("Mi Carrito", style: TextStyle(fontSize: 16)),
              onTap: () => _abrirPagina(context, const Carrito()),
            ),
            ListTile(
              leading: const Icon(Icons.contact_mail),
              title: const Text("Contacto", style: TextStyle(fontSize: 16)),
              onTap: () => _abrirPagina(context, const Contacto()),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hero Section
            Stack(
              children: [
                Container(
                  height: 250,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: const NetworkImage(
                        'https://tse3.mm.bing.net/th/id/OIP.jHmnitetrL9Sxjqhju0g3AHaD_?rs=1&pid=ImgDetMain&o=7&rm=3',
                      ),
                      fit: BoxFit.cover,
                      colorFilter: ColorFilter.mode(
                        Colors.black.withAlpha(102),
                        BlendMode.darken,
                      ),
                    ),
                  ),
                  child: Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Colors.transparent, Colors.black54],
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 20,
                  left: 20,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "ProvTecno",
                        style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          shadows: const [
                            Shadow(blurRadius: 10, color: Colors.black, offset: Offset(2, 2)),
                          ],
                        ),
                      ),
                      Text(
                        "VENTA DE PRODUCTOS TECNOLÓGICOS",
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: Colors.white70,
                          shadows: const [
                            Shadow(blurRadius: 5, color: Colors.black, offset: Offset(1, 1)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 25),

            // Categories Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                "Explora por Categoría",
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 15),
            SizedBox(
              height: 120,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 15),
                children: [
                  _CategoryChip(
                    icon: Icons.laptop_mac,
                    label: "Laptops",
                    onTap: () => _abrirPagina(context, const Productos(category: "Laptops")),
                  ),
                  _CategoryChip(
                    icon: Icons.smartphone,
                    label: "Smartphones",
                    onTap: () => _abrirPagina(context, const Productos(category: "Smartphones")),
                  ),
                  _CategoryChip(
                    icon: Icons.headphones,
                    label: "Audífonos",
                    onTap: () => _abrirPagina(context, const Productos(category: "Audífonos")),
                  ),
                  _CategoryChip(
                    icon: Icons.monitor,
                    label: "Monitores",
                    onTap: () => _abrirPagina(context, const Productos(category: "Monitores")),
                  ),
                  _CategoryChip(
                    icon: Icons.watch,
                    label: "Wearables",
                    onTap: () => _abrirPagina(context, const Productos(category: "Wearables")),
                  ),
                  _CategoryChip(
                    icon: Icons.keyboard,
                    label: "Accesorios",
                    onTap: () => _abrirPagina(context, const Productos(category: "Accesorios")),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 25),

            // Featured Products Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                "Productos Destacados",
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 15),
            SizedBox(
              height: 380,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 15),
                itemCount: 4,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 15),
                    child: SizedBox(
                      width: 200,
                      child: ProductCard(product: _allProducts[index]),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 25),

            // About Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                "Sobre ProvTecno",
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 15),
            Card(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Nuestra Misión",
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'En ProvTecno, nuestra misión es cuidar cuidadosamente cada producto para asegurar calidad, innovación y valor. Nos esforzamos por ofrecer una experiencia de compra excepcional, con asesoramiento experto y un soporte postventa inigualable. Tu satisfacción es nuestra prioridad.',
                      style: TextStyle(fontSize: 16),
                      textAlign: TextAlign.justify,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 25),

            // Reviews Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                "Lo que dicen nuestros clientes",
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Column(
                children: _allReviews.map((r) => ReviewCard(review: r)).toList(),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

class _CategoryChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _CategoryChip({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 100,
        margin: const EdgeInsets.only(right: 10),
        decoration: BoxDecoration(
          color: Theme.of(context).cardTheme.color,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withAlpha(50),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: Theme.of(context).primaryColor),
            const SizedBox(height: 8),
            Text(
              label,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}

class Productos extends StatelessWidget {
  final String? category;

  const Productos({super.key, this.category});

  @override
  Widget build(BuildContext context) {
    final List<Product> displayedProducts = category == null
        ? _allProducts
        : _allProducts.where((p) => p.category == category).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(category == null ? "Todos los Productos" : "Productos de $category"),
        actions: const [_ShoppingCartIcon()],
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: displayedProducts.isEmpty
            ? const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.category, size: 80, color: Colors.grey),
                    SizedBox(height: 20),
                    Text(
                      "No hay productos en esta categoría.",
                      style: TextStyle(fontSize: 20, color: Colors.grey),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              )
            : GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 15,
                  mainAxisSpacing: 15,
                  childAspectRatio: 0.65,
                ),
                itemCount: displayedProducts.length,
                itemBuilder: (context, index) {
                  return ProductCard(product: displayedProducts[index]);
                },
              ),
      ),
    );
  }
}

class ProductDetailsPage extends StatelessWidget {
  final Product product;

  const ProductDetailsPage({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(product.name),
        actions: const [_ShoppingCartIcon()],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Hero(
              tag: 'productImage_${product.id}',
              child: Image.network(
                product.imageUrl,
                height: 300,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => const SizedBox(
                  height: 300,
                  child: Center(
                    child: Icon(Icons.image_not_supported, size: 100, color: Colors.grey),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      RatingStars(rating: product.rating, starSize: 24),
                      const SizedBox(width: 8),
                      Text(
                        '(${product.rating.toStringAsFixed(1)})',
                        style: const TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    '\$${product.price.toStringAsFixed(2)}',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: Theme.of(context).colorScheme.secondary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    "Descripción del Producto",
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    product.description,
                    style: const TextStyle(fontSize: 16, height: 1.5),
                    textAlign: TextAlign.justify,
                  ),
                  const SizedBox(height: 24),
                  if (product.specifications.isNotEmpty) ...[
                    Text(
                      "Especificaciones Técnicas",
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Column(
                      children: product.specifications.map((spec) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: 120,
                                child: Text(
                                  spec['key']!,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 15,
                                  ),
                                ),
                              ),
                              const Text(":  "),
                              Expanded(
                                child: Text(
                                  spec['value']!,
                                  style: const TextStyle(fontSize: 15),
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 24),
                  ],
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Provider.of<CartModel>(context, listen: false).addProduct(product);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('${product.name} añadido al carrito!'),
                            duration: const Duration(seconds: 1),
                          ),
                        );
                      },
                      icon: const Icon(Icons.add_shopping_cart),
                      label: const Text("Agregar al Carrito"),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 15),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    "Opiniones de Clientes",
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Column(
                    children: _allReviews.map((r) => ReviewCard(review: r)).toList(),
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

class Carrito extends StatelessWidget {
  const Carrito({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Tu Carrito de Compras")),
      body: Consumer<CartModel>(
        builder: (context, cart, child) {
          if (cart.items.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.remove_shopping_cart, size: 80, color: Colors.grey),
                  SizedBox(height: 20),
                  Text(
                    "Tu carrito está vacío",
                    style: TextStyle(
                      fontSize: 22,
                      color: Colors.grey,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "¡Añade algunos productos increíbles!",
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                ],
              ),
            );
          }

          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: cart.items.length,
                  itemBuilder: (context, index) {
                    final CartItem cartItem = cart.items[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ListTile(
                          leading: const Icon(Icons.shopping_bag, color: Colors.blueGrey),
                          title: Text(
                            cartItem.name,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                            '\$${cartItem.price.toStringAsFixed(2)} x ${cartItem.quantity}',
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.remove),
                                onPressed: () => cart.decrementQuantity(cartItem.productId),
                              ),
                              Text('${cartItem.quantity}'),
                              IconButton(
                                icon: const Icon(Icons.add),
                                onPressed: () => cart.incrementQuantity(cartItem.productId),
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete, color: Colors.red),
                                onPressed: () {
                                  cart.removeItem(cartItem.productId);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('${cartItem.name} eliminado.'),
                                      duration: const Duration(seconds: 1),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              Card(
                margin: const EdgeInsets.all(15),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Total:",
                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            '\$${cart.totalPrice.toStringAsFixed(2)}',
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: () {
                            cart.clearCart();
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('¡Gracias por tu compra! Carrito vaciado.'),
                                duration: Duration(seconds: 2),
                              ),
                            );
                            Navigator.pop(context);
                          },
                          icon: const Icon(Icons.payment),
                          label: const Text("Finalizar Compra"),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class Ofertas extends StatelessWidget {
  const Ofertas({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Ofertas Especiales")),
      body: ListView(
        children: [
          const SizedBox(height: 20),
          Center(
            child: Text(
              "Oportunidades Imperdibles",
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.redAccent,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 15),
          ..._allOffers.map((offer) => OfferCard(offer: offer)),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

class Contacto extends StatelessWidget {
  const Contacto({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Contacto")),
      body: Center(
        child: Card(
          margin: const EdgeInsets.all(25),
          child: Padding(
            padding: const EdgeInsets.all(25.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.headset_mic, size: 80, color: Colors.blueGrey),
                const SizedBox(height: 20),
                Text(
                  "ProvTecno",
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 15),
                const ListTile(
                  leading: Icon(Icons.email, color: Colors.blueGrey),
                  title: Text("Email"),
                  subtitle: Text("cordobarengifoedwindisney@gmail.com"),
                ),
                const ListTile(
                  leading: Icon(Icons.phone, color: Colors.blueGrey),
                  title: Text("Teléfono"),
                  subtitle: Text("+57 321 884 4014"),
                ),
                const ListTile(
                  leading: Icon(Icons.location_on, color: Colors.blueGrey),
                  title: Text("Dirección"),
                  subtitle: Text("Calle Ficticia 123, Ciudad Digital"),
                ),
                const SizedBox(height: 20),
                Text(
                  "Estamos aquí para ayudarte. ¡Contáctanos!",
                  style: Theme.of(context).textTheme.titleMedium,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
