import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tickets_app/providers/ticket_provider.dart';
import 'package:tickets_app/screens/home_screen.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ticketProvider = Provider.of<TicketProvider>(context);
    final favoriteTickets = ticketProvider.favoriteTickets;
    final isLoading = ticketProvider.isLoading;
    final error = ticketProvider.error;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF0A192F),
        elevation: 10,
        shadowColor: Colors.cyanAccent.withOpacity(0.5),
        title: const Text(
          'Favoritos',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 28,
            color: Color(0xFF00FFF7),
            letterSpacing: 2,
            fontFamily: 'monospace',
            shadows: [
              Shadow(
                blurRadius: 12,
                color: Color(0xFF00FFF7),
                offset: Offset(0, 0),
              ),
            ],
          ),
        ),
        centerTitle: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(24)),
          side: BorderSide(color: Color(0xFF00FFF7), width: 3),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Mis Tickets Favoritos',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: _buildContent(isLoading, error, favoriteTickets),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent(bool isLoading, String? error, List<dynamic> favoriteTickets) {
    if (isLoading) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Cargando favoritos...'),
          ],
        ),
      );
    }

    if (error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 48, color: Colors.red),
            const SizedBox(height: 16),
            const Text(
              'Error al cargar favoritos',
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 8),
            Text(
              error,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    if (favoriteTickets.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.favorite_border, size: 80, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              'No tienes tickets favoritos',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Marca como favorito los eventos que más te interesen',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: favoriteTickets.length,
      itemBuilder: (context, index) {
        return TicketCard(ticket: favoriteTickets[index]);
      },
    );
  }
}
