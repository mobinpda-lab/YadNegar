import 'package:yadnegar/features/timeline/domain/timeline_item.dart';
import 'package:yadnegar/features/timeline/domain/yadnegar_project.dart';
import 'package:yadnegar/features/timeline/domain/yadnegar_taxonomy.dart';

class SearchTrackedSubjects {
  const SearchTrackedSubjects();

  List<TimelineItem> search({
    required List<TimelineItem> subjects,
    required Map<String, List<TimelineItem>> followUpsBySubject,
    required List<YadNegarProject> projects,
    required List<YadNegarCategory> categories,
    required List<YadNegarTag> tags,
    String query = '',
  }) {
    final tokens = PersianSearchText.tokenize(query);
    if (tokens.isEmpty) {
      return List<TimelineItem>.unmodifiable(subjects);
    }

    final projectsById = <String, YadNegarProject>{
      for (final project in projects) project.id: project,
    };
    final categoriesById = <String, YadNegarCategory>{
      for (final category in categories) category.id: category,
    };
    final tagsById = <String, YadNegarTag>{
      for (final tag in tags) tag.id: tag,
    };

    final matches = <TimelineItem>[];
    for (final subject in subjects) {
      final searchable = <String>[
        subject.text,
        if (subject.description != null) subject.description!,
        if (projectsById[subject.projectId] != null)
          projectsById[subject.projectId]!.title,
        if (categoriesById[subject.categoryId] != null)
          categoriesById[subject.categoryId]!.title,
        ...subject.tagIds
            .map((id) => tagsById[id]?.title)
            .whereType<String>(),
        ...(followUpsBySubject[subject.id] ?? const <TimelineItem>[])
            .map((followUp) => followUp.text),
      ].join(' ');

      final normalized = PersianSearchText.normalize(searchable);
      if (tokens.every(normalized.contains)) {
        matches.add(subject);
      }
    }

    return List<TimelineItem>.unmodifiable(matches);
  }
}

class PersianSearchText {
  const PersianSearchText._();

  static List<String> tokenize(String query) {
    final normalized = normalize(query);
    if (normalized.isEmpty) {
      return const <String>[];
    }
    return normalized
        .split(' ')
        .where((token) => token.isNotEmpty)
        .toSet()
        .toList(growable: false);
  }

  static String normalize(String value) {
    var text = value.toLowerCase();

    const aliases = <String, String>{
      'ي': 'ی',
      'ى': 'ی',
      'ك': 'ک',
      'تماس': 'تماس زنگ',
      'زنگ': 'تماس زنگ',
      'جلسه': 'جلسه ملاقات',
      'ملاقات': 'جلسه ملاقات',
      'پرداخت': 'پرداخت واریز',
      'واریز': 'پرداخت واریز',
    };
    for (final entry in aliases.entries) {
      text = text.replaceAll(entry.key, entry.value);
    }

    text = text
        .replaceAll(RegExp(r'[\u064B-\u065F\u0670]'), '')
        .replaceAll(RegExp(r'[\u200B-\u200D\uFEFF]'), ' ')
        .replaceAll('\u00A0', ' ')
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();

    return text;
  }
}
