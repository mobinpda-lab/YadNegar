import 'package:flutter/material.dart';
import 'package:yadnegar/features/timeline/application/manage_projects.dart';
import 'package:yadnegar/features/timeline/domain/yadnegar_project.dart';

class ProjectManagementSheet {
  const ProjectManagementSheet._();

  static const palette = <int>[
    0xFF5B4BDB,
    0xFF3176D5,
    0xFF25A55A,
    0xFFE69A17,
    0xFFD9516A,
    0xFF8A56C6,
    0xFF258D8B,
    0xFF795548,
  ];

  static Future<void> open(
    BuildContext context, {
    required ManageProjects manageProjects,
  }) async {
    var projects = await manageProjects.list();
    if (!context.mounted) {
      return;
    }

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      backgroundColor: Colors.white,
      builder: (sheetContext) => StatefulBuilder(
        builder: (context, setSheetState) {
          Future<void> reload() async {
            final loaded = await manageProjects.list();
            if (context.mounted) {
              setSheetState(() => projects = loaded);
            }
          }

          Future<void> editProject([YadNegarProject? existing]) async {
            final result = await _projectDialog(context, existing: existing);
            if (result == null || !context.mounted) {
              return;
            }
            if (existing == null) {
              await manageProjects.create(
                title: result.title,
                colorValue: result.colorValue,
              );
            } else {
              await manageProjects.update(
                project: existing,
                title: result.title,
                colorValue: result.colorValue,
              );
            }
            await reload();
          }

          Future<void> deleteProject(YadNegarProject project) async {
            try {
              await manageProjects.delete(project.id);
              await reload();
            } on ProjectNotEmptyException {
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'این پروژه دارای کار است و تا زمانی که کارهای آن منتقل یا خارج نشوند قابل حذف نیست.',
                    ),
                  ),
                );
              }
            }
          }

          return SafeArea(
            child: SizedBox(
              height: MediaQuery.sizeOf(context).height * 0.78,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
                    child: Row(
                      children: [
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'پروژه‌ها',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                              SizedBox(height: 3),
                              Text(
                                'پروژه با تگ متفاوت است و گروهی از کارها را نگه می‌دارد.',
                                style: TextStyle(color: Color(0xFF77788A)),
                              ),
                            ],
                          ),
                        ),
                        FilledButton.icon(
                          key: const Key('project-add'),
                          onPressed: () => editProject(),
                          icon: const Icon(Icons.add_rounded),
                          label: const Text('پروژه جدید'),
                        ),
                      ],
                    ),
                  ),
                  const Divider(height: 1),
                  Expanded(
                    child: projects.isEmpty
                        ? const Center(
                            child: Text(
                              'هنوز پروژه‌ای ساخته نشده است.',
                              key: Key('project-empty'),
                            ),
                          )
                        : ListView.separated(
                            padding: const EdgeInsets.all(16),
                            itemCount: projects.length,
                            separatorBuilder: (_, __) =>
                                const SizedBox(height: 10),
                            itemBuilder: (context, index) {
                              final project = projects[index];
                              final color = Color(project.colorValue);
                              return Container(
                                key: Key('project-card-${project.id}'),
                                decoration: BoxDecoration(
                                  color: color.withValues(alpha: 0.12),
                                  borderRadius: BorderRadius.circular(18),
                                  border: Border.all(
                                    color: color.withValues(alpha: 0.34),
                                  ),
                                ),
                                child: ListTile(
                                  leading: Container(
                                    width: 14,
                                    height: 42,
                                    decoration: BoxDecoration(
                                      color: color,
                                      borderRadius: BorderRadius.circular(999),
                                    ),
                                  ),
                                  title: Text(
                                    project.title,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                  subtitle: const Text('گروه کارها'),
                                  trailing: PopupMenuButton<String>(
                                    key: Key('project-menu-${project.id}'),
                                    onSelected: (value) {
                                      if (value == 'edit') {
                                        editProject(project);
                                      } else if (value == 'delete') {
                                        deleteProject(project);
                                      }
                                    },
                                    itemBuilder: (context) => const [
                                      PopupMenuItem(
                                        value: 'edit',
                                        child: Text('ویرایش پروژه'),
                                      ),
                                      PopupMenuItem(
                                        value: 'delete',
                                        child: Text('حذف پروژه'),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  static Future<_ProjectDraft?> _projectDialog(
    BuildContext context, {
    YadNegarProject? existing,
  }) async {
    final controller = TextEditingController(text: existing?.title ?? '');
    var selectedColor = existing?.colorValue ?? palette.first;
    final result = await showDialog<_ProjectDraft>(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Text(existing == null ? 'پروژه جدید' : 'ویرایش پروژه'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                key: const Key('project-title-input'),
                controller: controller,
                autofocus: true,
                decoration: const InputDecoration(
                  labelText: 'عنوان پروژه',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'رنگ باکس پروژه',
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  for (final value in palette)
                    InkWell(
                      key: Key('project-color-$value'),
                      onTap: () => setDialogState(() => selectedColor = value),
                      borderRadius: BorderRadius.circular(999),
                      child: Container(
                        width: 38,
                        height: 38,
                        decoration: BoxDecoration(
                          color: Color(value),
                          shape: BoxShape.circle,
                          border: selectedColor == value
                              ? Border.all(color: Colors.black87, width: 3)
                              : null,
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('لغو'),
            ),
            FilledButton(
              key: const Key('project-save'),
              onPressed: () {
                final title = controller.text.trim();
                if (title.isEmpty) {
                  return;
                }
                Navigator.of(dialogContext).pop(
                  _ProjectDraft(title: title, colorValue: selectedColor),
                );
              },
              child: const Text('ذخیره'),
            ),
          ],
        ),
      ),
    );
    controller.dispose();
    return result;
  }
}

class _ProjectDraft {
  const _ProjectDraft({required this.title, required this.colorValue});
  final String title;
  final int colorValue;
}
