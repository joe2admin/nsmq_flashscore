import 'dart:math';

/// Provides a unique and consistent device identifier for user interactions
/// (favorites, likes, retweets, bookmarks, poll voting) with the Laravel backend.
class DeviceService {
  static String? _cachedDeviceId;

  /// Retrieves the current device UUID or generates one if not yet initialized.
  static String get deviceId {
    if (_cachedDeviceId != null) return _cachedDeviceId!;

    // Generate standard v4-style UUID: xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx
    final random = Random();
    final bytes = List<int>.generate(16, (_) => random.nextInt(256));

    // Version 4
    bytes[6] = (bytes[6] & 0x0f) | 0x40;
    // Variant 1
    bytes[8] = (bytes[8] & 0x3f) | 0x80;

    final hex = bytes.map((b) => b.toRadixString(16).padLeft(2, '0')).join();
    _cachedDeviceId = '${hex.substring(0, 8)}-${hex.substring(8, 12)}-${hex.substring(12, 16)}-${hex.substring(16, 20)}-${hex.substring(20, 32)}';

    return _cachedDeviceId!;
  }

  /// Override the device ID (e.g. for testing or fixed profile)
  static void setDeviceId(String id) {
    _cachedDeviceId = id;
  }
}
