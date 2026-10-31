import 'package:flutter/material.dart';

import '../services/api_client.dart';

/// Dynamic Location Selection: Country -> State -> District -> City
/// Supports cascading lookups, reverse location population, and map pin integration.
class DynamicLocationHierarchyPicker extends StatefulWidget {
  const DynamicLocationHierarchyPicker({
    super.key,
    required this.api,
    this.initialCountry = 'India',
    this.initialState,
    this.initialDistrict,
    this.initialCity,
    required this.onLocationChanged,
    this.isRequired = true,
  });

  final ApiClient api;
  final String initialCountry;
  final String? initialState;
  final String? initialDistrict;
  final String? initialCity;
  final void Function({
    required String country,
    required String state,
    required String district,
    required String city,
  }) onLocationChanged;
  final bool isRequired;

  @override
  State<DynamicLocationHierarchyPicker> createState() => DynamicLocationHierarchyPickerState();
}

class DynamicLocationHierarchyPickerState extends State<DynamicLocationHierarchyPicker> {
  static const _supportedCountries = ['India'];
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
  final _cityCtrl = TextEditingController();

  List<String> _states = [];
  List<String> _districts = [];
  List<String> _cities = [];

  bool _loadingStates = false;
  bool _loadingDistricts = false;
  bool _loadingCities = false;

  String? _stateError;
  String? _districtError;
  String? _cityError;

  @override
  void initState() {
    super.initState();
    _country = widget.initialCountry;
    _state = widget.initialState;
    _district = widget.initialDistrict;
    if (widget.initialCity != null) _cityCtrl.text = widget.initialCity!;
    _loadStates();
  }

  @override
  void dispose() {
    _cityCtrl.dispose();
    super.dispose();
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
      _cities = [];
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

    if (_district != null && _district!.isNotEmpty) {
      await _loadCities(state, _district!);
    }
  }

  Future<void> _loadCities(String state, String district) async {
    setState(() => _loadingCities = true);
    try {
      final res = await widget.api.get(
        '/api/locations/areas?state=${Uri.encodeComponent(state)}&city=${Uri.encodeComponent(district)}',
        auth: false,
      );
      if (res['success'] == true && res['areas'] is List) {
        final list = (res['areas'] as List).map((e) => e.toString()).toList();
        if (mounted) setState(() => _cities = list);
      }
    } catch (_) {
      // Graceful fallback
    } finally {
      if (mounted) setState(() => _loadingCities = false);
    }
  }

  void _notify() {
    widget.onLocationChanged(
      country: _country,
      state: _state ?? '',
      district: _district ?? '',
      city: _cityCtrl.text.trim(),
    );
  }

  /// Automatically resolves a city, address, or map location to State & District.
  Future<void> reverseLookup(String query) async {
    if (query.trim().isEmpty) return;
    try {
      final res = await widget.api.get(
        '/api/locations/lookup?query=${Uri.encodeComponent(query.trim())}',
        auth: false,
      );
      if (res['success'] == true && mounted) {
        final matchedState = res['state']?.toString();
        final matchedDist = res['district']?.toString();
        final matchedCity = res['city']?.toString();

        setState(() {
          if (matchedState != null && matchedState.isNotEmpty) {
            _state = matchedState;
          }
          if (matchedCity != null && matchedCity.isNotEmpty && _cityCtrl.text.isEmpty) {
            _cityCtrl.text = matchedCity;
          }
        });

        if (matchedState != null) {
          await _loadDistricts(matchedState, restoreDistrict: matchedDist);
        }
        _notify();
      }
    } catch (_) {
      // Non-blocking reverse lookup
    }
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

      if (widget.isRequired && _cityCtrl.text.trim().isEmpty) {
        _cityError = 'City or Locality is required';
        ok = false;
      } else {
        _cityError = null;
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
          value: _country,
          decoration: InputDecoration(
            labelText: 'Country${widget.isRequired ? ' *' : ''}',
            helperText: 'Select country of residence / practice.',
            helperMaxLines: 2,
            prefixIcon: const Icon(Icons.public_outlined, color: Color(0xFFBE123C)),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            filled: true,
            fillColor: Colors.white,
          ),
          items: _supportedCountries.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
          onChanged: (v) {
            if (v != null) {
              setState(() => _country = v);
              _notify();
            }
          },
        ),
        const SizedBox(height: 12),

        // 2. State Selection
        DropdownButtonFormField<String>(
          key: const ValueKey('location_state_dropdown'),
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
          items: _states.map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
          onChanged: (v) {
            setState(() {
              _state = v;
              _district = null;
              _cityCtrl.clear();
              _stateError = null;
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
          items: _districts.map((d) => DropdownMenuItem(value: d, child: Text(d))).toList(),
          onChanged: _state == null
              ? null
              : (v) {
                  setState(() {
                    _district = v;
                    _cityCtrl.clear();
                    _districtError = null;
                  });
                  if (v != null && _state != null) {
                    _loadCities(_state!, v);
                  }
                  _notify();
                },
        ),
        const SizedBox(height: 12),

        // 4. City / Locality Selection
        _cities.isNotEmpty
            ? DropdownButtonFormField<String>(
                key: const ValueKey('location_city_dropdown'),
                value: _cities.contains(_cityCtrl.text) ? _cityCtrl.text : null,
                decoration: InputDecoration(
                  labelText: 'City / Locality${widget.isRequired ? ' *' : ''}',
                  hintText: 'Select locality or city area',
                  helperText: 'Select or enter your City or Locality.',
                  helperMaxLines: 2,
                  errorText: _cityError,
                  prefixIcon: const Icon(Icons.place_outlined, color: Color(0xFFBE123C)),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  filled: true,
                  fillColor: Colors.white,
                ),
                items: [
                  ..._cities.map((c) => DropdownMenuItem(value: c, child: Text(c))),
                  const DropdownMenuItem(value: '_OTHER_', child: Text('+ Enter custom locality')),
                ],
                onChanged: (v) {
                  if (v == '_OTHER_') {
                    setState(() => _cities = []);
                  } else if (v != null) {
                    setState(() {
                      _cityCtrl.text = v;
                      _cityError = null;
                    });
                    _notify();
                  }
                },
              )
            : TextFormField(
                key: const ValueKey('location_city_text_input'),
                controller: _cityCtrl,
                textCapitalization: TextCapitalization.words,
                onChanged: (_) {
                  setState(() => _cityError = null);
                  _notify();
                },
                decoration: InputDecoration(
                  labelText: 'City / Locality${widget.isRequired ? ' *' : ''}',
                  hintText: 'e.g. Bengaluru, Koramangala',
                  helperText: 'Select or enter your City or Locality.',
                  helperMaxLines: 2,
                  errorText: _cityError,
                  prefixIcon: const Icon(Icons.place_outlined, color: Color(0xFFBE123C)),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  filled: true,
                  fillColor: Colors.white,
                ),
              ),
      ],
    );
  }
}
