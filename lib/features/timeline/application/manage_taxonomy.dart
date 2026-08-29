import 'package:yadnegar/features/timeline/domain/taxonomy_repository.dart';
import 'package:yadnegar/features/timeline/domain/timeline_repository.dart';
import 'package:yadnegar/features/timeline/domain/yadnegar_taxonomy.dart';

typedef TaxonomyIdGenerator = String Function();

class TaxonomyInUseException implements Exception {
  const TaxonomyInUseException(this.id, this.kind);
  final String id;
  final String kind;
}

class ManageTaxonomy {
  const ManageTaxonomy({
    required this.taxonomyRepository,
    required this.timelineRepository,
    required this.idGenerator,
  });

  final TaxonomyRepository taxonomyRepository;
  final TimelineRepository timelineRepository;
  final TaxonomyIdGenerator idGenerator;

  Future<List<YadNegarCategory>> listCategories() => taxonomyRepository.listCategories();
  Future<List<YadNegarTag>> listTags() => taxonomyRepository.listTags();

  Future<YadNegarCategory> createCategory({required String title, required int colorValue}) async {
    final normalized = _title(title);
    final category = YadNegarCategory(id: _id(), title: normalized, colorValue: colorValue);
    await taxonomyRepository.upsertCategory(category);
    return category;
  }

  Future<YadNegarTag> createTag({required String title, required int colorValue}) async {
    final normalized = _title(title);
    final tag = YadNegarTag(id: _id(), title: normalized, colorValue: colorValue);
    await taxonomyRepository.upsertTag(tag);
    return tag;
  }

  Future<YadNegarCategory> updateCategory(YadNegarCategory value, {required String title, required int colorValue}) async {
    final updated = YadNegarCategory(id: value.id, title: _title(title), colorValue: colorValue);
    await taxonomyRepository.upsertCategory(updated);
    return updated;
  }

  Future<YadNegarTag> updateTag(YadNegarTag value, {required String title, required int colorValue}) async {
    final updated = YadNegarTag(id: value.id, title: _title(title), colorValue: colorValue);
    await taxonomyRepository.upsertTag(updated);
    return updated;
  }

  Future<void> deleteCategory(String id) async {
    final normalized = id.trim();
    final items = await timelineRepository.listNewestFirst();
    if (items.any((item) => item.isTrackedSubject && item.categoryId == normalized)) {
      throw TaxonomyInUseException(normalized, 'category');
    }
    await taxonomyRepository.deleteCategoryById(normalized);
  }

  Future<void> deleteTag(String id) async {
    final normalized = id.trim();
    final items = await timelineRepository.listNewestFirst();
    if (items.any((item) => item.isTrackedSubject && item.tagIds.contains(normalized))) {
      throw TaxonomyInUseException(normalized, 'tag');
    }
    await taxonomyRepository.deleteTagById(normalized);
  }

  String _title(String title) {
    final normalized = title.trim();
    if (normalized.isEmpty) throw ArgumentError.value(title, 'title', 'Title cannot be empty.');
    return normalized;
  }

  String _id() {
    final id = idGenerator().trim();
    if (id.isEmpty) throw StateError('Taxonomy id generator returned an empty id.');
    return id;
  }
}
