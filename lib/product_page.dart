import 'package:flutter/material.dart';
import 'api_service.dart';
import 'product_model.dart';
import 'product_detail_page.dart';

class ProductPage extends StatefulWidget {
  const ProductPage({Key? key}) : super(key: key);

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  late Future<List<Product>> futureProducts;

  @override
  void initState() {
    super.initState();
    futureProducts = fetchProducts();
  }

  // Fetch product list from the API
  Future<List<Product>> fetchProducts() async {
    final apiService = ApiService();
    try {
      final response = await apiService.fetchProducts();
      final productList = response['products'] as List;
      return productList
          .map((data) => Product.fromJson(data as Map<String, dynamic>))
          .toList();
    } catch (e) {
      // Throw a custom exception message
      throw Exception('No internet connection. Please check your network.');
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context); // Get the current theme
    final isDarkMode = theme.brightness == Brightness.dark; // Check if dark mode is active

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor, // Use theme's background color
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Brand Title at the top
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 16.0),
              child: Center(
                child: Text(
                  'ORYX Products',
                  style: TextStyle(
                    color: theme.colorScheme.secondary, // Dynamically use theme color
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            // Product Grid
            Expanded(
              child: FutureBuilder<List<Product>>(
                future: futureProducts,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    // Display the error message when there's no internet connection or another error
                    return Center(
                      child: Text(
                        'Sorry, no internet connection available. Please try again later.',
                        style: TextStyle(
                          color: theme.colorScheme.error, // Use theme's error color
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    );
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text('No products found.'));
                  }

                  final products = snapshot.data!;

                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GridView.builder(
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2, // Display two products per row
                        mainAxisSpacing: 10,
                        crossAxisSpacing: 10,
                        childAspectRatio: 0.65, // Adjusted to give better layout (taller cards)
                      ),
                      itemCount: products.length,
                      itemBuilder: (context, index) {
                        final product = products[index];
                        return ProductCard(product: product, isDarkMode: isDarkMode);
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Product Card Widget
class ProductCard extends StatelessWidget {
  final Product product;
  final bool isDarkMode; // Add a boolean flag to check dark mode

  const ProductCard({Key? key, required this.product, required this.isDarkMode}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context); // Get the current theme

    return GestureDetector(
      onTap: () {
        // Navigate to the ProductDetailPage when tapped
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductDetailPage(productId: product.id),
          ),
        );
      },
      child: Card(
        color: isDarkMode ? const Color(0xFF2B3554) : Colors.white, // Different colors for dark/light mode
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15), // Rounded corners
        ),
        elevation: 5, // Shadow for the card to make it pop
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Product Image with proper aspect ratio to avoid image crush
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: Image.network(
                    'http://10.0.2.2:8000/storage/${product.image}', // Adjust to your image URL
                    fit: BoxFit.cover,
                    width: double.infinity,
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(Icons.broken_image, color: Colors.red);
                    },
                  ),
                ),
              ),
              const SizedBox(height: 8),
              // Product Name
              Text(
                product.name,
                style: TextStyle(
                  color: theme.textTheme.bodyMedium?.color, // Dynamically use text color from theme
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 1, // Prevent overflow
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              // Product Description
              Text(
                product.description,
                style: TextStyle(
                  color: theme.textTheme.bodyMedium?.color?.withOpacity(0.7),
                  fontSize: 12,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const Spacer(),
              // Product Price
              Text(
                '\$${product.price}',
                style: TextStyle(
                  color: theme.colorScheme.secondary,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              // Product Stock Info
              Text(
                'In Stock: ${product.stock}',
                style: TextStyle(
                  color: theme.textTheme.bodyMedium?.color?.withOpacity(0.6),
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 6),
              // View Product Button
              Align(
                alignment: Alignment.centerLeft,
                child: TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProductDetailPage(productId: product.id),
                      ),
                    );
                  },
                  child: Text(
                    'View Product',
                    style: TextStyle(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
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