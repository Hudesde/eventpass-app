// Model for ticket/event data
class Ticket {
  final String id;
  final String name;
  final String description;
  final String date;
  final String venue;
  final List<String> imageUrls;
  final String? videoUrl;
  final String category;
  final double price;
  bool isFavorite;

  Ticket({
    required this.id,
    required this.name,
    required this.description,
    required this.date,
    required this.venue,
    required this.imageUrls,
    this.videoUrl,
    required this.category,
    required this.price,
    this.isFavorite = false,
  });

  // Create a copy of the ticket with updated properties
  Ticket copyWith({
    String? id,
    String? name,
    String? description,
    String? date,
    String? venue,
    List<String>? imageUrls,
    String? videoUrl,
    String? category,
    double? price,
    bool? isFavorite,
  }) {
    return Ticket(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      date: date ?? this.date,
      venue: venue ?? this.venue,
      imageUrls: imageUrls ?? this.imageUrls,
      videoUrl: videoUrl ?? this.videoUrl,
      category: category ?? this.category,
      price: price ?? this.price,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }
}
