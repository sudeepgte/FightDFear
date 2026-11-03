import 'package:flutter/material.dart';

import '../services/api_client.dart';

/// Dynamic Location Selection: Country -> State -> District -> Full Address
/// Cascading dropdowns and address text input with multi-country support.
class DynamicLocationHierarchyPicker extends StatefulWidget {
  const DynamicLocationHierarchyPicker({
    super.key,
    required this.api,
    this.initialCountry = 'India',
    this.initialState,
    this.initialDistrict,
    this.initialFullAddress,
    this.initialCity,
    required this.onLocationChanged,
    this.isRequired = true,
  });

  final ApiClient api;
  final String initialCountry;
  final String? initialState;
  final String? initialDistrict;
  final String? initialFullAddress;
  final String? initialCity;
  final void Function({
    required String country,
    required String state,
    required String district,
    String? fullAddress,
    String? city,
  }) onLocationChanged;
  final bool isRequired;

  @override
  State<DynamicLocationHierarchyPicker> createState() => DynamicLocationHierarchyPickerState();
}

class DynamicLocationHierarchyPickerState extends State<DynamicLocationHierarchyPicker> {
  static const _defaultCountries = [
    'India',
    'United States',
    'United Kingdom',
    'Canada',
    'Australia',
    'United Arab Emirates',
    'Singapore',
    'Other'
  ];

  static const _fallbackStates = [
    'Andhra Pradesh', 'Arunachal Pradesh', 'Assam', 'Bihar', 'Chhattisgarh',
    'Goa', 'Gujarat', 'Haryana', 'Himachal Pradesh', 'Jharkhand',
    'Karnataka', 'Kerala', 'Madhya Pradesh', 'Maharashtra', 'Manipur',
    'Meghalaya', 'Mizoram', 'Nagaland', 'Odisha', 'Punjab',
    'Rajasthan', 'Sikkim', 'Tamil Nadu', 'Telangana', 'Tripura',
    'Uttar Pradesh', 'Uttarakhand', 'West Bengal',
    'Andaman and Nicobar Islands', 'Chandigarh', 'Dadra and Nagar Haveli and Daman and Diu',
    'Delhi', 'Jammu and Kashmir', 'Ladakh', 'Lakshadweep', 'Puducherry'
  ];

  String _country = 'India';
  String? _state;
  String? _district;
  final _fullAddressCtrl = TextEditingController();

  List<String> _countries = _defaultCountries;
  List<String> _states = [];
  List<String> _districts = [];

  bool _loadingCountries = false;
  bool _loadingStates = false;
  bool _loadingDistricts = false;

  String? _stateError;
  String? _districtError;
  String? _fullAddressError;

  @override
  void initState() {
    super.initState();
    _country = widget.initialCountry.isNotEmpty ? widget.initialCountry : 'India';
    _state = widget.initialState;
    _district = widget.initialDistrict;
    final initAddr = widget.initialFullAddress ?? widget.initialCity;
    if (initAddr != null && initAddr.isNotEmpty) {
      _fullAddressCtrl.text = initAddr;
    }
    _loadCountries();
    _loadStates();
  }

  @override
  void dispose() {
    _fullAddressCtrl.dispose();
    super.dispose();
  }

  Future<void> _loadCountries() async {
    setState(() => _loadingCountries = true);
    try {
      final res = await widget.api.get('/api/locations/countries', auth: false);
      if (res['success'] == true && res['countries'] is List) {
        final list = (res['countries'] as List).map((e) => e.toString()).toList();
        if (mounted && list.isNotEmpty) {
          setState(() {
            _countries = list;
            if (!_countries.contains(_country)) {
              _countries.add(_country);
            }
          });
        }
      }
    } catch (_) {
      // Keep default countries
    } finally {
      if (mounted) setState(() => _loadingCountries = false);
    }
  }

  Future<void> _loadStates() async {
    setState(() => _loadingStates = true);
    try {
      final res = await widget.api.get('/api/locations/states', auth: false);
      if (res['success'] == true && res['states'] is List) {
        final list = (res['states'] as List).map((e) => e.toString()).toList();
        if (mounted) setState(() => _states = list);
      } else {
        if (mounted) setState(() => _states = _fallbackStates);
      }
    } catch (_) {
      if (mounted) setState(() => _states = _fallbackStates);
    } finally {
      if (mounted) setState(() => _loadingStates = false);
    }

    if (_state != null && _state!.isNotEmpty) {
      await _loadDistricts(_state!, restoreDistrict: _district);
    }
  }

  Future<void> _loadDistricts(String state, {String? restoreDistrict}) async {
    setState(() {
      _loadingDistricts = true;
      _districts = [];
    });
    try {
      final res = await widget.api.get(
        '/api/locations/districts?state=${Uri.encodeComponent(state)}',
        auth: false,
      );
      if (res['success'] == true && res['districts'] is List) {
        final list = (res['districts'] as List).map((e) => e.toString()).toList();
        if (mounted) {
          setState(() {
            _districts = list;
            if (restoreDistrict != null && list.contains(restoreDistrict)) {
              _district = restoreDistrict;
            }
          });
        }
      }
    } catch (_) {
      // Graceful fallback
    } finally {
      if (mounted) setState(() => _loadingDistricts = false);
    }
  }

  void _notify() {
    final addr = _fullAddressCtrl.text.trim();
    widget.onLocationChanged(
      country: _country,
      state: _state ?? '',
      district: _district ?? '',
      fullAddress: addr,
      city: addr.isNotEmpty ? addr : (_district ?? ''),
    );
  }

  bool validate() {
    var ok = true;
    setState(() {
      if (widget.isRequired && (_state == null || _state!.isEmpty)) {
        _stateError = 'State is required';
        ok = false;
      } else {
        _stateError = null;
      }

      if (widget.isRequired && (_district == null || _district!.isEmpty)) {
        _districtError = 'District is required';
        ok = false;
      } else {
        _districtError = null;
      }

      if (widget.isRequired && _fullAddressCtrl.text.trim().isEmpty) {
        _fullAddressError = 'Full address is required';
        ok = false;
      } else {
        _fullAddressError = null;
      }
    });
    return ok;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // 1. Country Selection
        DropdownButtonFormField<String>(
          key: const ValueKey('location_country_dropdown'),
          isExpanded: true,
          value: _countries.contains(_country) ? _country : _countries.first,
          decoration: InputDecoration(
            labelText: 'Country${widget.isRequired ? ' *' : ''}',
            helperText: 'Select country of residence / practice.',
            helperMaxLines: 2,
            prefixIcon: const Icon(Icons.public_outlined, color: Color(0xFFBE123C)),
            suffixIcon: _loadingCountries
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: Padding(padding: EdgeInsets.all(12), child: CircularProgressIndicator(strokeWidth: 2)),
                  )
                : null,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            filled: true,
            fillColor: Colors.white,
          ),
          items: _countries.map((c) => DropdownMenuItem(value: c, child: Text(c, overflow: TextOverflow.ellipsis))).toList(),
          onChanged: (v) {
            if (v != null && v != _country) {
              setState(() {
                _country = v;
                _state = null;
                _district = null;
                _stateError = null;
                _districtError = null;
              });
              if (_country == 'India') {
                _loadStates();
              } else {
                setState(() => _states = ['State / Province / Region']);
              }
              _notify();
            }
          },
        ),
        const SizedBox(height: 12),

        // 2. State Selection
        DropdownButtonFormField<String>(
          key: const ValueKey('location_state_dropdown'),
          isExpanded: true,
          value: _states.contains(_state) ? _state : null,
          decoration: InputDecoration(
            labelText: 'State / Union Territory${widget.isRequired ? ' *' : ''}',
            hintText: _loadingStates ? 'Loading states…' : 'Select State',
            helperText: 'Select your State or Union Territory.',
            helperMaxLines: 2,
            errorText: _stateError,
            prefixIcon: const Icon(Icons.map_outlined, color: Color(0xFFBE123C)),
            suffixIcon: _loadingStates
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: Padding(padding: EdgeInsets.all(12), child: CircularProgressIndicator(strokeWidth: 2)),
                  )
                : null,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            filled: true,
            fillColor: Colors.white,
          ),
          items: _states.map((s) => DropdownMenuItem(value: s, child: Text(s, overflow: TextOverflow.ellipsis))).toList(),
          onChanged: (v) {
            setState(() {
              _state = v;
              _district = null;
              _stateError = null;
              _districtError = null;
            });
            if (v != null) {
              _loadDistricts(v);
            }
            _notify();
          },
        ),
        const SizedBox(height: 12),

        // 3. District Selection
        DropdownButtonFormField<String>(
          key: const ValueKey('location_district_dropdown'),
          isExpanded: true,
          value: _districts.contains(_district) ? _district : null,
          decoration: InputDecoration(
            labelText: 'District${widget.isRequired ? ' *' : ''}',
            hintText: _state == null
                ? 'Select a State first'
                : (_loadingDistricts ? 'Loading districts…' : 'Select District'),
            helperText: 'Select your District within the chosen State.',
            helperMaxLines: 2,
            errorText: _districtError,
            prefixIcon: const Icon(Icons.location_city_outlined, color: Color(0xFFBE123C)),
            suffixIcon: _loadingDistricts
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: Padding(padding: EdgeInsets.all(12), child: CircularProgressIndicator(strokeWidth: 2)),
                  )
                : null,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            filled: true,
            fillColor: Colors.white,
          ),
          items: _districts.map((d) => DropdownMenuItem(value: d, child: Text(d, overflow: TextOverflow.ellipsis))).toList(),
          onChanged: _state == null
              ? null
              : (v) {
                  setState(() {
                    _district = v;
                    _districtError = null;
                  });
                  _notify();
                },
        ),
        const SizedBox(height: 12),

        // 4. Full Address (Replacing City and Locality)
        TextFormField(
          key: const ValueKey('location_full_address_input'),
          controller: _fullAddressCtrl,
          textCapitalization: TextCapitalization.sentences,
          maxLines: 2,
          onChanged: (_) {
            if (_fullAddressError != null) setState(() => _fullAddressError = null);
            _notify();
          },
          decoration: InputDecoration(
            labelText: 'Full Address${widget.isRequired ? ' *' : ''}',
            hintText: 'House / Building no., Street / Road, Area, Landmark, Postal Code',
            helperText: 'Complete address including premises, street, landmark & postal code.',
            helperMaxLines: 2,
            errorText: _fullAddressError,
            prefixIcon: const Icon(Icons.home_work_outlined, color: Color(0xFFBE123C)),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            filled: true,
            fillColor: Colors.white,
          ),
        ),
      ],
    );
  }
}
