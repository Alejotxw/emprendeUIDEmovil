import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EventModel {
  final String id;
  final String title;
  final DateTime startDateTime;
  final DateTime endDateTime;
  final String description;
  final String contact;
  final String? image;
  final String status;

  EventModel({
    required this.id,
    required this.title,
    required this.startDateTime,
    required this.endDateTime,
    required this.description,
    required this.contact,
    this.image,
    required this.status,
  });

  factory EventModel.fromMap(String id, Map<String, dynamic> map) {
    return EventModel(
      id: id,
      title: map['title'] ?? '',
      startDateTime: map['startDateTime'] != null 
          ? DateTime.parse(map['startDateTime']) 
          : DateTime.now(),
      endDateTime: map['endDateTime'] != null 
          ? DateTime.parse(map['endDateTime']) 
          : DateTime.now(),
      description: map['description'] ?? '',
      contact: map['contact'] ?? '',
      image: map['image'],
      status: map['status'] ?? 'published',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'startDateTime': startDateTime.toIso8601String(),
      'endDateTime': endDateTime.toIso8601String(),
      'description': description,
      'contact': contact,
      'image': image,
      'status': status,
    };
  }
}

class EventProvider extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<EventModel> _events = [];

  List<EventModel> get events => _events;

  EventProvider() {
    _listenToEvents();
  }

  void _listenToEvents() {
    _firestore.collection('events').orderBy('startDateTime', descending: true).snapshots().listen((snapshot) {
      _events = snapshot.docs.map((doc) => EventModel.fromMap(doc.id, doc.data())).toList();
      notifyListeners();
    });
  }

  Future<void> addEvent(Map<String, dynamic> data) async {
    try {
      await _firestore.collection('events').add(data);
    } catch (e) {
      debugPrint("Error adding event: $e");
    }
  }

  Future<void> updateEvent(String id, Map<String, dynamic> data) async {
    try {
      await _firestore.collection('events').doc(id).update(data);
    } catch (e) {
      debugPrint("Error updating event: $e");
    }
  }

  Future<void> deleteEvent(String id) async {
    try {
      await _firestore.collection('events').doc(id).delete();
    } catch (e) {
      debugPrint("Error deleting event: $e");
    }
  }
}
