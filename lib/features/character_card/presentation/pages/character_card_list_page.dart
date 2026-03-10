import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:talk/core/router/router.dart';
import 'package:talk/core/theme/theme.dart';
import 'package:talk/features/character_card/presentation/providers/character_card_providers.dart';
import 'package:talk/features/character_card/presentation/widgets/character_card_item.dart';
import 'package:talk/shared/widgets/common_widgets.dart';

/// 角色卡列表页面
/// 
/// 显示所有角色卡，支持创建、导入、删除操作
class CharacterCardListPage extends ConsumerWidget {
  const CharacterCardListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(characterCardListProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('角色卡'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => context.push(AppRoutes.characterCardCreate),
            tooltip: '创建角色卡',
          ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert),
            onSelected: (value) => _handleMenuAction(context, ref, value),
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'import',
                child: ListTile(
                  leading: Icon(Icons.file_upload),
                  title: Text('导入角色卡'),
                ),
              ),
              const PopupMenuItem(
                value: 'refresh',
                child: ListTile(
                  leading: Icon(Icons.refresh),
                  title: Text('刷新'),
                ),
              ),
            ],
          ),
        ],
      ),
      body: _buildBody(context, ref, state),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push(AppRoutes.characterCardCreate),
        icon: const Icon(Icons.add),
        label: const Text('创建角色卡'),
      ),
    );
  }

  /// 构建页面主体
  Widget _buildBody(
    BuildContext context,
    WidgetRef ref,
    CharacterCardListState state,
  ) {
    if (state.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.error != null) {
      return ErrorState(
        message: state.error,
        onRetry: () => ref.read(characterCardListProvider.notifier).refresh(),
      );
    }

    if (state.cards.isEmpty) {
      return EmptyState(
        icon: const Icon(Icons.person_add_outlined, size: 64),
        title: '还没有角色卡',
        message: '创建或导入一个角色卡开始对话吧',
        actionText: '创建角色卡',
        onAction: () => context.push(AppRoutes.characterCardCreate),
      );
    }

    return RefreshIndicator(
      onRefresh: () => ref.read(characterCardListProvider.notifier).refresh(),
      child: ListView.builder(
        padding: const EdgeInsets.only(bottom: 80),
        itemCount: state.cards.length,
        itemBuilder: (context, index) {
          final card = state.cards[index];
          return CharacterCardItem(
            card: card,
            onTap: () => context.push('/character-cards/${card.id}'),
            onDelete: () => _showDeleteDialog(context, ref, card.id, card.name),
          );
        },
      ),
    );
  }

  /// 处理菜单操作
  void _handleMenuAction(
    BuildContext context,
    WidgetRef ref,
    String action,
  ) {
    switch (action) {
      case 'import':
        context.push(AppRoutes.characterCardImport);
        break;
      case 'refresh':
        ref.read(characterCardListProvider.notifier).refresh();
        break;
    }
  }

  /// 显示删除确认对话框
  void _showDeleteDialog(
    BuildContext context,
    WidgetRef ref,
    String cardId,
    String cardName,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('确认删除'),
        content: Text('确定要删除角色卡 "$cardName" 吗？此操作无法撤销。'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              ref.read(characterCardListProvider.notifier).deleteCard(cardId);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('角色卡已删除')),
              );
            },
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            child: const Text('删除'),
          ),
        ],
      ),
    );
  }
}
