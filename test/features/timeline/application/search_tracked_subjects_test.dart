import 'package:flutter_test/flutter_test.dart';
import 'package:yadnegar/features/timeline/application/search_tracked_subjects.dart';
import 'package:yadnegar/features/timeline/domain/timeline_item.dart';
import 'package:yadnegar/features/timeline/domain/yadnegar_project.dart';
import 'package:yadnegar/features/timeline/domain/yadnegar_taxonomy.dart';

void main() {
  final subject = TimelineItem(
    id: 'subject-1',
    type: TimelineItemType.activity,
    text: 'تماس با علی',
    description: 'هماهنگی جلسه فردا',
    createdAt: DateTime(2026, 9, 20),
    projectId: 'project-1',
    categoryId: 'category-1',
    tagIds: const <String>['tag-1'],
  );

  final followUp = TimelineItem(
    id: 'follow-up-1',
    type: TimelineItemType.activity,
    text: 'پرداخت انجام شد',
    createdAt: DateTime(2026, 9, 20, 10),
    parentId: 'subject-1',
  );

  final service = SearchTrackedSubjects();

  List<TimelineItem> run(String query) => service.search(
        subjects: <TimelineItem>[subject],
        followUpsBySubject: <String, List<TimelineItem>>{
          'subject-1': <TimelineItem>[followUp],
        },
        projects: const <YadNegarProject>[
          YadNegarProject(id: 'project-1', title: 'پروژه شخصی', colorValue: 1),
        ],
        categories: const <YadNegarCategory>[
          YadNegarCategory(id: 'category-1', title: 'جلسات', colorValue: 2),
        ],
        tags: const <YadNegarTag>[
          YadNegarTag(id: 'tag-1', title: 'مهم', colorValue: 3),
        ],
        query: query,
      );

  test('normalizes Persian letter variants and diacritics', () {
    expect(run('ي').single.id, 'subject-1');
    expect(run('ك') .single.id, 'subject-1');
    expect(
      PersianSearchText.normalize('عَلِی‌  ك'),
      'علی ک',
    );
  });

  test('uses AND semantics across fields', () {
    expect(run('علی مهم').single.id, 'subject-1');
    expect(run('علی پروژه').single.id, 'subject-1');
    expect(run('مهم جلسات').single.id, 'subject-1');
    expect(run('پرداخت مهم').single.id, 'subject-1');
    expect(run('علی وجودندارد'), isEmpty);
  });

  test('supports limited aliases', () {
    expect(run('زنگ').single.id, 'subject-1');
    expect(run('ملاقات').single.id, 'subject-1');
    expect(run('واریز').single.id, 'subject-1');
  });

  test('returns each root once and does not include follow-ups', () {
    final results = run('پرداخت');
    expect(results, hasLength(1));
    expect(results.single.id, 'subject-1');
    expect(results.single.isTrackedSubject, isTrue);
  });

  test('does not create a disk dependency', () {
    expect(
      service.search(
        subjects: <TimelineItem>[subject],
        followUpsBySubject: const <String, List<TimelineItem>>{},
        projects: const <YadNegarProject>[],
        categories: const <YadNegarCategory>[],
        tags: const <YadNegarTag>[],
        query: 'علی',
      ),
      hasLength(1),
    );
  });
}
