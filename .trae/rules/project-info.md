# 星语物语 (StarTale) - 项目规范

## 概述
Flutter AI 角色扮演对话应用，支持 CharacterAI 角色卡导入。 Android 平台。

## 技术栈
Flutter 3.24+ / Riverpod / GoRouter / Dio / Hive / Freezed

## 架构
```
lib/
├── core/        # 基础设施
├── features/    # 功能模块 (character_card, dialogue, relationship, story, user)
│   └── {module}/data/ domain/ presentation/
└── shared/      # 共享模块
```

## 规范
1. 导入用 `package:talk/...`
2. 文件 snake_case，类 PascalCase
3. 注释用中文
4. 主题色 #4A90D9

## 角色卡格式
```json
{"name":"角色名","description":"描述","personality":"性格","first_mes":"首次对话"}
```
