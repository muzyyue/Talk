import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 更新好感度用例
class UpdateAffectionUseCase {
  Future<void> call(UpdateAffectionParams params) async {}
}

/// 更新好感度参数
class UpdateAffectionParams {
  final String characterId;
  final int change;
  final String reason;

  const UpdateAffectionParams({
    required this.characterId,
    required this.change,
    required this.reason,
  });
}

/// 更新好感度用例 Provider
final updateAffectionUseCaseProvider = Provider<UpdateAffectionUseCase>(
  (ref) => UpdateAffectionUseCase(),
);
