import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../services/auth_state.dart';
import '../../services/entrepreneur_auth_service.dart';
import '../../widgets/module_theme.dart';
import '../../widgets/ux_feedback.dart';

/// Entrepreneur withdraw / released funds + bank details + commission pay.
class EntrepreneurFundingScreen extends StatefulWidget {
  const EntrepreneurFundingScreen({super.key});

  static const Color primary = Color(0xFFF43F5E);
  static const Color navy = Color(0xFF1E1B4B);
  static const Color muted = Color(0xFF64748B);

  @override
  State<EntrepreneurFundingScreen> createState() =>
      _EntrepreneurFundingScreenState();
}

class _EntrepreneurFundingScreenState extends State<EntrepreneurFundingScreen> {
  final _bankNameCtrl = TextEditingController();
  final _accountCtrl = TextEditingController();
  final _ifscCtrl = TextEditingController();
  final _upiCtrl = TextEditingController();

  bool _loading = true;
  bool _savingBank = false;
  final Set<int> _payingIds = {};
  String? _error;
  String? _guidance;
  double _releasedTotal = 0;
  double _pendingInterestTotal = 0;
  double _commissionDue = 0;
  List<Map<String, dynamic>> _investments = [];

  EntrepreneurAuthService get _svc =>
      EntrepreneurAuthService(context.read<AuthState>().api);

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _bankNameCtrl.dispose();
    _accountCtrl.dispose();
    _ifscCtrl.dispose();
    _upiCtrl.dispose();
    super.dispose();
  }

  double _num(dynamic v) {
    if (v is num) return v.toDouble();
    return double.tryParse('$v') ?? 0;
  }

  int? _asInt(dynamic v) {
    if (v is int) return v;
    return int.tryParse('$v');
  }

  String _money(num v) {
    if (v >= 10000000) return '₹${(v / 10000000).toStringAsFixed(1)} Cr';
    if (v >= 100000) return '₹${(v / 100000).toStringAsFixed(1)} L';
    if (v >= 1000) return '₹${(v / 1000).toStringAsFixed(1)}K';
    return '₹${v.toStringAsFixed(0)}';
  }

  void _toast(String msg, {bool error = false}) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: error ? Colors.red.shade700 : null,
      ),
    );
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final res = await _svc.fundingDetail();
      if (!mounted) return;
      if (res['success'] == true) {
        _releasedTotal = _num(res['releasedTotal']);
        _pendingInterestTotal = _num(res['pendingInterestTotal']);
        _commissionDue = _num(res['commissionDue']);
        _guidance = res['guidance']?.toString();
        _investments = ModuleTheme.toList(res['investments']);
        final bank = Map<String, dynamic>.from(res['bank'] ?? {});
        _bankNameCtrl.text = bank['bankName']?.toString() ?? '';
        _accountCtrl.text = bank['accountNumber']?.toString() ?? '';
        _ifscCtrl.text = bank['ifscCode']?.toString() ?? '';
        _upiCtrl.text = bank['upiId']?.toString() ?? '';
      } else {
        _error = res['error']?.toString() ?? 'Failed to load funding detail';
      }
    } catch (e) {
      _error = '$e';
    }
    if (mounted) setState(() => _loading = false);
  }

  Future<void> _saveBank() async {
    if (_savingBank) return;
    setState(() => _savingBank = true);
    try {
      final res = await _svc.updateBank({
        'bankName': _bankNameCtrl.text.trim(),
        'accountNumber': _accountCtrl.text.trim(),
        'ifscCode': _ifscCtrl.text.trim(),
        'upiId': _upiCtrl.text.trim(),
      });
      if (!mounted) return;
      if (res['success'] == true) {
        _toast(res['message']?.toString() ?? 'Bank details saved');
      } else {
        _toast(res['error']?.toString() ?? 'Save failed', error: true);
      }
    } catch (e) {
      _toast('$e', error: true);
    }
    if (mounted) setState(() => _savingBank = false);
  }

  Future<void> _payCommission(int id) async {
    if (_payingIds.contains(id)) return;
    setState(() => _payingIds.add(id));
    try {
      final res = await _svc.payCommission(id);
      if (!mounted) return;
      if (res['success'] == true) {
        _toast(res['message']?.toString() ?? 'Commission paid');
        await _load();
      } else {
        _toast(res['error']?.toString() ?? 'Payment failed', error: true);
      }
    } catch (e) {
      _toast('$e', error: true);
    }
    if (mounted) setState(() => _payingIds.remove(id));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      appBar: AppBar(
        title: const Text('Released Funds'),
        backgroundColor: Colors.white,
        foregroundColor: EntrepreneurFundingScreen.navy,
        elevation: 0.5,
      ),
      body: _loading
          ? ModuleTheme.loading()
          : _error != null
              ? ModuleTheme.errorView(_error!, _load)
              : RefreshIndicator(
                  onRefresh: _load,
                  child: ListView(
                    padding: const EdgeInsets.all(16),
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: _statCard(
                              'Released',
                              _money(_releasedTotal),
                              const Color(0xFF16A34A),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: _statCard(
                              'Pending interest',
                              _money(_pendingInterestTotal),
                              const Color(0xFFF59E0B),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      _statCard(
                        'Commission due',
                        _money(_commissionDue),
                        EntrepreneurFundingScreen.primary,
                        wide: true,
                      ),
                      if (_guidance != null && _guidance!.isNotEmpty) ...[
                        const SizedBox(height: 12),
                        Text(
                          _guidance!,
                          style: const TextStyle(
                            color: EntrepreneurFundingScreen.muted,
                            height: 1.4,
                            fontSize: 13,
                          ),
                        ),
                      ],
                      const SizedBox(height: 20),
                      const Text(
                        'Bank details',
                        style: TextStyle(
                          fontWeight: FontWeight.w800,
                          color: EntrepreneurFundingScreen.navy,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 10),
                      _field(_bankNameCtrl, 'Bank name'),
                      const SizedBox(height: 10),
                      _field(_accountCtrl, 'Account number'),
                      const SizedBox(height: 10),
                      _field(_ifscCtrl, 'IFSC code'),
                      const SizedBox(height: 10),
                      _field(_upiCtrl, 'UPI ID'),
                      const SizedBox(height: 12),
                      FilledButton(
                        onPressed: _savingBank ? null : _saveBank,
                        style: FilledButton.styleFrom(
                          backgroundColor: EntrepreneurFundingScreen.navy,
                          minimumSize: const Size.fromHeight(46),
                        ),
                        child: _savingBank
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : const Text('Save bank details'),
                      ),
                      const SizedBox(height: 24),
                      const Text(
                        'Investments',
                        style: TextStyle(
                          fontWeight: FontWeight.w800,
                          color: EntrepreneurFundingScreen.navy,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 10),
                      if (_investments.isEmpty)
                        const EmptyStateView(
                          icon: Icons.account_balance_wallet_outlined,
                          title: 'No investments yet',
                          message:
                              'Released and pending interests will appear here.',
                        )
                      else
                        ..._investments.map(_investmentCard),
                    ],
                  ),
                ),
    );
  }

  Widget _field(TextEditingController ctrl, String label) {
    return TextField(
      controller: ctrl,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: Colors.white,
        border: const OutlineInputBorder(),
      ),
    );
  }

  Widget _statCard(String label, String value, Color color, {bool wide = false}) {
    return Container(
      width: wide ? double.infinity : null,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: EntrepreneurFundingScreen.muted,
              fontWeight: FontWeight.w600,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.w800,
              fontSize: 20,
            ),
          ),
        ],
      ),
    );
  }

  Widget _investmentCard(Map<String, dynamic> inv) {
    final id = _asInt(inv['id']);
    final due = _num(inv['commissionDue']);
    final status = (inv['status']?.toString() ?? '').toUpperCase();
    final busy = id != null && _payingIds.contains(id);

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            inv['proposalTitle']?.toString() ?? 'Proposal',
            style: const TextStyle(
              fontWeight: FontWeight.w800,
              color: EntrepreneurFundingScreen.navy,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '${inv['investorName'] ?? 'Investor'} · $status',
            style: const TextStyle(
              color: EntrepreneurFundingScreen.muted,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 8),
          Text('Amount: ${_money(_num(inv['amount']))}'),
          Text('Released: ${_money(_num(inv['releasedAmount']))}'),
          if (due > 0) Text('Commission due: ${_money(due)}'),
          if (due > 0 && id != null) ...[
            const SizedBox(height: 10),
            FilledButton(
              onPressed: busy ? null : () => _payCommission(id),
              style: FilledButton.styleFrom(
                backgroundColor: EntrepreneurFundingScreen.primary,
              ),
              child: busy
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Text('Pay commission'),
            ),
          ],
        ],
      ),
    );
  }
}
