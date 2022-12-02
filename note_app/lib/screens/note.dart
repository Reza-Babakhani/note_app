import 'package:flutter/material.dart';

class NoteScreen extends StatefulWidget {
  static const String routeName = "/note";
  const NoteScreen({super.key});

  @override
  State<NoteScreen> createState() => _NoteScreenState();
}

class _NoteScreenState extends State<NoteScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Container(
        child: Text("1243455"),
      )),
    );
  }
}
