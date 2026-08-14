import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/auth_state.dart';
import '../services/module_services.dart';
import '../widgets/module_theme.dart';

class RemindersScreen extends StatefulWidget {
  const RemindersScreen({super.key});

  @override
  State<RemindersScreen> createState() => _RemindersScreenState();
}

class _RemindersScreenState extends State<RemindersScreen> {
  late final ReminderService _api;
  bool _loading = true;
  String? _error;
  List<Map<String, dynamic>> _reminders = [];

  @override
  void initState() {
    super.initState();
    _api = ReminderService(context.read<AuthState>().api);
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final res = await _api.list();
      if (!mounted) return;
      if (res['success'] == true) {
        _reminders = ModuleTheme.toList(res['reminders']);
      } else {
        _error = res['error']?.toString();
      }
    } catch (e) {
      _error = '$e';
    }
    if (mounted) setState(() => _loading = false);
  }

  Future<void> _addReminder() async {
    final titleCtrl = TextEditingController();
    final msgCtrl = TextEditingController();
    final timeCtrl = TextEditingController(text: '09:00');
    String day = 'MONDAY';
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setLocal) => AlertDialog(
          title: const Text('Add reminder'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: titleCtrl,
                  decoration: const InputDecoration(labelText: 'Title', border: OutlineInputBorder()),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: msgCtrl,
                  decoration: const InputDecoration(labelText: 'Message', border: OutlineInputBorder()),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: timeCtrl,
                  decoration: const InputDecoration(labelText: 'Time (HH:mm)', border: OutlineInputBorder()),
                ),
                const SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  value: day,
                  decoration: const InputDecoration(labelText: 'Day', border: OutlineInputBorder()),
                  items: const [
                    'MONDAY', 'TUESDAY', 'WEDNESDAY', 'THURSDAY', 'FRIDAY', 'SATURDAY', 'SUNDAY',
                  ].map((d) => DropdownMenuItem(value: d, child: Text(d))).toList(),
                  onChanged: (v) => setLocal(() => day = v ?? day),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
            FilledButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Save')),
          ],
        ),
      ),
    );
    if (ok != true || !mounted) return;
    final res = await _api.add(
      title: titleCtrl.text.trim(),
      message: msgCtrl.text.trim(),
      timeOfDay: timeCtrl.text.trim(),
      dayOfWeek: day,
    );
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(res['success'] == true ? 'Reminder added' : '${res['error']}')),
    );
    _load();
  }

  Future<void> _toggle(int id) async {
    await _api.toggle(id);
    _load();
  }

  Future<void> _delete(int id) async {
    await _api.delete(id);
    _load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text('Routine Reminders'),
        backgroundColor: Colors.white,
        foregroundColor: ModuleTheme.navy,
        actions: [
          IconButton(onPressed: _addReminder, icon: const Icon(Icons.add)),
        ],
      ),
      body: _loading
          ? ModuleTheme.loading()
          : _error != null
              ? ModuleTheme.errorView(_error!, _load)
              : RefreshIndicator(
                  onRefresh: _load,
                  child: _reminders.isEmpty
                      ? ListView(
                          children: const [
                            SizedBox(height: 80),
                            Center(child: Text('No reminders yet. Tap + to add one.')),
                          ],
                        )
                      : ListView.separated(
                          padding: const EdgeInsets.all(16),
                          itemCount: _reminders.length,
                          separatorBuilder: (_, __) => const SizedBox(height: 8),
                          itemBuilder: (_, i) {
                            final r = _reminders[i];
                            final id = r['id'];
                            final enabled = r['enabled'] == true;
                            return Card(
                              child: ListTile(
                                title: Text(r['title']?.toString() ?? 'Reminder'),
                                subtitle: Text(
                                  '${r['dayOfWeek'] ?? r['reminderDate'] ?? ''} at ${r['timeOfDay'] ?? ''}\n${r['message'] ?? ''}',
                                ),
                                isThreeLine: true,
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Switch(
                                      value: enabled,
                                      onChanged: id is num ? (_) => _toggle(id.toInt()) : null,
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.delete_outline),
                                      onPressed: id is num ? () => _delete(id.toInt()) : null,
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                ),
    );
  }
}
