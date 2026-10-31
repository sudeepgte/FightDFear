import 'package:flutter/material.dart';

enum OrgVerifyField {
  gst,
  ngoReg,
  societyReg,
  trustReg,
  companyCin,
  startupIndiaId,
}

class EventOrgType {
  const EventOrgType({
    required this.label,
    required this.icon,
    required this.verifyFields,
  });

  final String label;
  final IconData icon;
  final List<OrgVerifyField> verifyFields;
}

class EventOrganizerCatalog {
  EventOrganizerCatalog._();

  static const frequencies = [
    'Weekly',
    'Monthly',
    'Quarterly',
    'Yearly',
    'One Time',
  ];

  static const modes = ['Offline', 'Online', 'Hybrid'];

  static const venueTypes = [
    'Indoor',
    'Outdoor',
    'Own Venue',
    'Rental Venue',
  ];

  static const audiences = [
    'Women',
    'Students',
    'Professionals',
    'Entrepreneurs',
    'Senior Citizens',
    'Children',
    'Families',
    'NGOs',
    'Startups',
  ];

  static const languages = [
    'English',
    'Hindi',
    'Kannada',
    'Tamil',
    'Telugu',
    'Malayalam',
    'Marathi',
  ];

  static const facilities = [
    'Parking',
    'Food Court',
    'Drinking Water',
    'Security',
    'Medical Support',
    'Wheelchair Access',
    'Child Care',
    'Washrooms',
    'Wi-Fi',
    'Photography',
  ];

  static const pricingModels = [
    'Free Events',
    'Paid Events',
    'Donation Based',
    'Sponsored',
  ];

  static const eventCategories = [
    'Women Safety',
    'Women Empowerment',
    'Self Defence',
    'Health Camp',
    'Blood Donation',
    'Yoga',
    'Marathon',
    'Mental Wellness',
    'Career Fair',
    'Startup Meetup',
    'Business Networking',
    'Education Workshop',
    'Coding Bootcamp',
    'Cultural Event',
    'Music Festival',
    'Art Exhibition',
    'Fashion Show',
    'Entrepreneurship',
    'Leadership Training',
    'Financial Literacy',
    'Legal Awareness',
    'Parenting',
    'Community Service',
  ];

  static const orgTypes = <EventOrgType>[
    EventOrgType(
      label: 'NGO',
      icon: Icons.volunteer_activism_rounded,
      verifyFields: [OrgVerifyField.ngoReg, OrgVerifyField.trustReg, OrgVerifyField.gst],
    ),
    EventOrgType(
      label: 'Company',
      icon: Icons.business_rounded,
      verifyFields: [OrgVerifyField.gst, OrgVerifyField.companyCin],
    ),
    EventOrgType(
      label: 'Educational Institution',
      icon: Icons.school_rounded,
      verifyFields: [OrgVerifyField.societyReg, OrgVerifyField.gst],
    ),
    EventOrgType(
      label: 'Government Department',
      icon: Icons.account_balance_rounded,
      verifyFields: [],
    ),
    EventOrgType(
      label: 'Community Organization',
      icon: Icons.groups_rounded,
      verifyFields: [OrgVerifyField.societyReg, OrgVerifyField.ngoReg],
    ),
    EventOrgType(
      label: 'Women Self Help Group',
      icon: Icons.woman_rounded,
      verifyFields: [OrgVerifyField.societyReg, OrgVerifyField.ngoReg],
    ),
    EventOrgType(
      label: 'Startup',
      icon: Icons.rocket_launch_rounded,
      verifyFields: [OrgVerifyField.startupIndiaId, OrgVerifyField.gst, OrgVerifyField.companyCin],
    ),
    EventOrgType(
      label: 'Fitness Organization',
      icon: Icons.fitness_center_rounded,
      verifyFields: [OrgVerifyField.gst],
    ),
    EventOrgType(
      label: 'Healthcare Organization',
      icon: Icons.local_hospital_rounded,
      verifyFields: [OrgVerifyField.gst, OrgVerifyField.societyReg],
    ),
    EventOrgType(
      label: 'Event Management Company',
      icon: Icons.event_rounded,
      verifyFields: [OrgVerifyField.gst, OrgVerifyField.companyCin],
    ),
    EventOrgType(
      label: 'Charity Foundation',
      icon: Icons.favorite_rounded,
      verifyFields: [OrgVerifyField.trustReg, OrgVerifyField.ngoReg, OrgVerifyField.gst],
    ),
    EventOrgType(
      label: 'Sports Club',
      icon: Icons.sports_soccer_rounded,
      verifyFields: [OrgVerifyField.societyReg, OrgVerifyField.gst],
    ),
    EventOrgType(
      label: 'Youth Organization',
      icon: Icons.emoji_people_rounded,
      verifyFields: [OrgVerifyField.societyReg, OrgVerifyField.ngoReg],
    ),
  ];

  static EventOrgType? byLabel(String label) {
    for (final t in orgTypes) {
      if (t.label == label) return t;
    }
    return null;
  }

  static String verifyLabel(OrgVerifyField f) => switch (f) {
        OrgVerifyField.gst => 'GST (optional)',
        OrgVerifyField.ngoReg => 'NGO Registration Number',
        OrgVerifyField.societyReg => 'Society Registration Number',
        OrgVerifyField.trustReg => 'Trust Registration',
        OrgVerifyField.companyCin => 'Company CIN',
        OrgVerifyField.startupIndiaId => 'Startup India ID',
      };
}
