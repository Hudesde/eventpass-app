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
          'https://imgs.search.brave.com/5gx2RkaGmqpTL2YHEMZ4eJesIWJ_Jh1wYCaEhQouQco/rs:fit:860:0:0:0/g:ce/aHR0cHM6Ly9pMC53/cC5jb20vbGFzaGlz/dG9yaWFzZGVscm9j/ay5jb20vd3AtY29u/dGVudC91cGxvYWRz/LzIwMjQvMDUvTG9z/LUZlc3RpdmFsZXMt/ZGUtUm9jay1NYXMt/R3JhbmRlcy1kZWwt/TXVuZG8tVW5hLUd1/aWEtcGFyYS1sb3Mt/QW1hbnRlcy1kZS1s/YS1NdXNpY2EtZW4t/Vml2by5wbmc_cmVz/aXplPTY0MCw0Mjcm/c3NsPTE',
          'https://imgs.search.brave.com/z1EkiaV0C1jclwuSmSphdKd9nChjKLTBFMlIBRfWufI/rs:fit:860:0:0:0/g:ce/aHR0cHM6Ly9jZG4w/LnVuY29tby5jb20v/ZXMvcG9zdHMvNC82/LzQvd2Fja2VuX29w/ZW5fYWlyXzU0NDY0/XzNfNjAwLmpwZw',
        ],
        'videoUrl': 'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4',
        'category': 'Concierto',
        'price': 75.00,
        'isFavorite': false,
      },
      {
        'name': 'Festival de Música Electrónica',
        'description': 'Un día completo de música electrónica con DJs internacionales.',
        'date': '20 Agosto, 2025 - 14:00',
        'venue': 'Parque Central',
        'imageUrls': [
          'https://images.unsplash.com/photo-1516450360452-9312f5e86fc7?auto=format&fit=crop&w=1050&q=80',
          'https://images.unsplash.com/photo-1465101046530-73398c7f28ca?auto=format&fit=crop&w=1050&q=80',
        ],
        'videoUrl': 'https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4',
        'category': 'Festival',
        'price': 120.00,
        'isFavorite': false,
      },
      {
        'name': 'Obra de Teatro: Romeo y Julieta',
        'description': 'Clásica obra de Shakespeare interpretada por actores de renombre.',
        'date': '10 Septiembre, 2025 - 19:30',
        'venue': 'Teatro Nacional',
        'imageUrls': [
          'https://images.unsplash.com/photo-1503095396549-807759245b35?auto=format&fit=crop&w=1050&q=80',
          'https://images.unsplash.com/photo-1465101178521-c1a9136a3b99?auto=format&fit=crop&w=1050&q=80',
        ],
        'videoUrl': null,
        'category': 'Teatro',
        'price': 50.00,
        'isFavorite': false,
      },
      {
        'name': 'Carrera 10K por la Ciudad',
        'description': 'Carrera anual que recorre los principales puntos de la ciudad.',
        'date': '25 Julio, 2025 - 08:00',
        'venue': 'Centro Histórico',
        'imageUrls': [
          'https://images.unsplash.com/photo-1530549387789-4c1017266635?auto=format&fit=crop&w=1050&q=80',
          'https://images.unsplash.com/photo-1465101046530-73398c7f28ca?auto=format&fit=crop&w=1050&q=80',
        ],
        'videoUrl': null,
        'category': 'Deporte',
        'price': 30.00,
        'isFavorite': false,
      },
      {
        'name': 'Fiesta de Año Nuevo',
        'description': 'La mejor fiesta para recibir el año nuevo con música, comida y sorpresas.',
        'date': '31 Diciembre, 2025 - 21:00',
        'venue': 'Hotel Metropol',
        'imageUrls': [
          'https://images.unsplash.com/photo-1546171753-97d7676e4602?auto=format&fit=crop&w=1050&q=80',
          'https://images.unsplash.com/photo-1465101178521-c1a9136a3b99?auto=format&fit=crop&w=1050&q=80',
        ],
        'videoUrl': 'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4',
        'category': 'Fiesta',
        'price': 90.00,
        'isFavorite': false,
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
