import 'package:shared_preferences/shared_preferences.dart';

class DeviceConfig {
  final String ipAddress;
  final int port;
  final bool autoConnect;
  final DateTime? lastConnected;

  DeviceConfig({
    required this.ipAddress,
    this.port = 80,
    this.autoConnect = true,
    this.lastConnected,
  });

  String get baseUrl => 'http://$ipAddress:$port';

  Map<String, dynamic> toJson() {
    return {
      'ipAddress': ipAddress,
      'port': port,
      'autoConnect': autoConnect,
      'lastConnected': lastConnected?.toIso8601String(),
    };
  }

  factory DeviceConfig.fromJson(Map<String, dynamic> json) {
    return DeviceConfig(
      ipAddress: json['ipAddress'],
      port: json['port'] ?? 80,
      autoConnect: json['autoConnect'] ?? true,
      lastConnected: json['lastConnected'] != null
          ? DateTime.parse(json['lastConnected'])
          : null,
    );
  }

  DeviceConfig copyWith({
    String? ipAddress,
    int? port,
    bool? autoConnect,
    DateTime? lastConnected,
  }) {
    return DeviceConfig(
      ipAddress: ipAddress ?? this.ipAddress,
      port: port ?? this.port,
      autoConnect: autoConnect ?? this.autoConnect,
      lastConnected: lastConnected ?? this.lastConnected,
    );
  }

  // Save to SharedPreferences
  Future<void> save() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('ipAddress', ipAddress);
    await prefs.setInt('port', port);
    await prefs.setBool('autoConnect', autoConnect);
    if (lastConnected != null) {
      await prefs.setString('lastConnected', lastConnected!.toIso8601String());
    }
  }

  // Load from SharedPreferences
  static Future<DeviceConfig> load() async {
    final prefs = await SharedPreferences.getInstance();
    return DeviceConfig(
      ipAddress: prefs.getString('ipAddress') ?? '192.168.4.1',
      port: prefs.getInt('port') ?? 80,
      autoConnect: prefs.getBool('autoConnect') ?? true,
      lastConnected: prefs.getString('lastConnected') != null
          ? DateTime.parse(prefs.getString('lastConnected')!)
          : null,
    );
  }

  // Clear saved config
  static Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('ipAddress');
    await prefs.remove('port');
    await prefs.remove('autoConnect');
    await prefs.remove('lastConnected');
  }
}

class DeviceStatus {
  final int mode;
  final bool active;

  DeviceStatus({
    required this.mode,
    required this.active,
  });

  factory DeviceStatus.fromJson(Map<String, dynamic> json) {
    return DeviceStatus(
      mode: json['mode'],
      active: json['active'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'mode': mode,
      'active': active,
    };
  }
}
