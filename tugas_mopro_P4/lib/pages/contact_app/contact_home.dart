import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class ContactHome extends StatefulWidget {
  const ContactHome({super.key});

  @override
  State<ContactHome> createState() => _ContactHomeState();
}

class _ContactHomeState extends State<ContactHome> {
  final _inputNameKey = GlobalKey<FormFieldState>();
  final _inputTelKey = GlobalKey<FormFieldState>();
  final _updateNameKey = GlobalKey<FormFieldState>();
  final _updateTelKey = GlobalKey<FormFieldState>();

  late Box _contactsBox;
  List<Map<String, dynamic>> _contacts = [];

  @override
  void initState() {
    super.initState();
    _contactsBox = Hive.box('contacts_box');
    _loadContacts();
  }

  void _loadContacts() {
    setState(() {
      _contacts = _contactsBox.values
          .map((entry) => Map<String, dynamic>.from(entry as Map))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[400],
        title: const Text(
          'Contact App',
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
                  'Tambah Kontak',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 15),
                TextFormField(
                  key: _inputNameKey,
                  decoration: const InputDecoration(labelText: 'Nama', border: OutlineInputBorder()),
                  validator: (value) => value == null || value.isEmpty
                      ? 'Input tidak boleh kosong'
                      : null,
                ),
                const SizedBox(height: 10),
                TextFormField(
                  key: _inputTelKey,
                  decoration: const InputDecoration(labelText: 'Nomor Telepon', border: OutlineInputBorder()),
                  validator: (value) => value == null || value.isEmpty
                      ? 'Input tidak boleh kosong'
                      : null,
                ),
                const SizedBox(height: 20),
                ElevatedButton.icon(
                  label: const Text('Tambah'),
                  icon: const Icon(Icons.add),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.lightBlue, foregroundColor: Colors.white),
                  onPressed: () {
                    if (_inputNameKey.currentState!.validate() && _inputTelKey.currentState!.validate()) {
                      _contactsBox.add({
                        'name': _inputNameKey.currentState!.value,
                        'telephone': _inputTelKey.currentState!.value,
                      });
                      _loadContacts();
                      _inputNameKey.currentState!.reset();
                      _inputTelKey.currentState!.reset();
                    }
                  },
                ),
                const Divider(height: 25, thickness: 3),
              ]),
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                childCount: _contacts.length,
                (context, index) => Card(
                  color: Colors.blueGrey[100],
                  child: ListTile(
                    leading: const Icon(Icons.person),
                    title: Text(_contacts[index]['name'] ?? ''),
                    subtitle: Text(_contacts[index]['telephone'] ?? ''),
                    trailing: PopupMenuButton<String>(
                      onSelected: (menu) async {
                        if (menu == 'Update') {
                          await showDialog<void>(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text('Update Kontak'),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  TextFormField(
                                    key: _updateNameKey,
                                    initialValue: _contacts[index]['name'],
                                    decoration: const InputDecoration(labelText: 'Nama', border: OutlineInputBorder()),
                                    validator: (value) => value == null || value.isEmpty
                                        ? 'Input tidak boleh kosong'
                                        : null,
                                  ),
                                  const SizedBox(height: 10),
                                  TextFormField(
                                    key: _updateTelKey,
                                    initialValue: _contacts[index]['telephone'],
                                    decoration: const InputDecoration(labelText: 'Nomor Telepon', border: OutlineInputBorder()),
                                    validator: (value) => value == null || value.isEmpty
                                        ? 'Input tidak boleh kosong'
                                        : null,
                                  ),
                                ],
                              ),
                              actions: [
                                TextButton(onPressed: () => Navigator.pop(context), child: const Text('Batal')),
                                TextButton(
                                  onPressed: () {
                                    if (_updateNameKey.currentState!.validate() && _updateTelKey.currentState!.validate()) {
                                      _contactsBox.putAt(index, {
                                        'name': _updateNameKey.currentState!.value,
                                        'telephone': _updateTelKey.currentState!.value,
                                      });
                                      _loadContacts();
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
                                TextButton(onPressed: () => Navigator.pop(context), child: const Text('Batal')),
                                TextButton(
                                  onPressed: () {
                                    _contactsBox.deleteAt(index);
                                    _loadContacts();
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
