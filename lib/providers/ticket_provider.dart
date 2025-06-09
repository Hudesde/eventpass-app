import 'dart:async';
import 'package:flutter/material.dart';
import 'package:tickets_app/models/ticket.dart';
import 'package:tickets_app/services/firestore_service.dart';

class TicketProvider extends ChangeNotifier {
  final FirestoreService _firestoreService = FirestoreService();
  List<Ticket> _tickets = [];
  bool _isLoading = true;
  String? _error;

  // Getters
  List<Ticket> get tickets => [..._tickets];
  bool get isLoading => _isLoading;
  String? get error => _error;
  
  // Stream subscription para mantener la lista actualizada
  StreamSubscription<List<Ticket>>? _ticketsSubscription;

  // Constructor
  TicketProvider() {
    // Carga los datos de muestra (solo en desarrollo)
    _loadSampleData();
    
    // Inicia la escucha de cambios en Firestore
    _listenToTickets();
  }

  // Cargar datos de muestra (solo en desarrollo)
  Future<void> _loadSampleData() async {
    try {
      await _firestoreService.loadSampleData();
    } catch (e) {
      print('Error al cargar datos de muestra: $e');
    }
  }

  // Escuchar cambios en los tickets
  void _listenToTickets() {
    _isLoading = true;
    notifyListeners();

    _ticketsSubscription?.cancel();
    _ticketsSubscription = _firestoreService.getTickets().listen(
      (tickets) {
        _tickets = tickets;
        _isLoading = false;
        _error = null;
        notifyListeners();
      },
      onError: (error) {
        _isLoading = false;
        _error = 'Error al cargar los tickets: $error';
        print(_error);
        notifyListeners();
      }
    );
  }

  // Get favorite tickets
  List<Ticket> get favoriteTickets => 
      _tickets.where((ticket) => ticket.isFavorite).toList();

  // Toggle favorite status
  Future<void> toggleFavorite(String ticketId) async {
    final ticketIndex = _tickets.indexWhere((ticket) => ticket.id == ticketId);
    if (ticketIndex >= 0) {
      final isFavorite = !_tickets[ticketIndex].isFavorite;
      
      // Actualizar localmente primero para una UI más responsiva
      _tickets[ticketIndex] = _tickets[ticketIndex].copyWith(
        isFavorite: isFavorite,
      );
      notifyListeners();
      
      // Luego actualizar en Firestore
      try {
        await _firestoreService.toggleFavorite(ticketId, isFavorite);
      } catch (e) {
        // Si hay un error, revertir el cambio local
        _tickets[ticketIndex] = _tickets[ticketIndex].copyWith(
          isFavorite: !isFavorite,
        );
        notifyListeners();
        print('Error al actualizar favorito: $e');
      }
    }
  }

  // Get ticket by ID
  Ticket getTicketById(String id) {
    return _tickets.firstWhere(
      (ticket) => ticket.id == id,
      orElse: () => Ticket(
        id: '',
        name: 'Not Found',
        description: 'Ticket not found',
        date: '',
        venue: '',
        imageUrls: [],
        videoUrl: null,
        category: '',
        price: 0,
      ),
    );
  }

  // Get tickets by category
  List<Ticket> getTicketsByCategory(String category) {
    return _tickets.where((ticket) => ticket.category == category).toList();
  }
  
  // Método para recargar los datos (útil para reintentar después de un error)
  void reloadData() {
    _listenToTickets();
  }
  
  // Importante: Cancelar la suscripción cuando el provider se destruye
  @override
  void dispose() {
    _ticketsSubscription?.cancel();
    super.dispose();
  }
}
