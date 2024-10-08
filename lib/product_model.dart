class Product {
  final int id;
  final String name;
  final String description;
  final String price;
  final int stock;
  final String image;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.stock,
    required this.image,
  });

  // Factory method to create a Product from JSON data
  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      price: json['price'],
      stock: json['stock'],
      image: json['image'],
    );
  }
}
