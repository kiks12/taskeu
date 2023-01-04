import 'package:flutter/material.dart';

class SearchBar extends StatefulWidget {
  const SearchBar({
    super.key,
    required this.searchTodo,
    required this.controller,
  });

  final void searchTodo;
  final TextEditingController controller;

  @override
  State<SearchBar> createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Row(
          children: [
            Flexible(
              child: TextFormField(
                controller: widget.controller,
                decoration: const InputDecoration(
                  hintText: 'Search Tasks',
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 15),
              child: GestureDetector(
                onTap: () {},
                child: const CircleAvatar(
                  maxRadius: 26,
                  backgroundColor: Colors.black87,
                  child: Icon(
                    Icons.search,
                    size: 17,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
