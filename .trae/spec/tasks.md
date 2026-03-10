# 星语物语 (StarTale) - 开发任务分解

## Phase 1: 项目初始化与基础设施 (预计 3 天)

### 1.1 项目创建与配置
- [ ] 创建 Flutter 项目
- [ ] 配置 FVM 版本管理
- [ ] 配置 pubspec.yaml 依赖
- [ ] 配置代码生成器 (build_runner)
- [ ] 配置 lint 规则 (analysis_options.yaml)

### 1.2 核心基础设施
- [ ] 创建目录结构
- [ ] 实现日志工具 (core/utils/logger.dart)
- [ ] 实现常量定义 (core/constants/)
- [ ] 实现主题配置 (core/theme/)
  - [ ] AppColors - 色彩系统（蓝色系）
  - [ ] AppTextStyles - 字体系统
  - [ ] AppTheme - 主题配置
  - [ ] AppDecorations - 装饰样式

### 1.3 网络层
- [ ] 实现 ApiClient (Dio 封装)
- [ ] 实现请求拦截器
  - [ ] AuthInterceptor - Token 处理
  - [ ] LogInterceptor - 日志记录
  - [ ] ErrorInterceptor - 错误处理
- [ ] 实现异常定义 (core/network/exceptions/)

### 1.4 存储层
- [ ] 实现 LocalStorage (Hive 封装)
- [ ] 实现 SecureStorage (敏感数据存储)
- [ ] 定义存储键值 (StorageKeys)

### 1.5 路由配置
- [ ] 配置 GoRouter
- [ ] 定义路由表 (routes.dart)
- [ ] 实现路由守卫 (登录检查)

---

## Phase 2: 核心功能模块开发 (预计 12 天)

### 2.1 用户系统 (User Feature) - 2 天
- [ ] 数据层
  - [ ] UserModel 定义
  - [ ] UserRepository 实现
  - [ ] UserService 实现
- [ ] 领域层
  - [ ] User 实体
  - [ ] LoginUseCase
  - [ ] RegisterUseCase
  - [ ] UpdateProfileUseCase
- [ ] 表现层
  - [ ] UserProvider (Riverpod)
  - [ ] LoginPage
  - [ ] RegisterPage
  - [ ] ProfilePage
  - [ ] SettingsPage

### 2.2 角色卡系统 (Character Card Feature) - 3 天
- [ ] 数据层
  - [ ] CharacterCardModel 定义 (freezed) - 兼容 chara_card_v2
  - [ ] CharacterCardDataModel 定义
  - [ ] CharacterExtensionsModel 定义
  - [ ] CharacterProfileModel 定义（扩展字段）
  - [ ] CharacterCardRepository 实现
  - [ ] CharacterCardService 实现
  - [ ] CharacterCardImportService 实现（导入/导出）
- [ ] 领域层
  - [ ] CharacterCard 实体
  - [ ] CharacterCardData 实体
  - [ ] CharacterExtensions 实体
  - [ ] GetCharacterCardsUseCase
  - [ ] GetCharacterCardDetailUseCase
  - [ ] CreateCharacterCardUseCase
  - [ ] UpdateCharacterCardUseCase
  - [ ] DeleteCharacterCardUseCase
  - [ ] ImportCharacterCardUseCase（支持多种格式）
  - [ ] ExportCharacterCardUseCase
- [ ] 表现层
  - [ ] CharacterCardProvider
  - [ ] CharacterCardFormProvider
  - [ ] CharacterCardImportProvider
  - [ ] CharacterCardListPage
  - [ ] CharacterCardDetailPage
  - [ ] CharacterCardCreatePage
  - [ ] CharacterCardEditPage
  - [ ] CharacterCardImportPage
  - [ ] CharacterCardItem 组件
  - [ ] CharacterCardForm 组件
  - [ ] CharacterCardPreview 组件

### 2.3 对话系统 (Chat Feature) - 4 天
- [ ] 数据层
  - [ ] ChatSessionModel 定义
  - [ ] ChatMessageModel 定义
  - [ ] ChatContextModel 定义
  - [ ] AIRequestModel 定义
  - [ ] ChatRepository 实现
  - [ ] ChatService 实现
  - [ ] AIService 实现（对接AI API）
- [ ] 领域层
  - [ ] ChatSession 实体
  - [ ] ChatMessage 实体
  - [ ] ChatContext 实体
  - [ ] AIRequest 实体
  - [ ] StartChatSessionUseCase
  - [ ] SendMessageUseCase
  - [ ] GetChatHistoryUseCase
  - [ ] DeleteChatSessionUseCase
- [ ] 表现层
  - [ ] ChatSessionProvider
  - [ ] ChatHistoryProvider
  - [ ] AIProvider
  - [ ] ChatPage
  - [ ] ChatHistoryPage
  - [ ] ChatBubble 组件
  - [ ] ChatInput 组件
  - [ ] TypewriterText 组件 (打字机效果)
  - [ ] MessageList 组件
  - [ ] EmotionIndicator 组件

### 2.4 好感度系统 (Relationship Feature) - 2 天
- [ ] 数据层
  - [ ] CharacterRelationshipModel 定义
  - [ ] RelationshipEventModel 定义
  - [ ] RelationshipRepository 实现
- [ ] 领域层
  - [ ] CharacterRelationship 实体
  - [ ] RelationshipEvent 实体
  - [ ] UpdateAffectionUseCase
  - [ ] CheckUnlockConditionUseCase
  - [ ] GetRelationshipUseCase
- [ ] 表现层
  - [ ] RelationshipProvider
  - [ ] AffectionMeter 组件
  - [ ] RelationshipIndicator 组件
  - [ ] RelationshipLevelBadge 组件

### 2.5 剧情系统 (Story Feature) - 1 天 (P1，可选)
- [ ] 数据层
  - [ ] StoryChapterModel 定义
  - [ ] StoryRepository 实现
- [ ] 领域层
  - [ ] StoryChapter 实体
  - [ ] GetStoriesUseCase
  - [ ] UpdateStoryProgressUseCase
- [ ] 表现层
  - [ ] StoryProvider
  - [ ] StoryListPage
  - [ ] StoryCard 组件

---

## Phase 3: UI组件库开发 (预计 4 天)

### 3.1 基础组件
- [ ] GlassCard - 毛玻璃卡片
- [ ] GradientButton - 渐变按钮
- [ ] AnimatedAvatar - 头像动画组件
- [ ] LoadingOverlay - 加载遮罩
- [ ] EmptyState - 空状态组件
- [ ] ErrorState - 错误状态组件

### 3.2 导航组件
- [ ] AppBottomNavBar - 底部导航栏
- [ ] AppNavigationRail - 侧边导航栏
- [ ] AdaptiveNavigation - 自适应导航

### 3.3 动画组件
- [ ] FadeInAnimation - 淡入动画
- [ ] SlideInAnimation - 滑入动画
- [ ] ScaleAnimation - 缩放动画
- [ ] ShimmerLoading - 骨架屏

### 3.4 表单组件
- [ ] AppTextField - 输入框
- [ ] AppDropdown - 下拉选择
- [ ] AppSwitch - 开关
- [ ] AppImagePicker - 图片选择器
- [ ] AppTagInput - 标签输入

---

## Phase 4: 集成与测试 (预计 3 天)

### 4.1 功能集成
- [ ] 集成用户系统与角色卡系统
- [ ] 集成角色卡系统与对话系统
- [ ] 集成对话系统与好感度系统
- [ ] 实现事件总线 (系统间通信)
- [ ] AI API 对接测试

### 4.2 单元测试
- [ ] Repository 层测试
- [ ] UseCase 层测试
- [ ] Provider 状态测试
- [ ] 工具类测试

### 4.3 Widget 测试
- [ ] 基础组件测试
- [ ] 页面组件测试
- [ ] 交互流程测试

### 4.4 集成测试
- [ ] 登录流程测试
- [ ] 创建角色卡流程测试
- [ ] 对话流程测试
- [ ] 好感度变化测试

---

## Phase 5: 优化与发布准备 (预计 2 天)

### 5.1 性能优化
- [ ] 图片缓存优化
- [ ] 列表性能优化
- [ ] 动画性能优化
- [ ] 内存优化
- [ ] AI 响应优化

### 5.2 UI/UX 优化
- [ ] 深色模式适配
- [ ] 响应式布局适配
- [ ] 无障碍支持

### 5.3 安全加固
- [ ] 代码混淆
- [ ] 敏感数据加密
- [ ] API 安全检查
- [ ] AI API Key 安全存储

### 5.4 发布准备
- [ ] 配置应用图标
- [ ] 配置启动页
- [ ] 配置应用签名
- [ ] 准备应用商店素材

---

## 任务依赖关系

```
Phase 1 (基础设施)
    │
    ├──→ Phase 2.1 (用户系统)
    │        │
    │        ├──→ Phase 2.2 (角色卡系统)
    │        │        │
    │        │        ├──→ Phase 2.3 (对话系统)
    │        │        │        │
    │        │        │        └──→ Phase 2.4 (好感度系统)
    │        │        │
    │        │        └──→ Phase 2.5 (剧情系统)
    │
    └──→ Phase 3 (UI组件库) ──→ Phase 4 (集成测试)
                                        │
                                        └──→ Phase 5 (优化发布)
```

---

## 里程碑

| 里程碑 | 完成标准 | 预计时间 |
|--------|---------|---------|
| M1 - 基础设施完成 | 项目可运行，路由可用 | Day 3 |
| M2 - 用户系统完成 | 登录注册可用 | Day 5 |
| M3 - 角色卡系统完成 | 创建/导入角色卡可用 | Day 8 |
| M4 - 对话系统完成 | AI对话流程可用 | Day 12 |
| M5 - 好感度系统完成 | 好感度变化生效 | Day 14 |
| M6 - MVP 完成 | 核心功能可用 | Day 19 |
| M7 - 发布就绪 | 测试通过，可发布 | Day 24 |

---

## 风险与应对

| 风险 | 影响 | 应对措施 |
|------|------|---------|
| AI API 响应慢 | 用户体验下降 | 流式输出 + 缓存策略 |
| 动画性能问题 | 用户体验下降 | 低端设备降级策略 |
| 资源加载慢 | 页面卡顿 | 预加载 + 缓存策略 |
| 状态管理复杂 | 代码维护困难 | 严格遵循架构规范 |
| 需求变更 | 开发延期 | 预留扩展接口 |
