import 'package:flutter/material.dart';
import '../models/theme_model.dart';
import '../services/api_service.dart';
import '../theme/app_theme.dart';

class ThemeDetailScreen extends StatefulWidget {
  final ThemeModel theme;
  final ApiService apiService;
  final VoidCallback onThemeActivated;

  const ThemeDetailScreen({
    Key? key,
    required this.theme,
    required this.apiService,
    required this.onThemeActivated,
  }) : super(key: key);

  @override
  State<ThemeDetailScreen> createState() => _ThemeDetailScreenState();
}

class _ThemeDetailScreenState extends State<ThemeDetailScreen> {
  late double _brightness;
  late double _volume;
  late double _speed;
  bool _isActivating = false;

  @override
  void initState() {
    super.initState();
    _brightness = widget.theme.defaultSettings.brightness.toDouble();
    _volume = widget.theme.defaultSettings.volume.toDouble();
    _speed = widget.theme.defaultSettings.animationSpeed.toDouble();
  }

  Future<void> _activateTheme() async {
    setState(() {
      _isActivating = true;
    });

    try {
      final success = await widget.apiService.activateTheme(
        widget.theme.id,
        brightness: _brightness.toInt(),
        volume: _volume.toInt(),
        speed: _speed.toInt(),
      );

      if (success) {
        widget.onThemeActivated();
        
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('${widget.theme.name} activated ✓'),
              backgroundColor: Colors.green,
              duration: const Duration(seconds: 2),
            ),
          );
          
          // Navigate back after short delay
          await Future.delayed(const Duration(milliseconds: 500));
          if (mounted) {
            Navigator.pop(context);
          }
        }
      } else {
        throw Exception('Failed to activate theme');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Connection failed: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isActivating = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final accentColor = AppTheme.fromHex(widget.theme.accentColor);
    
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.theme.name),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Theme Icon and Info
            Container(
              padding: const EdgeInsets.all(30),
              decoration: BoxDecoration(
                color: accentColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  Text(
                    widget.theme.icon,
                    style: const TextStyle(fontSize: 80),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    widget.theme.name,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.theme.description,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 30),

            // Brightness Slider
            _buildSlider(
              label: 'Brightness',
              icon: Icons.wb_sunny,
              value: _brightness,
              color: accentColor,
              onChanged: (value) {
                setState(() {
                  _brightness = value;
                });
              },
            ),

            const SizedBox(height: 20),

            // Volume Slider
            _buildSlider(
              label: 'Sound Level',
              icon: Icons.volume_up,
              value: _volume,
              color: accentColor,
              onChanged: (value) {
                setState(() {
                  _volume = value;
                });
              },
            ),

            const SizedBox(height: 20),

            // Animation Speed Slider
            _buildSlider(
              label: 'Animation Speed',
              icon: Icons.speed,
              value: _speed,
              color: accentColor,
              onChanged: (value) {
                setState(() {
                  _speed = value;
                });
              },
            ),

            const SizedBox(height: 40),

            // Activate Button
            SizedBox(
              width: double.infinity,
              height: 60,
              child: ElevatedButton(
                onPressed: _isActivating ? null : _activateTheme,
                style: ElevatedButton.styleFrom(
                  backgroundColor: accentColor,
                  foregroundColor: Colors.white,
                  disabledBackgroundColor: accentColor.withOpacity(0.5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                child: _isActivating
                    ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : const Text(
                        'Activate Theme',
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
    );
  }

  Widget _buildSlider({
    required String label,
    required IconData icon,
    required double value,
    required Color color,
    required ValueChanged<double> onChanged,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: color),
                const SizedBox(width: 12),
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                Text(
                  '${value.toInt()}%',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: color,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            SliderTheme(
              data: SliderThemeData(
                activeTrackColor: color,
                thumbColor: color,
                inactiveTrackColor: color.withOpacity(0.3),
                overlayColor: color.withOpacity(0.2),
              ),
              child: Slider(
                value: value,
                min: 0,
                max: 100,
                divisions: 100,
                onChanged: onChanged,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
