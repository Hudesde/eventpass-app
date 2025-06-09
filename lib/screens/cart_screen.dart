import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tickets_app/providers/cart_provider.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);
    final items = cart.items;
    return Scaffold(
      body: items.isEmpty
          ? const Center(child: Text('El carrito está vacío'))
          : ListView.builder(
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];
                return ListTile(
                  title: Text(item.ticket.name),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (item.adultCount > 0) Text('Adulto: ${item.adultCount}'),
                      if (item.childCount > 0) Text('Niño: ${item.childCount}'),
                      if (item.seniorCount > 0) Text('Adulto mayor: ${item.seniorCount}'),
                      Text('Total: ${item.total}'),
                    ],
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () => cart.removeFromCart(item.ticket.id),
                  ),
                );
              },
            ),
      bottomNavigationBar: items.isEmpty
          ? null
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Compra simulada'),
                      content: const Text('¡Gracias por tu compra! (Simulada)'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            cart.clearCart();
                            Navigator.of(context).pop();
                          },
                          child: const Text('OK'),
                        ),
                      ],
                    ),
                  );
                },
                child: const Text('Finalizar compra'),
              ),
            ),
    );
  }
}
