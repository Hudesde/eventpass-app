import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:tickets_app/models/ticket.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collection = 'tickets';

  // Obtener todos los tickets
  Stream<List<Ticket>> getTickets() {
    return _firestore.collection(_collection).snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data();
        return Ticket(
          id: doc.id,
          name: data['name'] ?? '',
          description: data['description'] ?? '',
          date: data['date'] ?? '',
          venue: data['venue'] ?? '',
          imageUrls: (data['imageUrls'] as List?)?.map((e) => e.toString()).toList() ?? [],
          videoUrl: data['videoUrl'],
          category: data['category'] ?? '',
          price: (data['price'] ?? 0).toDouble(),
          isFavorite: data['isFavorite'] ?? false,
        );
      }).toList();
    });
  }

  // Obtener un ticket por ID
  Future<Ticket?> getTicketById(String id) async {
    final doc = await _firestore.collection(_collection).doc(id).get();
    if (!doc.exists) return null;
    
    Map<String, dynamic> data = doc.data()!;
    return Ticket(
      id: doc.id,
      name: data['name'] ?? '',
      description: data['description'] ?? '',
      date: data['date'] ?? '',
      venue: data['venue'] ?? '',
      imageUrls: (data['imageUrls'] as List?)?.map((e) => e.toString()).toList() ?? [],
      videoUrl: data['videoUrl'],
      category: data['category'] ?? '',
      price: (data['price'] ?? 0).toDouble(),
      isFavorite: data['isFavorite'] ?? false,
    );
  }

  // Actualizar el estado de favorito de un ticket
  Future<void> toggleFavorite(String id, bool isFavorite) async {
    await _firestore.collection(_collection).doc(id).update({
      'isFavorite': isFavorite,
    });
  }

  // En una implementación real, podrías tener métodos para:
  // - Añadir tickets
  // - Eliminar tickets
  // - Actualizar tickets
  // - Filtrar tickets por categoría
  // - etc.

  // Método para cargar datos iniciales de muestra (solo para fines educativos)
  Future<void> loadSampleData() async {
    // Comprobar si ya existen datos
    final snapshot = await _firestore.collection(_collection).limit(1).get();
    if (snapshot.docs.isNotEmpty) {
      print('Los datos de muestra ya existen, no se cargarán nuevamente.');
      return;
    }

    // =============================
    //  AQUI PUEDES CAMBIAR LAS URLS DE IMAGENES Y VIDEOS DE CADA EVENTO
    //  SOLO MODIFICA LOS CAMPOS 'imageUrls' Y 'videoUrl' DE CADA TICKET
    //  PUEDES USAR CUALQUIER URL PUBLICA DE IMAGEN O VIDEO MP4
    // =============================
    // Ejemplo:
    // 'imageUrls': [
    //   'https://tusitio.com/imagen1.jpg',
    //   'https://tusitio.com/imagen2.jpg',
    // ],
    // 'videoUrl': 'https://tusitio.com/video.mp4',
    // =============================

    // Lista de tickets de muestra
    final sampleTickets = [
      {
        'name': 'Concierto de Rock',
        'description': 'El mejor concierto de rock del año con bandas internacionales.',
        'date': '15 Julio, 2025 - 20:00',
        'venue': 'Arena Ciudad',
        'imageUrls': [
          'https://imgs.search.brave.com/FQqDXVqTAkK-JZ7iOfloWo_jH4fKuTMm33B_9l0ChE0/rs:fit:860:0:0:0/g:ce/aHR0cHM6Ly9jZG4u/cGl4YWJheS5jb20v/cGhvdG8vMjAyMi8w/My8xMC8yMC8yOC9y/b2NrLWJhbmQtNzA2/MDY4OV82NDAuanBn',
          'https://imgs.search.brave.com/zvPaBs_7oty6lHbjGwRPThpI1h8DtpCdnrei02j6Z5I/rs:fit:860:0:0:0/g:ce/aHR0cHM6Ly9zdGF0/aWMudmVjdGVlenku/Y29tL3N5c3RlbS9y/ZXNvdXJjZXMvdGh1/bWJuYWlscy8wMjQv/NjAzLzgxMS9zbWFs/bC9yb2NrLW11c2lj/LWNvbmNlcnQtYmFj/a2dyb3VuZC1pbGx1/c3RyYXRpb24tYWkt/Z2VuZXJhdGl2ZS1m/cmVlLXBob3RvLmpw/Zw',
        ],
        'videoUrl': 'https://github.com/Hudesde/eventpass-app/raw/main/lib/assets/rock.mp4',
        'category': 'Concierto',
        'price': 75.00,
        'isFavorite': false,
        'address': 'Av. Insurgentes Sur 123, CDMX',
      },
      {
        'name': 'Festival de Música Electrónica',
        'description': 'Un día completo de música electrónica con DJs internacionales.',
        'date': '20 Agosto, 2025 - 14:00',
        'venue': 'Parque Central',
        'imageUrls': [
          'https://imgs.search.brave.com/WCjmaFNXYUUkR8BX9PQ1Hk-YySMQiHrJWsdKUNtWYPA/rs:fit:860:0:0:0/g:ce/aHR0cHM6Ly93d3cu/ZG9uZGVpci5jb20v/d3AtY29udGVudC91/cGxvYWRzLzIwMTcv/MTEvNS1mZXN0aXZh/bGVzLWRlLW11c2lj/YS1lbGVjdHJvbmlj/YS0wNS5qcGc',
          'https://imgs.search.brave.com/fJeIBpBjhD6rQIIycSr36QnGqvUElZx1gUViV9BXtyQ/rs:fit:860:0:0:0/g:ce/aHR0cHM6Ly93d3cu/ZG9uZGVpci5jb20v/d3AtY29udGVudC91/cGxvYWRzLzIwMTcv/MTEvNS1mZXN0aXZh/bGVzLWRlLW11c2lj/YS1lbGVjdHJvbmlj/YS0xMS5qcGc',
        ],
        'videoUrl': 'https://github.com/Hudesde/eventpass-app/raw/main/lib/assets/festival.mp4',
        'category': 'Festival',
        'price': 120.00,
        'isFavorite': false,
        'address': 'Calle 5 de Mayo 456, CDMX',
      },
      {
        'name': 'Obra de Teatro: Romeo y Julieta',
        'description': 'Clásica obra de Shakespeare interpretada por actores de renombre.',
        'date': '10 Septiembre, 2025 - 19:30',
        'venue': 'Teatro Nacional',
        'imageUrls': [
          'https://imgs.search.brave.com/stToeV4Kex1XIOaJFGN7It0dB5B_N2SWELhtXk-dS24/rs:fit:860:0:0:0/g:ce/aHR0cHM6Ly9pLnBp/bmltZy5jb20vb3Jp/Z2luYWxzL2I2L2Qw/LzY4L2I2ZDA2OGYy/YjFmYjExYmVkMjcx/Yzc3MzY4YTJjY2U0/LmpwZw',
          'https://imgs.search.brave.com/2ArOpO7AM2yLBjvIk1nARBp6TNreoRQ_NOF317i5c7g/rs:fit:860:0:0:0/g:ce/aHR0cHM6Ly90ZWF0/cm9tYWRyaWQuY29t/L3dwLWNvbnRlbnQv/dXBsb2Fkcy8yMDIx/LzA2L1RFQVRSTy1N/QURSSUQtUm9tZW9f/eS1KdWxpZXRhLWVs/LW11c2ljYWxURUFU/Uk8uanBn',
        ],
        'videoUrl': 'https://github.com/Hudesde/eventpass-app/raw/main/lib/assets/teatro.mp4',
        'category': 'Teatro',
        'price': 50.00,
        'isFavorite': false,
        'address': 'Teatro Nacional, Av. Juárez 50, CDMX',
      },
      {
        'name': 'Competencia de Natación',
        'description': 'Competencia de natación profesional en la piscina olímpica de la ciudad.',
        'date': '25 Julio, 2025 - 08:00',
        'venue': 'Centro Acuático Olímpico',
        'imageUrls': [
          'https://imgs.search.brave.com/IeLl_iJiDVuuxfQkbbtENKsqHXjNigyNwJYJvNa3vFw/rs:fit:860:0:0:0/g:ce/aHR0cHM6Ly9pbWcu/ZnJlZXBpay5jb20v/Zm90b3MtcHJlbWl1/bS9uYWRhZG9yLWNv/bXBldGl0aXZvLXBy/b2Zlc2lvbmFsLW1h/c2N1bGluby1waXNj/aW5hXzEwNDYwMy04/OTQyLmpwZz9zZW10/PWFpc19oeWJyaWQ',
          'https://imgs.search.brave.com/pCpNTUQFN3Q7PiuhTfJ5-x6d6fvloGAFaJldxi8vCPU/rs:fit:860:0:0:0/g:ce/aHR0cHM6Ly9zY29u/dGVudHI0cC1kNzcy/Lmt4Y2RuLmNvbS93/cC1jb250ZW50L3Vw/bG9hZHMvMjAyMy8w/NS9ldGlxdWV0YS1h/Y3VhdGxvbi0zOTB4/MjIwLmpwZw',
        ],
        'videoUrl': 'https://github.com/Hudesde/eventpass-app/raw/main/lib/assets/natacion.mp4',
        'category': 'Deporte',
        'price': 30.00,
        'isFavorite': false,
        'address': 'Centro Acuático Olímpico, Calle Lago 789, CDMX',
      },
      {
        'name': 'Fiesta de Año Nuevo',
        'description': 'La mejor fiesta para recibir el año nuevo con música, comida y sorpresas.',
        'date': '31 Diciembre, 2025 - 21:00',
        'venue': 'Hotel Metropol',
        'imageUrls': [
          'https://imgs.search.brave.com/vaCs1slvV0OaPR7NBEXw20iHKMCyCGFoVJFbdzSPzDE/rs:fit:860:0:0:0/g:ce/aHR0cHM6Ly9zdGF0/aWMudmVjdGVlenku/Y29tL3N5c3RlbS9y/ZXNvdXJjZXMvdGh1/bWJuYWlscy8wMzQv/MzQzLzE2MS9zbWFs/bC9uZXcteWVhci1w/YXJ0eS1ncm91cC1v/Zi15b3VuZy1wZW9w/bGUtaW4tc2FudGEt/aGF0cy1ibG93aW5n/LWNvbmZldHRpLXdo/aWxlLWNlbGVicmF0/aW5nLW5ldy15ZWFy/LXBob3RvLmpwZw',
          'https://imgs.search.brave.com/Ibaz3hwb736TEKO_zpDgNAHdYgq8_udorVibsPnXdMQ/rs:fit:860:0:0:0/g:ce/aHR0cHM6Ly9zdGF0/aWMudmVjdGVlenku/Y29tL3N5c3RlbS9y/ZXNvdXJjZXMvdGh1/bWJuYWlscy8wMjgv/NzgyLzI2MS9zbWFs/bC9ncm91cC1vZi1o/YXBweS15b3VuZy1w/ZW9wbGUtY2VsZWJy/YXRpbmctYXQtbmV3/LXllYXItcGFydHkt/dGVlbmFnZXItZnJp/ZW5kc2hpcHMtaGF2/aW5nLWZ1bi13aXRo/LWNvbmZldHRpLWFu/ZC1jaGFtcGFnbmUt/YXQtdGhlLW5pZ2h0/LXBhcnR5LXRvZ2V0/aGVyLWdlbmVyYXRp/dmUtYWktcGhvdG8u/anBn',
        ],
        'videoUrl': 'https://github.com/Hudesde/eventpass-app/raw/main/lib/assets/cena.mp4',
        'category': 'Fiesta',
        'price': 90.00,
        'isFavorite': false,
        'address': 'Hotel Metropol, Av. Reforma 321, CDMX',
      },
    ];

    // Añadir los tickets a Firestore
    final batch = _firestore.batch();
    for (var ticketData in sampleTickets) {
      final docRef = _firestore.collection(_collection).doc();
      batch.set(docRef, ticketData);
    }

    // Commit el batch
    await batch.commit();
    print('Datos de muestra cargados exitosamente.');
  }

  // Fallback: cargar eventos desde JSON local si falla Firestore
  Future<List<Ticket>> loadLocalEvents() async {
    final String jsonString = await rootBundle.loadString('assets/sample_events.json');
    final List<dynamic> jsonList = json.decode(jsonString);
    return jsonList.map((data) => Ticket(
      id: '',
      name: data['name'] ?? '',
      description: data['description'] ?? '',
      date: data['date'] ?? '',
      venue: data['venue'] ?? '',
      imageUrls: (data['imageUrls'] as List?)?.map((e) => e.toString()).toList() ?? [],
      videoUrl: data['videoUrl'],
      category: data['category'] ?? '',
      price: (data['price'] ?? 0).toDouble(),
      isFavorite: data['isFavorite'] ?? false,
    )).toList();
  }
}
