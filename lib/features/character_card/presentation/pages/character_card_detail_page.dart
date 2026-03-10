import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:talk/core/theme/theme.dart';
import 'package:talk/features/character_card/domain/entities/character_card.dart';
import 'package:talk/features/character_card/domain/usecases/get_character_cards_usecase.dart';
import 'package:talk/features/character_card/presentation/providers/character_card_providers.dart';
import 'package:talk/shared/widgets/common_widgets.dart';

/// 角色卡详情页面
/// 
/// 显示角色卡的详细信息，支持编辑、删除、开始对话
class CharacterCardDetailPage extends ConsumerWidget {
  final String characterCardId;

  const CharacterCardDetailPage({
    super.key,
    required this.characterCardId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cardAsync = ref.watch(characterCardDetailProvider(characterCardId));

    return Scaffold(
      body: cardAsync.when(
        data: (card) => card != null
            ? _buildContent(context, ref, card)
            : const Center(child: Text('角色卡不存在')),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => ErrorState(
          message: error.toString(),
          onRetry: () => ref.invalidate(characterCardDetailProvider(characterCardId)),
        ),
      ),
    );
  }

  /// 构建页面内容
  Widget _buildContent(BuildContext context, WidgetRef ref, CharacterCard card) {
    return CustomScrollView(
      slivers: [
        _buildAppBar(context, ref, card),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(context, card),
                const SizedBox(height: 24),
                if (card.description != null) ...[
                  _buildSection('描述', card.description!),
                  const SizedBox(height: 16),
                ],
                if (card.personality != null) ...[
                  _buildSection('性格', card.personality!),
                  const SizedBox(height: 16),
                ],
                if (card.scenario != null) ...[
                  _buildSection('场景', card.scenario!),
                  const SizedBox(height: 16),
                ],
                if (card.firstMes != null) ...[
                  _buildSection('首次消息', card.firstMes!),
                  const SizedBox(height: 16),
                ],
                if (card.tags.isNotEmpty) ...[
                  _buildTagsSection(context, card.tags),
                  const SizedBox(height: 16),
                ],
                if (card.profile != null) ...[
                  _buildProfileSection(context, card.profile!),
                  const SizedBox(height: 24),
                ],
                _buildActionButtons(context, ref, card),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ],
    );
  }

  /// 构建应用栏
  Widget _buildAppBar(BuildContext context, WidgetRef ref, CharacterCard card) {
    return SliverAppBar(
      expandedHeight: 280,
      pinned: true,
      actions: [
        IconButton(
          icon: const Icon(Icons.edit_outlined),
          onPressed: () => context.push('/character-cards/${card.id}/edit'),
          tooltip: '编辑',
        ),
        PopupMenuButton<String>(
          icon: const Icon(Icons.more_vert),
          onSelected: (value) => _handleMenuAction(context, ref, card, value),
          itemBuilder: (context) => [
            const PopupMenuItem(
              value: 'export',
              child: ListTile(
                leading: Icon(Icons.file_download),
                title: Text('导出角色卡'),
              ),
            ),
            const PopupMenuItem(
              value: 'delete',
              child: ListTile(
                leading: Icon(Icons.delete_outline),
                title: Text('删除角色卡'),
              ),
            ),
          ],
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: _buildCover(card),
      ),
    );
  }

  /// 构建封面
  Widget _buildCover(CharacterCard card) {
    final portraitUrl = card.portraitUrl ?? card.avatarUrl;

    return Container(
      color: AppColors.primaryContainer,
      child: Stack(
        fit: StackFit.expand,
        children: [
          if (portraitUrl != null && portraitUrl.isNotEmpty)
            CachedNetworkImage(
              imageUrl: portraitUrl,
              fit: BoxFit.cover,
              placeholder: (context, url) => Container(
                color: AppColors.primaryContainer,
                child: const Center(
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              ),
              errorWidget: (context, url, error) => _buildDefaultCover(card),
            )
          else
            _buildDefaultCover(card),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Colors.black.withValues(alpha: 0.7),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 构建默认封面
  Widget _buildDefaultCover(CharacterCard card) {
    return Container(
      color: AppColors.primaryContainer,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.person,
              size: 64,
              color: AppColors.primary,
            ),
            const SizedBox(height: 16),
            Text(
              card.name,
              style: AppTextStyles.h2.copyWith(color: AppColors.primary),
            ),
          ],
        ),
      ),
    );
  }

  /// 构建头部信息
  Widget _buildHeader(BuildContext context, CharacterCard card) {
    return Row(
      children: [
        _buildAvatar(card),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                card.name,
                style: AppTextStyles.h2,
              ),
              if (card.nickname != null) ...[
                const SizedBox(height: 4),
                Text(
                  card.nickname!,
                  style: AppTextStyles.body1.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ],
              const SizedBox(height: 8),
              Text(
                '创建于 ${_formatDate(card.createdAt)}',
                style: AppTextStyles.caption.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ],
    ).animate().fadeIn(duration: 400.ms).slideX(begin: -0.1);
  }

  /// 构建头像
  Widget _buildAvatar(CharacterCard card) {
    final size = 80.0;

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.primaryContainer,
        border: Border.all(
          color: AppColors.primary.withValues(alpha: 0.3),
          width: 2,
        ),
      ),
      child: ClipOval(
        child: card.avatarUrl != null && card.avatarUrl!.isNotEmpty
            ? CachedNetworkImage(
                imageUrl: card.avatarUrl!,
                fit: BoxFit.cover,
                placeholder: (context, url) => const Center(
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
                errorWidget: (context, url, error) => _buildDefaultAvatar(),
              )
            : _buildDefaultAvatar(),
      ),
    );
  }

  /// 构建默认头像
  Widget _buildDefaultAvatar() {
    return const Icon(
      Icons.person,
      size: 40,
      color: AppColors.primary,
    );
  }

  /// 构建信息区块
  Widget _buildSection(String title, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppTextStyles.h3.copyWith(
            color: AppColors.primary,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          content,
          style: AppTextStyles.body1,
        ),
      ],
    ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.1);
  }

  /// 构建标签区块
  Widget _buildTagsSection(BuildContext context, List<String> tags) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '标签',
          style: AppTextStyles.h3.copyWith(
            color: AppColors.primary,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: tags.map((tag) {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                tag,
                style: AppTextStyles.caption,
              ),
            );
          }).toList(),
        ),
      ],
    ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.1);
  }

  /// 构建档案区块
  Widget _buildProfileSection(BuildContext context, CharacterProfile profile) {
    return GlassCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '角色档案',
            style: AppTextStyles.h3.copyWith(
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 12),
          _buildProfileItem('年龄', profile.age?.toString()),
          _buildProfileItem('性别', profile.gender),
          _buildProfileItem('职业', profile.occupation),
          _buildProfileItem('身高', profile.height),
          _buildProfileItem('生日', profile.birthday),
          if (profile.likes.isNotEmpty)
            _buildProfileList('喜好', profile.likes),
          if (profile.dislikes.isNotEmpty)
            _buildProfileList('厌恶', profile.dislikes),
        ],
      ),
    ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.1);
  }

  /// 构建档案项
  Widget _buildProfileItem(String label, String? value) {
    if (value == null) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          SizedBox(
            width: 60,
            child: Text(
              label,
              style: AppTextStyles.body2.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: AppTextStyles.body2,
            ),
          ),
        ],
      ),
    );
  }

  /// 构建档案列表项
  Widget _buildProfileList(String label, List<String> values) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 60,
            child: Text(
              label,
              style: AppTextStyles.body2.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ),
          Expanded(
            child: Text(
              values.join('、'),
              style: AppTextStyles.body2,
            ),
          ),
        ],
      ),
    );
  }

  /// 构建操作按钮
  Widget _buildActionButtons(BuildContext context, WidgetRef ref, CharacterCard card) {
    return Row(
      children: [
        Expanded(
          child: GradientButton(
            text: '开始对话',
            onPressed: () => context.push('/chat/${card.id}'),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () => context.push('/character-cards/${card.id}/edit'),
            icon: const Icon(Icons.edit_outlined),
            label: const Text('编辑'),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
          ),
        ),
      ],
    ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.2);
  }

  /// 处理菜单操作
  void _handleMenuAction(
    BuildContext context,
    WidgetRef ref,
    CharacterCard card,
    String action,
  ) {
    switch (action) {
      case 'export':
        _exportCard(context, ref, card);
        break;
      case 'delete':
        _showDeleteDialog(context, ref, card);
        break;
    }
  }

  /// 导出角色卡
  void _exportCard(BuildContext context, WidgetRef ref, CharacterCard card) {
    final exportUseCase = ref.read(exportProvider);
    final json = exportUseCase(card);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('导出角色卡'),
        content: SingleChildScrollView(
          child: SelectableText(
            const JsonEncoder.withIndent('  ').convert(json),
            style: AppTextStyles.caption.copyWith(
              fontFamily: 'monospace',
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('关闭'),
          ),
        ],
      ),
    );
  }

  /// 显示删除确认对话框
  void _showDeleteDialog(
    BuildContext context,
    WidgetRef ref,
    CharacterCard card,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('确认删除'),
        content: Text('确定要删除角色卡 "${card.name}" 吗？此操作无法撤销。'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(context).pop();
              await ref.read(characterCardListProvider.notifier).deleteCard(card.id);
              if (context.mounted) {
                context.pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('角色卡已删除')),
                );
              }
            },
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            child: const Text('删除'),
          ),
        ],
      ),
    );
  }

  /// 格式化日期
  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }
}

/// 角色卡详情 Provider
final characterCardDetailProvider = FutureProvider.family<CharacterCard?, String>(
  (ref, id) async {
    final useCase = ref.watch(getCharacterCardDetailUseCaseProvider);
    return useCase(id);
  },
);
