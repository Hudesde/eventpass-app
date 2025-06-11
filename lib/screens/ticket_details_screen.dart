import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tickets_app/models/ticket.dart';
import 'package:tickets_app/providers/ticket_provider.dart';
import 'package:tickets_app/providers/cart_provider.dart';
import 'package:video_player/video_player.dart';

class TicketDetailsScreen extends StatefulWidget {
  final Ticket ticket;
  const TicketDetailsScreen({Key? key, required this.ticket}) : super(key: key);

  @override
  State<TicketDetailsScreen> createState() => _TicketDetailsScreenState();
}

class _TicketDetailsScreenState extends State<TicketDetailsScreen> {
  bool isFavorite = false;
  int _current = 0;
  PageController? _pageController;
  VideoPlayerController? _videoController;
  bool _videoInitialized = false;
  int adultCount = 1;
  int childCount = 0;
  int seniorCount = 0;

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
  void didChangeDependencies() {
    super.didChangeDependencies();
    final ticketProvider = Provider.of<TicketProvider>(context, listen: false);
    isFavorite = ticketProvider.favoriteTickets.any((t) => t.id == widget.ticket.id);
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final ticketProvider = Provider.of<TicketProvider>(context);
    final isFavoriteNow = ticketProvider.favoriteTickets.any((t) => t.id == widget.ticket.id);
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
              VideoProgressIndicator(_videoController!, allowScrubbing: true, colors: VideoProgressColors(playedColor: Colors.deepPurple)),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: const Icon(Icons.replay_10, color: Colors.white),
                    onPressed: () => _videoController!.seekTo(_videoController!.value.position - const Duration(seconds: 10)),
                  ),
                  IconButton(
                    icon: Icon(_videoController!.value.isPlaying ? Icons.pause : Icons.play_arrow, color: Colors.white),
                    onPressed: () {
                      setState(() {
                        _videoController!.value.isPlaying ? _videoController!.pause() : _videoController!.play();
                      });
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.forward_10, color: Colors.white),
                    onPressed: () => _videoController!.seekTo(_videoController!.value.position + const Duration(seconds: 10)),
                  ),
                ],
              ),
            ],
          ),
        ),
    ];
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF0A192F),
        elevation: 10,
        shadowColor: Colors.cyanAccent.withOpacity(0.5),
        title: Text(
          widget.ticket.name,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 22,
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
        leading: IconButton(
          color: const Color(0xFF00FFF7),
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back),
        ),
        actions: [
          IconButton(
            onPressed: () async {
              await ticketProvider.toggleFavorite(widget.ticket.id);
              setState(() {});
            },
            icon: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              transitionBuilder: (child, animation) => ScaleTransition(scale: animation, child: child),
              child: Icon(
                isFavoriteNow ? Icons.favorite : Icons.favorite_border,
                color: const Color(0xFF00FFF7),
                key: ValueKey<bool>(isFavoriteNow),
              ),
            ),
          ),
        ],
        centerTitle: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(24)),
          side: BorderSide(color: Color(0xFF00FFF7), width: 3),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(25),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
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
                    color: _current == index ? Colors.deepPurple : Colors.grey[600],
                  ),
                )),
              ),
              const SizedBox(height: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.ticket.name,
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 20,
                      color: colors.primary,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  Text(widget.ticket.venue),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.5,
                    color: colors.primary,
                    height: 3,
                  ),
                  const SizedBox(height: 10),
                  Text(widget.ticket.date),
                  const SizedBox(height: 10),
                  Text(widget.ticket.description),
                  const SizedBox(height: 20),
                  Text('Selecciona tus boletos:', style: TextStyle(fontWeight: FontWeight.bold)),
                  Row(
                    children: [
                      const Text('Adulto'),
                      IconButton(
                        icon: const Icon(Icons.remove),
                        onPressed: () => setState(() { if (adultCount > 0) adultCount--; }),
                      ),
                      Text('$adultCount'),
                      IconButton(
                        icon: const Icon(Icons.add),
                        onPressed: () => setState(() { adultCount++; }),
                      ),
                      const SizedBox(width: 16),
                      const Text('Niño'),
                      IconButton(
                        icon: const Icon(Icons.remove),
                        onPressed: () => setState(() { if (childCount > 0) childCount--; }),
                      ),
                      Text('$childCount'),
                      IconButton(
                        icon: const Icon(Icons.add),
                        onPressed: () => setState(() { childCount++; }),
                      ),
                      const SizedBox(width: 16),
                      const Text('Adulto mayor'),
                      IconButton(
                        icon: const Icon(Icons.remove),
                        onPressed: () => setState(() { if (seniorCount > 0) seniorCount--; }),
                      ),
                      Text('$seniorCount'),
                      IconButton(
                        icon: const Icon(Icons.add),
                        onPressed: () => setState(() { seniorCount++; }),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.shopping_cart),
                    label: const Text('Agregar al carrito'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colors.primary,
                      foregroundColor: Colors.white,
                    ),
                    onPressed: () {
                      final total = adultCount + childCount + seniorCount;
                      if (total == 0) {
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Selecciona al menos un boleto.')));
                        return;
                      }
                      Provider.of<CartProvider>(context, listen: false).addToCart(
                        widget.ticket,
                        adult: adultCount,
                        child: childCount,
                        senior: seniorCount,
                      );
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Boletos agregados al carrito: $total')),
                      );
                    },
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    height: 180,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        'https://maps.googleapis.com/maps/api/staticmap?center=${Uri.encodeComponent(widget.ticket.venue)}&zoom=15&size=600x180&key=TU_API_KEY',
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(
                          color: Colors.grey[800],
                          child: const Center(child: Text('Mapa no disponible', style: TextStyle(color: Colors.white54))),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
