# 星语物语 (StarTale) - 项目规格说明书

## 1. 项目概述

### 1.1 项目名称
**星语物语 (StarTale)** - 一款类似"妹居物语"、"爱语app"的社交模拟手机应用

### 1.2 产品定位
- **目标用户**：ACG爱好者、二次元用户群体、虚拟社交需求用户
- **核心体验**：与虚拟角色互动、养成、剧情推进、沉浸式恋爱体验
- **平台支持**：Android（Flutter跨平台）

### 1.3 核心功能模块

| 模块 | 描述 | 优先级 |
|------|------|--------|
| 角色卡系统 | 创建/导入角色卡，定义角色人设、背景、性格，支持AI对话 | P0 |
| 对话系统 | 基于角色卡的AI对话，支持上下文记忆、多轮对话 | P0 |
| 好感度系统 | 互动亲密度提升、解锁内容、关系等级 | P0 |
| 剧情系统 | 主线剧情、支线剧情、角色专属剧情 | P1 |
| 用户系统 | 账号、设置、存档管理 | P0 |

---

## 2. 技术栈选型

### 2.1 核心技术栈

| 技术 | 版本 | 用途 |
|------|------|------|
| Flutter | 3.16+ | 跨平台UI框架 |
| Dart | 3.2+ | 编程语言 |
| Riverpod | 2.4+ | 状态管理 |
| GoRouter | 13.0+ | 路由导航 |
| Hive | 2.2+ | 本地数据库 |
| Dio | 5.4+ | 网络请求 |
| freezed | 2.4+ | 不可变数据模型 |
| json_serializable | 6.7+ | JSON序列化 |
| flutter_animate | 4.3+ | 声明式动画 |
| cached_network_image | 3.3+ | 图片缓存 |

### 2.2 开发工具

| 工具 | 用途 |
|------|------|
| VS Code / Android Studio | IDE |
| Flutter DevTools | 性能分析 |
| FVM | Flutter版本管理 |
| Melos | 多包管理（可选） |

---

## 3. 架构设计

### 3.1 架构模式
采用 **Feature-First + MVVM** 架构模式，结合 Clean Architecture 的分层思想。

### 3.2 设计原则

1. **单一职责**：每个模块只负责一个功能领域
2. **依赖倒置**：高层模块不依赖低层模块，都依赖抽象
3. **接口隔离**：使用小而专一的接口
4. **关注点分离**：UI、业务逻辑、数据访问分离

### 3.3 目录结构

```
lib/
├── main.dart                      # 应用入口
├── app.dart                       # App配置
│
├── core/                          # 核心基础设施
│   ├── constants/                 # 常量定义
│   │   ├── app_constants.dart
│   │   ├── api_constants.dart
│   │   └── storage_keys.dart
│   ├── theme/                     # 主题配置
│   │   ├── app_theme.dart
│   │   ├── app_colors.dart
│   │   ├── app_text_styles.dart
│   │   └── app_decorations.dart
│   ├── router/                    # 路由配置
│   │   ├── app_router.dart
│   │   └── routes.dart
│   ├── network/                   # 网络层
│   │   ├── api_client.dart
│   │   ├── interceptors/
│   │   └── exceptions/
│   ├── storage/                   # 存储层
│   │   ├── local_storage.dart
│   │   └── secure_storage.dart
│   └── utils/                     # 工具类
│       ├── logger.dart
│       ├── validators.dart
│       └── extensions/
│
├── features/                      # 功能模块
│   ├── character_card/            # 角色卡系统
│   │   ├── data/
│   │   │   ├── models/
│   │   │   ├── repositories/
│   │   │   └── services/
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   └── usecases/
│   │   └── presentation/
│   │       ├── pages/
│   │       ├── widgets/
│   │       └── providers/
│   │
│   ├── dialogue/                  # 对话系统
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/
│   │
│   ├── relationship/              # 好感度系统
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/
│   │
│   ├── story/                     # 剧情系统
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/
│   │
│   └── user/                      # 用户系统
│       ├── data/
│       ├── domain/
│       └── presentation/
│
├── shared/                        # 共享组件
│   ├── widgets/                   # 通用UI组件
│   │   ├── glass_card.dart
│   │   ├── gradient_button.dart
│   │   ├── animated_character.dart
│   │   ├── story_dialog.dart
│   │   └── loading_overlay.dart
│   ├── models/                    # 共享数据模型
│   │   ├── result.dart
│   │   └── paginated_response.dart
│   └── providers/                 # 全局Provider
│       ├── theme_provider.dart
│       └── user_provider.dart
│
├── l10n/                          # 国际化
│   ├── app_localizations.dart
│   ├── app_zh.arb
│   └── app_en.arb
│
└── gen/                           # 自动生成代码
    ├── assets.gen.dart
    └── fonts.gen.dart
```

---

## 4. 核心模块设计

### 4.1 角色卡系统 (Character Card Feature)

#### 数据模型

##### 角色卡主实体
```dart
/// 角色卡实体 - 兼容 chara_card_v2 格式
/// 参考: SillyTavern / CharacterAI 角色卡标准
class CharacterCard {
  final String id;                       // 本地唯一标识
  final String spec;                     // 规格标识: "chara_card_v2"
  final String specVersion;              // 规格版本: "2.0"
  final CharacterCardData data;          // 角色卡数据
  final CharacterCardSource source;      // 来源（创建/导入）
  final DateTime createdAt;
  final DateTime updatedAt;
}

/// 角色卡数据 - chara_card_v2 核心字段
class CharacterCardData {
  final String name;                     // 角色名称
  final String description;              // 角色描述（外貌、基本性格）
  final String personality;              // 性格详细描述
  final String scenario;                 // 场景设定/世界观
  final String? firstMes;                // 第一条消息（开场白）
  final String? mesExample;              // 消息示例
  final String? creatorNotes;            // 创建者备注
  final String? systemPrompt;            // 系统提示词
  final String? postHistoryInstructions; // 历史后指令
  final String? alternateGreetings;      // 备选问候语
  final List<String> tags;               // 标签
  final String? creator;                 // 创建者
  final String? characterVersion;        // 角色版本
  final CharacterExtensions? extensions; // 扩展字段
}

/// 扩展字段 - 自定义扩展
class CharacterExtensions {
  final String? avatarUrl;               // 头像URL
  final String? portraitUrl;             // 立绘URL
  final String? nickname;                // 昵称/爱称
  final CharacterProfile? profile;       // 角色档案（扩展）
  final Map<String, dynamic>? custom;    // 自定义扩展数据
}

/// 角色档案（扩展字段）
class CharacterProfile {
  final int? age;                        // 年龄
  final String? gender;                  // 性别
  final String? occupation;              // 职业
  final String? height;                  // 身高
  final String? birthday;                // 生日
  final List<String>? likes;             // 喜好
  final List<String>? dislikes;          // 厌恶
  final String? voiceDescription;        // 声音描述
}

/// 角色卡来源
enum CharacterCardSource {
  created,    // 用户创建
  imported,   // 导入（JSON/图片）
  shared,     // 社区分享
}

/// 角色卡导入结果
class CharacterCardImportResult {
  final bool success;
  final CharacterCard? card;
  final String? error;
  final CharacterCardImportFormat format;
}

/// 角色卡导入格式
enum CharacterCardImportFormat {
  charaCardV2,   // chara_card_v2 JSON
  charaCardV1,   // 旧版格式
  imageEmbedded, // 图片内嵌
  customJson,    // 自定义JSON
}
```

##### JSON 导入格式示例
```json
{
  "spec": "chara_card_v2",
  "spec_version": "2.0",
  "data": {
    "name": "凛",
    "description": "常穿着柔软针织衫配百褶裙，永远挂着恰到好处的浅笑...",
    "personality": "完美伪装下的精神支配型病娇。表层是无可挑剔的温柔妹妹...",
    "scenario": "每天早上，凛会提前一小时起床...",
    "first_mes": "早安，哥哥。早餐准备好了。",
    "creator_notes": "中层(9%时间):温柔中渗出的控制感...",
    "tags": ["病娇", "妹妹", "温柔"]
  }
}
```

#### 状态管理
```dart
/// 角色卡列表Provider
final characterCardsProvider = StateNotifierProvider<CharacterCardNotifier, 
    AsyncValue<List<CharacterCard>>>((ref) => CharacterCardNotifier());

/// 当前选中角色卡Provider
final selectedCardProvider = StateProvider<CharacterCard?>((ref) => null);

/// 角色卡创建表单Provider
final characterCardFormProvider = StateNotifierProvider<CharacterCardFormNotifier,
    CharacterCardFormData>((ref) => CharacterCardFormNotifier());

/// 角色卡导入Provider
final characterCardImportProvider = StateNotifierProvider<CharacterCardImportNotifier,
    CharacterCardImportState>((ref) => CharacterCardImportNotifier());
```

#### 核心功能
- **创建角色卡**：用户自定义角色名称、描述、性格、场景等
- **导入角色卡**：
  - 支持 `chara_card_v2` JSON 格式
  - 支持图片内嵌角色卡（PNG Metadata）
  - 支持旧版格式自动转换
- **导出角色卡**：导出为 `chara_card_v2` JSON 格式
- **编辑角色卡**：修改已有角色卡的各项设定
- **删除角色卡**：移除不需要的角色卡
- **角色卡模板**：提供预设性格模板快速创建

### 4.2 对话系统 (Dialogue Feature)

#### 数据模型
```dart
/// 对话会话
class ChatSession {
  final String id;
  final String characterCardId;         // 关联的角色卡ID
  final List<ChatMessage> messages;     // 消息历史
  final ChatContext context;            // 对话上下文
  final DateTime createdAt;
  final DateTime updatedAt;
}

/// 对话消息
class ChatMessage {
  final String id;
  final MessageRole role;               // 角色（用户/角色）
  final String content;                 // 消息内容
  final DateTime timestamp;
  final MessageMetadata? metadata;      // 元数据（情绪、表情等）
}

/// 消息角色
enum MessageRole {
  user,       // 用户消息
  character,  // 角色消息
  system,     // 系统消息
}

/// 消息元数据
class MessageMetadata {
  final String? emotion;                // 情绪状态
  final String? expression;             // 表情
  final String? action;                 // 动作描述
}

/// 对话上下文 - 用于AI理解对话状态
class ChatContext {
  final int totalMessages;              // 总消息数
  final int affectionLevel;             // 当前好感度
  final List<String> topics;            // 讨论过的话题
  final List<String> memories;          // 重要记忆点
  final String? lastTopic;              // 最后话题
}

/// AI请求参数
class AIRequest {
  final CharacterCard character;        // 角色卡信息
  final List<ChatMessage> history;      // 对话历史
  final String userMessage;             // 用户消息
  final ChatContext context;            // 对话上下文
  final AIParameters parameters;        // AI参数
}

/// AI参数配置
class AIParameters {
  final double temperature;             // 创造性 (0.0-1.0)
  final int maxTokens;                  // 最大输出长度
  final String? systemPrompt;           // 系统提示词
}
```

#### 状态管理
```dart
/// 当前对话会话Provider
final chatSessionProvider = StateNotifierProvider<ChatSessionNotifier, 
    ChatSessionState>((ref) => ChatSessionNotifier());

class ChatSessionState {
  final ChatSession? session;
  final bool isLoading;
  final String? error;
  final bool isTyping;                  // 角色正在输入
}

/// 对话历史Provider
final chatHistoryProvider = StateNotifierProvider<ChatHistoryNotifier,
    List<ChatSession>>((ref) => ChatHistoryNotifier());

/// AI服务Provider
final aiServiceProvider = Provider<AIService>((ref) => AIService());
```

#### 核心功能
- **发起对话**：选择角色卡开始新对话
- **发送消息**：用户发送消息，AI生成角色回复
- **上下文记忆**：保持多轮对话的连贯性
- **对话历史**：查看和管理历史对话
- **情绪系统**：根据对话内容调整角色情绪
- **打字效果**：模拟角色逐字输入的效果

### 4.3 好感度系统 (Relationship Feature)

#### 数据模型
```dart
/// 角色关系
class CharacterRelationship {
  final String characterCardId;         // 关联角色卡ID
  final int affection;                  // 好感度 (0-100)
  final RelationshipLevel level;        // 关系等级
  final List<RelationshipEvent> events; // 关系事件
  final List<String> unlockedContent;   // 已解锁内容
  final Map<String, int> interactionCount; // 互动统计
  final DateTime firstMetAt;            // 初次相遇时间
  final DateTime? lastInteractionAt;    // 最后互动时间
}

/// 关系等级
enum RelationshipLevel {
  stranger,     // 陌生人 (0-20)
  acquaintance, // 熟人 (21-40)
  friend,       // 朋友 (41-60)
  closeFriend,  // 密友 (61-80)
  lover,        // 恋人 (81-100)
}

/// 关系事件
class RelationshipEvent {
  final String id;
  final String type;                    // 事件类型
  final String description;             // 事件描述
  final int affectionChange;            // 好感度变化
  final DateTime timestamp;
}

/// 互动类型
enum InteractionType {
  chat,         // 对话
  gift,         // 送礼
  date,         // 约会
  specialEvent, // 特殊事件
}
```

#### 事件驱动
```dart
/// 好感度变化事件
class AffectionChangedEvent {
  final String characterCardId;
  final int oldValue;
  final int newValue;
  final InteractionType reason;
  final String? description;
}

/// 关系等级提升事件
class RelationshipLevelUpEvent {
  final String characterCardId;
  final RelationshipLevel oldLevel;
  final RelationshipLevel newLevel;
  final DateTime timestamp;
}

/// 事件总线Provider
final eventBusProvider = Provider<EventBus>((ref) => EventBus());
```

### 4.4 剧情系统 (Story Feature)

#### 数据模型
```dart
/// 剧情章节
class StoryChapter {
  final String id;
  final String title;
  final String description;
  final StoryType type;
  final String? characterId;     // 角色专属剧情
  final List<String> dialogueIds; // 对话ID列表
  final StoryCondition unlockCondition;
  final StoryReward reward;
  final bool isCompleted;
}

/// 剧情类型
enum StoryType {
  main,       // 主线
  side,       // 支线
  character,  // 角色专属
  event,      // 活动剧情
}
```

---

## 5. UI/UX 设计规范

### 5.1 设计风格
- **整体风格**：现代简约风格，清新优雅
- **视觉语言**：毛玻璃效果、渐变色、柔和阴影
- **动画风格**：流畅、自然、有弹性

### 5.2 色彩系统

#### 主色调（蓝色系）
| 名称 | 色值 | 用途 |
|------|------|------|
| Primary | #4A90D9 | 主要按钮、强调元素 |
| Primary Light | #87CEEB | 背景、卡片 |
| Primary Dark | #2E5C8A | 深色强调 |

#### 辅助色
| 名称 | 色值 | 用途 |
|------|------|------|
| Secondary | #6C5CE7 | 紫色，辅助强调 |
| Accent | #00B894 | 青绿色，特殊标记 |
| Success | #4CAF50 | 成功状态 |
| Warning | #FF9800 | 警告状态 |
| Error | #F44336 | 错误状态 |

#### 中性色
| 名称 | 色值 | 用途 |
|------|------|------|
| Background | #FAFAFA | 页面背景 |
| Surface | #FFFFFF | 卡片背景 |
| Text Primary | #212121 | 主要文字 |
| Text Secondary | #757575 | 次要文字 |

### 5.3 字体系统

```dart
/// 字体层级
class AppTextStyles {
  // 标题
  static final h1 = TextStyle(fontSize: 32, fontWeight: FontWeight.bold);
  static final h2 = TextStyle(fontSize: 24, fontWeight: FontWeight.w600);
  static final h3 = TextStyle(fontSize: 20, fontWeight: FontWeight.w500);
  
  // 正文
  static final body1 = TextStyle(fontSize: 16, fontWeight: FontWeight.normal);
  static final body2 = TextStyle(fontSize: 14, fontWeight: FontWeight.normal);
  
  // 标签
  static final caption = TextStyle(fontSize: 12, fontWeight: FontWeight.normal);
  static final button = TextStyle(fontSize: 14, fontWeight: FontWeight.w500);
}
```

### 5.4 组件规范

#### GlassCard（毛玻璃卡片）
```dart
/// 毛玻璃效果卡片
/// - 背景透明度: 0.8
/// - 模糊半径: 10
/// - 边框: 1px 白色半透明
/// - 圆角: 16px
```

#### GradientButton（渐变按钮）
```dart
/// 渐变按钮
/// - 渐变方向: 从左到右
/// - 颜色: Primary → PrimaryDark
/// - 圆角: 24px
/// - 最小高度: 48px
/// - 点击效果: 缩放 + 透明度变化
```

### 5.5 响应式断点

| 断点名称 | 宽度范围 | 布局策略 |
|---------|---------|---------|
| Compact | < 600px | 单列布局，底部导航 |
| Medium | 600-840px | 双列布局，侧边导航 |
| Expanded | > 840px | 多列布局，侧边导航 |

---

## 6. 数据模型设计

### 6.1 本地存储结构 (Hive)

```dart
/// 存储Box定义
class StorageBoxes {
  static const String user = 'user_box';               // 用户数据
  static const String characterCards = 'character_cards_box'; // 角色卡数据
  static const String chatSessions = 'chat_sessions_box'; // 对话会话
  static const String relationships = 'relationships_box'; // 关系数据
  static const String stories = 'stories_box';         // 剧情进度
  static const String settings = 'settings_box';       // 设置
  static const String cache = 'cache_box';             // 缓存
}
```

### 6.2 API 数据结构

#### 标准响应格式
```json
{
  "code": 200,
  "message": "success",
  "data": { ... },
  "timestamp": 1234567890
}
```

#### 分页响应格式
```json
{
  "code": 200,
  "message": "success",
  "data": {
    "items": [...],
    "total": 100,
    "page": 1,
    "pageSize": 20
  }
}
```

---

## 7. 状态管理方案

### 7.1 Provider 层级结构

```
ProviderScope (Root)
├── Global Providers
│   ├── themeProvider
│   ├── userProvider
│   └── eventBusProvider
│
└── Feature Providers
    ├── Character Card Feature
    │   ├── characterCardsProvider
    │   ├── selectedCardProvider
    │   └── characterCardFormProvider
    │
    ├── Chat Feature
    │   ├── chatSessionProvider
    │   ├── chatHistoryProvider
    │   └── aiServiceProvider
    │
    └── Relationship Feature
        ├── relationshipsProvider
        └── affectionEventsProvider
```

### 7.2 状态更新流程

```
User Action → Widget → Provider.notifier.method()
    → Repository → Service/Local Storage
    → Return Result → Update State
    → UI Rebuild
```

---

## 8. 路由设计

### 8.1 路由表

```dart
/// 应用路由配置
class AppRoutes {
  // 主页面
  static const String splash = '/splash';
  static const String home = '/home';
  static const String main = '/main';
  
  // 角色卡相关
  static const String characterCardList = '/character-cards';
  static const String characterCardDetail = '/character-cards/:id';
  static const String characterCardCreate = '/character-cards/create';
  static const String characterCardEdit = '/character-cards/:id/edit';
  static const String characterCardImport = '/character-cards/import';
  
  // 对话相关
  static const String chat = '/chat/:characterCardId';
  static const String chatHistory = '/chat/history';
  
  // 剧情相关
  static const String storyList = '/stories';
  static const String storyDetail = '/stories/:id';
  
  // 其他
  static const String settings = '/settings';
  static const String profile = '/profile';
}
```

### 8.2 导航结构

```
SplashScreen
    │
    ├── LoginScreen (未登录)
    │
    └── MainScreen (已登录)
        ├── HomePage (首页)
        ├── CharacterCardPage (角色卡)
        │   ├── CharacterCardListPage (角色卡列表)
        │   ├── CharacterCardCreatePage (创建角色卡)
        │   └── CharacterCardImportPage (导入角色卡)
        ├── ChatPage (对话)
        └── ProfilePage (我的)
```

---

## 9. 性能优化策略

### 9.1 图片优化
- 使用 `cached_network_image` 缓存网络图片
- 立绘图片懒加载 + 预加载策略
- 支持渐进式加载

### 9.2 列表优化
- 使用 `ListView.builder` 构建长列表
- 实现 `AutomaticKeepAliveClientMixin` 保持状态
- 分页加载

### 9.3 动画优化
- 使用 `flutter_animate` 声明式动画
- 低端设备动画降级
- 使用 `RepaintBoundary` 隔离重绘区域

### 9.4 内存优化
- 及时释放不用的资源
- 图片内存缓存限制
- 对话历史分页存储

---

## 10. 安全策略

### 10.1 数据安全
- 敏感数据使用 `flutter_secure_storage` 存储
- API 请求使用 HTTPS
- Token 自动刷新机制

### 10.2 代码安全
- 混淆发布版本
- 禁用调试日志
- 证书绑定（可选）

---

## 11. 测试策略

### 11.1 单元测试
- Repository 层测试
- UseCase 层测试
- Provider 状态测试

### 11.2 Widget 测试
- UI 组件测试
- 页面交互测试

### 11.3 集成测试
- 完整用户流程测试
- 性能测试

---

## 12. 发布计划

### 12.1 MVP 版本 (v1.0)
- 角色卡系统（创建、编辑、导入角色卡）
- 对话系统（基于角色卡的AI对话）
- 好感度系统（互动提升好感度）
- 用户系统（账号、设置）

### 12.2 后续版本
- v1.1: 剧情系统
- v1.2: 社交系统（分享角色卡）
- v2.0: 多语言支持
