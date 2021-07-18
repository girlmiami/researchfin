import 'package:flutter/material.dart';

class SearchBar extends StatelessWidget {
  final TextEditingController controller;
  final double width;
  final FocusNode focusNode;

  SearchBar({required this.controller, required this.width,required this.focusNode});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(
        color: Colors.black87,
        shadowColor: Colors.white,
        elevation: 10,
        child: Container(
          height: 40,
          width: width - 20,
          child: TextField(
            cursorColor: Colors.white,
            controller: controller,
            style: TextStyle(
              color: Colors.white,
            ),
            decoration: InputDecoration(
              contentPadding: EdgeInsets.only(
                top: 10,
                left: 10,
                right: 10,
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.white,
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.white,
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              hintText: 'Stocks',
              suffixIcon: Icon(
                Icons.search,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
