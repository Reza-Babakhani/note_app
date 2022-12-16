import 'package:flutter/material.dart';
import 'package:note_app/providers/notes.dart';
import 'package:note_app/services/theme_manager.dart';
import 'package:provider/provider.dart';
import 'models/note.dart';
import 'screens/note_screen.dart';

void main() {
  return runApp(ChangeNotifierProvider<ThemeNotifier>(
    create: (_) => ThemeNotifier(),
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (ctx) => Notes()),
      ],
      child: Consumer<ThemeNotifier>(builder: (context, theme, _) {
        return MaterialApp(
          title: 'My Notes',
          theme: theme.getTheme(),
          debugShowCheckedModeBanner: false,
          home: const MyHomePage(),
          routes: {NoteScreen.routeName: (ctx) => const NoteScreen()},
        );
      }),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<String> _selectedItems = [];
  bool _isSelectMode = false;
  late List<Note> _notes;
  bool _isInit = true;
  bool _isLoading = true;

  @override
  void didChangeDependencies() async {
    if (_isInit) {
      await Provider.of<Notes>(context).fetch();

      _isInit = false;
      _isLoading = false;
    }
    super.didChangeDependencies();
  }

  void _toggleSelectItem(String id) {
    if (_selectedItems.contains(id)) {
      _selectedItems.remove(id);
    } else {
      _selectedItems.add(id);
    }
  }

  bool _isSelected(String id) {
    if (_selectedItems.contains(id)) {
      return true;
    } else {
      return false;
    }
  }

  void _deleteSelectedItems() async {
    await Provider.of<Notes>(context, listen: false).deleteMany(_selectedItems);
    _deselectAll();
  }

  void _deselectAll() {
    _selectedItems.clear();
    _isSelectMode = false;
  }

  @override
  Widget build(BuildContext context) {
    _notes = Provider.of<Notes>(context).all;
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Notes"),
        centerTitle: true,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
        actions: [
          _isSelectMode
              ? IconButton(
                  onPressed: () {
                    setState(() {
                      _deleteSelectedItems();
                    });
                  },
                  icon: const Icon(Icons.delete))
              : Consumer<ThemeNotifier>(
                  builder: (context, theme, _) => IconButton(
                        onPressed: () {
                          if (theme.isDarkMode()) {
                            theme.setLightMode();
                          } else {
                            theme.setDarkMode();
                          }
                        },
                        icon: Icon(theme.isDarkMode()
                            ? Icons.light_mode
                            : Icons.dark_mode),
                      ))
        ],
        leading: _isSelectMode
            ? IconButton(
                onPressed: () {
                  setState(() {
                    _deselectAll();
                  });
                },
                icon: const Icon(Icons.close))
            : Container(),
      ),
      extendBodyBehindAppBar: true,
      floatingActionButton: FloatingActionButton(
          onPressed: (() {
            Navigator.of(context).pushNamed(NoteScreen.routeName);
          }),
          child: const Icon(Icons.edit)),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : _notes.isEmpty
              ? const Center(
                  child: Text(
                    "Your notes list is empty.",
                    style: TextStyle(fontSize: 18),
                  ),
                )
              : ListView.builder(
                  itemCount: _notes.length,
                  itemBuilder: (ctx, i) {
                    return InkWell(
                        onLongPress: () {
                          setState(() {
                            _toggleSelectItem(_notes[i].id);

                            if (_selectedItems.isEmpty) {
                              _isSelectMode = false;
                            } else {
                              _isSelectMode = true;
                            }
                          });
                        },
                        onTap: () async {
                          if (_isSelectMode) {
                            setState(() {
                              _toggleSelectItem(_notes[i].id);
                              if (_selectedItems.isEmpty) {
                                _isSelectMode = false;
                              } else {
                                _isSelectMode = true;
                              }
                            });
                          } else {
                            await Navigator.of(context).pushNamed(
                                NoteScreen.routeName,
                                arguments: _notes[i].id);

                            await Provider.of<Notes>(context, listen: false)
                                .fetch();
                          }
                        },
                        child:
                            NoteListItem(_notes[i], _isSelected(_notes[i].id)));
                  }),
    );
  }
}

class NoteListItem extends StatelessWidget {
  final Note _note;
  final bool _isSelected;
  const NoteListItem(this._note, this._isSelected, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Container(
        decoration: BoxDecoration(boxShadow: [
          BoxShadow(
            color: _isSelected
                ? Colors.red
                : Theme.of(context).colorScheme.primary,
            spreadRadius: _isSelected ? 3 : 0,
          ),
          BoxShadow(
            color: Theme.of(context).primaryColor,
            spreadRadius: 1.0,
            blurRadius: 8.0,
          ),
        ], borderRadius: const BorderRadius.all(Radius.circular(20))),
        padding: const EdgeInsets.all(10),
        height: 100,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              _isSelected ? "✓ ${_note.title}" : _note.title,
              style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontSize: 18,
                  fontWeight: FontWeight.w500),
            ),
            Text(
              _note.modifiedAt,
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontSize: 12,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
