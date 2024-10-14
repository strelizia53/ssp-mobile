import 'package:flutter/material.dart';
import 'api_service.dart';


class CartScreen extends StatefulWidget {
  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  Future<Map<String, dynamic>>? _cart;

  @override
  void initState() {
    super.initState();
    _cart = ApiService().getCartItems(); // Fetch the cart items
  }

  Future<void> _removeFromCart(int productId) async {
    try {
      await ApiService().removeFromCart(productId);
      setState(() {
        _cart = ApiService().getCartItems(); // Refresh cart after removal
      });
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Failed to remove item: $error'),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Your Cart')),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _cart,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!['cart'].isEmpty) {
            return Center(child: Text('Your cart is empty'));
          }

          var cartItems = snapshot.data!['cart'];
          double totalPrice = snapshot.data!['totalPrice'];

          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: cartItems.length,
                  itemBuilder: (context, index) {
                    var productId = cartItems.keys.elementAt(index);
                    var item = cartItems[productId];

                    return ListTile(
                      leading: Image.network('http://10.0.2.2:8000/${item['image']}'),
                      title: Text(item['name']),
                      subtitle: Text('Quantity: ${item['quantity']}'),
                      trailing: IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () => _removeFromCart(int.parse(productId)),
                      ),
                    );
                  },
                ),
              ),
              Text('Total Price: \$${totalPrice.toStringAsFixed(2)}'),
            ],
          );
        },
      ),
    );
  }
}
