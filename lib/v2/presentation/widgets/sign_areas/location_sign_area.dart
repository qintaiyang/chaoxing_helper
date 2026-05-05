import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../controllers/sign_in_controller.dart';

class LocationSignArea extends StatefulWidget {
  final SignInController controller;
  final String courseId;
  final String activeId;
  final String classId;
  final String cpi;

  const LocationSignArea({
    super.key,
    required this.controller,
    required this.courseId,
    required this.activeId,
    required this.classId,
    required this.cpi,
  });

  @override
  State<LocationSignArea> createState() => _LocationSignAreaState();
}

class _LocationSignAreaState extends State<LocationSignArea> {
  bool _isSelecting = false;
  String? _currentAddress;
  double? _currentLatitude;
  double? _currentLongitude;

  Future<void> _requestLocationPermission() async {
    final status = await Permission.location.request();

    if (!mounted) return;

    if (status.isDenied) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('需要位置权限才能选择位置')));
    } else if (status.isPermanentlyDenied) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('位置权限已被永久拒绝，请在设置中开启'),
          action: SnackBarAction(label: '去设置', onPressed: openAppSettings),
        ),
      );
    }
  }

  Future<void> _selectLocation() async {
    final hasPermission = await Permission.location.isGranted;
    if (!hasPermission) {
      await _requestLocationPermission();
      final granted = await Permission.location.isGranted;
      if (!granted || !mounted) return;
    }

    if (!mounted) return;
    setState(() => _isSelecting = true);

    final navigator = GoRouter.of(context);
    final result = await navigator.push<Map<String, String>>(
      '/location_select',
    );

    if (!mounted) return;

    setState(() => _isSelecting = false);

    if (result != null) {
      final latitude = double.tryParse(result['latitude'] ?? '');
      final longitude = double.tryParse(result['longitude'] ?? '');

      if (latitude != null && longitude != null) {
        final address = result['address'] ?? '未知位置';
        setState(() {
          _currentLatitude = latitude;
          _currentLongitude = longitude;
          _currentAddress = address;
        });

        widget.controller.setLocation(
          address: address,
          latitude: latitude,
          longitude: longitude,
        );
      }
    }
  }

  void _performSign() {
    if (_currentLatitude == null || _currentLongitude == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('请先选择位置')));
      return;
    }

    widget.controller.performMultiSign(
      courseId: widget.courseId,
      activeId: widget.activeId,
      classId: widget.classId,
      cpi: widget.cpi,
      address: _currentAddress,
      latitude: _currentLatitude,
      longitude: _currentLongitude,
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = widget.controller.currentState;
    final locationRange = state.locationRange;
    final designatedPlace = state.designatedPlace;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (designatedPlace != null || locationRange != null) ...[
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Theme.of(
                    context,
                  ).colorScheme.primaryContainer.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (designatedPlace != null) ...[
                      Row(
                        children: [
                          Icon(
                            Icons.place,
                            color: Theme.of(context).colorScheme.primary,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              '指定地点: $designatedPlace',
                              style: const TextStyle(
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                    ],
                    if (locationRange != null)
                      Text(
                        '范围: $locationRange 米',
                        style: TextStyle(color: Colors.grey[700]),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
            ],
            if (_currentAddress != null)
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.green.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.check_circle,
                      color: Colors.green,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        _currentAddress!,
                        style: const TextStyle(
                          color: Colors.green,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.refresh, size: 20),
                      onPressed: _isSelecting ? null : _selectLocation,
                      tooltip: '重新选择',
                    ),
                  ],
                ),
              ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _isSelecting ? null : _selectLocation,
                    icon: _isSelecting
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.white,
                              ),
                            ),
                          )
                        : const Icon(Icons.map),
                    label: Text(_isSelecting ? '选择中...' : '选择位置'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _currentLatitude != null && !_isSelecting
                        ? _performSign
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: const Text(
                      '立即签到',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
