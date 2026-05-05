import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:io';
import 'package:flutter_baidu_mapapi_map/flutter_baidu_mapapi_map.dart';
import 'package:flutter_baidu_mapapi_base/flutter_baidu_mapapi_base.dart';
import 'package:flutter_baidu_mapapi_search/flutter_baidu_mapapi_search.dart';
import 'package:flutter_bmflocation/flutter_bmflocation.dart';
import 'package:permission_handler/permission_handler.dart';

class LocationSelectPage extends StatefulWidget {
  const LocationSelectPage({super.key});

  @override
  State<LocationSelectPage> createState() => _LocationSelectPageState();
}

class _LocationSelectPageState extends State<LocationSelectPage> {
  BMFMapController? _mapController;
  BMFCoordinate? _selectedPosition;
  String _address = '正在获取位置...';
  String _locationName = '';
  bool _isLoading = true;
  final LocationFlutterPlugin _locationPlugin = LocationFlutterPlugin();

  @override
  void initState() {
    super.initState();
    BMFMapSDK.setAgreePrivacy(true);
    _initLocation();
  }

  Future<void> _initLocation() async {
    final hasPermission = await _checkPermissions();
    if (!hasPermission) {
      setState(() => _isLoading = false);
      return;
    }

    if (Platform.isAndroid) {
      _locationPlugin.seriesLocationCallback(
        callback: (BaiduLocation result) {
          if (result.locType != null && result.locType! > 0) {
            final coord = BMFCoordinate(result.latitude!, result.longitude!);
            _handleLocationUpdate(coord, result);
          }
        },
      );
    } else if (Platform.isIOS) {
      _locationPlugin.singleLocationCallback(
        callback: (BaiduLocation result) {
          if (result.locType != null && result.locType! > 0) {
            final coord = BMFCoordinate(result.latitude!, result.longitude!);
            _handleLocationUpdate(coord, result);
          }
        },
      );
    }

    await _prepareLocation();

    try {
      if (Platform.isIOS) {
        await _locationPlugin.singleLocation({
          'isReGeocode': true,
          'isNetworkState': true,
        });
      } else if (Platform.isAndroid) {
        await _locationPlugin.stopLocation();
        await _locationPlugin.startLocation();
      }
    } catch (e) {
      debugPrint('定位失败：$e');
    }

    if (mounted) {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _prepareLocation() async {
    try {
      final androidOptions = BaiduLocationAndroidOption(
        coordType: BMFLocationCoordType.bd09ll,
        isNeedAddress: true,
        isNeedLocationPoiList: false,
        isNeedNewVersionRgc: true,
        openGps: true,
        locationPurpose: BMFLocationPurpose.signIn,
      );

      final iosOptions = BaiduLocationIOSOption(
        coordType: BMFLocationCoordType.bd09ll,
        locationTimeout: 15,
        reGeocodeTimeout: 15,
        desiredAccuracy: BMFDesiredAccuracy.best,
        distanceFilter: 3.0,
      );

      await _locationPlugin.prepareLoc(
        androidOptions.getMap(),
        iosOptions.getMap(),
      );
    } catch (e) {
      debugPrint('配置定位参数失败：$e');
    }
  }

  void _handleLocationUpdate(BMFCoordinate coordinate, BaiduLocation location) {
    if (_selectedPosition == null) {
      setState(() {
        _selectedPosition = coordinate;
        _address = location.address ?? '未知位置';
        _locationName = _address;
      });

      if (_mapController != null) {
        _updateMarker(coordinate);
        _moveToPosition(coordinate);
      }
    }
  }

  Future<bool> _checkPermissions() async {
    var status = await Permission.location.status;

    if (status.isDenied) {
      await Permission.location.request();
      status = await Permission.location.status;
    }

    if (status.isPermanentlyDenied) {
      setState(() => _address = '定位权限被拒绝');
      return false;
    }

    return status.isGranted || PermissionStatus.limited == status;
  }

  Future<void> _updateMarker(BMFCoordinate position) async {
    if (_mapController == null) return;

    await _mapController!.cleanAllMarkers();

    final marker = BMFMarker.icon(
      position: position,
      icon: 'images/placeholder.png',
      title: '当前位置',
      scaleX: 0.3,
      scaleY: 0.3,
    );
    await _mapController!.addMarker(marker);
  }

  void _moveToPosition(BMFCoordinate position) {
    if (_mapController == null) return;
    _mapController!.setCenterCoordinate(position, true, animateDurationMs: 500);
    _mapController!.setZoomTo(18.0, animateDurationMs: 500);
  }

  Future<void> _getAddressFromCoordinate(BMFCoordinate coordinate) async {
    try {
      final option = BMFReverseGeoCodeSearchOption(location: coordinate);
      final search = BMFReverseGeoCodeSearch();
      final completer = Completer<void>();

      search.onGetReverseGeoCodeSearchResult(
        callback:
            (
              BMFReverseGeoCodeSearchResult? result,
              BMFSearchErrorCode errorCode,
            ) {
              if (result != null) {
                final address = result.address ?? '未知位置';
                final poiName = result.poiList?.isNotEmpty == true
                    ? result.poiList!.first.name
                    : address;
                setState(() {
                  _address = address;
                  _locationName = poiName ?? address;
                });
              }
              completer.complete();
            },
      );

      await search.reverseGeoCodeSearch(option);
      await completer.future;
    } catch (e) {
      debugPrint('逆地理编码失败：$e');
    }
  }

  void _onMapTap(BMFCoordinate coordinate) async {
    if (_mapController == null) return;

    setState(() {
      _selectedPosition = coordinate;
      _address = '正在获取地址...';
      _locationName = '';
    });

    await _updateMarker(coordinate);
    await _getAddressFromCoordinate(coordinate);
  }

  void _sendLocation() {
    if (_selectedPosition == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('请先选择位置')));
      return;
    }

    Navigator.of(context).pop({
      'latitude': _selectedPosition!.latitude.toString(),
      'longitude': _selectedPosition!.longitude.toString(),
      'address': _address,
      'name': _locationName.isNotEmpty ? _locationName : _address,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('选择位置'),
        actions: [
          TextButton(
            onPressed: _sendLocation,
            child: const Text('发送', style: TextStyle(fontSize: 16)),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : BMFMapWidget(
                    onBMFMapCreated: (controller) {
                      _mapController = controller;
                      if (_selectedPosition != null) {
                        _updateMarker(_selectedPosition!);
                        _moveToPosition(_selectedPosition!);
                      }
                      _mapController!.setMapOnClickedMapBlankCallback(
                        callback: (coordinate) => _onMapTap(coordinate),
                      );
                    },
                    mapOptions: BMFMapOptions(
                      center:
                          _selectedPosition ?? BMFCoordinate(39.9042, 116.4074),
                      zoomLevel: 18,
                      mapType: BMFMapType.Standard,
                    ),
                  ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 4,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _locationName.isNotEmpty ? _locationName : _address,
                  style: Theme.of(context).textTheme.titleMedium,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  _address,
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall?.copyWith(color: Colors.grey),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _mapController?.cleanAllMarkers();
    super.dispose();
  }
}
