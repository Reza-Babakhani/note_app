import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import '../models/note.dart';
import '../providers/notes.dart';

class NoteScreen extends StatefulWidget {
  static const String routeName = "/note";

  const NoteScreen({super.key});

  @override
  State<NoteScreen> createState() => _NoteScreenState();
}

class _NoteScreenState extends State<NoteScreen> {
  final TextEditingController _titleController = TextEditingController();
  final QuillController _editorController = QuillController.basic();
  bool _isToolbarShows = false;
  late String _id;
  bool _isInit = true;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      _id = ModalRoute.of(context)!.settings.arguments as String;
      if (_id.isNotEmpty) {
        var note = Provider.of<Notes>(context).getById(_id);
        _titleController.text = note.title;
        _editorController.document = Document.fromDelta(note.content);

        _isInit = false;
      }
    }
    super.didChangeDependencies();
  }

  void toggleToolbar() {
    setState(() {
      _isToolbarShows = !_isToolbarShows;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Scaffold(
          appBar: AppBar(
            title: Theme(
              data: Theme.of(context).copyWith(
                textSelectionTheme: const TextSelectionThemeData(
                  selectionColor: Colors.red,
                  selectionHandleColor: Colors.red,
                ),
              ),
              child: TextField(
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
            ),
            centerTitle: true,
            actions: [
              IconButton(
                  onPressed: () async {
                    if (_id.isEmpty) {
                      await Provider.of<Notes>(context, listen: false).insert(
                          Note(
                              const Uuid().v1().toString(),
                              _titleController.text.isEmpty
                                  ? "Untitled"
                                  : _titleController.text,
                              _editorController.document.toDelta(),
                              DateTime.now()));
                    } else {
                      await Provider.of<Notes>(context, listen: false).update(
                        _id,
                        _titleController.text,
                        _editorController.document.toDelta(),
                      );
                    }

                    Navigator.of(context).pop();
                  },
                  icon: const Icon(Icons.done_outline_rounded)),
            ],
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
          ),
          extendBodyBehindAppBar: true,
          body: SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(5),
                    child: QuillEditor.basic(
                      controller: _editorController,
                      readOnly: false, // true for view only mode
                    ),
                  ),
                ),
                Divider(
                  color: Theme.of(context).colorScheme.primary,
                ),
                _isToolbarShows
                    ? QuillToolbar.basic(
                        controller: _editorController,
                        showAlignmentButtons: true,
                        toolbarSectionSpacing: 0,
                        customButtons: [
                          QuillCustomButton(
                            icon: Icons.keyboard_arrow_down,
                            onTap: () {
                              toggleToolbar();
                            },
                          ),
                        ],
                      )
                    : Container(),
              ],
            ),
          ),
          floatingActionButton: _isToolbarShows
              ? null
              : FloatingActionButton(
                  onPressed: toggleToolbar,
                  mini: true,
                  child: const Icon(Icons.design_services),
                ),
        ));
  }
}
