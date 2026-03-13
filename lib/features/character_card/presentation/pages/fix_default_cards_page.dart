import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:talk/features/character_card/data/repositories/character_card_repository.dart';
import 'package:talk/features/character_card/data/services/default_character_cards.dart';

/// 修复默认角色卡页面
/// 
/// 用于手动添加默认角色卡
class FixDefaultCardsPage extends ConsumerStatefulWidget {
  const FixDefaultCardsPage({super.key});

  @override
  ConsumerState<FixDefaultCardsPage> createState() => _FixDefaultCardsPageState();
}

class _FixDefaultCardsPageState extends ConsumerState<FixDefaultCardsPage> {
  String _status = '准备修复...';
  bool _isProcessing = false;
  String _result = '';

  @override
  void initState() {
    super.initState();
    // 自动开始修复
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fixDefaultCards();
    });
  }

  Future<void> _fixDefaultCards() async {
    setState(() {
      _isProcessing = true;
      _status = '正在初始化仓库...';
    });

    try {
      // 获取仓库实例
      final repository = ref.read(characterCardRepositoryProvider) as CharacterCardRepositoryImpl;
      
      // 确保仓库已初始化
      await repository.ensureInitialized();
      
      setState(() {
        _status = '正在添加默认角色卡...';
      });

      // 获取现有角色卡
      final existingCards = (await repository.getAll()).toList();
      final hasDefaultCard = existingCards.any(
        (card) => DefaultCharacterCards.isDefaultCard(card),
      );

      if (hasDefaultCard) {
        setState(() {
          _isProcessing = false;
          _result = '✅ 默认角色卡已存在，无需添加\n\n现有角色卡数量：${existingCards.length}';
        });
        return;
      }

      // 添加默认角色卡
      final defaultCards = DefaultCharacterCards.getDefaultCards();
      int addedCount = 0;

      for (final card in defaultCards) {
        await repository.save(card);
        addedCount++;
        setState(() {
          _status = '已添加：${card.data.name}';
        });
      }

      // 验证添加结果
      final allCards = await repository.getAll();
      
      setState(() {
        _isProcessing = false;
        _result = '✅ 修复完成！\n\n'
            '添加的角色卡：$addedCount 个\n'
            '总角色卡数：${allCards.length} 个\n\n'
            '角色卡列表:\n'
            '${allCards.map((c) => '  - ${c.data.name}').join('\n')}';
      });

    } catch (e) {
      setState(() {
        _isProcessing = false;
        _result = '❌ 修复失败\n\n错误信息：\n$e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('修复默认角色卡'),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (_isProcessing) ...[
                const CircularProgressIndicator(),
                const SizedBox(height: 24),
                Text(
                  _status,
                  style: const TextStyle(fontSize: 16),
                  textAlign: TextAlign.center,
                ),
              ] else ...[
                const Icon(
                  Icons.check_circle_outline,
                  size: 80,
                  color: Colors.green,
                ),
                const SizedBox(height: 24),
                Text(
                  _result.isEmpty ? _status : _result,
                  style: const TextStyle(fontSize: 16),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  icon: const Icon(Icons.arrow_back),
                  label: const Text('返回角色卡列表'),
                ),
                const SizedBox(height: 16),
                OutlinedButton.icon(
                  onPressed: _isProcessing ? null : _fixDefaultCards,
                  icon: const Icon(Icons.refresh),
                  label: const Text('重新修复'),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
