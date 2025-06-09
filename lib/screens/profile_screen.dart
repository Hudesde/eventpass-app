import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tickets_app/providers/ticket_provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ticketProvider = Provider.of<TicketProvider>(context);
    final favorites = ticketProvider.favoriteTickets;
    // Simulación de adquiridos: todos los tickets
    final acquired = ticketProvider.tickets;
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        body: TabBarView(
          children: [
            ListView.builder(
              itemCount: favorites.length,
              itemBuilder: (context, i) => ListTile(
                title: Text(favorites[i].name),
                subtitle: Text(favorites[i].date),
              ),
            ),
            ListView.builder(
              itemCount: acquired.length,
              itemBuilder: (context, i) => ListTile(
                title: Text(acquired[i].name),
                subtitle: Text(acquired[i].date),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
