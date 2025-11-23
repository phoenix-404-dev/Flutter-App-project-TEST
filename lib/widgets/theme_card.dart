import 'package:flutter/material.dart';
import '../models/theme_model.dart';
import '../theme/app_theme.dart';

class ThemeCard extends StatelessWidget {
  final ThemeModel theme;
  final bool isActive;
  final VoidCallback onTap;

  const ThemeCard({
    Key? key,
    required this.theme,
    required this.isActive,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final accentColor = AppTheme.fromHex(theme.accentColor);
    
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isActive ? accentColor : Colors.transparent,
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: isActive 
                  ? accentColor.withOpacity(0.3)
                  : Colors.black.withOpacity(0.1),
              blurRadius: isActive ? 12 : 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Card(
          elevation: 0,
          margin: EdgeInsets.zero,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Theme icon
                Text(
                  theme.icon,
                  style: const TextStyle(fontSize: 48),
                ),
                const SizedBox(height: 12),
                
                // Theme name
                Text(
                  theme.name,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 6),
                
                // Short description
                Text(
                  theme.description,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey[600],
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
