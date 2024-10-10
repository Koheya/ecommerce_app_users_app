import 'package:ecommerce/widgets/sub_title_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';

class CustomListTile extends StatelessWidget {
  const CustomListTile({
    super.key,
    required this.imagePath,
    required this.text,
    required this.function,
  });
  final String imagePath, text;
  final Function function;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        function();
      },
      leading: Image(
        image: AssetImage(imagePath),
        height: 35,
      ),
      title: SubTitleTextWidget(
        label: text,
      ),
      trailing: const Icon(IconlyLight.arrowRight2),
    );
  }
}
