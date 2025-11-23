import 'package:flutter/material.dart';
import '../models/device_config.dart';
import '../services/api_service.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final _formKey = GlobalKey<FormState>();
  final _ipController = TextEditingController();
  final _portController = TextEditingController();
  
  bool _autoConnect = true;
  bool _isTestingConnection = false;
  String? _connectionTestResult;
  bool? _connectionTestSuccess;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  @override
  void dispose() {
    _ipController.dispose();
    _portController.dispose();
    super.dispose();
  }

  Future<void> _loadSettings() async {
    final config = await DeviceConfig.load();
    setState(() {
      _ipController.text = config.ipAddress;
      _portController.text = config.port.toString();
      _autoConnect = config.autoConnect;
    });
  }

  Future<void> _saveSettings() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final config = DeviceConfig(
      ipAddress: _ipController.text.trim(),
      port: int.parse(_portController.text),
      autoConnect: _autoConnect,
      lastConnected: DateTime.now(),
    );

    await config.save();

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Settings saved ✓'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        ),
      );
      Navigator.pop(context);
    }
  }

  Future<void> _testConnection() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isTestingConnection = true;
      _connectionTestResult = null;
      _connectionTestSuccess = null;
    });

    try {
      final config = DeviceConfig(
        ipAddress: _ipController.text.trim(),
        port: int.parse(_portController.text),
      );
      
      final apiService = ApiService(config);
      final success = await apiService.testConnection();

      setState(() {
        _connectionTestSuccess = success;
        _connectionTestResult = success 
            ? 'Connected successfully ✓' 
            : 'Connection failed ✗';
      });
    } catch (e) {
      setState(() {
        _connectionTestSuccess = false;
        _connectionTestResult = 'Error: ${e.toString()}';
      });
    } finally {
      setState(() {
        _isTestingConnection = false;
      });
    }
  }

  String? _validateIpAddress(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter an IP address';
    }

    final parts = value.split('.');
    if (parts.length != 4) {
      return 'Invalid IP format';
    }

    for (final part in parts) {
      final num = int.tryParse(part);
      if (num == null || num < 0 || num > 255) {
        return 'Invalid IP address';
      }
    }

    return null;
  }

  String? _validatePort(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a port';
    }

    final port = int.tryParse(value);
    if (port == null || port < 1 || port > 65535) {
      return 'Port must be between 1 and 65535';
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Device Configuration Section
              const Text(
                'Device Configuration',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 16),

              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      // IP Address Field
                      TextFormField(
                        controller: _ipController,
                        decoration: const InputDecoration(
                          labelText: 'ESP8266 IP Address',
                          hintText: '192.168.4.1',
                          prefixIcon: Icon(Icons.wifi),
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.number,
                        validator: _validateIpAddress,
                      ),
                      
                      const SizedBox(height: 16),

                      // Port Field
                      TextFormField(
                        controller: _portController,
                        decoration: const InputDecoration(
                          labelText: 'Port',
                          hintText: '80',
                          prefixIcon: Icon(Icons.settings_ethernet),
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.number,
                        validator: _validatePort,
                      ),

                      const SizedBox(height: 16),

                      // Test Connection Button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: _isTestingConnection ? null : _testConnection,
                          icon: _isTestingConnection
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : const Icon(Icons.wifi_find),
                          label: Text(
                            _isTestingConnection 
                                ? 'Testing...' 
                                : 'Test Connection',
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            foregroundColor: Colors.white,
                          ),
                        ),
                      ),

                      // Connection Test Result
                      if (_connectionTestResult != null) ...[
                        const SizedBox(height: 12),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: _connectionTestSuccess == true
                                ? Colors.green.withOpacity(0.1)
                                : Colors.red.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: _connectionTestSuccess == true
                                  ? Colors.green
                                  : Colors.red,
                            ),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                _connectionTestSuccess == true
                                    ? Icons.check_circle
                                    : Icons.error,
                                color: _connectionTestSuccess == true
                                    ? Colors.green
                                    : Colors.red,
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  _connectionTestResult!,
                                  style: TextStyle(
                                    color: _connectionTestSuccess == true
                                        ? Colors.green
                                        : Colors.red,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 30),

              // Preferences Section
              const Text(
                'Preferences',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 16),

              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      // Auto-connect Toggle
                      SwitchListTile(
                        title: const Text('Auto-connect on app start'),
                        subtitle: const Text(
                          'Automatically connect to Theme Box when app opens',
                        ),
                        value: _autoConnect,
                        onChanged: (value) {
                          setState(() {
                            _autoConnect = value;
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 30),

              // Save Button
              SizedBox(
                width: double.infinity,
                height: 60,
                child: ElevatedButton(
                  onPressed: _saveSettings,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF667EEA),
                    foregroundColor: Colors.white,
                  ),
                  child: const Text(
                    'Save Settings',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
