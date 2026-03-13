# 修复默认角色卡问题

## 问题说明

应用启动后，角色卡列表页面显示"还没有角色卡"，没有自动添加木灵希默认角色卡。

## 原因

由于 Hive 数据库初始化时机问题，默认角色卡可能没有正确添加到数据库中。

## 解决方法

### 方法 1：使用应用内修复功能（推荐）

1. 启动应用
2. 进入"角色卡"页面
3. 点击右上角的 **⋮** (更多菜单)
4. 选择 **"修复默认角色卡"**
5. 等待修复完成
6. 返回角色卡列表，应该能看到"木灵希"角色卡

### 方法 2：重新构建应用

1. 关闭应用
2. 双击运行项目根目录下的 `rebuild.bat` 脚本
3. 等待构建完成
4. 重新启动应用

### 方法 3：手动清除数据后重启

1. 关闭应用
2. 删除以下目录（如果存在）：
   ```
   C:\Users\Administrator\AppData\Local\talk
   ```
3. 重新启动应用

## 验证

修复成功后，角色卡列表应该显示：
- 木灵希（拜月魔教圣女）

角色卡标签应包含：古风、玄幻、圣女、痴情、活泼、女神、default

## 技术细节

修复功能会：
1. 确保 CharacterCardRepository 已正确初始化
2. 检查数据库中是否已有默认角色卡
3. 如果没有，则添加木灵希角色卡
4. 显示添加结果

## 文件变更

- `lib/shared/providers/global_init_provider.dart` - 全局初始化 Provider
- `lib/features/character_card/data/repositories/character_card_repository.dart` - 角色卡仓库
- `lib/features/character_card/data/services/default_character_cards.dart` - 默认角色卡服务
- `lib/features/character_card/presentation/pages/fix_default_cards_page.dart` - 修复页面（新增）
- `lib/core/router/app_router.dart` - 添加修复页面路由
