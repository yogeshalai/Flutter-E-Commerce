import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget with PreferredSizeWidget {
  final String title;
  final bool automaticallyImplyLeading;

  const CustomAppBar({
    Key? key,
    required this.title,
    this.automaticallyImplyLeading = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.black,
      elevation: 0,
      centerTitle: true,
      automaticallyImplyLeading: automaticallyImplyLeading,
      title: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        color: Colors.black,
        child: Text(
          title,
          style: Theme.of(context)
              .textTheme
              .headline2!
              .copyWith(color: Colors.white),
        ),
      ),
      iconTheme: const IconThemeData(color: Colors.white),
      actions: [
        IconButton(
          icon: const Icon(Icons.favorite),
          onPressed: () {
            Navigator.pushNamed(
              context,
              '/wishlist',
            );
          },
        ),
      ],
    );
  }

  Size get preferredSize => const Size.fromHeight(50.0);
}
