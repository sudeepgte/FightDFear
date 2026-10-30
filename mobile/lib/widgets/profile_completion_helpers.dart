import 'package:flutter/material.dart';

/// Contextual field helper text generator for profile completion & editing screens.
class ProfileFieldHelper {
  ProfileFieldHelper._();

  static String helperForLabel(String label) {
    final l = label.toLowerCase();
    if (l.contains('full name') || (l.contains('name') && !l.contains('bank') && !l.contains('hospital') && !l.contains('shop') && !l.contains('company') && !l.contains('service'))) {
      return 'Enter your full name as it appears on your official documents.';
    }
    if (l.contains('phone')) return 'Enter your 10-digit mobile number.';
    if (l.contains('whatsapp')) return 'Enter your 10-digit WhatsApp number for customer updates.';
    if (l.contains('ifsc')) return 'Enter 11-character official bank IFSC code (e.g. SBIN0000123).';
    if (l.contains('reg') || l.contains('license') || l.contains('credential') || l.contains('bar council') || l.contains('gstin')) {
      return 'Enter valid official registration/license number.';
    }
    if (l.contains('experience') || l.contains('years')) {
      return 'Enter your total years of professional experience.';
    }
    if (l.contains('hospital') || l.contains('clinic') || l.contains('studio') || l.contains('centre') || l.contains('center') || l.contains('shop') || l.contains('company') || l.contains('business')) {
      return 'Enter registered establishment or business name.';
    }
    if (l.contains('address')) return 'Enter street address, building or suite details.';
    if (l.contains('city')) return 'Enter or select your city or locality.';
    if (l.contains('state')) return 'Select your State or Union Territory.';
    if (l.contains('district')) return 'Select your administrative District.';
    if (l.contains('pincode') || l.contains('zip')) return 'Enter your 6-digit postal PIN code.';
    if (l.contains('fee') || l.contains('rate') || l.contains('price') || l.contains('capital') || l.contains('ticket') || l.contains('starting')) {
      return 'Enter amount in INR (₹).';
    }
    if (l.contains('bio') || l.contains('about') || l.contains('how we teach')) {
      return 'Provide a clear summary of your expertise and background.';
    }
    if (l.contains('map')) return 'Paste a Google Maps link or choose your location using the map.';
    if (l.contains('upi')) return 'Enter your UPI ID (e.g., name@upi) for instant payouts.';
    if (l.contains('mode')) return 'Select preferred service or consultation mode.';
    if (l.contains('duration')) return 'Select standard session duration in minutes.';
    if (l.contains('buffer')) return 'Select rest or transit buffer in minutes.';
    return 'Enter $label.';
  }

  static String instructionForField({
    required String label,
    String? hint,
    bool required = false,
  }) {
    if (hint != null && hint.isNotEmpty && !hint.startsWith('e.g.') && hint.length > 5) {
      return hint;
    }
    final text = helperForLabel(label);
    if (required && !text.contains('required')) {
      return '$text (Required)';
    }
    return text;
  }
}

/// Centralized helper to evaluate partner approval and redirection.
/// Ensures approved users always navigate to their role-specific dashboard directly.
class ApprovalNavigation {
  ApprovalNavigation._();

  /// Returns true if the user must complete their profile before accessing dashboard.
  /// If the partner status is APPROVED or approved == true, returns false.
  static bool shouldRedirectToProfileCompletion(Map<String, dynamic> res) {
    final statusStr = (res['status'] ??
            res['partnerStatus'] ??
            res['partnerProfileStatus'] ??
            res['verificationStatus'] ??
            '')
        .toString()
        .toUpperCase();
    if (statusStr == 'APPROVED' || statusStr == 'VERIFIED' || res['approved'] == true) {
      return false; // APPROVED users ALWAYS go to dashboard directly!
    }
    return res['needsProfileCompletion'] == true;
  }
}
