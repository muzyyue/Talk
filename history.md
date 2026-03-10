# 项目变更历史

## v1.0.0 (2026-03-10) 初始化Git仓库并配置远程仓库

### Git配置
- 初始化本地Git仓库
- 添加远程仓库：https://github.com/muzyyue/Talk.git
- 配置.gitignore文件，仅保留Android平台开发所需文件
- 忽略iOS/Web/Windows/Linux/macOS等非目标平台目录

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
