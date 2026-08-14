import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/auth_state.dart';
import 'danger_map_screen.dart';
import 'glow_provider_signup_screen.dart';
import 'home_screen.dart';
import 'login_screen.dart';
import 'martial_arts_admin_screen.dart';
import 'martial_arts_centre_login_screen.dart';
import 'martial_arts_centre_register_screen.dart';
import 'martial_arts_screen.dart';
import 'register_screen.dart';
import 'user_dashboard_screen.dart';
import 'women_events_screen.dart';

/// Mobile landing page styled after the localhost Fight D Fear index.
class LandingScreen extends StatelessWidget {
  const LandingScreen({super.key});

  static const Color primary = Color(0xFFF43F5E);
  static const Color primaryHover = Color(0xFFE11D48);
  static const Color navy = Color(0xFF1E1B4B);
  static const Color textGray = Color(0xFF64748B);

  static void _handleJoinUsSelection(BuildContext context, String value) {
    switch (value) {
      case 'member':
        Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const RegisterScreen()),
        );
      case 'martial_arts':
        Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const MartialArtsCentreRegisterScreen()),
        );
      case 'salon':
        Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const GlowProviderSignupScreen(initialTab: 0)),
        );
      case 'stylist':
        Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const GlowProviderSignupScreen(initialTab: 1)),
        );
      default:
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('$_joinUsLabel(value) — coming soon on mobile')),
        );
    }
  }

  static String _joinUsLabel(String value) {
    return switch (value) {
      'member' => 'Join as Member',
      'doctor' => 'Women Doctor',
      'martial_arts' => 'Self-Defense Trainer',
      'salon' => 'Beauty & Wellness Salon',
      'stylist' => 'Hair Stylist',
      'service_partner' => 'Service Partner',
      'marketplace_seller' => 'Marketplace Seller',
      'women_jobs' => 'Women Jobs',
      'entrepreneur' => 'Entrepreneur',
      'investor' => 'Investor',
      'event_host' => 'Event Host',
      'fitness_trainer' => 'Fitness Trainer',
      _ => 'Registration',
    };
  }

  static void _handleLoginSelection(BuildContext context, String value) {
    switch (value) {
      case 'user':
        Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const LoginScreen()),
        );
      case 'martial_arts':
        Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const MartialArtsCentreLoginScreen()),
        );
      case 'admin':
        Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const MartialArtsAdminScreen()),
        );
      default:
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${_loginLabel(value)} — sign in coming soon on mobile')),
        );
    }
  }

  static String _loginLabel(String value) {
    return switch (value) {
      'user' => 'User Login',
      'doctor' => 'Women Doctor Login',
      'martial_arts' => 'Self-Defense Center Login',
      'salon' => 'Beauty Salon Login',
      'stylist' => 'Hair Stylist Login',
      'service_partner' => 'Service Partner Login',
      'marketplace_seller' => 'Marketplace Seller Login',
      'entrepreneur' => 'Entrepreneur Login',
      'investor' => 'Investor Login',
      'event_host' => 'Event Host Login',
      'fitness_trainer' => 'Fitness Trainer Login',
      'admin' => 'Admin Login',
      _ => 'Login',
    };
  }

  void _openDangerMap(BuildContext context) {
    final auth = context.read<AuthState>();
    if (auth.loggedIn) {
      Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => const DangerMapScreen()),
      );
    } else {
      Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => const LoginScreen()),
      );
    }
  }

  void _openWomenEvents(BuildContext context) {
    final auth = context.read<AuthState>();
    if (auth.loggedIn) {
      Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => const WomenEventsScreen()),
      );
    } else {
      Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => const LoginScreen()),
      );
    }
  }

  void _openMartialArts(BuildContext context) {
    final auth = context.read<AuthState>();
    if (auth.loggedIn) {
      Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => const MartialArtsScreen()),
      );
    } else {
      Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => const LoginScreen()),
      );
    }
  }

  void _openDashboard(BuildContext context) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const UserDashboardScreen()),
    );
  }

  void _openSos(BuildContext context) {
    final auth = context.read<AuthState>();
    if (auth.loggedIn) {
      Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => const HomeScreen()),
      );
    } else {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => const LoginScreen(redirectToSos: true),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthState>();

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFFF8FAFC),
              Color(0xFFFFE4E6),
              Color(0xFFE0E7FF),
              Color(0xFFF8FAFC),
            ],
          ),
        ),
        child: SafeArea(
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(child: _TopBar(
                loggedIn: auth.loggedIn,
                onLoginSelected: (value) => _handleLoginSelection(context, value),
                onJoinSelected: (value) => _handleJoinUsSelection(context, value),
                onDashboard: () => _openDashboard(context),
              )),
              SliverToBoxAdapter(child: _Hero(
                loggedIn: auth.loggedIn,
                onDashboard: () => _openDashboard(context),
                onLoginSelected: (value) => _handleLoginSelection(context, value),
                onJoinSelected: (value) => _handleJoinUsSelection(context, value),
              )),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                  child: _QuickActions(
                    onSos: () => _openSos(context),
                    onMap: () => _openDangerMap(context),
                    onEvents: () => _openWomenEvents(context),
                    onDefense: () => _openMartialArts(context),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 28, 16, 0),
                  child: _WelcomeBlock(onSos: () => _openSos(context)),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 32, 16, 40),
                  child: _FeaturesGrid(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TopBar extends StatelessWidget {
  const _TopBar({
    required this.loggedIn,
    required this.onLoginSelected,
    required this.onJoinSelected,
    required this.onDashboard,
  });

  final bool loggedIn;
  final ValueChanged<String> onLoginSelected;
  final ValueChanged<String> onJoinSelected;
  final VoidCallback onDashboard;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.asset(
              'assets/images/fightdfear-logo.jpg',
              height: 48,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                height: 48,
                width: 48,
                color: LandingScreen.primary,
                alignment: Alignment.center,
                child: const Text(
                  'FD',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
          const Spacer(),
          if (loggedIn)
            FilledButton.tonal(
              onPressed: onDashboard,
              style: FilledButton.styleFrom(
                foregroundColor: LandingScreen.primary,
              ),
              child: const Text('My Dashboard'),
            )
          else ...[
            _LoginDropdown(
              onSelected: onLoginSelected,
              style: _LoginDropdownStyle.header,
            ),
            const SizedBox(width: 8),
            _JoinUsDropdown(
              onSelected: onJoinSelected,
              style: _JoinUsDropdownStyle.header,
            ),
          ],
        ],
      ),
    );
  }
}

class _Hero extends StatelessWidget {
  const _Hero({
    required this.loggedIn,
    required this.onDashboard,
    required this.onLoginSelected,
    required this.onJoinSelected,
  });

  final bool loggedIn;
  final VoidCallback onDashboard;
  final ValueChanged<String> onLoginSelected;
  final ValueChanged<String> onJoinSelected;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Stack(
          children: [
            AspectRatio(
              aspectRatio: 16 / 11,
              child: Image.asset(
                'assets/images/fighthero.jpeg',
                fit: BoxFit.cover,
                width: double.infinity,
                errorBuilder: (_, __, ___) => Container(
                  color: const Color(0xFFFFE4E6),
                  alignment: Alignment.center,
                  child: const Icon(Icons.shield_outlined, size: 64, color: LandingScreen.primary),
                ),
              ),
            ),
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withValues(alpha: 0.15),
                      Colors.black.withValues(alpha: 0.72),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              left: 20,
              right: 20,
              bottom: 20,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Fight D Fear',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Your Safety is Our Priority',
                    style: TextStyle(
                      color: Color(0xFFFFE4E6),
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 14),
                  if (loggedIn)
                    FilledButton(
                      onPressed: onDashboard,
                      style: FilledButton.styleFrom(
                        backgroundColor: LandingScreen.primary,
                        shape: const StadiumBorder(),
                      ),
                      child: const Text('My Dashboard'),
                    )
                  else
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: [
                        _LoginDropdown(
                          onSelected: onLoginSelected,
                          style: _LoginDropdownStyle.hero,
                        ),
                        _JoinUsDropdown(
                          onSelected: onJoinSelected,
                          style: _JoinUsDropdownStyle.hero,
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _QuickActions extends StatelessWidget {
  const _QuickActions({
    required this.onSos,
    required this.onMap,
    required this.onEvents,
    required this.onDefense,
  });

  final VoidCallback onSos;
  final VoidCallback onMap;
  final VoidCallback onEvents;
  final VoidCallback onDefense;

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      childAspectRatio: 1.55,
      children: [
        _QuickCard(
          title: 'SOS Emergency',
          subtitle: 'One-Tap Danger Alert',
          icon: Icons.warning_amber_rounded,
          emergency: true,
          onTap: onSos,
        ),
        _QuickCard(
          title: 'Danger Map',
          subtitle: 'Avoid Unsafe Zones',
          icon: Icons.map_outlined,
          onTap: onMap,
        ),
        _QuickCard(
          title: 'Women Events',
          subtitle: 'Empowerment Meetups',
          icon: Icons.event_outlined,
          onTap: onEvents,
        ),
        _QuickCard(
          title: 'Self-Defense',
          subtitle: 'Verified Academies',
          icon: Icons.sports_martial_arts_outlined,
          onTap: onDefense,
        ),
      ],
    );
  }
}

class _QuickCard extends StatelessWidget {
  const _QuickCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.onTap,
    this.emergency = false,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback onTap;
  final bool emergency;

  @override
  Widget build(BuildContext context) {
    final bg = emergency
        ? const LinearGradient(
            colors: [LandingScreen.primary, LandingScreen.primaryHover],
          )
        : null;
    return Material(
      color: emergency ? null : Colors.white.withValues(alpha: 0.92),
      borderRadius: BorderRadius.circular(20),
      elevation: 2,
      shadowColor: Colors.black12,
      child: Ink(
        decoration: BoxDecoration(
          gradient: bg,
          borderRadius: BorderRadius.circular(20),
          border: emergency
              ? null
              : Border.all(color: Colors.white.withValues(alpha: 0.6)),
        ),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: emergency
                        ? Colors.white.withValues(alpha: 0.2)
                        : LandingScreen.primary.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    icon,
                    color: emergency ? Colors.white : LandingScreen.primary,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 13,
                          color: emergency ? Colors.white : LandingScreen.navy,
                        ),
                      ),
                      Text(
                        subtitle,
                        style: TextStyle(
                          fontSize: 11,
                          color: emergency
                              ? Colors.white.withValues(alpha: 0.85)
                              : LandingScreen.textGray,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _WelcomeBlock extends StatefulWidget {
  const _WelcomeBlock({required this.onSos});

  final VoidCallback onSos;

  @override
  State<_WelcomeBlock> createState() => _WelcomeBlockState();
}

class _WelcomeBlockState extends State<_WelcomeBlock>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulse;

  @override
  void initState() {
    super.initState();
    _pulse = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulse.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: LandingScreen.primary.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Text(
            'FIGHT D FEAR — WOMEN SAFETY',
            style: TextStyle(
              color: LandingScreen.primary,
              fontWeight: FontWeight.w700,
              fontSize: 11,
              letterSpacing: 1.1,
            ),
          ),
        ),
        const SizedBox(height: 12),
        Text.rich(
          TextSpan(
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w900,
                  color: LandingScreen.navy,
                ),
            children: const [
              TextSpan(text: 'Your Safety is '),
              TextSpan(
                text: 'Our Priority',
                style: TextStyle(color: LandingScreen.primary),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        const Text(
          'Empowering women with instant emergency response, self-defense training, '
          'community support and professional wellness resources — all in one platform.',
          style: TextStyle(color: LandingScreen.textGray, height: 1.5),
        ),
        const SizedBox(height: 24),
        Center(
          child: AnimatedBuilder(
            animation: _pulse,
            builder: (context, child) {
              final t = _pulse.value;
              return Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: LandingScreen.primary.withValues(alpha: 0.25 + t * 0.2),
                      blurRadius: 24 + t * 16,
                      spreadRadius: 4 + t * 8,
                    ),
                  ],
                ),
                child: child,
              );
            },
            child: Material(
              color: LandingScreen.primary,
              shape: const CircleBorder(),
              child: InkWell(
                customBorder: const CircleBorder(),
                onTap: widget.onSos,
                child: const SizedBox(
                  width: 140,
                  height: 140,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'SOS',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 2,
                        ),
                      ),
                      Text(
                        'PRESS TO TRIGGER',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 1,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          child: FilledButton.icon(
            onPressed: widget.onSos,
            icon: const Icon(Icons.notifications_active_outlined),
            label: const Text('Go to SOS Dashboard'),
            style: FilledButton.styleFrom(
              backgroundColor: LandingScreen.primaryHover,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: const StadiumBorder(),
            ),
          ),
        ),
      ],
    );
  }
}

class _FeaturesGrid extends StatelessWidget {
  static const _modules = [
    (
      '01',
      'Core Safety Features',
      'SOS Panic Button, Audio Recording, Emergency Contacts, Live Location Sharing.',
      Icons.shield_outlined,
    ),
    (
      '02',
      'Community Features',
      'Community posts, Chat, Safety Stories, Volunteer Network & Buddy System.',
      Icons.groups_outlined,
    ),
    (
      '03',
      'Location Intelligence',
      'Danger maps, safe routes and live location awareness.',
      Icons.location_on_outlined,
    ),
    (
      '04',
      'Self-Defense',
      'Verified academies and training to build confidence.',
      Icons.sports_martial_arts_outlined,
    ),
    (
      '05',
      'Women Events',
      'Empowerment meetups and community gatherings.',
      Icons.event_available_outlined,
    ),
    (
      '06',
      'Wellness & Care',
      'Doctors, salon, fitness and marketplace resources.',
      Icons.favorite_outline,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
          decoration: BoxDecoration(
            color: LandingScreen.primary.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Text(
            'ALL-IN-ONE PLATFORM',
            style: TextStyle(
              color: LandingScreen.primary,
              fontWeight: FontWeight.w700,
              fontSize: 11,
              letterSpacing: 1.2,
            ),
          ),
        ),
        const SizedBox(height: 12),
        Text.rich(
          TextSpan(
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w800,
                  color: LandingScreen.navy,
                ),
            children: const [
              TextSpan(text: "Everything You Need for "),
              TextSpan(
                text: "Women's Safety",
                style: TextStyle(color: LandingScreen.primary),
              ),
            ],
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        const Text(
          'Modules designed to protect, empower, and connect women',
          textAlign: TextAlign.center,
          style: TextStyle(color: LandingScreen.textGray),
        ),
        const SizedBox(height: 20),
        ..._modules.map(
          (m) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x08000000),
                    blurRadius: 16,
                    offset: Offset(0, 6),
                  ),
                ],
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: LandingScreen.primary.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Icon(m.$4, color: LandingScreen.primary),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${m.$1}  ${m.$2}',
                          style: const TextStyle(
                            fontWeight: FontWeight.w800,
                            color: LandingScreen.navy,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          m.$3,
                          style: const TextStyle(
                            color: LandingScreen.textGray,
                            height: 1.4,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

enum _JoinUsDropdownStyle { header, hero }

enum _LoginDropdownStyle { header, hero }

class _LoginOption {
  const _LoginOption({
    required this.value,
    required this.label,
    required this.icon,
    this.available = false,
  });

  final String value;
  final String label;
  final IconData icon;
  final bool available;
}

class _LoginDropdown extends StatelessWidget {
  const _LoginDropdown({
    required this.onSelected,
    required this.style,
  });

  final ValueChanged<String> onSelected;
  final _LoginDropdownStyle style;

  static const _options = [
    _LoginOption(value: 'user', label: 'User Login', icon: Icons.person_outline, available: true),
    _LoginOption(value: 'doctor', label: 'Women Doctor Login', icon: Icons.monitor_heart_outlined),
    _LoginOption(value: 'martial_arts', label: 'Self-Defense Center Login', icon: Icons.sports_martial_arts_outlined, available: true),
    _LoginOption(value: 'salon', label: 'Beauty Salon Login', icon: Icons.spa_outlined),
    _LoginOption(value: 'stylist', label: 'Hair Stylist Login', icon: Icons.content_cut_outlined),
    _LoginOption(value: 'service_partner', label: 'Service Partner Login', icon: Icons.handshake_outlined),
    _LoginOption(value: 'marketplace_seller', label: 'Marketplace Seller Login', icon: Icons.storefront_outlined),
    _LoginOption(value: 'entrepreneur', label: 'Entrepreneur Login', icon: Icons.lightbulb_outline),
    _LoginOption(value: 'investor', label: 'Investor Login', icon: Icons.trending_up),
    _LoginOption(value: 'event_host', label: 'Event Host Login', icon: Icons.event_available_outlined),
    _LoginOption(value: 'fitness_trainer', label: 'Fitness Trainer Login', icon: Icons.fitness_center_outlined),
    _LoginOption(value: 'admin', label: 'Admin Login', icon: Icons.admin_panel_settings_outlined, available: true),
  ];

  @override
  Widget build(BuildContext context) {
    final isHero = style == _LoginDropdownStyle.hero;
    return PopupMenuButton<String>(
      onSelected: onSelected,
      offset: Offset(0, isHero ? 8 : 40),
      constraints: const BoxConstraints(minWidth: 280, maxWidth: 340),
      itemBuilder: (ctx) => _options
          .map(
            (o) => PopupMenuItem<String>(
              value: o.value,
              child: Row(
                children: [
                  Icon(o.icon, size: 20, color: LandingScreen.primary),
                  const SizedBox(width: 10),
                  Expanded(child: Text(o.label, style: const TextStyle(fontSize: 14))),
                  if (o.available)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: const Color(0xFFDCFCE7),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Text(
                        'Open',
                        style: TextStyle(fontSize: 10, color: Color(0xFF166534), fontWeight: FontWeight.w700),
                      ),
                    ),
                ],
              ),
            ),
          )
          .toList(),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: isHero ? 18 : 14,
          vertical: isHero ? 12 : 10,
        ),
        decoration: BoxDecoration(
          color: isHero ? Colors.transparent : Colors.white,
          borderRadius: BorderRadius.circular(isHero ? 24 : 20),
          border: Border.all(
            color: isHero ? Colors.white : LandingScreen.primary,
            width: isHero ? 2 : 1.5,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.login,
              color: isHero ? Colors.white : LandingScreen.primary,
              size: 18,
            ),
            const SizedBox(width: 6),
            Text(
              'Login',
              style: TextStyle(
                color: isHero ? Colors.white : LandingScreen.primary,
                fontWeight: FontWeight.w700,
                fontSize: isHero ? 15 : 14,
              ),
            ),
            Icon(
              Icons.arrow_drop_down,
              color: isHero ? Colors.white : LandingScreen.primary,
            ),
          ],
        ),
      ),
    );
  }
}

class _JoinUsOption {
  const _JoinUsOption({
    required this.value,
    required this.label,
    required this.icon,
    this.available = false,
  });

  final String value;
  final String label;
  final IconData icon;
  final bool available;
}

class _JoinUsDropdown extends StatelessWidget {
  const _JoinUsDropdown({
    required this.onSelected,
    required this.style,
  });

  final ValueChanged<String> onSelected;
  final _JoinUsDropdownStyle style;

  static const _options = [
    _JoinUsOption(value: 'member', label: 'Join as Member', icon: Icons.person_outline, available: true),
    _JoinUsOption(value: 'doctor', label: 'Women Doctor', icon: Icons.monitor_heart_outlined),
    _JoinUsOption(value: 'martial_arts', label: 'Self-Defense Trainer', icon: Icons.sports_martial_arts_outlined, available: true),
    _JoinUsOption(value: 'salon', label: 'Beauty & Wellness Salon', icon: Icons.spa_outlined, available: true),
    _JoinUsOption(value: 'stylist', label: 'Hair Stylist', icon: Icons.content_cut_outlined, available: true),
    _JoinUsOption(value: 'service_partner', label: 'Service Partner', icon: Icons.handshake_outlined),
    _JoinUsOption(value: 'marketplace_seller', label: 'Marketplace Seller', icon: Icons.storefront_outlined),
    _JoinUsOption(value: 'women_jobs', label: 'Women Jobs', icon: Icons.work_outline),
    _JoinUsOption(value: 'entrepreneur', label: 'Entrepreneur', icon: Icons.lightbulb_outline),
    _JoinUsOption(value: 'investor', label: 'Investor', icon: Icons.trending_up),
    _JoinUsOption(value: 'event_host', label: 'Event Host', icon: Icons.event_available_outlined),
    _JoinUsOption(value: 'fitness_trainer', label: 'Fitness Trainer', icon: Icons.fitness_center_outlined),
  ];

  @override
  Widget build(BuildContext context) {
    final isHero = style == _JoinUsDropdownStyle.hero;
    return PopupMenuButton<String>(
      onSelected: onSelected,
      offset: Offset(0, isHero ? 8 : 40),
      constraints: const BoxConstraints(minWidth: 260, maxWidth: 320),
      itemBuilder: (ctx) => _options
          .map(
            (o) => PopupMenuItem<String>(
              value: o.value,
              child: Row(
                children: [
                  Icon(o.icon, size: 20, color: LandingScreen.primary),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      o.label,
                      style: const TextStyle(fontSize: 14),
                    ),
                  ),
                  if (o.available)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: const Color(0xFFDCFCE7),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Text(
                        'Open',
                        style: TextStyle(fontSize: 10, color: Color(0xFF166534), fontWeight: FontWeight.w700),
                      ),
                    ),
                ],
              ),
            ),
          )
          .toList(),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: isHero ? 18 : 14,
          vertical: isHero ? 12 : 10,
        ),
        decoration: BoxDecoration(
          color: LandingScreen.primary,
          borderRadius: BorderRadius.circular(isHero ? 24 : 20),
          boxShadow: isHero
              ? const [
                  BoxShadow(
                    color: Color(0x33F43F5E),
                    blurRadius: 8,
                    offset: Offset(0, 3),
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(isHero ? Icons.person_add_alt_1 : Icons.person_add_outlined, color: Colors.white, size: 18),
            const SizedBox(width: 6),
            Text(
              'Join Us',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: isHero ? 15 : 14,
              ),
            ),
            const SizedBox(width: 2),
            const Icon(Icons.arrow_drop_down, color: Colors.white),
          ],
        ),
      ),
    );
  }
}
