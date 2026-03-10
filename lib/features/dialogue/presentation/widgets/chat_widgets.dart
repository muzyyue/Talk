import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:talk/core/theme/theme.dart';
import 'package:talk/features/dialogue/data/models/chat_session_model.dart';

/// 对话消息气泡组件
class ChatBubble extends StatelessWidget {
  final ChatMessageModel message;
  final String? characterAvatar;
  final String? characterName;

  const ChatBubble({
    super.key,
    required this.message,
    this.characterAvatar,
    this.characterName,
  });

  @override
  Widget build(BuildContext context) {
    final isUser = message.role == MessageRole.user;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment:
            isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isUser) _buildAvatar(),
          Flexible(
            child: Container(
              margin: EdgeInsets.only(
                left: isUser ? 48 : 8,
                right: isUser ? 8 : 48,
              ),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isUser
                    ? AppColors.primary
                    : Theme.of(context).colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(16),
                  topRight: const Radius.circular(16),
                  bottomLeft: Radius.circular(isUser ? 16 : 4),
                  bottomRight: Radius.circular(isUser ? 4 : 16),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (message.metadata != null) ...[
                    _buildMetadata(message.metadata!),
                    const SizedBox(height: 4),
                  ],
                  Text(
                    message.content,
                    style: AppTextStyles.body1.copyWith(
                      color: isUser ? Colors.white : null,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _formatTime(message.timestamp),
                    style: AppTextStyles.caption.copyWith(
                      color: isUser
                          ? Colors.white.withValues(alpha: 0.7)
                          : AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ).animate().fadeIn(duration: 200.ms).slideX(
            begin: isUser ? 0.1 : -0.1,
            end: 0,
          ),
          if (isUser)
            CircleAvatar(
              radius: 16,
              backgroundColor: AppColors.primaryContainer,
              child: const Icon(Icons.person, size: 16),
            ),
        ],
      ),
    );
  }

  /// 构建头像
  Widget _buildAvatar() {
    return Container(
      width: 40,
      height: 40,
      margin: const EdgeInsets.only(right: 8),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.3), width: 2),
      ),
      child: ClipOval(
        child: characterAvatar != null && characterAvatar!.isNotEmpty
            ? CachedNetworkImage(
                imageUrl: characterAvatar!,
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(
                  color: AppColors.primaryContainer,
                  child: const Icon(Icons.person, size: 20),
                ),
                errorWidget: (context, url, error) => Container(
                  color: AppColors.primaryContainer,
                  child: Text(
                    characterName?.substring(0, 1) ?? '?',
                    style: AppTextStyles.h3.copyWith(color: AppColors.primary),
                  ),
                ),
              )
            : Container(
                color: AppColors.primaryContainer,
                child: Text(
                  characterName?.substring(0, 1) ?? '?',
                  style: AppTextStyles.h3.copyWith(color: AppColors.primary),
                ),
              ),
      ),
    );
  }

  /// 构建元数据显示
  Widget _buildMetadata(MessageMetadataModel metadata) {
    return Wrap(
      spacing: 4,
      runSpacing: 4,
      children: [
        if (metadata.emotion != null)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: AppColors.accentContainer,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              metadata.emotion!,
              style: AppTextStyles.caption.copyWith(
                color: AppColors.onAccentContainer,
              ),
            ),
          ),
        if (metadata.expression != null)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: AppColors.secondaryContainer,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              metadata.expression!,
              style: AppTextStyles.caption.copyWith(
                color: AppColors.onSecondaryContainer,
              ),
            ),
          ),
      ],
    );
  }

  /// 格式化时间
  String _formatTime(DateTime time) {
    final now = DateTime.now();
    final diff = now.difference(time);

    if (diff.inMinutes < 1) {
      return '刚刚';
    } else if (diff.inHours < 1) {
      return '${diff.inMinutes}分钟前';
    } else if (diff.inDays < 1) {
      return '${diff.inHours}小时前';
    } else {
      return '${time.month}/${time.day} ${time.hour}:${time.minute.toString().padLeft(2, '0')}';
    }
  }
}

/// 打字机文本组件
class TypewriterText extends StatefulWidget {
  final String text;
  final TextStyle? style;
  final Duration duration;
  final VoidCallback? onComplete;

  const TypewriterText({
    super.key,
    required this.text,
    this.style,
    this.duration = const Duration(milliseconds: 50),
    this.onComplete,
  });

  @override
  State<TypewriterText> createState() => _TypewriterTextState();
}

class _TypewriterTextState extends State<TypewriterText> {
  String _displayText = '';
  int _charIndex = 0;

  @override
  void initState() {
    super.initState();
    _startTyping();
  }

  @override
  void didUpdateWidget(TypewriterText oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.text != widget.text) {
      _displayText = '';
      _charIndex = 0;
      _startTyping();
    }
  }

  void _startTyping() {
    if (_charIndex < widget.text.length) {
      Future.delayed(widget.duration, () {
        if (mounted) {
          setState(() {
            _displayText += widget.text[_charIndex];
            _charIndex++;
          });
          _startTyping();
        }
      });
    } else {
      widget.onComplete?.call();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Text(_displayText, style: widget.style);
  }
}

/// 消息输入框组件
class ChatInput extends StatefulWidget {
  final Function(String) onSend;
  final bool isLoading;

  const ChatInput({
    super.key,
    required this.onSend,
    this.isLoading = false,
  });

  @override
  State<ChatInput> createState() => _ChatInputState();
}

class _ChatInputState extends State<ChatInput> {
  final _controller = TextEditingController();
  final _focusNode = FocusNode();

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 8,
        bottom: MediaQuery.of(context).padding.bottom + 8,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _controller,
                focusNode: _focusNode,
                decoration: InputDecoration(
                  hintText: '输入消息...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  filled: true,
                  fillColor: Theme.of(context).colorScheme.surfaceContainerHighest,
                ),
                maxLines: 4,
                minLines: 1,
                textInputAction: TextInputAction.send,
                onSubmitted: _handleSend,
              ),
            ),
            const SizedBox(width: 8),
            Material(
              color: widget.isLoading
                  ? AppColors.primary.withValues(alpha: 0.5)
                  : AppColors.primary,
              borderRadius: BorderRadius.circular(24),
              child: InkWell(
                onTap: widget.isLoading ? null : () => _handleSend(_controller.text),
                borderRadius: BorderRadius.circular(24),
                child: Container(
                  width: 48,
                  height: 48,
                  alignment: Alignment.center,
                  child: widget.isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : const Icon(Icons.send, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleSend(String text) {
    if (text.trim().isEmpty) return;
    widget.onSend(text.trim());
    _controller.clear();
  }
}
