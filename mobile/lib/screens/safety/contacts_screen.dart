import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../services/auth_state.dart';
import '../../widgets/registration_form_kit.dart';

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
      if (!mounted) return;
      if (res['_status'] == 401) {
        _error = 'Please sign in to manage trusted contacts';
      } else if (res['success'] == true) {
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

  Future<Map<String, dynamic>?> _promptContact({
    String title = 'Add trusted contact',
    Map<String, dynamic>? initial,
  }) async {
    final nameCtrl = TextEditingController(text: initial?['name']?.toString() ?? '');
    final phoneCtrl = TextEditingController(text: initial?['phone']?.toString() ?? '');
    final waCtrl = TextEditingController(
      text: initial?['whatsappNumber']?.toString() ?? initial?['phone']?.toString() ?? '',
    );
    final emailCtrl = TextEditingController(text: initial?['email']?.toString() ?? '');
    final relationCtrl = TextEditingController(text: initial?['relation']?.toString() ?? '');
    var sms = initial?['canReceiveSMS'] != false;
    var emailOn = initial?['canReceiveEmail'] == true ||
        (initial == null && (initial?['email']?.toString() ?? '').isNotEmpty);
    var callOn = initial?['canReceiveCall'] != false;
    var waOn = initial?['canReceiveWhatsApp'] != false;
    String? formError;

    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setLocal) => AlertDialog(
          title: Text(title),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'SOS will auto-call, SMS, email and open WhatsApp with your live location using these details.',
                  style: TextStyle(fontSize: 12, color: Color(0xFF64748B), height: 1.35),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: nameCtrl,
                  textCapitalization: TextCapitalization.words,
                  decoration: const InputDecoration(
                    labelText: 'Name *',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: phoneCtrl,
                  keyboardType: TextInputType.phone,
                  maxLength: 10,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  onChanged: (v) {
                    // Keep WhatsApp in sync until the user edits it separately.
                    if (waCtrl.text.isEmpty || waCtrl.text == v.substring(0, waCtrl.text.length.clamp(0, v.length))) {
                      setLocal(() {
                        if (waCtrl.text.length <= v.length) waCtrl.text = v;
                      });
                    }
                  },
                  decoration: const InputDecoration(
                    labelText: 'Phone (call / SMS) *',
                    border: OutlineInputBorder(),
                    counterText: '',
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: waCtrl,
                  keyboardType: TextInputType.phone,
                  maxLength: 10,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  decoration: const InputDecoration(
                    labelText: 'WhatsApp number *',
                    hintText: 'Usually same as phone',
                    border: OutlineInputBorder(),
                    counterText: '',
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: emailCtrl,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    labelText: 'Email (for SOS mail)',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: relationCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Relation (optional)',
                    hintText: 'Mother, Friend, …',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 8),
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Call on SOS', style: TextStyle(fontSize: 14)),
                  value: callOn,
                  onChanged: (v) => setLocal(() => callOn = v),
                ),
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('SMS on SOS', style: TextStyle(fontSize: 14)),
                  value: sms,
                  onChanged: (v) => setLocal(() => sms = v),
                ),
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('WhatsApp location share', style: TextStyle(fontSize: 14)),
                  value: waOn,
                  onChanged: (v) => setLocal(() => waOn = v),
                ),
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Email on SOS', style: TextStyle(fontSize: 14)),
                  value: emailOn,
                  onChanged: (v) => setLocal(() => emailOn = v),
                ),
                if (formError != null) ...[
                  const SizedBox(height: 8),
                  Text(formError!, style: const TextStyle(color: Colors.red, fontSize: 13)),
                ],
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
            FilledButton(
              onPressed: () {
                final name = nameCtrl.text.trim();
                final phone = phoneCtrl.text.trim();
                final wa = waCtrl.text.trim().isEmpty ? phone : waCtrl.text.trim();
                final email = emailCtrl.text.trim();
                if (name.isEmpty) {
                  setLocal(() => formError = 'Name is required');
                  return;
                }
                if (!RegValidators.isPhone10(phone)) {
                  setLocal(() => formError = 'Phone must be exactly 10 digits');
                  return;
                }
                if (!RegValidators.isPhone10(wa)) {
                  setLocal(() => formError = 'WhatsApp must be exactly 10 digits');
                  return;
                }
                if (emailOn && email.isEmpty) {
                  setLocal(() => formError = 'Add email or turn off Email on SOS');
                  return;
                }
                if (email.isNotEmpty && !RegValidators.isEmail(email)) {
                  setLocal(() => formError = 'Enter a valid email');
                  return;
                }
                Navigator.pop(ctx, true);
              },
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );

    final result = ok == true
        ? <String, dynamic>{
            'name': nameCtrl.text.trim(),
            'phone': phoneCtrl.text.trim(),
            'whatsappNumber':
                waCtrl.text.trim().isEmpty ? phoneCtrl.text.trim() : waCtrl.text.trim(),
            'email': emailCtrl.text.trim(),
            'relation': relationCtrl.text.trim(),
            'canReceiveSMS': sms,
            'canReceiveEmail': emailOn && emailCtrl.text.trim().isNotEmpty,
            'canReceiveCall': callOn,
            'canReceiveWhatsApp': waOn,
          }
        : null;
    nameCtrl.dispose();
    phoneCtrl.dispose();
    waCtrl.dispose();
    emailCtrl.dispose();
    relationCtrl.dispose();
    return result;
  }

  Future<void> _add() async {
    final data = await _promptContact();
    if (data == null || !mounted) return;

    final res = await context.read<AuthState>().api.post('/api/me/trusted-contacts', body: data);
    if (!mounted) return;
    if (res['success'] == true) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Contact added — SOS can call, SMS, WhatsApp & email them')),
      );
      await _load();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(res['error']?.toString() ?? 'Could not add contact')),
      );
    }
  }

  Future<void> _edit(Map<String, dynamic> c) async {
    final id = c['id'];
    final contactId = id is int ? id : int.tryParse('$id');
    if (contactId == null) return;

    final data = await _promptContact(title: 'Edit trusted contact', initial: c);
    if (data == null || !mounted) return;

    final res = await context.read<AuthState>().api.put(
          '/api/me/trusted-contacts/$contactId',
          body: data,
        );
    if (!mounted) return;
    if (res['success'] == true) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Contact updated')),
      );
      await _load();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(res['error']?.toString() ?? 'Could not update contact')),
      );
    }
  }

  Future<void> _delete(int id) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Remove contact?'),
        content: const Text('They will no longer get SOS alerts from you.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Keep')),
          FilledButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Remove')),
        ],
      ),
    );
    if (confirm != true || !mounted) return;

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

  String _channelsLabel(Map<String, dynamic> c) {
    final parts = <String>[];
    if (c['canReceiveCall'] != false) parts.add('Call');
    if (c['canReceiveSMS'] != false) parts.add('SMS');
    if (c['canReceiveWhatsApp'] != false) parts.add('WA');
    if (c['canReceiveEmail'] == true) parts.add('Email');
    return parts.isEmpty ? 'No channels' : parts.join(' · ');
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
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(_error!, textAlign: TextAlign.center),
                        const SizedBox(height: 12),
                        FilledButton(onPressed: _load, child: const Text('Retry')),
                      ],
                    ),
                  ),
                )
              : _contacts.isEmpty
                  ? const Center(
                      child: Padding(
                        padding: EdgeInsets.all(24),
                        child: Text(
                          'No contacts yet.\nTap + and add phone, WhatsApp & email so SOS can reach them automatically.',
                          textAlign: TextAlign.center,
                        ),
                      ),
                    )
                  : RefreshIndicator(
                      onRefresh: _load,
                      child: ListView.separated(
                        itemCount: _contacts.length,
                        separatorBuilder: (_, _) => const Divider(height: 1),
                        itemBuilder: (ctx, i) {
                          final c = _contacts[i];
                          final id = c['id'];
                          final contactId = id is int ? id : int.tryParse('$id');
                          return ListTile(
                            onTap: () => _edit(c),
                            leading: const CircleAvatar(child: Icon(Icons.person_outline)),
                            title: Text(c['name']?.toString() ?? 'Contact'),
                            subtitle: Text(
                              [
                                c['phone']?.toString() ?? '',
                                if ((c['email']?.toString() ?? '').isNotEmpty) c['email'].toString(),
                                _channelsLabel(c),
                              ].where((e) => e.isNotEmpty).join('\n'),
                            ),
                            isThreeLine: true,
                            trailing: contactId == null
                                ? null
                                : Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      IconButton(
                                        tooltip: 'Edit',
                                        icon: const Icon(Icons.edit_outlined),
                                        onPressed: () => _edit(c),
                                      ),
                                      IconButton(
                                        tooltip: 'Remove',
                                        icon: const Icon(Icons.delete_outline),
                                        onPressed: () => _delete(contactId),
                                      ),
                                    ],
                                  ),
                          );
                        },
                      ),
                    ),
    );
  }
}
