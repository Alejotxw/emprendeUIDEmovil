import 'package:flutter/material.dart';

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
}

class EventProvider extends ChangeNotifier {
  final List<EventModel> _events = [];

  List<EventModel> get events => _events;

  void addEvent(Map<String, dynamic> data) {
    final newEvent = EventModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: data['title'],
      startDateTime: DateTime.parse(data['startDateTime']),
      endDateTime: DateTime.parse(data['endDateTime']),
      description: data['description'],
      contact: data['contact'],
      image: data['image'],
      status: data['status'],
    );
    _events.insert(0, newEvent);
    notifyListeners();
  }

  void updateEvent(String id, Map<String, dynamic> data) {
    final index = _events.indexWhere((e) => e.id == id);
    if (index != -1) {
      _events[index] = EventModel(
        id: id,
        title: data['title'],
        startDateTime: DateTime.parse(data['startDateTime']),
        endDateTime: DateTime.parse(data['endDateTime']),
        description: data['description'],
        contact: data['contact'],
        image: data['image'],
        status: data['status'],
      );
      notifyListeners();
    }
  }

  void deleteEvent(String id) {
    _events.removeWhere((e) => e.id == id);
    notifyListeners();
  }
}
