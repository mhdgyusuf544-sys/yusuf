import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotesHome extends StatefulWidget {
  const NotesHome({super.key});

  @override
  State<NotesHome> createState() => _NotesHomeState();
}

class _NotesHomeState extends State<NotesHome> {
  final _inputNoteKey = GlobalKey<FormFieldState>();
  final _updateNoteKey = GlobalKey<FormFieldState>();

  List<String> _notes = [];

  @override
  void initState() {
    super.initState();
    _loadNotes();
  }

  Future<void> _loadNotes() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _notes = prefs.getStringList('notes_key') ?? [];
    });
  }

  Future<void> _saveNotes() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('notes_key', _notes);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber[400],
        title: const Text(
          'Notes App',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.home, color: Colors.white),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: CustomScrollView(
          slivers: [
            SliverList(
              delegate: SliverChildListDelegate([
                const Text(
                  'Buat Catatan',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 15),
                TextFormField(
                  key: _inputNoteKey,
                  decoration: const InputDecoration(
                    labelText: 'Catatan',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) =>
                      value == null || value.isEmpty ? 'Input tidak boleh kosong' : null,
                ),
                const SizedBox(height: 20),
                ElevatedButton.icon(
                  label: const Text('Tambah'),
                  icon: const Icon(Icons.add),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.lightBlue,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () {
                    if (_inputNoteKey.currentState!.validate()) {
                      setState(() {
                        _notes.add(_inputNoteKey.currentState!.value as String);
                      });
                      _saveNotes();
                      _inputNoteKey.currentState!.reset();
                    }
                  },
                ),
                const Divider(height: 25, thickness: 3),
              ]),
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                childCount: _notes.length,
                (context, index) => Card(
                  color: Colors.blueGrey[100],
                  child: ListTile(
                    leading: const Icon(Icons.notes),
                    title: Text(_notes[index]),
                    trailing: PopupMenuButton<String>(
                      onSelected: (menu) async {
                        if (menu == 'Update') {
                          await showDialog<void>(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text('Update Catatan'),
                              content: TextFormField(
                                key: _updateNoteKey,
                                initialValue: _notes[index],
                                decoration: const InputDecoration(
                                  labelText: 'Catatan',
                                  border: OutlineInputBorder(),
                                ),
                                validator: (value) => value == null || value.isEmpty
                                    ? 'Input tidak boleh kosong'
                                    : null,
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text('Batal'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    if (_updateNoteKey.currentState!.validate()) {
                                      setState(() {
                                        _notes[index] = _updateNoteKey.currentState!.value as String;
                                      });
                                      _saveNotes();
                                      Navigator.pop(context);
                                    }
                                  },
                                  child: const Text('Simpan', style: TextStyle(color: Colors.blue)),
                                ),
                              ],
                            ),
                          );
                        } else {
                          await showDialog<void>(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text('Ingin Menghapus'),
                              content: const Text('Apakah kamu yakin ingin menghapus?'),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text('Batal'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    setState(() => _notes.removeAt(index));
                                    _saveNotes();
                                    Navigator.pop(context);
                                  },
                                  child: const Text('Hapus', style: TextStyle(color: Colors.red)),
                                ),
                              ],
                            ),
                          );
                        }
                      },
                      itemBuilder: (context) => const [
                        PopupMenuItem(value: 'Update', child: Text('Update')),
                        PopupMenuItem(value: 'Hapus', child: Text('Hapus', style: TextStyle(color: Colors.red))),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
