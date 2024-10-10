import 'package:ecommerce/screens/search_screen.dart';
import 'package:ecommerce/widgets/sub_title_text.dart';
import 'package:flutter/material.dart';

class CategoryRounderWidget extends StatelessWidget {
  const CategoryRounderWidget({
    super.key,
    required this.image,
    required this.name,
  });
  final String image, name;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        await Navigator.of(context)
            .pushNamed(SearchScreen.routeName, arguments: name);
      },
      child: Column(
        children: [
          Image.asset(
            image,
            height: 50,
            width: 50,
          ),
          const SizedBox(
            height: 8,
          ),
          SubTitleTextWidget(
            label: name,
            fontSize: 14,
            fontWeight: FontWeight.bold,
            maxLines: 1,
          ),
        ],
      ),
    );
  }
}
