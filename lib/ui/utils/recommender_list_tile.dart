import 'package:flutter/material.dart';

class RecommenderListTile extends StatelessWidget {
  final String genre;
  final String title;
  final String duration;
  final VoidCallback? onLike;
  final VoidCallback? onDislike;

  const RecommenderListTile({
    super.key,
    required this.genre,
    required this.title,
    required this.duration,
    this.onLike,
    this.onDislike,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      color: const Color(0xFFEDEDED),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(genre, style: const TextStyle(fontSize: 12)),
              const SizedBox(height: 4),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(duration, style: const TextStyle(fontSize: 14)),
            ],
          ),
          Row(
            children: [
              GestureDetector(
                onTap: onLike,
                child: const Icon(Icons.thumb_up_outlined, color: Colors.blue),
              ),
              const SizedBox(width: 16),
              GestureDetector(
                onTap: onDislike,
                child: const Icon(Icons.thumb_down_outlined, color: Colors.red),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
