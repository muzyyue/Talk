import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:talk/core/theme/theme.dart';
import 'package:talk/features/character_card/presentation/providers/character_card_providers.dart';
import 'package:talk/shared/widgets/common_widgets.dart';

/// 角色卡导入页面
/// 
/// 支持从JSON导入角色卡
class CharacterCardImportPage extends ConsumerStatefulWidget {
  const CharacterCardImportPage({super.key});

  @override
  ConsumerState<CharacterCardImportPage> createState() => _CharacterCardImportPageState();
}

class _CharacterCardImportPageState extends ConsumerState<CharacterCardImportPage> {
  final _textController = TextEditingController();
  final _scrollController = ScrollController();

  @override
  void dispose() {
    _textController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(importProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('导入角色卡'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.content_paste),
            onPressed: _pasteFromClipboard,
            tooltip: '从剪贴板粘贴',
          ),
        ],
      ),
      body: LoadingOverlay(
        isLoading: state.isLoading,
        loadingText: '导入中...',
        child: SingleChildScrollView(
          controller: _scrollController,
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildInstructions(),
              const SizedBox(height: 16),
              _buildInputField(),
              const SizedBox(height: 16),
              if (state.error != null) ...[
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.error.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.error_outline, color: AppColors.error),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          state.error!,
                          style: AppTextStyles.body2.copyWith(color: AppColors.error),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
              ],
              GradientButton(
                text: '导入',
                onPressed: state.isLoading ? null : _import,
              ),
              const SizedBox(height: 24),
              _buildExampleSection(),
              const SizedBox(height: 24),
              if (state.importedCard != null) ...[
                _buildSuccessSection(state.importedCard!),
              ],
            ],
          ),
        ),
      ),
    );
  }

  /// 构建说明区域
  Widget _buildInstructions() {
    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.info_outline, color: AppColors.primary),
              const SizedBox(width: 8),
              Text('导入说明', style: AppTextStyles.h3),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            '支持 chara_card_v2 格式的JSON数据。您可以从 SillyTavern、CharacterAI 等平台导出角色卡，然后粘贴到下方输入框中。',
            style: AppTextStyles.body2.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  /// 构建输入框
  Widget _buildInputField() {
    return TextField(
      controller: _textController,
      decoration: const InputDecoration(
        labelText: 'JSON数据',
        hintText: '粘贴角色卡JSON数据',
        border: OutlineInputBorder(),
        alignLabelWithHint: true,
      ),
      maxLines: 10,
      style: AppTextStyles.body2.copyWith(
        fontFamily: 'monospace',
      ),
    );
  }

  /// 构建示例区域
  Widget _buildExampleSection() {
    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.code, color: AppColors.primary),
              const SizedBox(width: 8),
              Text('JSON格式示例', style: AppTextStyles.h3),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.surfaceVariant,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              '''{
  "spec": "chara_card_v2",
  "spec_version": "2.0",
  "data": {
    "name": "凛",
    "description": "常穿着柔软针织衫配百褶裙...",
    "personality": "温柔体贴的妹妹...",
    "scenario": "每天早上...",
    "first_mes": "早安，哥哥。",
    "tags": ["病娇", "妹妹", "温柔"]
  }
}''',
              style: AppTextStyles.caption.copyWith(
                fontFamily: 'monospace',
                color: AppColors.onSurfaceVariant,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 构建成功区域
  Widget _buildSuccessSection(dynamic card) {
    return GlassCard(
      backgroundColor: AppColors.success.withValues(alpha: 0.1),
      child: Column(
        children: [
          const Icon(Icons.check_circle, color: AppColors.success, size: 48),
          const SizedBox(height: 12),
          Text(
            '导入成功！',
            style: AppTextStyles.h3.copyWith(color: AppColors.success),
          ),
          const SizedBox(height: 8),
          Text(
            '角色卡 "${card.name}" 已成功导入',
            style: AppTextStyles.body2,
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TextButton.icon(
                onPressed: () {
                  ref.read(importProvider.notifier).reset();
                  _textController.clear();
                },
                icon: const Icon(Icons.refresh),
                label: const Text('继续导入'),
              ),
              ElevatedButton.icon(
                onPressed: () => context.go('/character-cards'),
                icon: const Icon(Icons.list),
                label: const Text('查看列表'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// 从剪贴板粘贴
  Future<void> _pasteFromClipboard() async {
    final data = await Clipboard.getData(Clipboard.kTextPlain);
    if (data?.text != null) {
      _textController.text = data!.text!;
    }
  }

  /// 导入角色卡
  Future<void> _import() async {
    final text = _textController.text.trim();
    if (text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('请输入JSON数据')),
      );
      return;
    }

    final card = await ref.read(importProvider.notifier).importFromJsonString(text);
    if (card != null && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('角色卡 "${card.name}" 导入成功')),
      );
    }
  }
}
