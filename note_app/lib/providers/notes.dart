import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:note_app/models/note.dart';
import '../services/storage_manager.dart';
import 'dart:convert';

class Notes with ChangeNotifier {
  List<Note> _list = [];

  List<Note> get all {
    return [..._list];
  }

  Future fetch() async {
    var json = await StorageManager.readData("notes");
    if (json != null) {
      var data = jsonDecode(json) as List<dynamic>;

      _list = data
          .map((e) => Note(e["id"], e["title"], Delta.fromJson(e["content"]),
              DateTime.parse(e["createdAt"]),
              updatedAt: DateTime.tryParse(e["updatedAt"].toString())))
          .toList();
    }

    notifyListeners();
  }

  Future _save() async {
    await StorageManager.saveData("notes", jsonEncode(_list));
  }

  Future insert(Note note) async {
    _list.add(note);

    await _save();
    notifyListeners();
  }

  Future update(String id, String title, Delta content) async {
    var noteIndex = _list.indexWhere((element) => element.id == id);
    _list[noteIndex].title = title;
    _list[noteIndex].content = content;
    _list[noteIndex].updatedAt = DateTime.now();

    await _save();

    notifyListeners();
  }

  Future delete(String id) async {
    _list.removeWhere((element) => element.id == id);
    await _save();

    notifyListeners();
  }

  Future deleteMany(List<String> idList) async {
    _list.removeWhere((element) => idList.contains(element.id));
    await _save();

    notifyListeners();
  }

  Note getById(String id) {
    return _list.firstWhere((element) => element.id == id);
  }
}
