import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:talk/core/theme/theme.dart';
import 'package:talk/features/dialogue/presentation/providers/chat_providers.dart';
import 'package:talk/features/dialogue/presentation/widgets/chat_widgets.dart';
import 'package:talk/shared/widgets/common_widgets.dart';

/// 对话页面
class ChatPage extends ConsumerStatefulWidget {
  final String characterCardId;

  const ChatPage({
    super.key,
    required this.characterCardId,
  });

  @override
  ConsumerState<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends ConsumerState<ChatPage> {
  final _scrollController = ScrollController();
  final _messageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(chatProvider(widget.characterCardId).notifier).init(widget.characterCardId);
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final chatState = ref.watch(chatProvider(widget.characterCardId));

    return Scaffold(
      appBar: AppBar(
        title: Text(chatState.character?.name ?? '对话'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () => _showOptions(context),
          ),
        ],
      ),
      body: chatState.isLoading
          ? const Center(child: CircularProgressIndicator())
          : chatState.error != null
              ? ErrorState(
                  message: chatState.error,
                  onRetry: () => ref
                      .read(chatProvider(widget.characterCardId).notifier)
                      .init(widget.characterCardId),
                )
              : _buildChatContent(context, chatState),
    );
  }

  /// 构建对话内容
  Widget _buildChatContent(BuildContext context, ChatState chatState) {
    return Column(
      children: [
        Expanded(
          child: chatState.session?.messages.isEmpty ?? true
              ? _buildEmptyState(chatState)
              : _buildMessageList(chatState),
        ),
        if (chatState.isTyping) _buildTypingIndicator(),
        ChatInput(
          isLoading: chatState.isTyping,
          onSend: _sendMessage,
        ),
      ],
    );
  }

  /// 构建空状态
  Widget _buildEmptyState(ChatState chatState) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: AppColors.primaryContainer,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.chat_bubble_outline,
              size: 40,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            '开始和 ${chatState.character?.name ?? "角色"} 对话吧',
            style: AppTextStyles.body1.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          if (chatState.character?.firstMes != null) ...[
            const SizedBox(height: 24),
            GestureDetector(
              onTap: () => _sendMessage(chatState.character!.firstMes!),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                decoration: BoxDecoration(
                  color: AppColors.primaryContainer,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Text(
                  chatState.character!.firstMes!,
                  style: AppTextStyles.body2.copyWith(
                    color: AppColors.primary,
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  /// 构建消息列表
  Widget _buildMessageList(ChatState chatState) {
    final messages = chatState.session?.messages ?? [];

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });

    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.symmetric(vertical: 16),
      itemCount: messages.length,
      itemBuilder: (context, index) {
        final message = messages[index];
        return ChatBubble(
          message: message,
          characterAvatar: chatState.character?.avatarUrl,
          characterName: chatState.character?.name,
        );
      },
    );
  }

  /// 构建输入指示器
  Widget _buildTypingIndicator() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: AppColors.primaryContainer,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.more_horiz,
              size: 16,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            '正在输入...',
            style: AppTextStyles.body2.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 200.ms);
  }

  /// 发送消息
  void _sendMessage(String content) {
    if (content.trim().isEmpty) return;
    ref.read(chatProvider(widget.characterCardId).notifier).sendMessage(content);
  }

  /// 显示选项菜单
  void _showOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.delete_outline),
              title: const Text('清空对话'),
              onTap: () {
                Navigator.pop(context);
                _showClearDialog(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.info_outline),
              title: const Text('角色信息'),
              onTap: () {
                Navigator.pop(context);
                _showCharacterInfo(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  /// 显示清空对话确认
  void _showClearDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('清空对话'),
        content: const Text('确定要清空所有对话记录吗？此操作无法撤销。'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('对话已清空')),
              );
            },
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            child: const Text('清空'),
          ),
        ],
      ),
    );
  }

  /// 显示角色信息
  void _showCharacterInfo(BuildContext context) {
    final character = ref.read(chatProvider(widget.characterCardId)).character;
    
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.6,
        minChildSize: 0.3,
        maxChildSize: 0.9,
        expand: false,
        builder: (context, scrollController) => Container(
          padding: const EdgeInsets.all(16),
          child: ListView(
            controller: scrollController,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.divider,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                character?.name ?? '角色信息',
                style: AppTextStyles.h2,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              if (character?.description != null) ...[
                _buildInfoSection('描述', character!.description!),
                const SizedBox(height: 12),
              ],
              if (character?.personality != null) ...[
                _buildInfoSection('性格', character!.personality!),
                const SizedBox(height: 12),
              ],
              if (character?.scenario != null) ...[
                _buildInfoSection('场景', character!.scenario!),
              ],
            ],
          ),
        ),
      ),
    );
  }

  /// 构建信息区块
  Widget _buildInfoSection(String title, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppTextStyles.body1.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          content,
          style: AppTextStyles.body2.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }
}
