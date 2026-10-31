import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../config/financial_catalog.dart';
import '../../services/auth_state.dart';
import '../../services/module_services.dart';
import '../../services/payment_service.dart';
import '../../widgets/module_payment_checkout.dart';
import '../../widgets/module_theme.dart';

class FinancialSessionDetailScreen extends StatefulWidget {
  const FinancialSessionDetailScreen({
    super.key,
    required this.kind,
    required this.id,
    this.summary,
  });

  final String kind;
  final int id;
  final Map<String, dynamic>? summary;

  @override
  State<FinancialSessionDetailScreen> createState() => _FinancialSessionDetailScreenState();
}

class _FinancialSessionDetailScreenState extends State<FinancialSessionDetailScreen> {
  late final FinancialLiteracyService _api;
  late final ModulePaymentCheckout _checkout;
  bool _loading = true;
  bool _acting = false;
  String? _error;
  Map<String, dynamic> _item = {};
  Map<String, dynamic>? _registration;

  @override
  void initState() {
    super.initState();
    final api = context.read<AuthState>().api;
    _api = FinancialLiteracyService(api);
    _checkout = ModulePaymentCheckout(PaymentService(api));
    _checkout.bind(
      onSuccess: (r) => _checkout.handleSuccess(context, r),
      onError: (r) => _checkout.handleError(r),
    );
    if (widget.summary != null) _item = Map<String, dynamic>.from(widget.summary!);
    _load();
  }

  @override
  void dispose() {
    _checkout.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final res = widget.kind == 'video'
          ? await _api.video(widget.id)
          : widget.kind == 'live'
              ? await _api.liveSession(widget.id)
              : await _api.workshop(widget.id);
      if (!mounted) return;
      if (res['success'] == true) {
        if (widget.kind == 'video') {
          _item = Map<String, dynamic>.from(res['video'] ?? {});
        } else if (widget.kind == 'live') {
          _item = Map<String, dynamic>.from(res['session'] ?? {});
        } else {
          _item = Map<String, dynamic>.from(res['workshop'] ?? {});
        }
        _registration = res['registration'] is Map
            ? Map<String, dynamic>.from(res['registration'] as Map)
            : null;
      } else {
        _error = res['error']?.toString();
      }
    } catch (e) {
      _error = '$e';
    }
    if (mounted) setState(() => _loading = false);
  }

  int? _regId() {
    final v = _registration?['numericId'] ?? _registration?['id'];
    if (v is num) return v.toInt();
    return int.tryParse('$v');
  }

  Future<void> _register() async {
    if (_acting) return;
    setState(() => _acting = true);
    final res = widget.kind == 'live'
        ? await _api.registerLive(widget.id)
        : await _api.registerWorkshop(widget.id);
    if (!mounted) return;
    setState(() => _acting = false);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(res['success'] == true
          ? (res['message']?.toString() ?? 'Registered')
          : res['error']?.toString() ?? 'Failed'),
    ));
    await _load();
    if (res['paymentRequired'] == true && _registration != null) {
      await _pay();
    }
  }

  Future<void> _pay() async {
    final id = _regId();
    final amount = (_registration?['amount'] is num)
        ? (_registration!['amount'] as num).toDouble()
        : ((_item['fee'] is num) ? (_item['fee'] as num).toDouble() : 0.0);
    if (id == null || amount <= 0) return;
    await _checkout.pay(
      context: context,
      amount: amount,
      description: 'Financial Literacy · ${_item['title'] ?? 'Session'}',
      verifyPayload: (response) => {
        'razorpay_order_id': response.orderId,
        'razorpay_payment_id': response.paymentId,
        'razorpay_signature': response.signature,
        'type': 'FINANCIAL_BOOKING',
        'registrationId': id,
        'targetId': id,
        'amount': amount,
      },
      onSuccess: () => _load(),
    );
  }

  Future<void> _writeReview() async {
    final id = _regId();
    if (id == null) return;
    int rating = 5;
    final comment = TextEditingController();
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setLocal) => AlertDialog(
          title: const Text('Rate this session'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<int>(
                initialValue: rating,
                decoration: const InputDecoration(labelText: 'Rating', border: OutlineInputBorder()),
                items: List.generate(5, (i) => DropdownMenuItem(value: i + 1, child: Text('${i + 1}'))),
                onChanged: (v) => setLocal(() => rating = v ?? 5),
              ),
              const SizedBox(height: 10),
              TextField(controller: comment, maxLines: 3, decoration: const InputDecoration(hintText: 'How was the session?', border: OutlineInputBorder())),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
            FilledButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Submit')),
          ],
        ),
      ),
    );
    if (ok != true) return;
    final res = await _api.rateEnrollment(id, rating: rating, review: comment.text.trim());
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(res['success'] == true ? 'Thanks for the review' : res['error']?.toString() ?? 'Failed'),
    ));
    if (res['success'] == true) _load();
  }

  Future<void> _cancel() async {
    final id = _regId();
    if (id == null || _acting) return;
    setState(() => _acting = true);
    final res = await _api.cancelEnrollment(id);
    if (!mounted) return;
    setState(() => _acting = false);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(res['success'] == true ? 'Cancelled' : res['error']?.toString() ?? 'Failed'),
    ));
    _load();
  }

  Future<void> _openUrl(String? raw) async {
    if (raw == null || raw.isEmpty) return;
    final uri = Uri.tryParse(raw);
    if (uri == null) return;
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  @override
  Widget build(BuildContext context) {
    final title = _item['title']?.toString() ?? 'Details';
    final status = _registration?['status']?.toString();
    final canCancel = _registration?['canCancel'] == true;
    final needsPayment = _registration?['needsPayment'] == true;
    final canReview = _registration?['canReview'] == true;
    final fee = (_item['fee'] is num) ? (_item['fee'] as num).toDouble() : 0.0;
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: Text(widget.kind == 'video' ? 'Video' : widget.kind == 'live' ? 'Live session' : 'Workshop'),
        backgroundColor: Colors.white,
        foregroundColor: ModuleTheme.navy,
      ),
      body: _loading
          ? ModuleTheme.loading()
          : _error != null
              ? ModuleTheme.errorView(_error!, _load)
              : ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    Text(title, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: ModuleTheme.navy)),
                    const SizedBox(height: 8),
                    if (_item['host'] != null || _item['speaker'] != null)
                      Text(_item['host']?.toString() ?? _item['speaker']?.toString() ?? '',
                          style: const TextStyle(color: ModuleTheme.textGray)),
                    if (_item['date'] != null) Text('${_item['date']} ${_item['time'] ?? ''}'),
                    if (_item['city'] != null || _item['venue'] != null)
                      Text('${_item['venue'] ?? ''} ${_item['city'] ?? ''}'),
                    if (_item['seatsLeft'] != null) Text('Seats left: ${_item['seatsLeft']}'),
                    if (fee > 0) Text('Fee: ₹${fee.round()}', style: const TextStyle(fontWeight: FontWeight.w700)),
                    const SizedBox(height: 8),
                    const Text(FinancialCatalog.cancelPolicy, style: TextStyle(fontSize: 12, color: ModuleTheme.textGray)),
                    const SizedBox(height: 12),
                    if (_item['description'] != null) Text(_item['description'].toString()),
                    if (status != null) ...[
                      const SizedBox(height: 16),
                      _timeline(status),
                    ],
                    const SizedBox(height: 20),
                    if (widget.kind == 'video')
                      FilledButton(
                        onPressed: () => _openUrl(_item['videoUrl']?.toString()),
                        child: const Text('Open video'),
                      )
                    else if (_registration == null)
                      FilledButton(
                        onPressed: _acting ? null : _register,
                        child: _acting
                            ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                            : Text(fee > 0 ? 'Register & pay' : 'Register'),
                      )
                    else ...[
                      if (needsPayment)
                        FilledButton(onPressed: _pay, child: const Text('Pay now')),
                      if (canReview)
                        OutlinedButton(onPressed: _writeReview, child: const Text('Write a review')),
                      if (canCancel)
                        OutlinedButton(
                          onPressed: _acting ? null : _cancel,
                          child: const Text('Cancel registration'),
                        ),
                    ],
                  ],
                ),
    );
  }

  Widget _timeline(String status) {
    final steps = ['pending', 'approved'];
    if (status == 'rejected') {
      return const Text('Registration rejected', style: TextStyle(color: Colors.red, fontWeight: FontWeight.w700));
    }
    if (status == 'cancelled') {
      return const Text('Registration cancelled', style: TextStyle(color: ModuleTheme.textGray));
    }
    return Row(
      children: [
        for (var i = 0; i < steps.length; i++) ...[
          Icon(
            status == steps[i] || (status == 'approved' && i == 0) ? Icons.check_circle : Icons.radio_button_unchecked,
            color: status == 'approved' || status == steps[i] ? Colors.green : Colors.grey,
            size: 18,
          ),
          Text(i == 0 ? ' Placed ' : ' Confirmed', style: const TextStyle(fontSize: 12)),
          if (i == 0) const Text('— '),
        ],
      ],
    );
  }
}
