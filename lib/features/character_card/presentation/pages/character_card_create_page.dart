import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:talk/core/theme/theme.dart';
import 'package:talk/features/character_card/presentation/providers/character_card_providers.dart';
import 'package:talk/shared/widgets/common_widgets.dart';

/// 角色卡创建页面
/// 
/// 用于创建新的角色卡
class CharacterCardCreatePage extends ConsumerStatefulWidget {
  const CharacterCardCreatePage({super.key});

  @override
  ConsumerState<CharacterCardCreatePage> createState() => _CharacterCardCreatePageState();
}

class _CharacterCardCreatePageState extends ConsumerState<CharacterCardCreatePage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _personalityController = TextEditingController();
  final _scenarioController = TextEditingController();
  final _firstMesController = TextEditingController();
  final _mesExampleController = TextEditingController();
  final _systemPromptController = TextEditingController();
  final _avatarUrlController = TextEditingController();
  final _nicknameController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _personalityController.dispose();
    _scenarioController.dispose();
    _firstMesController.dispose();
    _mesExampleController.dispose();
    _systemPromptController.dispose();
    _avatarUrlController.dispose();
    _nicknameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final formState = ref.watch(characterCardFormProvider);
    final formNotifier = ref.read(characterCardFormProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('创建角色卡'),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: formState.isLoading ? null : _save,
            child: const Text('保存'),
          ),
        ],
      ),
      body: LoadingOverlay(
        isLoading: formState.isLoading,
        loadingText: '保存中...',
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _buildNameField(formNotifier),
              const SizedBox(height: 16),
              _buildNicknameField(formNotifier),
              const SizedBox(height: 16),
              _buildAvatarUrlField(formNotifier),
              const SizedBox(height: 16),
              _buildDescriptionField(formNotifier),
              const SizedBox(height: 16),
              _buildPersonalityField(formNotifier),
              const SizedBox(height: 16),
              _buildScenarioField(formNotifier),
              const SizedBox(height: 16),
              _buildFirstMesField(formNotifier),
              const SizedBox(height: 16),
              _buildMesExampleField(formNotifier),
              const SizedBox(height: 16),
              _buildSystemPromptField(formNotifier),
              const SizedBox(height: 16),
              _buildTagsSection(formNotifier, formState.tags),
              const SizedBox(height: 24),
              if (formState.error != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Text(
                    formState.error!,
                    style: AppTextStyles.body2.copyWith(color: AppColors.error),
                  ),
                ),
              GradientButton(
                text: '创建角色卡',
                onPressed: formState.isLoading ? null : _save,
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  /// 构建名称输入框
  Widget _buildNameField(CharacterCardFormNotifier formNotifier) {
    return TextFormField(
      controller: _nameController,
      decoration: const InputDecoration(
        labelText: '角色名称 *',
        hintText: '输入角色名称',
        border: OutlineInputBorder(),
        prefixIcon: Icon(Icons.person),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return '请输入角色名称';
        }
        return null;
      },
      onChanged: formNotifier.updateName,
    );
  }

  /// 构建昵称输入框
  Widget _buildNicknameField(CharacterCardFormNotifier formNotifier) {
    return TextFormField(
      controller: _nicknameController,
      decoration: const InputDecoration(
        labelText: '昵称/爱称',
        hintText: '输入角色的昵称',
        border: OutlineInputBorder(),
        prefixIcon: Icon(Icons.favorite_outline),
      ),
      onChanged: (value) => formNotifier.updateNickname(value.isEmpty ? null : value),
    );
  }

  /// 构建头像URL输入框
  Widget _buildAvatarUrlField(CharacterCardFormNotifier formNotifier) {
    return TextFormField(
      controller: _avatarUrlController,
      decoration: const InputDecoration(
        labelText: '头像URL',
        hintText: '输入头像图片URL',
        border: OutlineInputBorder(),
        prefixIcon: Icon(Icons.image_outlined),
      ),
      keyboardType: TextInputType.url,
      onChanged: (value) => formNotifier.updateAvatarUrl(value.isEmpty ? null : value),
    );
  }

  /// 构建描述输入框
  Widget _buildDescriptionField(CharacterCardFormNotifier formNotifier) {
    return TextFormField(
      controller: _descriptionController,
      decoration: const InputDecoration(
        labelText: '角色描述',
        hintText: '描述角色的外貌、基本性格等',
        border: OutlineInputBorder(),
        alignLabelWithHint: true,
      ),
      maxLines: 3,
      onChanged: (value) => formNotifier.updateDescription(value.isEmpty ? null : value),
    );
  }

  /// 构建性格输入框
  Widget _buildPersonalityField(CharacterCardFormNotifier formNotifier) {
    return TextFormField(
      controller: _personalityController,
      decoration: const InputDecoration(
        labelText: '性格',
        hintText: '详细描述角色的性格特点',
        border: OutlineInputBorder(),
        alignLabelWithHint: true,
      ),
      maxLines: 4,
      onChanged: (value) => formNotifier.updatePersonality(value.isEmpty ? null : value),
    );
  }

  /// 构建场景输入框
  Widget _buildScenarioField(CharacterCardFormNotifier formNotifier) {
    return TextFormField(
      controller: _scenarioController,
      decoration: const InputDecoration(
        labelText: '场景设定',
        hintText: '描述角色所处的世界观或场景',
        border: OutlineInputBorder(),
        alignLabelWithHint: true,
      ),
      maxLines: 3,
      onChanged: (value) => formNotifier.updateScenario(value.isEmpty ? null : value),
    );
  }

  /// 构建首次消息输入框
  Widget _buildFirstMesField(CharacterCardFormNotifier formNotifier) {
    return TextFormField(
      controller: _firstMesController,
      decoration: const InputDecoration(
        labelText: '首次消息',
        hintText: '角色发送的第一条消息',
        border: OutlineInputBorder(),
        alignLabelWithHint: true,
      ),
      maxLines: 3,
      onChanged: (value) => formNotifier.updateFirstMes(value.isEmpty ? null : value),
    );
  }

  /// 构建消息示例输入框
  Widget _buildMesExampleField(CharacterCardFormNotifier formNotifier) {
    return TextFormField(
      controller: _mesExampleController,
      decoration: const InputDecoration(
        labelText: '消息示例',
        hintText: '角色的对话示例，帮助AI理解角色风格',
        border: OutlineInputBorder(),
        alignLabelWithHint: true,
      ),
      maxLines: 5,
      onChanged: (value) => formNotifier.updateMesExample(value.isEmpty ? null : value),
    );
  }

  /// 构建系统提示词输入框
  Widget _buildSystemPromptField(CharacterCardFormNotifier formNotifier) {
    return TextFormField(
      controller: _systemPromptController,
      decoration: const InputDecoration(
        labelText: '系统提示词',
        hintText: '自定义AI行为指令',
        border: OutlineInputBorder(),
        alignLabelWithHint: true,
      ),
      maxLines: 3,
      onChanged: (value) => formNotifier.updateSystemPrompt(value.isEmpty ? null : value),
    );
  }

  /// 构建标签区域
  Widget _buildTagsSection(CharacterCardFormNotifier formNotifier, List<String> tags) {
    final tagController = TextEditingController();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('标签', style: AppTextStyles.body1),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            ...tags.map((tag) => Chip(
              label: Text(tag),
              onDeleted: () => formNotifier.removeTag(tag),
            )),
            ActionChip(
              avatar: const Icon(Icons.add, size: 18),
              label: const Text('添加标签'),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('添加标签'),
                    content: TextField(
                      controller: tagController,
                      decoration: const InputDecoration(
                        hintText: '输入标签名称',
                      ),
                      autofocus: true,
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('取消'),
                      ),
                      TextButton(
                        onPressed: () {
                          if (tagController.text.isNotEmpty) {
                            formNotifier.addTag(tagController.text);
                          }
                          Navigator.pop(context);
                        },
                        child: const Text('添加'),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ],
    );
  }

  /// 保存角色卡
  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final card = await ref.read(characterCardFormProvider.notifier).save();
    if (card != null && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('角色卡创建成功')),
      );
      context.pop();
    }
  }
}
