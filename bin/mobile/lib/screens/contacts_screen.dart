import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/auth_state.dart';

class ContactsScreen extends StatefulWidget {
  const ContactsScreen({super.key});

  @override
  State<ContactsScreen> createState() => _ContactsScreenState();
}

class _ContactsScreenState extends State<ContactsScreen> {
  bool _loading = true;
  String? _error;
  List<Map<String, dynamic>> _contacts = [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final res = await context.read<AuthState>().api.get('/api/me/trusted-contacts');
      if (res['success'] == true) {
        final list = (res['contacts'] as List?) ?? [];
        _contacts = list.map((e) => Map<String, dynamic>.from(e as Map)).toList();
      } else {
        _error = res['error']?.toString() ?? 'Failed to load contacts';
      }
    } catch (e) {
      _error = '$e';
    }
    if (mounted) setState(() => _loading = false);
  }

  Future<void> _add() async {
    final nameCtrl = TextEditingController();
    final phoneCtrl = TextEditingController();
    final relationCtrl = TextEditingController();
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Add contact'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: nameCtrl, decoration: const InputDecoration(labelText: 'Name')),
            TextField(
              controller: phoneCtrl,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(labelText: 'Phone'),
            ),
            TextField(
              controller: relationCtrl,
              decoration: const InputDecoration(labelText: 'Relation'),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
          FilledButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Save')),
        ],
      ),
    );
    if (ok != true || !mounted) return;
    final api = context.read<AuthState>().api;
    final res = await api.post('/api/me/trusted-contacts', body: {
      'name': nameCtrl.text.trim(),
      'phone': phoneCtrl.text.trim(),
      'relation': relationCtrl.text.trim(),
    });
    if (!mounted) return;
    if (res['success'] == true) {
      await _load();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(res['error']?.toString() ?? 'Could not add')),
      );
    }
  }

  Future<void> _delete(int id) async {
    final res = await context.read<AuthState>().api.delete('/api/me/trusted-contacts/$id');
    if (!mounted) return;
    if (res['success'] == true) {
      await _load();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(res['error']?.toString() ?? 'Delete failed')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Trusted contacts')),
      floatingActionButton: FloatingActionButton(
        onPressed: _add,
        child: const Icon(Icons.add),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(child: Text(_error!))
              : _contacts.isEmpty
                  ? const Center(child: Text('No contacts yet. Tap + to add.'))
                  : RefreshIndicator(
                      onRefresh: _load,
                      child: ListView.separated(
                        itemCount: _contacts.length,
                        separatorBuilder: (_, _) => const Divider(height: 1),
                        itemBuilder: (ctx, i) {
                          final c = _contacts[i];
                          return ListTile(
                            title: Text('${c['name'] ?? ''}'),
                            subtitle: Text('${c['phone'] ?? ''} · ${c['relation'] ?? ''}'),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete_outline),
                              onPressed: () {
                                final id = c['id'];
                                if (id != null) _delete(id is int ? id : int.parse('$id'));
                              },
                            ),
                          );
                        },
                      ),
                    ),
    );
  }
}
