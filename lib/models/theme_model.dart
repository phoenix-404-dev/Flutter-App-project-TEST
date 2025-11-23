class ThemeModel {
  final int id;
  final String name;
  final String icon;
  final String description;
  final String accentColor;
  final ThemeSettings defaultSettings;

  ThemeModel({
    required this.id,
    required this.name,
    required this.icon,
    required this.description,
    required this.accentColor,
    required this.defaultSettings,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'icon': icon,
      'description': description,
      'accentColor': accentColor,
      'defaultSettings': defaultSettings.toJson(),
    };
  }

  factory ThemeModel.fromJson(Map<String, dynamic> json) {
    return ThemeModel(
      id: json['id'],
      name: json['name'],
      icon: json['icon'],
      description: json['description'],
      accentColor: json['accentColor'],
      defaultSettings: ThemeSettings.fromJson(json['defaultSettings']),
    );
  }
}

class ThemeSettings {
  final int brightness;
  final int volume;
  final int animationSpeed;

  ThemeSettings({
    required this.brightness,
    required this.volume,
    required this.animationSpeed,
  });

  Map<String, dynamic> toJson() {
    return {
      'brightness': brightness,
      'volume': volume,
      'animationSpeed': animationSpeed,
    };
  }

  factory ThemeSettings.fromJson(Map<String, dynamic> json) {
    return ThemeSettings(
      brightness: json['brightness'],
      volume: json['volume'],
      animationSpeed: json['animationSpeed'],
    );
  }

  ThemeSettings copyWith({
    int? brightness,
    int? volume,
    int? animationSpeed,
  }) {
    return ThemeSettings(
      brightness: brightness ?? this.brightness,
      volume: volume ?? this.volume,
      animationSpeed: animationSpeed ?? this.animationSpeed,
    );
  }
}

// Predefined themes
class Themes {
  static final List<ThemeModel> all = [
    ThemeModel(
      id: 0,
      name: 'Forest Mode',
      icon: '🌲',
      description: 'Peaceful nature sounds with green ambient lighting and bird chirps',
      accentColor: '#4CAF50',
      defaultSettings: ThemeSettings(
        brightness: 80,
        volume: 60,
        animationSpeed: 50,
      ),
    ),
    ThemeModel(
      id: 1,
      name: 'Christmas Mode',
      icon: '🎄',
      description: 'Festive joyful melodies with red twinkling lights',
      accentColor: '#F44336',
      defaultSettings: ThemeSettings(
        brightness: 85,
        volume: 70,
        animationSpeed: 60,
      ),
    ),
    ThemeModel(
      id: 2,
      name: 'Campfire Mode',
      icon: '🔥',
      description: 'Crackling fire ambience with warm orange glow',
      accentColor: '#FF9800',
      defaultSettings: ThemeSettings(
        brightness: 75,
        volume: 55,
        animationSpeed: 40,
      ),
    ),
  ];

  static ThemeModel getById(int id) {
    return all.firstWhere((theme) => theme.id == id);
  }
}
