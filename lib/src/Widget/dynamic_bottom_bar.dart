import 'package:flutter/material.dart';
import '../models/bar_item.dart';

class DynamicBottomBar extends StatelessWidget {
  /// List of navigation items
  final List<BottomBarItem> items;

  /// Currently selected index
  final int currentIndex;

  /// Callback when a destination is tapped
  final Function(int) onTap;

  /// Color of the selection indicator
  final Color? indicatorColor;

  /// Background color of the navigation bar
  final Color? backgroundColor;

  /// Elevation of the navigation bar
  final double? elevation;

  /// Height of the navigation bar
  final double? height;

  /// Label behavior for navigation destinations
  final NavigationDestinationLabelBehavior? labelBehavior;

  /// Animation duration for selection changes
  final Duration? animationDuration;

  /// Custom icon builder for more control over icons
  final Widget Function(BottomBarItem item, bool isSelected)? iconBuilder;

  /// Custom label builder for more control over labels
  final Widget Function(BottomBarItem item, bool isSelected)? labelBuilder;

  /// Text style for selected labels
  final TextStyle? selectedLabelStyle;

  /// Text style for unselected labels
  final TextStyle? unselectedLabelStyle;

  /// Color for selected icons (when using default icon builder)
  final Color? selectedIconColor;

  /// Color for unselected icons (when using default icon builder)
  final Color? unselectedIconColor;

  /// Size for icons
  final double? iconSize;

  /// Padding around the navigation bar
  final EdgeInsetsGeometry? margin;

  /// Shape of the navigation bar
  final ShapeBorder? shape;

  /// Whether to show tooltips on destinations
  final bool showTooltips;

  /// Custom tooltip builder
  final String Function(BottomBarItem item)? tooltipBuilder;

  /// Shadow color for the navigation bar
  final Color? shadowColor;

  /// Surface tint color for Material 3 theming
  final Color? surfaceTintColor;

  /// Overlay color for touch feedback
  final MaterialStateProperty<Color?>? overlayColor;

  /// Enable haptic feedback on tap
  final bool enableHapticFeedback;

  const DynamicBottomBar({
    Key? key,
    required this.items,
    required this.currentIndex,
    required this.onTap,

    // Visual customization
    this.indicatorColor,
    this.backgroundColor,
    this.elevation,
    this.height,
    this.shadowColor,
    this.surfaceTintColor,
    this.shape,
    this.margin,

    // Label customization
    this.labelBehavior,
    this.selectedLabelStyle,
    this.unselectedLabelStyle,
    this.labelBuilder,

    // Icon customization
    this.iconBuilder,
    this.selectedIconColor,
    this.unselectedIconColor,
    this.iconSize,

    // Interaction customization
    this.animationDuration,
    this.overlayColor,
    this.enableHapticFeedback = true,

    // Tooltip customization
    this.showTooltips = false,
    this.tooltipBuilder,
  }) : super(key: key);

  /// Default icon mapping for common icon names
  IconData _getIconData(String iconName, {bool isSelected = false}) {
    final baseIconMap = {
      'home': Icons.home_outlined,
      'task': Icons.assignment_outlined,
      'person': Icons.person_outline,
      'project': Icons.bar_chart_outlined,
      'notifications': Icons.notifications_outlined,
      'messages':Icons.message_outlined,
      'search': Icons.search_outlined,
      'settings': Icons.settings_outlined,
      'favorite': Icons.favorite_outline,
      'bookmark': Icons.bookmark_outline,
      'shopping': Icons.shopping_cart_outlined,
      'profile': Icons.account_circle_outlined,
      'calendar': Icons.calendar_today_outlined,
      'location': Icons.location_on_outlined,
      'camera': Icons.camera_alt_outlined,
      'photo': Icons.photo_outlined,
      'music': Icons.music_note_outlined,
      'video': Icons.video_collection_outlined,
    };

    return baseIconMap[iconName.toLowerCase()] ??
        (isSelected ? Icons.help : Icons.help_outline);
  }

  /// Build default icon widget
  Widget _buildDefaultIcon(BottomBarItem item, bool isSelected) {
    return Icon(
      _getIconData(item.iconName, isSelected: isSelected),
      size: iconSize,
      color: isSelected ? selectedIconColor : unselectedIconColor,
    );
  }

  /// Build default label widget
  Widget _buildDefaultLabel(BottomBarItem item, bool isSelected) {
    return Text(
      item.title,
      style: isSelected ? selectedLabelStyle : unselectedLabelStyle,
    );
  }

  /// Build tooltip text
  String _buildTooltip(BottomBarItem item) {
    return tooltipBuilder?.call(item) ?? item.title;
  }

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return const SizedBox.shrink();
    }

    final theme = Theme.of(context);
    final navigationBarTheme = theme.navigationBarTheme;

    Widget navigationBar = NavigationBar(
      selectedIndex: currentIndex.clamp(0, items.length - 1),
      onDestinationSelected: (index) {
        if (enableHapticFeedback) {
          // Add haptic feedback if available
          try {
            // This would require adding haptic_feedback package dependency
            // HapticFeedback.selectionClick();
          } catch (e) {
            // Silently fail if haptic feedback is not available
          }
        }
        onTap(index);
      },

      // Visual properties
      indicatorColor: indicatorColor ?? Colors.amber,
      backgroundColor: backgroundColor ?? navigationBarTheme.backgroundColor,
      elevation: elevation ?? navigationBarTheme.elevation,
      height: height,
      shadowColor: shadowColor ?? navigationBarTheme.shadowColor,
      surfaceTintColor: surfaceTintColor ?? navigationBarTheme.surfaceTintColor,

      // Behavior
      labelBehavior: labelBehavior ??
          navigationBarTheme.labelBehavior ??
          NavigationDestinationLabelBehavior.alwaysShow,

      // Animation
      animationDuration: animationDuration,

      // Overlay color for touch feedback
      overlayColor: overlayColor,

      destinations: items.asMap().entries.map((entry) {
        final index = entry.key;
        final item = entry.value;
        final isSelected = index == currentIndex;

        // Build icon
        final iconWidget = iconBuilder?.call(item, isSelected) ??
            _buildDefaultIcon(item, isSelected);

        final selectedIconWidget = iconBuilder?.call(item, true) ??
            _buildDefaultIcon(item, true);

        // Build label
        final labelWidget = labelBuilder?.call(item, isSelected);

        NavigationDestination destination = NavigationDestination(
          selectedIcon: selectedIconWidget,
          icon: iconWidget,
          label: labelWidget?.toString() ?? item.title,
          tooltip: showTooltips ? _buildTooltip(item) : null,
        );

        return destination;
      }).toList(),
    );

    // Apply margin if specified
    if (margin != null) {
      navigationBar = Padding(
        padding: margin!,
        child: navigationBar,
      );
    }

    // Apply custom shape if specified
    if (shape != null) {
      navigationBar = Material(
        shape: shape,
        child: navigationBar,
      );
    }

    return navigationBar;
  }
}

/// Extension to add convenience methods for common configurations
extension DynamicBottomBarStyles on DynamicBottomBar {
  /// Create a minimal style navigation bar
  static DynamicBottomBar minimal({
    required List<BottomBarItem> items,
    required int currentIndex,
    required Function(int) onTap,
    Color? indicatorColor,
  }) {
    return DynamicBottomBar(
      items: items,
      currentIndex: currentIndex,
      onTap: onTap,
      indicatorColor: indicatorColor ?? Colors.transparent,
      labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
      elevation: 0,
    );
  }

  /// Create a floating style navigation bar
  static DynamicBottomBar floating({
    required List<BottomBarItem> items,
    required int currentIndex,
    required Function(int) onTap,
    Color? backgroundColor,
    Color? indicatorColor,
  }) {
    return DynamicBottomBar(
      items: items,
      currentIndex: currentIndex,
      onTap: onTap,
      backgroundColor: backgroundColor ?? Colors.white,
      indicatorColor: indicatorColor ?? Colors.blue,
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      margin: const EdgeInsets.all(16),
    );
  }
}

/// Predefined themes for quick setup
class DynamicBottomBarThemes {
  static const DynamicBottomBarTheme material3Light = DynamicBottomBarTheme(
    indicatorColor: Colors.amber,
    backgroundColor: Colors.white,
    selectedIconColor: Colors.black87,
    unselectedIconColor: Colors.black54,
    elevation: 3,
  );

  static const DynamicBottomBarTheme material3Dark = DynamicBottomBarTheme(
    indicatorColor: Colors.amber,
    backgroundColor: Color(0xFF1C1B1F),
    selectedIconColor: Colors.white,
    unselectedIconColor: Colors.white60,
    elevation: 3,
  );

  static const DynamicBottomBarTheme cupertino = DynamicBottomBarTheme(
    indicatorColor: Colors.transparent,
    backgroundColor: Color(0xFFF9F9F9),
    selectedIconColor: Colors.blue,
    unselectedIconColor: Colors.grey,
    elevation: 0,
    labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
  );
}

/// Theme data class for consistent styling
class DynamicBottomBarTheme {
  final Color? indicatorColor;
  final Color? backgroundColor;
  final Color? selectedIconColor;
  final Color? unselectedIconColor;
  final double? elevation;
  final NavigationDestinationLabelBehavior? labelBehavior;
  final TextStyle? selectedLabelStyle;
  final TextStyle? unselectedLabelStyle;

  const DynamicBottomBarTheme({
    this.indicatorColor,
    this.backgroundColor,
    this.selectedIconColor,
    this.unselectedIconColor,
    this.elevation,
    this.labelBehavior,
    this.selectedLabelStyle,
    this.unselectedLabelStyle,
  });

  /// Apply this theme to a DynamicBottomBar
  DynamicBottomBar apply({
    required List<BottomBarItem> items,
    required int currentIndex,
    required Function(int) onTap,
  }) {
    return DynamicBottomBar(
      items: items,
      currentIndex: currentIndex,
      onTap: onTap,
      indicatorColor: indicatorColor,
      backgroundColor: backgroundColor,
      selectedIconColor: selectedIconColor,
      unselectedIconColor: unselectedIconColor,
      elevation: elevation,
      labelBehavior: labelBehavior,
      selectedLabelStyle: selectedLabelStyle,
      unselectedLabelStyle: unselectedLabelStyle,
    );
  }
}