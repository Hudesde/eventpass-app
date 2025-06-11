import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tickets_app/models/ticket.dart';
import 'package:tickets_app/providers/ticket_provider.dart';
import 'package:tickets_app/providers/cart_provider.dart';
import 'package:video_player/video_player.dart';
import 'package:tickets_app/screens/ticket_details_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ticketProvider = Provider.of<TicketProvider>(context);
    final tickets = ticketProvider.tickets;
    final isLoading = ticketProvider.isLoading;
    final error = ticketProvider.error;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Eventos Disponibles',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: _buildContent(isLoading, error, tickets),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(bool isLoading, String? error, List<Ticket> tickets) {
    if (isLoading) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Cargando eventos...'),
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
              'Error al cargar los eventos',
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 8),
            Text(
              error,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Builder(
              builder: (context) => ElevatedButton(
                onPressed: () {
                  // Reintentar la carga de datos
                  Provider.of<TicketProvider>(
                    context, 
                    listen: false
                  ).reloadData();
                },
                child: const Text('Reintentar'),
              ),
            ),
          ],
        ),
      );
    }

    if (tickets.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.event_busy, size: 48, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              'No hay eventos disponibles',
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: tickets.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => TicketDetailsScreen(ticket: tickets[index]),
              ),
            );
          },
          child: TicketCard(ticket: tickets[index]),
        );
      },
    );
  }
}

class TicketCard extends StatefulWidget {
  final Ticket ticket;
  const TicketCard({Key? key, required this.ticket}) : super(key: key);

  @override
  State<TicketCard> createState() => _TicketCardState();
}

class _TicketCardState extends State<TicketCard> {
  int _current = 0;
  PageController? _pageController;
  VideoPlayerController? _videoController;
  bool _videoInitialized = false;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    if (widget.ticket.videoUrl != null) {
      _videoController = VideoPlayerController.asset(widget.ticket.videoUrl!);
      _videoController!.initialize().then((_) {
        setState(() {
          _videoInitialized = true;
        });
      });
    }
  }

  @override
  void dispose() {
    _videoController?.dispose();
    _pageController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ticketProvider = Provider.of<TicketProvider>(context, listen: false);
    final List<Widget> mediaItems = [
      ...widget.ticket.imageUrls.map((url) => ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.network(url, fit: BoxFit.cover, width: double.infinity, height: 220, loadingBuilder: (c, w, l) => l == null ? w : Container(color: Colors.grey[200], height: 220),),
          )),
      if (widget.ticket.videoUrl != null && _videoInitialized)
        ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              AspectRatio(
                aspectRatio: _videoController!.value.aspectRatio,
                child: VideoPlayer(_videoController!),
              ),
              VideoProgressIndicator(_videoController!, allowScrubbing: true, colors: VideoProgressColors(playedColor: Colors.black)),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: const Icon(Icons.replay_10, color: Colors.black),
                    onPressed: () => _videoController!.seekTo(_videoController!.value.position - const Duration(seconds: 10)),
                  ),
                  IconButton(
                    icon: Icon(_videoController!.value.isPlaying ? Icons.pause : Icons.play_arrow, color: Colors.black),
                    onPressed: () {
                      setState(() {
                        _videoController!.value.isPlaying ? _videoController!.pause() : _videoController!.play();
                      });
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.forward_10, color: Colors.black),
                    onPressed: () => _videoController!.seekTo(_videoController!.value.position + const Duration(seconds: 10)),
                  ),
                ],
              ),
            ],
          ),
        ),
    ];

    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.black, width: 1.2),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Carrusel minimalista con PageView
          SizedBox(
            height: 240,
            child: PageView.builder(
              controller: _pageController,
              itemCount: mediaItems.length,
              onPageChanged: (index) {
                setState(() {
                  _current = index;
                });
              },
              itemBuilder: (context, index) => mediaItems[index],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(mediaItems.length, (index) => Container(
              width: 8,
              height: 8,
              margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 2),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _current == index ? Colors.black : Colors.grey[300],
              ),
            )),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        widget.ticket.name,
                        style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black),
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        widget.ticket.isFavorite ? Icons.favorite : Icons.favorite_border,
                        color: Colors.black,
                      ),
                      onPressed: () => ticketProvider.toggleFavorite(widget.ticket.id),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(widget.ticket.date, style: const TextStyle(color: Colors.black87)),
                const SizedBox(height: 2),
                Text(widget.ticket.venue, style: const TextStyle(color: Colors.black54)),
                const SizedBox(height: 8),
                Text(
                  widget.ticket.description,
                  style: const TextStyle(color: Colors.black87),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      ' 24${widget.ticket.price.toStringAsFixed(2)}',
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
                    ),
                    OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.black,
                        side: const BorderSide(color: Colors.black),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        backgroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                      ),
                      onPressed: () {
                        Provider.of<CartProvider>(context, listen: false).addToCart(widget.ticket);
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            backgroundColor: Colors.white,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16), side: const BorderSide(color: Colors.black)),
                            title: const Text('Carrito', style: TextStyle(color: Colors.black)),
                            content: Text('Simulación: ${widget.ticket.name} agregado al carrito.', style: const TextStyle(color: Colors.black)),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text('OK', style: TextStyle(color: Colors.black)),
                              ),
                            ],
                          ),
                        );
                      },
                      child: const Text('Agregar al carrito', style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
