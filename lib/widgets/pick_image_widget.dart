import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class PickImageWidget extends StatelessWidget {
  const PickImageWidget({super.key, this.pickedImage, required this.function});
  final XFile? pickedImage;
  final Function function;
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ClipRRect(
          child: pickedImage == null
              ? Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey),
                  ),
                )
              : Image.file(
                  File(pickedImage!.path),
                  fit: BoxFit.fill,
                ),
        ),
        Positioned(
          top: 0,
          right: 0,
          child: Material(
            borderRadius: BorderRadius.circular(16),
            color: Colors.lightBlue,
            child: InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: () {
                function();
              },
              child: const Padding(
                padding: EdgeInsets.all(8.0),
                child: Icon(
                  Icons.add_shopping_cart_rounded,
                  size: 20,
                ),
              ),
            ),
          ),
        )
      ],
    );
  }
}
