import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

const Color primaryColor = Color(0xFF03045E);
const Color secondaryColor = Color(0xFF90E0EF);
const Color lightSecondaryColor = Color(0xFFE6F9FC);

class Imagepicker extends StatelessWidget {
  final VoidCallback onTap;

  final String title;
  final String subtitle;
  final IconData icon;

  final List<XFile> images;
  final void Function(int index) onRemove;

  const Imagepicker({
    super.key,
    required this.onTap,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.images,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,

        padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),

        decoration: BoxDecoration(
          color: Colors.white,

          borderRadius: BorderRadius.circular(12),

          border: Border.all(color: secondaryColor.withOpacity(0.6)),

          boxShadow: [
            BoxShadow(
              color: primaryColor.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),

        child: images.isEmpty ? _emptyPicker() : _selectedImages(),
      ),
    );
  }

  // ======================================================
  // EMPTY STATE
  // ======================================================

  Widget _emptyPicker() {
    return Column(
      children: [
        const DecoratedBox(
          decoration: BoxDecoration(
            color: lightSecondaryColor,
            shape: BoxShape.circle,
          ),

          child: Padding(
            padding: EdgeInsets.all(12),

            child: Icon(
              Icons.add_photo_alternate_outlined,
              size: 34,
              color: primaryColor,
            ),
          ),
        ),

        const SizedBox(height: 10),

        Text(
          title,
          textAlign: TextAlign.center,

          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: primaryColor,
          ),
        ),

        const SizedBox(height: 5),

        Text(
          subtitle,
          textAlign: TextAlign.center,

          style: const TextStyle(fontSize: 13, color: Colors.black45),
        ),
      ],
    );
  }

  // ======================================================
  // SELECTED IMAGES
  // ======================================================

  Widget _selectedImages() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Selected photos",
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: primaryColor,
          ),
        ),

        const SizedBox(height: 12),

        SingleChildScrollView(
          scrollDirection: Axis.horizontal,

          child: Row(
            children: List.generate(images.length, (index) {
              final image = images[index];

              return Padding(
                padding: const EdgeInsets.only(right: 10),

                child: Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),

                      child: Image.file(
                        File(image.path),
                        width: 105,
                        height: 105,
                        fit: BoxFit.cover,
                      ),
                    ),

                    Positioned(
                      top: 5,
                      right: 5,

                      child: GestureDetector(
                        onTap: () {
                          onRemove(index);
                        },

                        child: Container(
                          padding: const EdgeInsets.all(4),

                          decoration: BoxDecoration(
                            color: primaryColor.withOpacity(0.85),

                            shape: BoxShape.circle,
                          ),

                          child: const Icon(
                            Icons.close,
                            color: Colors.white,
                            size: 15,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }),
          ),
        ),

        const SizedBox(height: 12),

        Row(
          mainAxisAlignment: MainAxisAlignment.center,

          children: const [
            Icon(
              Icons.add_photo_alternate_outlined,
              size: 18,
              color: primaryColor,
            ),

            SizedBox(width: 6),

            Text(
              "Tap to add more photos",
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: primaryColor,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
