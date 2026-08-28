class YadNegarProject {
  const YadNegarProject({
    required this.id,
    required this.title,
    required this.colorValue,
  });

  final String id;
  final String title;
  final int colorValue;

  YadNegarProject copyWith({
    String? title,
    int? colorValue,
  }) {
    return YadNegarProject(
      id: id,
      title: title ?? this.title,
      colorValue: colorValue ?? this.colorValue,
    );
  }
}
