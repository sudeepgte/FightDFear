import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'module_theme.dart';

/// Digital event ticket matching web `/women-events/ticket/{id}`.
class DigitalTicketDialog extends StatelessWidget {
  const DigitalTicketDialog({
    super.key,
    required this.ticketCode,
    this.qrToken,
    required this.eventName,
    this.attendeeName,
    this.eventDate,
    this.eventTime,
    this.venue,
    this.city,
    this.mapsLocation,
    this.eventFormat = 'OFFLINE',
    this.virtual = false,
    this.streamLink,
    this.meetingPlatform,
    this.status = 'REGISTERED',
    this.checkedIn = false,
    this.checkedInAt,
    this.amountPaid = 0.0,
    this.coinsUsed = 0,
    this.ticketTypeName = 'General',
    this.canCancel = false,
    this.onCancel,
    this.canReview = false,
    this.onReview,
  });

  final String ticketCode;
  final String? qrToken;
  final String eventName;
  final String? attendeeName;
  final String? eventDate;
  final String? eventTime;
  final String? venue;
  final String? city;
  final String? mapsLocation;
  final String eventFormat;
  final bool virtual;
  final String? streamLink;
  final String? meetingPlatform;
  final String status;
  final bool checkedIn;
  final String? checkedInAt;
  final double amountPaid;
  final int coinsUsed;
  final String ticketTypeName;
  final bool canCancel;
  final VoidCallback? onCancel;
  final bool canReview;
  final VoidCallback? onReview;

  static const Color plum = Color(0xFF2D142C);
  static const Color rose = Color(0xFFF43F5E);
  static const Color softPink = Color(0xFFFFF1F2);
  static const Color border = Color(0xFFFECDD3);

  String get _qrUrl {
    final token = (qrToken != null && qrToken!.trim().isNotEmpty) ? qrToken!.trim() : ticketCode.trim();
    final encoded = Uri.encodeComponent(token);
    return 'https://api.qrserver.com/v1/create-qr-code/?size=220x220&data=$encoded';
  }

  @override
  Widget build(BuildContext context) {
    final isCancelled = status.toUpperCase() == 'CANCELLED';
    final isAttended = checkedIn || status.toUpperCase() == 'ATTENDED';

    final loc = [venue, city].where((s) => s != null && s.trim().isNotEmpty).join(', ');

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      clipBehavior: Clip.antiAlias,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 420),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Ticket Header Banner
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 22),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [plum, rose],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Fight D Fear',
                          style: TextStyle(
                            color: Colors.white70,
                            fontWeight: FontWeight.w700,
                            fontSize: 12,
                            letterSpacing: 1.1,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.white24,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            isCancelled
                                ? 'Cancelled'
                                : (isAttended ? 'Verified & Attended' : 'Digital Ticket'),
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w800,
                              fontSize: 11,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      eventName,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                        fontSize: 18,
                        height: 1.25,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      ticketTypeName,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),

              // Ticket Body
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    if (attendeeName != null && attendeeName!.isNotEmpty)
                      _row('Attendee', attendeeName!),
                    if (eventDate != null && eventDate!.isNotEmpty)
                      _row('Date & Time', '$eventDate ${eventTime ?? ""}'),
                    if (loc.isNotEmpty)
                      _row('Venue', loc),
                    _row(
                      'Attendance',
                      isAttended
                          ? 'Verified & Attended'
                          : (isCancelled ? 'Cancelled' : 'Registered (Awaiting Entry)'),
                      valColor: isAttended
                          ? const Color(0xFF16A34A)
                          : (isCancelled ? const Color(0xFFDC2626) : const Color(0xFF64748B)),
                    ),
                    if (checkedInAt != null && checkedInAt!.isNotEmpty)
                      _row('Checked in at', checkedInAt!),
                    _row('Amount Paid', amountPaid <= 0 ? 'Free' : '₹${amountPaid.toStringAsFixed(0)}'),
                    if (coinsUsed > 0)
                      _row('Coins Redeemed', '$coinsUsed coins'),

                    const SizedBox(height: 14),

                    // QR Code Card
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: softPink,
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(color: border),
                      ),
                      child: Column(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Container(
                              color: Colors.white,
                              padding: const EdgeInsets.all(8),
                              child: ModuleTheme.networkImage(
                                _qrUrl,
                                width: 170,
                                height: 170,
                                fit: BoxFit.contain,
                                error: const Icon(Icons.qr_code_2, size: 140, color: plum),
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: border),
                            ),
                            child: Text(
                              ticketCode,
                              style: const TextStyle(
                                fontFamily: 'monospace',
                                fontWeight: FontWeight.w800,
                                fontSize: 16,
                                letterSpacing: 2,
                                color: plum,
                              ),
                            ),
                          ),
                          const SizedBox(height: 6),
                          const Text(
                            'Show this QR code or code at event entrance',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF6B5B68),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Direction / Stream Action
                    if (streamLink != null && streamLink!.isNotEmpty && !isCancelled) ...[
                      FilledButton.icon(
                        style: FilledButton.styleFrom(
                          backgroundColor: const Color(0xFF0284C7),
                          minimumSize: const Size.fromHeight(46),
                        ),
                        onPressed: () async {
                          final uri = Uri.parse(streamLink!);
                          if (await canLaunchUrl(uri)) await launchUrl(uri);
                        },
                        icon: const Icon(Icons.videocam_outlined),
                        label: Text('Join Online ${meetingPlatform != null && meetingPlatform!.isNotEmpty ? "($meetingPlatform)" : ""}'),
                      ),
                      const SizedBox(height: 8),
                    ] else if (mapsLocation != null && mapsLocation!.isNotEmpty && !isCancelled) ...[
                      OutlinedButton.icon(
                        style: OutlinedButton.styleFrom(
                          minimumSize: const Size.fromHeight(44),
                        ),
                        onPressed: () async {
                          final uri = Uri.parse(mapsLocation!);
                          if (await canLaunchUrl(uri)) await launchUrl(uri);
                        },
                        icon: const Icon(Icons.directions, color: rose),
                        label: const Text('Get Directions (Google Maps)'),
                      ),
                      const SizedBox(height: 8),
                    ],

                    if (canReview) ...[
                      FilledButton.icon(
                        style: FilledButton.styleFrom(
                          backgroundColor: rose,
                          minimumSize: const Size.fromHeight(44),
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                          onReview?.call();
                        },
                        icon: const Icon(Icons.star_outline),
                        label: const Text('Rate & Review Event'),
                      ),
                      const SizedBox(height: 8),
                    ],

                    if (canCancel) ...[
                      TextButton.icon(
                        onPressed: () {
                          Navigator.pop(context);
                          onCancel?.call();
                        },
                        icon: const Icon(Icons.cancel_outlined, size: 16, color: Color(0xFFDC2626)),
                        label: const Text(
                          'Cancel Ticket',
                          style: TextStyle(color: Color(0xFFDC2626), fontWeight: FontWeight.w700),
                        ),
                      ),
                    ],

                    const SizedBox(height: 6),
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Close'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _row(String label, String value, {Color? valColor}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 12, color: Color(0xFF6B5B68), fontWeight: FontWeight.w500),
          ),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: valColor ?? plum,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
