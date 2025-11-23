import 'dart:async';
import 'package:flutter/material.dart';
import '../models/theme_model.dart';
import '../models/device_config.dart';
import '../services/api_service.dart';
import '../widgets/theme_card.dart';
import '../widgets/status_indicator.dart';
import '../theme/app_theme.dart';
import 'theme_detail_screen.dart';
import 'settings_screen.dart';
import 'about_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late ApiService _apiService;
  DeviceConfig? _config;
  ConnectionStatus _connectionStatus = ConnectionStatus.disconnected;
  int? _activeThemeId;
  bool _isThemeActive = false;
  Timer? _statusTimer;

  @override
  void initState() {
    super.initState();
    _loadConfig();
  }

  @override
  void dispose() {
    _statusTimer?.cancel();
    super.dispose();
  }

  Future<void> _loadConfig() async {
    final config = await DeviceConfig.load();
    setState(() {
      _config = config;
      _apiService = ApiService(config);
    });

    if (config.autoConnect) {
      _startStatusPolling();
    }
  }

  void _startStatusPolling() {
    _statusTimer?.cancel();
    _updateStatus(); // Initial update
    
    _statusTimer = Timer.periodic(const Duration(seconds: 2), (timer) {
      _updateStatus();
    });
  }

  void _stopStatusPolling() {
    _statusTimer?.cancel();
  }

  Future<void> _updateStatus() async {
    if (_config == null) return;

    try {
      setState(() {
        if (_connectionStatus == ConnectionStatus.disconnected) {
          _connectionStatus = ConnectionStatus.connecting;
        }
      });

      final status = await _apiService.getStatus();
      
      setState(() {
        _connectionStatus = ConnectionStatus.connected;
        _activeThemeId = status.mode;
        _isThemeActive = status.active;
      });
    } catch (e) {
      setState(() {
        _connectionStatus = ConnectionStatus.disconnected;
        _isThemeActive = false;
      });
    }
  }

  Future<void> _backToMenu() async {
    try {
      final success = await _apiService.backToMenu();
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Returned to menu ✓'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
          ),
        );
        _updateStatus();
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  String _getCurrentThemeName() {
    if (!_isThemeActive || _activeThemeId == null) {
      return 'Main Menu';
    }
    return Themes.getById(_activeThemeId!).name;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: Theme.of(context).brightness == Brightness.light
              ? AppTheme.purpleGradient
              : AppTheme.darkGradient,
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Text(
                      'Theme Box Controller',
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 20),
                    
                    // Status Card
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 20,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'CURRENT STATUS',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Colors.white70,
                              letterSpacing: 1.2,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              StatusIndicator(status: _connectionStatus),
                              const Spacer(),
                              Text(
                                _getCurrentThemeName(),
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Theme Grid
              Expanded(
                child: RefreshIndicator(
                  onRefresh: _updateStatus,
                  child: GridView.builder(
                    padding: const EdgeInsets.all(20),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 15,
                      mainAxisSpacing: 15,
                      childAspectRatio: 0.85,
                    ),
                    itemCount: Themes.all.length,
                    itemBuilder: (context, index) {
                      final theme = Themes.all[index];
                      final isActive = _isThemeActive && _activeThemeId == theme.id;
                      
                      return ThemeCard(
                        theme: theme,
                        isActive: isActive,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ThemeDetailScreen(
                                theme: theme,
                                apiService: _apiService,
                                onThemeActivated: _updateStatus,
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ),

              // Bottom Navigation
              Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(20),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildNavButton(
                        icon: Icons.home,
                        label: 'Home',
                        isActive: true,
                        onTap: () {},
                      ),
                      _buildNavButton(
                        icon: Icons.settings,
                        label: 'Settings',
                        isActive: false,
                        onTap: () async {
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const SettingsScreen(),
                            ),
                          );
                          _loadConfig(); // Reload config after settings
                        },
                      ),
                      _buildNavButton(
                        icon: Icons.info_outline,
                        label: 'About',
                        isActive: false,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const AboutScreen(),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: _isThemeActive
          ? FloatingActionButton.extended(
              onPressed: _backToMenu,
              icon: const Icon(Icons.home),
              label: const Text('Back to Menu'),
              backgroundColor: Colors.white.withOpacity(0.2),
              foregroundColor: Colors.white,
            )
          : null,
    );
  }

  Widget _buildNavButton({
    required IconData icon,
    required String label,
    required bool isActive,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isActive ? Colors.white : Colors.white60,
              size: 28,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: isActive ? Colors.white : Colors.white60,
                fontSize: 12,
                fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
