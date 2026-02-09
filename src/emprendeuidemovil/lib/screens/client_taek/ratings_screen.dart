import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../models/service_model.dart';
import '../../providers/review_provider.dart';

class RatingsScreen extends StatefulWidget {
  final ServiceModel service;

  const RatingsScreen({super.key, required this.service});

  @override
  State<RatingsScreen> createState() => _RatingsScreenState();
}

class _RatingsScreenState extends State<RatingsScreen> {
  int _rating = 5;
  final TextEditingController _commentCtrl = TextEditingController();
  bool _loading = false;

  @override
  void dispose() {
    _commentCtrl.dispose();
    super.dispose();
  }

  Future<void> _sendReview() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) return;

    setState(() => _loading = true);

    final ok = await context.read<ReviewProvider>().addReview(
      serviceId: widget.service.id,
      ownerId: widget.service.id, // ⚠️ por ahora igual
      userId: user.uid,
      userName: user.displayName ?? '',
      rating: _rating,
      comment: _commentCtrl.text.trim(),
    );

    setState(() => _loading = false);

    if (!mounted) return;

    if (ok) {
      Navigator.pop(context, true); // 👈 devuelve OK
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No se pudo guardar la reseña')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calificar servicio'),
        backgroundColor: const Color(0xFFC8102E),
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.service.name,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 16),

            Row(
              children: List.generate(5, (i) {
                final index = i + 1;
                return IconButton(
                  onPressed: () => setState(() => _rating = index),
                  icon: Icon(
                    index <= _rating ? Icons.star : Icons.star_border,
                    color: Colors.amber,
                  ),
                );
              }),
            ),

            const SizedBox(height: 12),

            TextField(
              controller: _commentCtrl,
              decoration: const InputDecoration(
                labelText: 'Comentario (opcional)',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),

            const Spacer(),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _loading ? null : _sendReview,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFC8102E),
                  foregroundColor: Colors.white,
                ),
                child: _loading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('Enviar reseña'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
