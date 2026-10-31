import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../services/auth_state.dart';
import '../../services/module_services.dart';
import '../../widgets/module_theme.dart';

class WalletScreen extends StatefulWidget {
  const WalletScreen({super.key});

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  late final WalletService _api;
  bool _loading = true;
  String? _error;
  int _points = 0;
  List<Map<String, dynamic>> _transactions = [];
  List<String> _rewards = [];

  @override
  void initState() {
    super.initState();
    _api = WalletService(context.read<AuthState>().api);
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final res = await _api.wallet();
      if (!mounted) return;
      if (res['success'] == true) {
        _points = res['rewardPoints'] is num ? (res['rewardPoints'] as num).toInt() : 0;
        _transactions = ModuleTheme.toList(res['transactions']);
        final raw = res['rewards'];
        _rewards = raw is List ? raw.map((e) => e.toString()).toList() : [];
      } else {
        _error = res['error']?.toString();
      }
    } catch (e) {
      _error = '$e';
    }
    if (mounted) setState(() => _loading = false);
  }

  Future<void> _redeem(String reward, int cost) async {
    if (_points < cost) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Not enough coins')),
      );
      return;
    }
    final res = await _api.redeem(cost: cost, rewardName: reward);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(res['message']?.toString() ?? res['error']?.toString() ?? '')),
    );
    if (res['success'] == true) _load();
  }

  int _rewardCost(String reward) {
    final match = RegExp(r'(\d+)\s*Coins').firstMatch(reward);
    return match == null ? 100 : int.tryParse(match.group(1)!) ?? 100;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text('My Wallet'),
        backgroundColor: Colors.white,
        foregroundColor: ModuleTheme.navy,
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
                      Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [ModuleTheme.primary, Color(0xFFE11D48)],
                          ),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Reward coins', style: TextStyle(color: Colors.white70)),
                            const SizedBox(height: 8),
                            Text(
                              '$_points',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 36,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                      const Text('Redeem rewards', style: TextStyle(fontWeight: FontWeight.w700)),
                      const SizedBox(height: 8),
                      ..._rewards.map((r) {
                        final cost = _rewardCost(r);
                        return Card(
                          child: ListTile(
                            title: Text(r),
                            trailing: FilledButton(
                              onPressed: () => _redeem(r, cost),
                              child: Text('$cost'),
                            ),
                          ),
                        );
                      }),
                      const SizedBox(height: 24),
                      const Text('Recent transactions', style: TextStyle(fontWeight: FontWeight.w700)),
                      const SizedBox(height: 8),
                      if (_transactions.isEmpty)
                        const Text('No transactions yet.', style: TextStyle(color: ModuleTheme.textGray))
                      else
                        ..._transactions.map((t) => Card(
                              child: ListTile(
                                title: Text(t['description']?.toString() ?? t['type']?.toString() ?? 'Transaction'),
                                subtitle: Text(t['transactionDate']?.toString() ?? ''),
                                trailing: Text(
                                  '${t['type'] == 'DEBIT' ? '-' : '+'}${t['amount'] ?? ''}',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    color: t['type'] == 'DEBIT' ? Colors.red : Colors.green,
                                  ),
                                ),
                              ),
                            )),
                    ],
                  ),
                ),
    );
  }
}
