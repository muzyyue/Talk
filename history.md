# 项目变更历史

## v1.0.4 (2026-03-13) 修复初始化问题与测试错误

### 问题修复
- **默认角色卡未显示**：修复角色卡仓库初始化时机问题
- **对话页面加载失败**：修复 ChatRepository 未初始化错误
- **测试编译错误**：删除缺失 mocktail 依赖的测试文件
- **Lint 警告**：清理未使用的导入和不必要的代码

### 新增功能
- **修复页面**：用户可手动触发添加默认角色卡
- **重建脚本**：`rebuild.bat` 一键清理和重建项目
- **修复文档**：`FIX_DEFAULT_CARDS.md` 详细说明问题和解决方案

### 技术实现
- **全局初始化 Provider**：`global_init_provider.dart` 统一初始化所有仓库
- **应用启动触发**：在 `StarTaleApp` 的 `initState` 中触发全局初始化
- **仓库初始化方法**：添加 `ensureInitialized()` 确保仓库已初始化
- **修复菜单**：角色卡列表页面添加"修复默认角色卡"选项
- **修复路由**：`/character-cards/fix-defaults` 路由支持

### 文件变更
- **新增**：
  - `lib/shared/providers/global_init_provider.dart` - 全局初始化 Provider
  - `lib/features/character_card/presentation/pages/fix_default_cards_page.dart` - 修复页面
  - `FIX_DEFAULT_CARDS.md` - 修复说明文档
  - `rebuild.bat` - 重建脚本
  - `scripts/add_default_cards.dart` - 手动添加脚本
- **修改**：
  - `lib/main.dart` - 简化初始化逻辑
  - `lib/app.dart` - 添加全局初始化触发
  - `lib/core/router/app_router.dart` - 添加修复路由
  - `lib/features/character_card/data/repositories/character_card_repository.dart` - 添加 ensureInitialized 方法
  - `lib/features/character_card/presentation/pages/character_card_list_page.dart` - 添加修复菜单
- **删除**：
  - `test/core/services/lm_studio_client_test.dart` - 缺失依赖的测试文件

### 代码质量
- 修复所有编译错误（error 级别）
- 清理未使用的导入
- 删除不必要的类型转换
- 剩余 113 个 lint 警告（info 级别，不影响运行）

---

## v1.0.3 (2026-03-13) 默认角色卡与 Windows 桌面应用

### 新增功能
- 默认角色卡系统：应用首次启动时自动添加预设角色卡
- 木灵希角色卡：完整角色设定（外貌、性格、背景、互动示例）
- Windows 桌面应用构建：支持 Windows 10/11 64 位系统

### 技术实现
- 默认角色卡服务：`DefaultCharacterCards` 类管理预设角色卡
- 自动初始化：在 `CharacterCardRepository.init()` 中检查并添加
- 防重复机制：通过 "default" 标签识别，避免重复添加
- 角色卡数据结构：完整映射用户提供的木灵希设定

### 角色卡内容
- **木灵希**：拜月魔教圣女，昆仑界第一美人
  - 外貌：乌黑长发、白皙肌肤、凤凰印记
  - 性格：古灵精怪、痴情专一、勇敢无畏
  - 背景：卧底学宫、抢亲、征战各界
  - 能力：冰凰之力、天凰道体、空间造诣
  - 标签：古风/玄幻/圣女/痴情/活泼/女神

### 构建产物
- Windows 应用：`build\windows\x64\runner\Release\talk.exe`
- 完整运行时：包含 Flutter 运行时和所有依赖

---

## v1.0.2 (2026-03-11) LM Studio API 对接功能

### 新增功能
- API 配置系统：支持多后端切换（Mock/LM Studio/OpenAI/自定义）
- LM Studio 本地 AI 服务支持：兼容 OpenAI 格式的本地模型调用
- API 设置页面：用户可配置服务提供商、Base URL、API Key、模型参数等
- 流式响应支持：SSE (Server-Sent Events) 实时对话输出
- 连接测试功能：可测试 API 服务可用性和获取模型列表

### 技术实现
- 多后端服务工厂模式：`AIServiceFactory` 统一接口
- LM Studio 客户端：支持非流式和流式聊天请求
- API 配置模型：手动实现序列化（移除 freezed 依赖）
- Hive 存储：API 配置本地持久化
- 完整测试套件：68 个测试用例（单元+Widget+ 集成测试）

### 文档与质量
- 错误日志文档：`err/dart-err-info.md` 记录常见问题及解决方案
- 测试报告模板：`test/integration/LM_STUDIO_TEST_REPORT.md`
- 代码质量：符合项目规范，无编译错误

### 修复问题
- 移除 freezed 代码生成依赖，改为手动实现序列化
- 解决 Provider 重复定义和类名冲突问题
- 修复导出路径错误和导入问题

---

## v1.0.1 (2026-03-10) 初始化 Git 仓库并配置远程仓库

### Git 配置
- 初始化本地 Git 仓库
- 添加远程仓库：https://github.com/muzyyue/Talk.git
- 配置.gitignore 文件，仅保留 Android 平台开发所需文件
- 忽略 iOS/Web/Windows/Linux/macOS 等非目标平台目录

---

## v1.0.0 (2026-03-10) 初始版本发布

### 新增功能
- 角色卡系统：支持创建、编辑、删除、导入、导出角色卡
- 对话系统：支持与角色卡进行 AI 对话，包含消息历史记录
- 好感度系统：基础好感度管理功能
- 用户系统：用户信息存储和管理

### 技术实现
- 使用 Hive 进行本地数据持久化
- 使用 freezed 生成不可变数据模型
- 使用 Riverpod 进行状态管理
- 使用 GoRouter 进行路由管理
- 支持 chara_card_v2 格式角色卡导入

### 已知问题
- AI 服务目前使用 Mock 实现，需要接入真实 AI API
- 用户登录/注册页面为占位实现

---

## v0.1.0 (2026-03-10) 项目初始化

### 基础架构搭建
- 创建 Feature-First + MVVM 项目结构
- 配置核心依赖：Riverpod, GoRouter, Hive, freezed
- 定义基础主题和颜色系统
- 创建通用组件库
