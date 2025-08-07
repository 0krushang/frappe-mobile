class BottomBarItem {
  final String title;
  final String iconName;
  final String route;
  final int order;

  BottomBarItem({
    required this.title,
    required this.iconName,
    required this.route,
    required this.order,
  });

  factory BottomBarItem.fromJson(Map<String, dynamic> json) {
    return BottomBarItem(
      title: json['title'] ?? '',
      iconName: json['icon'] ?? '',
      route: json['route'] ?? '',
      order: json['order'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'icon_name': iconName,
      'route': route,
      'order': order,
    };
  }
}