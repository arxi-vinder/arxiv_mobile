import 'package:flutter/material.dart';

class CustomListTile extends StatelessWidget {
  final String title;
  final String subTitle;
  final String description;

  const CustomListTile({
    super.key,
    required this.title,
    required this.subTitle,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        side: BorderSide(color: Colors.blueGrey, width: 2.0),
        borderRadius: BorderRadius.circular(12.0),
      ),
      elevation: 0,
      color: Colors.transparent,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 11, horizontal: 12),
        child: Column(
          children: [
            Text(
              subTitle,
              style: const TextStyle(
                fontSize: 12,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w500,
                color: Colors.black,
                height: 1.33,
                letterSpacing: 0.50,
              ),
            ),

            const SizedBox(height: 4),

            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black,
                height: 1.50,
                letterSpacing: -0.5,
              ),
            ),

            Text(
              description,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black87,
                height: 1.43,
                letterSpacing: 0.25,
              ),
              maxLines: 4,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
