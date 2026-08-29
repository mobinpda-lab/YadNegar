import 'package:yadnegar/features/timeline/domain/yadnegar_taxonomy.dart';

abstract class TaxonomyRepository {
  Future<List<YadNegarCategory>> listCategories();
  Future<List<YadNegarTag>> listTags();

  Future<YadNegarCategory?> findCategoryById(String id);
  Future<YadNegarTag?> findTagById(String id);

  Future<void> upsertCategory(YadNegarCategory category);
  Future<void> upsertTag(YadNegarTag tag);

  Future<bool> deleteCategoryById(String id);
  Future<bool> deleteTagById(String id);
}
