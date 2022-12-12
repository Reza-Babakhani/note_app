import 'package:flutter/material.dart';

class NoteScreen extends StatefulWidget {
  static const String routeName = "/note";
  const NoteScreen({super.key});

  @override
  State<NoteScreen> createState() => _NoteScreenState();
}

class _NoteScreenState extends State<NoteScreen> {
  final TextEditingController _titleController = TextEditingController();

  @override
  void initState() {
    _titleController.text = "";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: TextField(
            controller: _titleController,
            decoration: InputDecoration(
                border: InputBorder.none,
                hintText: "Untitled",
                hintStyle: TextStyle(color: Colors.white.withOpacity(0.7))),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
            cursorColor: Colors.white,
          ),
          centerTitle: true,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
        ),
        extendBodyBehindAppBar: true,
        body: SafeArea(
            child: Container(
          child: Text("1243455"),
        )),
      ),
    );
  }
}
