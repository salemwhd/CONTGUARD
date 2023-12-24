import 'package:flutter/material.dart';

class GlobalAppBar extends StatelessWidget implements PreferredSizeWidget {
  const GlobalAppBar({super.key,required this.title});

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);

 final String title;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title:  Text(
        title,
        style: const TextStyle(
            color: Colors.white, fontSize: 25, fontWeight: FontWeight.bold),
      ),
      backgroundColor: const Color.fromARGB(255, 135, 1, 172),
      actions: [IconButton(onPressed: () {}, icon: Icon(Icons.logout))],
    );
  }
}