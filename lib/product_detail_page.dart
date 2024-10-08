import 'package:flutter/material.dart';
import 'api_service.dart';
import 'product_model.dart';

class ProductDetailPage extends StatefulWidget {
  final int productId;

  const ProductDetailPage({Key? key, required this.productId}) : super(key: key);

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  late Future<Product> futureProduct;

  @override
  void initState() {
    super.initState();
    futureProduct = fetchProduct();
  }

  Future<Product> fetchProduct() async {
    final apiService = ApiService();
    return await apiService.fetchProductById(widget.productId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.pinkAccent,
        title: const Text('Product Details'),
      ),
      body: FutureBuilder<Product>(
        future: futureProduct,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return const Center(child: Text('Product not found.'));
          }

          final product = snapshot.data!;
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Simple Product Image using Image.network
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    'http://10.0.2.2:8000/storage/${product.image}',  // Replace with correct image URL
                    fit: BoxFit.cover,
                    height: 250,
                    width: double.infinity,
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(Icons.broken_image, color: Colors.red);
                    },
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  product.name,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  product.description,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  '\$${product.price}',
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.greenAccent,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'In Stock: ${product.stock}',
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
