import 'package:flutter/material.dart';
import 'package:tickets_app/models/ticket.dart';

class CartItem {
  final Ticket ticket;
  int adultCount;
  int childCount;
  int seniorCount;

  CartItem({
    required this.ticket,
    this.adultCount = 0,
    this.childCount = 0,
    this.seniorCount = 0,
  });

  int get total => adultCount + childCount + seniorCount;
}

class CartProvider extends ChangeNotifier {
  final Map<String, CartItem> _items = {}; // ticketId -> CartItem

  List<CartItem> get items => _items.values.toList();
  List<Ticket> get tickets => _items.values.map((e) => e.ticket).toList();

  void addToCart(Ticket ticket, {int adult = 0, int child = 0, int senior = 0}) {
    if (_items.containsKey(ticket.id)) {
      _items[ticket.id]!.adultCount += adult;
      _items[ticket.id]!.childCount += child;
      _items[ticket.id]!.seniorCount += senior;
    } else {
      _items[ticket.id] = CartItem(
        ticket: ticket,
        adultCount: adult,
        childCount: child,
        seniorCount: senior,
      );
    }
    notifyListeners();
  }

  void removeFromCart(String ticketId) {
    if (_items.containsKey(ticketId)) {
      _items.remove(ticketId);
      notifyListeners();
    }
  }

  void clearCart() {
    _items.clear();
    notifyListeners();
  }

  int getItemCount(String ticketId) => _items[ticketId]?.total ?? 0;
  int get totalItems => _items.values.fold(0, (a, b) => a + b.total);
}
