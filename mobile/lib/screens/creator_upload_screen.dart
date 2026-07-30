import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../services/auth_state.dart';
import '../services/creator_hub_service.dart';

class CreatorUploadScreen extends StatefulWidget {
  const CreatorUploadScreen({super.key});

  static const _categories = [
    'Safety Awareness',
    'Entrepreneurship',
    'Financial Literacy',
    'Skill Development',
    'Inspirational',
    'Entertainment',
  ];

  @override
  State<CreatorUploadScreen> createState() => _CreatorUploadScreenState();
}

class _CreatorUploadScreenState extends State<CreatorUploadScreen> {
  late final CreatorHubService _api;
  final _titleCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  final _locationCtrl = TextEditingController();
  final _hashtagsCtrl = TextEditingController();
  final _priceCtrl = TextEditingController(text: '0');
  String _uploadType = 'LONG_VIDEO';
  String _category = CreatorUploadScreen._categories.first;
  File? _file;
  bool _isDraft = false;
  bool _isPaid = false;
  bool _subscriberOnly = false;
  bool _uploading = false;

  @override
  void initState() {
    super.initState();
    _api = CreatorHubService(context.read<AuthState>().api);
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _descCtrl.dispose();
    _locationCtrl.dispose();
    _hashtagsCtrl.dispose();
    _priceCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickMedia() async {
    final picker = ImagePicker();
    final isStory = _uploadType == 'STORY';
    final isImage = _uploadType == 'IMAGE';
    final XFile? picked = isImage
        ? await picker.pickImage(source: ImageSource.gallery)
        : await picker.pickVideo(source: ImageSource.gallery, maxDuration: isStory ? const Duration(seconds: 30) : null);
    if (picked != null) setState(() => _file = File(picked.path));
  }

  Future<void> _submit() async {
    if (_file == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Select a media file')));
      return;
    }
    if (_titleCtrl.text.trim().isEmpty && _uploadType != 'STORY') {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Title is required')));
      return;
    }
    setState(() => _uploading = true);
    try {
      final res = await _api.upload(
        title: _titleCtrl.text.trim().isEmpty ? 'Story' : _titleCtrl.text.trim(),
        description: _descCtrl.text.trim(),
        category: _category,
        uploadType: _uploadType,
        file: _file!,
        location: _locationCtrl.text.trim(),
        hashtags: _hashtagsCtrl.text.trim(),
        isDraft: _isDraft,
        isPaidContent: _isPaid,
        price: double.tryParse(_priceCtrl.text) ?? 0,
        isSubscriberOnly: _subscriberOnly,
      );
      if (!mounted) return;
      if (res['success'] == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(res['message']?.toString() ?? 'Uploaded!')),
        );
        Navigator.pop(context, true);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(res['error']?.toString() ?? 'Upload failed')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$e')));
      }
    } finally {
      if (mounted) setState(() => _uploading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create Content')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SegmentedButton<String>(
              segments: const [
                ButtonSegment(value: 'REEL', label: Text('Reel')),
                ButtonSegment(value: 'LONG_VIDEO', label: Text('Video')),
                ButtonSegment(value: 'IMAGE', label: Text('Image')),
                ButtonSegment(value: 'STORY', label: Text('Story')),
              ],
              selected: {_uploadType},
              onSelectionChanged: (s) => setState(() => _uploadType = s.first),
            ),
            const SizedBox(height: 16),
            OutlinedButton.icon(
              onPressed: _pickMedia,
              icon: const Icon(Icons.photo_library_outlined),
              label: Text(_file == null ? 'Pick media' : 'Selected: ${_file!.path.split(Platform.pathSeparator).last}'),
            ),
            const SizedBox(height: 12),
            TextField(controller: _titleCtrl, decoration: const InputDecoration(labelText: 'Title', border: OutlineInputBorder())),
            const SizedBox(height: 12),
            TextField(
              controller: _descCtrl,
              maxLines: 3,
              decoration: const InputDecoration(labelText: 'Caption / Description', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              value: _category,
              decoration: const InputDecoration(labelText: 'Category', border: OutlineInputBorder()),
              items: CreatorUploadScreen._categories.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
              onChanged: (v) => setState(() => _category = v ?? _category),
            ),
            const SizedBox(height: 12),
            TextField(controller: _locationCtrl, decoration: const InputDecoration(labelText: 'Location (optional)', border: OutlineInputBorder())),
            const SizedBox(height: 12),
            TextField(controller: _hashtagsCtrl, decoration: const InputDecoration(labelText: '#Hashtags', border: OutlineInputBorder())),
            const SizedBox(height: 12),
            SwitchListTile(title: const Text('Save as draft'), value: _isDraft, onChanged: (v) => setState(() => _isDraft = v)),
            SwitchListTile(title: const Text('Paid content'), value: _isPaid, onChanged: (v) => setState(() => _isPaid = v)),
            if (_isPaid)
              TextField(
                controller: _priceCtrl,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Price (Rs)', border: OutlineInputBorder()),
              ),
            SwitchListTile(
              title: const Text('Subscriber only'),
              value: _subscriberOnly,
              onChanged: (v) => setState(() => _subscriberOnly = v),
            ),
            const SizedBox(height: 20),
            FilledButton(
              onPressed: _uploading ? null : _submit,
              child: _uploading
                  ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2))
                  : const Text('Publish'),
            ),
          ],
        ),
      ),
    );
  }
}
