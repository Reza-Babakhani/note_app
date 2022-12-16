import 'package:flutter/material.dart';
import 'package:note_app/services/theme_manager.dart';
import 'package:provider/provider.dart';
import 'screens/note.dart';

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
    return Consumer<ThemeNotifier>(builder: (context, theme, _) {
      return MaterialApp(
        title: 'My Notes',
        theme: theme.getTheme(),
        debugShowCheckedModeBanner: false,
        home: const MyHomePage(),
        routes: {NoteScreen.routeName: (ctx) => const NoteScreen()},
      );
    });
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<int> _selectedItems = [];
  bool _isSelectMode = false;
  void _toggleSelectItem(index) {
    if (_selectedItems.contains(index)) {
      _selectedItems.remove(index);
    } else {
      _selectedItems.add(index);
    }
  }

  bool _isSelected(index) {
    if (_selectedItems.contains(index)) {
      return true;
    } else {
      return false;
    }
  }

  void _deleteSelectedItems() {
    //TODO delete selected items

    _deselectAll();
  }

  void _deselectAll() {
    _selectedItems.clear();
    _isSelectMode = false;
  }

  @override
  Widget build(BuildContext context) {
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
      body: ListView.builder(
          itemCount: 100,
          itemBuilder: (ctx, i) {
            return InkWell(
                onLongPress: () {
                  setState(() {
                    _toggleSelectItem(i);

                    if (_selectedItems.isEmpty) {
                      _isSelectMode = false;
                    } else {
                      _isSelectMode = true;
                    }
                  });
                },
                onTap: () {
                  setState(() {
                    if (_isSelectMode) {
                      _toggleSelectItem(i);
                      if (_selectedItems.isEmpty) {
                        _isSelectMode = false;
                      } else {
                        _isSelectMode = true;
                      }
                    }
                  });
                },
                child: NoteListItem(i, _isSelected(i)));
          }),
    );
  }
}

class NoteListItem extends StatelessWidget {
  final int _i;
  final bool _isSelected;
  const NoteListItem(this._i, this._isSelected, {super.key});

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
              _isSelected ? "✓ Title" : "Title",
              style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontSize: 18,
                  fontWeight: FontWeight.w500),
            ),
            Text(
              "modified at: 2022 dec 10",
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
